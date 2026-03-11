import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../../core/failure/server_failure.dart';
import '../../data/data_sources/psw_application_remote_dataSource.dart';
import '../../data/repositories/psw_application_repository_Impl.dart';
import '../../domain/entities/psw_application_entity.dart';

part 'psw_application_event.dart';

part 'psw_application_state.dart';

class PswApplicationBloc
    extends Bloc<PswApplicationEvent, PswApplicationState> {
  PswApplicationBloc() : super(PswApplicationInitial()) {
    final repo = PswApplicationRepositoryImpl(
      remoteDataSource: PswApplicationRemoteDataSourceImpl(),
    );

    // ── Fetch my applications ─────────────────────────────────────────────────
    on<FetchMyApplicationsEvent>((event, emit) async {
      emit(PswApplicationsLoading());
      final result = await repo.getMyApplications();
      result.fold((failure) {
        final msg = failure is ServerFailure
            ? (failure.messageEn ?? failure.message ?? 'Failed to load')
            : 'Something went wrong';
        emit(PswApplicationsError(msg));
      }, (list) => emit(PswApplicationsLoaded(list)));
    });

    // ── Apply for offer ───────────────────────────────────────────────────────
    on<ApplyForOfferEvent>((event, emit) async {
      emit(PswApplicationMutationLoading());
      final result = await repo.apply(
        offerId: event.offerId,
        shiftIds: event.shiftIds,
      );
      result.fold(
        (failure) {
          final msg = failure is ServerFailure
              ? (failure.messageEn ?? failure.message ?? 'Apply failed')
              : 'Something went wrong';
          emit(PswApplicationMutationError(msg));
        },
        (_) {
          emit(PswApplicationMutationSuccess('Application submitted!'));
          // Refresh list after applying
          add(FetchMyApplicationsEvent());
        },
      );
    });

    // ── Cancel application ────────────────────────────────────────────────────
    on<CancelApplicationEvent>((event, emit) async {
      emit(PswApplicationMutationLoading());
      final result = await repo.cancelApplication(event.jobRequestItemId);
      result.fold(
        (failure) {
          final msg = failure is ServerFailure
              ? (failure.messageEn ?? failure.message ?? 'Cancel failed')
              : 'Something went wrong';
          emit(PswApplicationMutationError(msg));
        },
        (_) {
          emit(PswApplicationMutationSuccess('Application cancelled'));
          // Refresh list after cancelling
          add(FetchMyApplicationsEvent());
        },
      );
    });
  }
}
