import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/data.dart';
import '../../../../../core/failure/server_failure.dart';
import '../../data/data_sources/offers_remote_dataSource.dart';
import '../../data/repositories/offer_repo_impl.dart';
import '../../domain/entities/offer_entity.dart';
import '../../domain/use_cases/get_offer_by_id_usecase.dart';
import '../../domain/use_cases/get_offers_usecase.dart';

part 'offers_event.dart';
part 'offers_state.dart';

class OffersBloc extends Bloc<OffersEvent, OffersState> {
  late final GetOffersUseCase _getOffersUseCase;
  late final GetOfferByIdUseCase _getOfferByIdUseCase;

  // Remember last params for load-more context
  static const int _pageSize = Data.kOffersPageSize;

  OffersBloc() : super(const OffersState()) {
    final repository = OffersRepositoryImpl(
      remoteDataSource: OffersRemoteDataSourceImpl(),
    );
    _getOffersUseCase = GetOffersUseCase(repository);
    _getOfferByIdUseCase = GetOfferByIdUseCase(repository);

    // ── Fresh fetch (page 1) ──────────────────────────────────────────────
    on<FetchOffersEvent>((event, emit) async {
      emit(state.copyWith(
        listLoading: true,
        clearListError: true,
        offers: [], // clear old list on fresh fetch
        hasMore: true,
      ));

      // When posterType is "Individual" we don't send CareHomeId;
      // when it is "CareHome" we let the API filter by posterType via search.
      // The API supports CareHomeId filter — for CareHome tab we leave it null
      // so it returns all CareHome offers; for Individual tab same.
      // Both tabs send no CareHomeId — filtering is done client-side already
      // from posterType field in the returned items (API doesn't have
      // posterType query param in the swagger). So we fetch all and the
      // UI filters the tab view by posterType locally.
      final result = await _getOffersUseCase(
        pageIndex: event.pageIndex,
        pageSize: event.pageSize,
        search: event.search,
        sort: event.sort,
      );

      result.fold(
            (failure) {
          final msg = failure is ServerFailure
              ? (failure.messageEn ?? failure.message ??
              'Failed to load offers')
              : 'Something went wrong';
          emit(state.copyWith(listLoading: false, listError: msg));
        },
            (offers) =>
            emit(state.copyWith(
              listLoading: false,
              offers: offers,
              clearListError: true,
              hasMore: offers.length >= event.pageSize,
            )),
      );
    });

    // ── Load more (next page, appends) ────────────────────────────────────
    on<LoadMoreOffersEvent>((event, emit) async {
      if (state.listLoadingMore) return;
      emit(state.copyWith(listLoadingMore: true));

      final result = await _getOffersUseCase(
        pageIndex: event.pageIndex,
        pageSize: event.pageSize,
        search: event.search,
        sort: event.sort,
      );

      result.fold(
            (_) => emit(state.copyWith(listLoadingMore: false)),
            (newOffers) =>
            emit(state.copyWith(
              listLoadingMore: false,
              offers: [...state.offers, ...newOffers],
              hasMore: newOffers.length >= event.pageSize,
            )),
      );
    });

    // ── Fetch detail — NEVER touches list fields ───────────────────────────
    on<FetchOfferDetailEvent>((event, emit) async {
      emit(state.copyWith(
        detailLoading: true,
        clearDetailError: true,
        clearDetail: true,
      ));
      final result = await _getOfferByIdUseCase(event.offerId);
      result.fold(
            (failure) {
          final msg = failure is ServerFailure
              ? (failure.messageEn ?? failure.message ?? 'Failed to load offer')
              : 'Something went wrong';
          emit(state.copyWith(detailLoading: false, detailError: msg));
        },
            (offer) =>
            emit(state.copyWith(
              detailLoading: false,
              detail: offer,
              clearDetailError: true,
            )),
      );
    });
  }
}