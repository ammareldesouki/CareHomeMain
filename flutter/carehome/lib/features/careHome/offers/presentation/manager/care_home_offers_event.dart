part of 'care_home_offers_bloc.dart';

abstract class CareHomeOffersEvent {}

class FetchCareHomeOffersEvent extends CareHomeOffersEvent {
  final String careHomeId;
  final int pageNumber;
  final int pageSize;

  FetchCareHomeOffersEvent({
    required this.careHomeId,
    this.pageNumber = 1,
    this.pageSize = 10,
  });
}

class FetchCareHomeOfferDetailEvent extends CareHomeOffersEvent {
  final String offerId;

  FetchCareHomeOfferDetailEvent(this.offerId);
}

class CreateOfferEvent extends CareHomeOffersEvent {
  final CreateOfferRequest request;

  CreateOfferEvent(this.request);
}

class UpdateOfferEvent extends CareHomeOffersEvent {
  final String offerId;
  final UpdateOfferRequest request;

  UpdateOfferEvent({required this.offerId, required this.request});
}

class DeleteOfferEvent extends CareHomeOffersEvent {
  final String offerId;

  DeleteOfferEvent(this.offerId);
}
