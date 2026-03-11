part of 'offers_bloc.dart';

/// Single combined state — list and detail are stored independently.
/// Fetching detail NEVER wipes the loaded offers list.
class OffersState {
  // ── List ──────────────────────────────────────────────────────────────────
  final List<OfferListItemEntity> offers;
  final bool listLoading;
  final String? listError;

  // ── Detail ────────────────────────────────────────────────────────────────
  final OfferDetailEntity? detail;
  final bool detailLoading;
  final String? detailError;

  const OffersState({
    this.offers = const [],
    this.listLoading = false,
    this.listError,
    this.detail,
    this.detailLoading = false,
    this.detailError,
  });

  OffersState copyWith({
    List<OfferListItemEntity>? offers,
    bool? listLoading,
    String? listError,
    bool clearListError = false,
    OfferDetailEntity? detail,
    bool? detailLoading,
    String? detailError,
    bool clearDetailError = false,
    bool clearDetail = false,
  }) {
    return OffersState(
      offers: offers ?? this.offers,
      listLoading: listLoading ?? this.listLoading,
      listError: clearListError ? null : (listError ?? this.listError),
      detail: clearDetail ? null : (detail ?? this.detail),
      detailLoading: detailLoading ?? this.detailLoading,
      detailError: clearDetailError ? null : (detailError ?? this.detailError),
    );
  }
}
