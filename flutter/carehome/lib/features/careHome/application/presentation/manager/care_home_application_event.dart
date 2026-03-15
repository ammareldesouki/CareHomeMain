part of 'care_home_application_bloc.dart';

@immutable
sealed class CareHomeApplicationEvent {}

class FetchApplicationsEvent extends CareHomeApplicationEvent {}

class FetchApplicationsByOfferEvent extends CareHomeApplicationEvent {
  final String offerId;

  FetchApplicationsByOfferEvent(this.offerId);
}

class AcceptApplicationEvent extends CareHomeApplicationEvent {
  final String shiftId;
  final String jobRequestItemId;
  final String offerId; // to refresh list after action
  AcceptApplicationEvent({
    required this.shiftId,
    required this.jobRequestItemId,
    required this.offerId,
  });
}

class RejectApplicationEvent extends CareHomeApplicationEvent {
  final String jobRequestItemId;
  final String offerId;

  RejectApplicationEvent({
    required this.jobRequestItemId,
    required this.offerId,
  });
}
