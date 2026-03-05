part of 'offers_bloc.dart';

abstract class OffersEvent {}

class FetchOffersEvent extends OffersEvent {
  final int pageNumber;
  final int pageSize;

  FetchOffersEvent({this.pageNumber = 1, this.pageSize = 10});
}

class FetchOfferDetailEvent extends OffersEvent {
  final String offerId;

  FetchOfferDetailEvent(this.offerId);
}
