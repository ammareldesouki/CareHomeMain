part of 'care_home_offers_bloc.dart';

abstract class CareHomeOffersState {}

class CareHomeOffersInitial extends CareHomeOffersState {}

// ── List ──────────────────────────────────────────────────────────────────────

class CareHomeOffersLoading extends CareHomeOffersState {}

class CareHomeOffersLoaded extends CareHomeOffersState {
  final List<CareHomeOfferListItem> offers;
  final int totalCount;
  final bool hasMore;
  final bool isLoadingMore;

  CareHomeOffersLoaded({
    required this.offers,
    required this.totalCount,
    this.hasMore = false,
    this.isLoadingMore = false,
  });

  CareHomeOffersLoaded copyWith({
    List<CareHomeOfferListItem>? offers,
    int? totalCount,
    bool? hasMore,
    bool? isLoadingMore,
  }) => CareHomeOffersLoaded(
    offers: offers ?? this.offers,
    totalCount: totalCount ?? this.totalCount,
    hasMore: hasMore ?? this.hasMore,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
  );
}

class CareHomeOffersError extends CareHomeOffersState {
  final String message;
  CareHomeOffersError(this.message);
}

// ── Detail ────────────────────────────────────────────────────────────────────

class CareHomeOfferDetailLoading extends CareHomeOffersState {}

class CareHomeOfferDetailLoaded extends CareHomeOffersState {
  final CareHomeOfferDetail offer;
  CareHomeOfferDetailLoaded(this.offer);
}

class CareHomeOfferDetailError extends CareHomeOffersState {
  final String message;
  CareHomeOfferDetailError(this.message);
}

// ── Mutations ─────────────────────────────────────────────────────────────────

class CareHomeOfferMutationLoading extends CareHomeOffersState {}

class CareHomeOfferMutationSuccess extends CareHomeOffersState {
  final String message;
  CareHomeOfferMutationSuccess(this.message);
}

class CareHomeOfferMutationError extends CareHomeOffersState {
  final String message;
  CareHomeOfferMutationError(this.message);
}