part of 'admin_bloc.dart';

@immutable
abstract class AdminEvent {}

// Verifications
class FetchPendingVerificationsEvent extends AdminEvent {}

class ApproveVerificationEvent extends AdminEvent {
  final String pswId;

  ApproveVerificationEvent(this.pswId);
}

class RejectVerificationEvent extends AdminEvent {
  final String pswId;
  final String reason;

  RejectVerificationEvent({required this.pswId, required this.reason});
}

// Applications
class FetchPendingApplicationsEvent extends AdminEvent {}

class ApproveApplicationEvent extends AdminEvent {
  final String requestId;

  ApproveApplicationEvent(this.requestId);
}

class RejectApplicationEvent extends AdminEvent {
  final String requestId;

  RejectApplicationEvent(this.requestId);
}

// Offers
class FetchAllOffersEvent extends AdminEvent {}

class CancelOfferEvent extends AdminEvent {
  final String offerId;

  CancelOfferEvent(this.offerId);
}
