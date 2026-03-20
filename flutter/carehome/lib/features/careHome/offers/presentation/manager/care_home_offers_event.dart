part of 'care_home_offers_bloc.dart';

abstract class CareHomeOffersEvent {}

/// Fresh load (page 1). Replaces the list.
class FetchCareHomeOffersEvent extends CareHomeOffersEvent {
  final String careHomeId;
  final int pageIndex;
  final int pageSize;
  final String? search;
  final String? sort;

  FetchCareHomeOffersEvent({
    required this.careHomeId,
    this.pageIndex = 1,
    this.pageSize = 10,
    this.search,
    this.sort,
  });
}

/// Appends the next page (infinite scroll).
class LoadMoreCareHomeOffersEvent extends CareHomeOffersEvent {
  final int pageIndex;
  final int pageSize;
  final String? search;
  final String? sort;

  LoadMoreCareHomeOffersEvent({
    required this.pageIndex,
    this.pageSize = 10,
    this.search,
    this.sort,
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