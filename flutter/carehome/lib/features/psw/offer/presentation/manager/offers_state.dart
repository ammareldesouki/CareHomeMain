part of 'offers_bloc.dart';

class OffersState {
  // ── List ──────────────────────────────────────────────────────────────────
  final List<OfferListItemEntity> offers;
  final bool listLoading;
  final bool listLoadingMore; // true when appending next page
  final bool hasMore;
  final String? listError;

  // ── Detail ────────────────────────────────────────────────────────────────
  final OfferDetailEntity? detail;
  final bool detailLoading;
  final String? detailError;

  const OffersState({
    this.offers = const [],
    this.listLoading = false,
    this.listLoadingMore = false,
    this.hasMore = true,
    this.listError,
    this.detail,
    this.detailLoading = false,
    this.detailError,
  });

  OffersState copyWith({
    List<OfferListItemEntity>? offers,
    bool? listLoading,
    bool? listLoadingMore,
    bool? hasMore,
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
      listLoadingMore: listLoadingMore ?? this.listLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      listError: clearListError ? null : (listError ?? this.listError),
      detail: clearDetail ? null : (detail ?? this.detail),
      detailLoading: detailLoading ?? this.detailLoading,
      detailError: clearDetailError ? null : (detailError ?? this.detailError),
    );
  }
}