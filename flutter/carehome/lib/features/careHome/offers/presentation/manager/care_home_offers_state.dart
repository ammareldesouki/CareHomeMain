part of 'care_home_offers_bloc.dart';

abstract class CareHomeOffersState {}

class CareHomeOffersInitial extends CareHomeOffersState {}

// ── List ─────────────────────────────────────────────────────────────────────
class CareHomeOffersLoading extends CareHomeOffersState {}

class CareHomeOffersLoaded extends CareHomeOffersState {
  final List<CareHomeOfferListItem> offers;

  CareHomeOffersLoaded(this.offers);
}

class CareHomeOffersError extends CareHomeOffersState {
  final String message;

  CareHomeOffersError(this.message);
}

// ── Detail ───────────────────────────────────────────────────────────────────
class CareHomeOfferDetailLoading extends CareHomeOffersState {}

class CareHomeOfferDetailLoaded extends CareHomeOffersState {
  final CareHomeOfferDetail offer;

  CareHomeOfferDetailLoaded(this.offer);
}

class CareHomeOfferDetailError extends CareHomeOffersState {
  final String message;

  CareHomeOfferDetailError(this.message);
}

// ── Mutations (create / update / delete) ─────────────────────────────────────
class CareHomeOfferMutationLoading extends CareHomeOffersState {}

class CareHomeOfferMutationSuccess extends CareHomeOffersState {
  final String message;

  CareHomeOfferMutationSuccess(this.message);
}

class CareHomeOfferMutationError extends CareHomeOffersState {
  final String message;

  CareHomeOfferMutationError(this.message);
}
