part of 'admin_bloc.dart';

@immutable
abstract class AdminEvent {}

// ── Verifications ─────────────────────────────────────────────────────────────

/// Fresh load (page 1). Replaces the list entirely.
class FetchVerificationsEvent extends AdminEvent {
  final String? verificationStatus; // null → All
  final int pageIndex;
  final int pageSize;
  final String? search;
  final String? sort;

  FetchVerificationsEvent({
    this.verificationStatus,
    this.pageIndex = 1,
    this.pageSize = 10,
    this.search,
    this.sort,
  });
}

/// Appends next page to the existing list (infinite scroll).
class LoadMoreVerificationsEvent extends AdminEvent {
  final String? verificationStatus;
  final int pageIndex;
  final int pageSize;
  final String? search;
  final String? sort;

  LoadMoreVerificationsEvent({
    this.verificationStatus,
    required this.pageIndex,
    this.pageSize = 10,
    this.search,
    this.sort,
  });
}

class ApproveVerificationEvent extends AdminEvent {
  final String pswId;
  ApproveVerificationEvent(this.pswId);
}

class RejectVerificationEvent extends AdminEvent {
  final String pswId;
  final String reason;
  RejectVerificationEvent({required this.pswId, required this.reason});
}

// ── Applications ──────────────────────────────────────────────────────────────

class FetchPendingApplicationsEvent extends AdminEvent {}

class ApproveApplicationEvent extends AdminEvent {
  final String requestId;
  ApproveApplicationEvent(this.requestId);
}

class RejectApplicationEvent extends AdminEvent {
  final String requestId;
  RejectApplicationEvent(this.requestId);
}

// ── Offers ────────────────────────────────────────────────────────────────────

class FetchAllOffersEvent extends AdminEvent {}

class CancelOfferEvent extends AdminEvent {
  final String offerId;
  CancelOfferEvent(this.offerId);
}

// ── PSW Profile ───────────────────────────────────────────────────────────────

class FetchPswProfileEvent extends AdminEvent {
  final String pswId;

  FetchPswProfileEvent(this.pswId);
}