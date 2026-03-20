part of 'offers_bloc.dart';

abstract class OffersEvent {}

/// Fetch page 1 — replaces list for the given tab.
class FetchOffersEvent extends OffersEvent {
  /// null → All, "Individual" → individual tab, "CareHome" → org tab
  final String? posterType;
  final int pageIndex;
  final int pageSize;
  final String? search;
  final String? sort;

  FetchOffersEvent({
    this.posterType,
    this.pageIndex = 1,
    this.pageSize = 10,
    this.search,
    this.sort,
  });
}

/// Appends the next page (infinite scroll).
class LoadMoreOffersEvent extends OffersEvent {
  final String? posterType;
  final int pageIndex;
  final int pageSize;
  final String? search;
  final String? sort;

  LoadMoreOffersEvent({
    this.posterType,
    required this.pageIndex,
    this.pageSize = 10,
    this.search,
    this.sort,
  });
}

class FetchOfferDetailEvent extends OffersEvent {
  final String offerId;
  FetchOfferDetailEvent(this.offerId);
}