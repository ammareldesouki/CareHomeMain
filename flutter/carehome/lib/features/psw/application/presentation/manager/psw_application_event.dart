part of 'psw_application_bloc.dart';

@immutable
sealed class PswApplicationEvent {}

class FetchMyApplicationsEvent extends PswApplicationEvent {}

class ApplyForOfferEvent extends PswApplicationEvent {
  final String offerId;
  final List<String> shiftIds;

  ApplyForOfferEvent({required this.offerId, required this.shiftIds});
}

class CancelApplicationEvent extends PswApplicationEvent {
  final String jobRequestItemId;

  CancelApplicationEvent(this.jobRequestItemId);
}
