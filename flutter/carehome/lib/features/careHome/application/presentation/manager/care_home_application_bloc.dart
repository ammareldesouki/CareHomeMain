import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../../core/failure/server_failure.dart';
import '../../data/data_sources/carehome_application_remote_datasource.dart';
import '../../data/repositories/carehome_application_repository_impl.dart';
import '../../domain/entities/carehome_application_entity.dart';

part 'care_home_application_event.dart';

part 'care_home_application_state.dart';

class CareHomeApplicationBloc
    extends Bloc<CareHomeApplicationEvent, CareHomeApplicationState> {
  CareHomeApplicationBloc() : super(CareHomeApplicationInitial()) {
    final repo = CareHomeApplicationRepositoryImpl(
      remoteDataSource: CareHomeApplicationRemoteDataSourceImpl(),
    );
//-- Fetch All request in care home
//         on<FetchApplicationsEvent>((event, emit) async {
    //           emit(CareHomeApplicationsLoading());
    //           // final result = await repo.getApplications();
    //           result.fold((failure) {
    //             final msg = failure is ServerFailure
    //                 ? (failure.messageEn ?? failure.message ?? 'Failed to load')
    //                 : 'Something went wrong';
    //             emit(CareHomeApplicationsError(msg));
    //           }, (list) => emit(CareHomeApplicationsLoaded(list)));
    //         });

    // ── Fetch list ────────────────────────────────────────────────────────────
    on<FetchApplicationsByOfferEvent>((event, emit) async {
      emit(CareHomeApplicationsLoading());
      final result = await repo.getApplicationsByOffer(event.offerId);
      result.fold((failure) {
        final msg = failure is ServerFailure
            ? (failure.messageEn ?? failure.message ?? 'Failed to load')
            : 'Something went wrong';
        emit(CareHomeApplicationsError(msg));
      }, (list) => emit(CareHomeApplicationsLoaded(list)));
    });

    // ── Accept ────────────────────────────────────────────────────────────────
    on<AcceptApplicationEvent>((event, emit) async {
      emit(CareHomeApplicationMutationLoading());
      final result = await repo.acceptApplication(
        shiftId: event.shiftId,
        jobRequestItemId: event.jobRequestItemId,
      );
      result.fold(
        (failure) {
          final msg = failure is ServerFailure
              ? (failure.messageEn ?? failure.message ?? 'Accept failed')
              : 'Something went wrong';
          emit(CareHomeApplicationMutationError(msg));
        },
        (_) {
          emit(
            CareHomeApplicationMutationSuccess('Shift accepted successfully'),
          );
          add(FetchApplicationsByOfferEvent(event.offerId));
        },
      );
    });

    // ── Reject ────────────────────────────────────────────────────────────────
    on<RejectApplicationEvent>((event, emit) async {
      emit(CareHomeApplicationMutationLoading());
      final result = await repo.rejectApplication(event.jobRequestItemId);
      result.fold(
        (failure) {
          final msg = failure is ServerFailure
              ? (failure.messageEn ?? failure.message ?? 'Reject failed')
              : 'Something went wrong';
          emit(CareHomeApplicationMutationError(msg));
        },
        (_) {
          emit(CareHomeApplicationMutationSuccess('Application rejected'));
          add(FetchApplicationsByOfferEvent(event.offerId));
        },
      );
    });
  }
}
