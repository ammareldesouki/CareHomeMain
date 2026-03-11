part of 'admin_bloc.dart';

@immutable
abstract class AdminState {}

class AdminInitial extends AdminState {}

// ── Verification states ───────────────────────────────────────────────────────
class VerificationsLoading extends AdminState {}

class VerificationsLoaded extends AdminState {
  final List<AdminPswVerificationEntity> list;

  VerificationsLoaded(this.list);
}

class VerificationsError extends AdminState {
  final String message;

  VerificationsError(this.message);
}

class VerificationMutationLoading extends AdminState {}

class VerificationMutationSuccess extends AdminState {
  final String message;

  VerificationMutationSuccess(this.message);
}

class VerificationMutationError extends AdminState {
  final String message;

  VerificationMutationError(this.message);
}

// ── Application states ────────────────────────────────────────────────────────
class ApplicationsLoading extends AdminState {}

class ApplicationsLoaded extends AdminState {
  final List<AdminApplicationEntity> list;

  ApplicationsLoaded(this.list);
}

class ApplicationsError extends AdminState {
  final String message;

  ApplicationsError(this.message);
}

class ApplicationMutationLoading extends AdminState {}

class ApplicationMutationSuccess extends AdminState {
  final String message;

  ApplicationMutationSuccess(this.message);
}

class ApplicationMutationError extends AdminState {
  final String message;

  ApplicationMutationError(this.message);
}

// ── Offer states ──────────────────────────────────────────────────────────────
class AdminOffersLoading extends AdminState {}

class AdminOffersLoaded extends AdminState {
  final List<AdminOfferEntity> list;

  AdminOffersLoaded(this.list);
}

class AdminOffersError extends AdminState {
  final String message;

  AdminOffersError(this.message);
}

class OfferMutationLoading extends AdminState {}

class OfferMutationSuccess extends AdminState {
  final String message;

  OfferMutationSuccess(this.message);
}

class OfferMutationError extends AdminState {
  final String message;

  OfferMutationError(this.message);
}
