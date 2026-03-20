import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../core/failure/server_failure.dart';
import '../../data/data_sources/admin_remote_datasource.dart';
import '../../domain/entities/admin_application_entity.dart';
import '../../domain/entities/admin_offer_entity.dart';
import '../../domain/entities/admin_psw_verification_entity.dart';
import '../../domain/entities/psw_profile_entity.dart';

part 'admin_event.dart';
part 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final AdminRemoteDataSource _ds;

  // Remember the last verification filter so we can re-fetch after mutations.
  String? _lastVerificationStatus;
  String? _lastVerificationSearch;
  String? _lastVerificationSort;
  int _lastVerificationPageSize = 10;

  AdminBloc({AdminRemoteDataSource? dataSource})
      : _ds = dataSource ?? AdminRemoteDataSourceImpl(),
        super(AdminInitial()) {
    // ── Verifications ───────────────────────────────────────────────────────

    on<FetchVerificationsEvent>((event, emit) async {
      // Store params for post-mutation re-fetch.
      _lastVerificationStatus = event.verificationStatus;
      _lastVerificationSearch = event.search;
      _lastVerificationSort = event.sort;
      _lastVerificationPageSize = event.pageSize;

      emit(VerificationsLoading());
      try {
        final result = await _ds.getVerifications(
          verificationStatus: event.verificationStatus,
          pageIndex: event.pageIndex,
          pageSize: event.pageSize,
          search: event.search,
          sort: event.sort,
        );
        emit(VerificationsLoaded(
          list: result.items,
          totalCount: result.totalCount,
          pageIndex: result.pageIndex,
          pageSize: result.pageSize,
        ));
      } catch (e) {
        final msg = e is ServerFailure
            ? (e.messageEn ?? e.message ?? 'Failed to load verifications')
            : 'Something went wrong';
        emit(VerificationsError(msg));
      }
    });

    on<LoadMoreVerificationsEvent>((event, emit) async {
      // Only append if current state has data.
      final current = state;
      if (current is! VerificationsLoaded) return;

      emit(VerificationsLoadingMore(
        list: current.list,
        totalCount: current.totalCount,
        pageIndex: current.pageIndex,
        pageSize: current.pageSize,
      ));
      try {
        final result = await _ds.getVerifications(
          verificationStatus: event.verificationStatus,
          pageIndex: event.pageIndex,
          pageSize: event.pageSize,
          search: event.search,
          sort: event.sort,
        );
        emit(VerificationsLoaded(
          list: [...current.list, ...result.items],
          totalCount: result.totalCount,
          pageIndex: result.pageIndex,
          pageSize: result.pageSize,
        ));
      } catch (e) {
        // On error, restore previous loaded state so the list remains visible.
        emit(VerificationsLoaded(
          list: current.list,
          totalCount: current.totalCount,
          pageIndex: current.pageIndex,
          pageSize: current.pageSize,
        ));
      }
    });

    on<ApproveVerificationEvent>((event, emit) async {
      emit(VerificationMutationLoading());
      try {
        await _ds.approveVerification(event.pswId);
        emit(VerificationMutationSuccess('PSW approved successfully'));
        // Re-fetch page 1 with the same filter the user had open.
        add(FetchVerificationsEvent(
          verificationStatus: _lastVerificationStatus,
          search: _lastVerificationSearch,
          sort: _lastVerificationSort,
          pageSize: _lastVerificationPageSize,
        ));
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
        emit(VerificationMutationSuccess('Verification rejected'));
        add(FetchVerificationsEvent(
          verificationStatus: _lastVerificationStatus,
          search: _lastVerificationSearch,
          sort: _lastVerificationSort,
          pageSize: _lastVerificationPageSize,
        ));
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

    // ── PSW Profile ──────────────────────────────────────────────────────────

    on<FetchPswProfileEvent>((event, emit) async {
      emit(PswProfileLoading());
      try {
        final profile = await _ds.getPswProfile(event.pswId);
        emit(PswProfileLoaded(profile));
      } catch (e) {
        final msg = e is ServerFailure
            ? (e.messageEn ?? e.message ?? 'Failed to load PSW profile')
            : 'Something went wrong';
        emit(PswProfileError(msg));
      }
    });
  }
}