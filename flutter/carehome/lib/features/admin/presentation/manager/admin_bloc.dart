import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../core/failure/server_failure.dart';
import '../../data/data_sources/admin_remote_datasource.dart';
import '../../domain/entities/admin_application_entity.dart';
import '../../domain/entities/admin_offer_entity.dart';
import '../../domain/entities/admin_psw_verification_entity.dart';

part 'admin_event.dart';

part 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final AdminRemoteDataSource _ds;

  AdminBloc({AdminRemoteDataSource? dataSource})
    : _ds = dataSource ?? AdminRemoteDataSourceImpl(),
      super(AdminInitial()) {
    // ── Verifications ───────────────────────────────────────────────────────
    on<FetchPendingVerificationsEvent>((_, emit) async {
      emit(VerificationsLoading());
      try {
        final list = await _ds.getPendingVerifications();
        emit(VerificationsLoaded(list));
      } catch (e) {
        final msg = e is ServerFailure
            ? (e.messageEn ?? e.message ?? 'Failed to load verifications')
            : 'Something went wrong';
        emit(VerificationsError(msg));
      }
    });

    on<ApproveVerificationEvent>((event, emit) async {
      emit(VerificationMutationLoading());
      try {
        print("-------------------${event.pswId}");
        await _ds.approveVerification(event.pswId);
        emit(VerificationMutationSuccess('PSW approved successfully'));
        add(FetchPendingVerificationsEvent());
      } catch (e) {
        final msg = e is ServerFailure
            ? (e.messageEn ?? e.message ?? 'Approve failed')
            : 'Something went wrong';
        emit(VerificationMutationError(msg));
      }
    });

    on<RejectVerificationEvent>((event, emit) async {
      emit(VerificationMutationLoading());
      try {
        await _ds.rejectVerification(event.pswId, event.reason);
        emit(VerificationMutationSuccess('PSW verification rejected'));
        add(FetchPendingVerificationsEvent());
      } catch (e) {
        final msg = e is ServerFailure
            ? (e.messageEn ?? e.message ?? 'Reject failed')
            : 'Something went wrong';
        emit(VerificationMutationError(msg));
      }
    });

    // ── Applications ────────────────────────────────────────────────────────
    on<FetchPendingApplicationsEvent>((_, emit) async {
      emit(ApplicationsLoading());
      try {
        final list = await _ds.getPendingApplications();
        emit(ApplicationsLoaded(list));
      } catch (e) {
        final msg = e is ServerFailure
            ? (e.messageEn ?? e.message ?? 'Failed to load applications')
            : 'Something went wrong';
        emit(ApplicationsError(msg));
      }
    });

    on<ApproveApplicationEvent>((event, emit) async {
      emit(ApplicationMutationLoading());
      try {
        print("------------------" + event.requestId);
        await _ds.approveApplication(event.requestId);
        emit(ApplicationMutationSuccess('Application approved'));
        add(FetchPendingApplicationsEvent());
      } catch (e) {
        final msg = e is ServerFailure
            ? (e.messageEn ?? e.message ?? 'Approve failed')
            : 'Something went wrong';
        emit(ApplicationMutationError(msg));
      }
    });

    on<RejectApplicationEvent>((event, emit) async {
      emit(ApplicationMutationLoading());
      try {
        await _ds.rejectApplication(event.requestId);
        emit(ApplicationMutationSuccess('Application rejected'));
        add(FetchPendingApplicationsEvent());
      } catch (e) {
        final msg = e is ServerFailure
            ? (e.messageEn ?? e.message ?? 'Reject failed')
            : 'Something went wrong';
        emit(ApplicationMutationError(msg));
      }
    });

    // ── Offers ──────────────────────────────────────────────────────────────
    on<FetchAllOffersEvent>((_, emit) async {
      emit(AdminOffersLoading());
      try {
        final list = await _ds.getAllOffers();
        emit(AdminOffersLoaded(list));
      } catch (e) {
        final msg = e is ServerFailure
            ? (e.messageEn ?? e.message ?? 'Failed to load offers')
            : 'Something went wrong';
        emit(AdminOffersError(msg));
      }
    });

    on<CancelOfferEvent>((event, emit) async {
      emit(OfferMutationLoading());
      try {
        await _ds.cancelOffer(event.offerId);
        emit(OfferMutationSuccess('Offer cancelled successfully'));
        add(FetchAllOffersEvent());
      } catch (e) {
        final msg = e is ServerFailure
            ? (e.messageEn ?? e.message ?? 'Cancel failed')
            : 'Something went wrong';
        emit(OfferMutationError(msg));
      }
    });
  }
}
