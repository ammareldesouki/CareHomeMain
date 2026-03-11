import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../../core/failure/failure.dart';
import '../../../../../core/failure/server_failure.dart';
import '../../data/data_sources/profile_remote_datasource.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/entities/admin_profile_entity.dart';
import '../../domain/entities/carehome_profile_entity.dart';
import '../../domain/entities/psw_profile_entity.dart';
import '../../domain/use_cases/get_profile_usecase.dart';
import '../../domain/use_cases/update_profile_usecase.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final String role;
  late final GetPswProfileUseCase _getPswProfile;
  late final GetCareHomeProfileUseCase _getCareHomeProfile;
  late final GetAdminProfileUseCase _getAdminProfile;
  late final UpdatePswProfileUseCase _updatePswProfile;
  late final UpdateCareHomeProfileUseCase _updateCareHomeProfile;
  late final UpdatePswDocumentUseCase _updatePswDocument;

  ProfileBloc({required this.role}) : super(ProfileInitial()) {
    final dataSource = ProfileRemoteDataSourceImpl();
    final repository = ProfileRepositoryImpl(remoteDataSource: dataSource);
    _getPswProfile = GetPswProfileUseCase(repository);
    _getCareHomeProfile = GetCareHomeProfileUseCase(repository);
    _getAdminProfile = GetAdminProfileUseCase(repository);

    _updatePswProfile = UpdatePswProfileUseCase(repository);
    _updateCareHomeProfile = UpdateCareHomeProfileUseCase(repository);
    _updatePswDocument = UpdatePswDocumentUseCase(repository);

    on<LoadProfileEvent>(_onLoadProfile);
    on<UpdatePswProfileEvent>(_onUpdatePswProfile);
    on<UpdateCareHomeProfileEvent>(_onUpdateCareHomeProfile);
    on<UpdatePswDocumentEvent>(_onUpdatePswDocument);
  }

  String _errorMessage(Failure failure, String fallback) {
    if (failure is ServerFailure) {
      return failure.message ?? failure.messageEn ?? fallback;
    }
    return failure.messageEn ?? fallback;
  }

  FutureOr<void> _onLoadProfile(
    LoadProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    if (role == 'PSW') {
      final result = await _getPswProfile();
      result.fold(
        (failure) => emit(
          ProfileError(_errorMessage(failure, 'Failed to load profile')),
        ),
        (profile) => emit(PswProfileLoaded(profile)),
      );
    } else if (role == 'CareHome') {
      final result = await _getCareHomeProfile();
      result.fold(
        (failure) => emit(
          ProfileError(_errorMessage(failure, 'Failed to load profile')),
        ),
        (profile) => emit(CareHomeProfileLoaded(profile)),
      );
    } else {
      final result = await _getAdminProfile();
      result.fold(
        (failure) => emit(
          ProfileError(_errorMessage(failure, 'Failed to load profile')),
        ),
        (profile) => emit(AdminProfileLoaded(profile)),
      );
    }
  }

  FutureOr<void> _onUpdatePswProfile(
    UpdatePswProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final currentProfile = state is PswProfileLoaded
        ? (state as PswProfileLoaded).profile
        : null;
    emit(ProfileUpdating(currentProfile));
    final result = await _updatePswProfile(event.data);
    result.fold(
      (failure) => emit(
        ProfileUpdateError(
          message: _errorMessage(failure, 'Failed to update profile'),
          currentProfile: currentProfile,
        ),
      ),
      (profile) {
        emit(ProfileUpdateSuccess(updatedProfile: profile));
        emit(PswProfileLoaded(profile));
      },
    );
  }

  FutureOr<void> _onUpdateCareHomeProfile(
    UpdateCareHomeProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final currentProfile = state is CareHomeProfileLoaded
        ? (state as CareHomeProfileLoaded).profile
        : null;
    emit(ProfileUpdating(currentProfile));
    final result = await _updateCareHomeProfile(event.data);
    result.fold(
      (failure) => emit(
        ProfileUpdateError(
          message: _errorMessage(failure, 'Failed to update profile'),
          currentProfile: currentProfile,
        ),
      ),
      (profile) {
        emit(ProfileUpdateSuccess(updatedProfile: profile));
        emit(CareHomeProfileLoaded(profile));
      },
    );
  }

  FutureOr<void> _onUpdatePswDocument(
    UpdatePswDocumentEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final result = await _updatePswDocument(
      documentType: event.documentType,
      filePath: event.filePath,
    );
    result.fold(
      (failure) => emit(
        ProfileUpdateError(
          message: _errorMessage(failure, 'Failed to update document'),
        ),
      ),
      (_) {
        emit(ProfileDocumentUpdateSuccess(event.documentType));
        add(LoadProfileEvent());
      },
    );
  }
}
