import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/failure/failure.dart';
import '../../../../../core/failure/server_failure.dart';
import '../../../../../core/network/dio_handler.dart';
import '../../../../auth/domain/entities/user_entity.dart';
import '../../data/data_sources/care_home_registration_remote_datasource.dart';
import '../../data/repositories/care_home_registration_repository_Impl.dart';
import '../../domain/entities/address_dto.dart';
import '../../domain/entities/carehome_register_request.dart';
import 'employer_type.dart';

part 'care_home_registration_event.dart';

part 'care_home_registration_state.dart';

class CareHomeRegistrationBloc
    extends Bloc<CareHomeRegistrationEvent, CareHomeRegistrationState> {
  CareHomeRegistrationBloc() : super(const CareHomeRegistrationState()) {
    final repo = CareHomeRegistrationRepositoryImpl(
      remoteDataSource: CareHomeRegistrationRemoteDataSourceImpl(),
    );

    // ── Field changes (IndividualForm / MultipleCareHomeForm) ──────────────────
    on<UpdateFormFieldEvent>((event, emit) {
      final updated = Map<String, String>.from(state.fields);
      updated[event.fieldName] = event.value;
      emit(state.copyWith(fields: updated, clearError: true));
    });

    // ── Document uploads (MultipleCareHomeForm) ────────────────────────────────
    on<UploadOrgDocumentEvent>((event, emit) {
      final updated = Map<String, String>.from(state.uploadedDocuments);
      updated[event.documentKey] = event.filePath;
      emit(state.copyWith(uploadedDocuments: updated));
    });

    // ── Vaccination toggles (MultipleCareHomeForm) ─────────────────────────────
    on<ToggleVaccinationPolicyEvent>((event, emit) {
      final updated = Map<String, bool>.from(state.vaccinationPolicy);
      updated[event.policyType] = event.value;
      emit(state.copyWith(vaccinationPolicy: updated));
    });

    // ── Terms checkbox (TermsAndConditionsScreen) ──────────────────────────────
    on<AcceptTermsEvent>((event, emit) {
      emit(state.copyWith(isTermsAccepted: event.accepted, clearError: true));
    });

    // ── Continue button on Terms screen ────────────────────────────────────────
    on<NextRegistrationStepEvent>((event, emit) {
      if (!state.isTermsAccepted) {
        emit(state.copyWith(error: 'Please accept the terms to continue'));
        return;
      }
      emit(state.copyWith(clearError: true));
    });

    // ── Sign & Continue on Contract screen ─────────────────────────────────────
    on<SignContractEvent>((event, emit) {
      emit(state.copyWith(isContractSigned: true, clearError: true));
    });

    // ── Real API call — fired from organization_register_screen after contract ─
    on<SubmitRegistrationEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true, clearError: true));

      final f = state.fields;

      final address = AddressDto(
        apartmentNumber: int.tryParse(f['apartment'] ?? '0') ?? 0,
        street: f['street'] ?? '',
        city: f['city'] ?? '',
        state: f['state'] ?? '',
        postalCode: f['postalCode'] ?? '',
        country: f['country'] ?? '',
      );

      final Either<Failure, UserEntity> result;

      if (event.employerType == EmployerType.individual) {
        result = await repo.registerIndividual(
          IndividualRegisterRequest(
            firstName: f['firstName'] ?? '',
            lastName: f['lastName'] ?? '',
            email: f['accountEmail'] ?? '',
            password: f['password'] ?? '',
            phoneNumber: f['phone'] ?? '',
            dateOfBirth: DateTime.now().toUtc().toIso8601String(),
            gender: f['gender'] ?? 'Male',
            address: address,
          ),
        );
      } else {
        result = await repo.registerCareHome(
          CareHomeRegisterRequest(
            firstName: f['contactFirstName'] ?? f['firstName'] ?? '',
            lastName: f['contactLastName'] ?? f['lastName'] ?? '',
            email: f['accountEmail'] ?? '',
            password: f['password'] ?? '',
            phoneNumber: f['contactPhone'] ?? f['phone'] ?? '',
            dateOfBirth: DateTime.now().toUtc().toIso8601String(),
            gender: f['gender'] ?? 'Male',
            address: address,
          ),
        );
      }

      result.fold(
        (failure) {
          final msg = failure is ServerFailure
              ? (failure.messageEn ?? failure.message ?? 'Registration failed')
              : 'Something went wrong';
          emit(state.copyWith(isLoading: false, errorMessage: msg, error: msg));
        },
        (user) {
          // Store Bearer token for all subsequent requests
          NetworkDioHandler().setAuthToken(user.token);
          NetworkDioHandler().setCurrentUser(
            userId: user.userId,
            role: user.role,
          );
          emit(
            state.copyWith(
              isLoading: false,
              isSuccess: true,
              registeredUser: user,
            ),
          );
        },
      );
    });
  }
}
