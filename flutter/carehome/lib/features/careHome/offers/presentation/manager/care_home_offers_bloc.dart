import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../../../core/constants/data.dart';
import '../../../../../core/failure/server_failure.dart';
import '../../data/data_sources/care_home_offers_remote_datasource.dart';
import '../../data/models/offer_model.dart';
import '../../data/repositories/carehome_offers_repository_impl.dart';

part 'care_home_offers_event.dart';
part 'care_home_offers_state.dart';

class CareHomeOffersBloc
    extends Bloc<CareHomeOffersEvent, CareHomeOffersState> {
  // Cache last params for post-mutation re-fetch
  String _cachedCareHomeId = '';
  String? _cachedSearch;
  String? _cachedSort;
  static const int _pageSize = Data.kOffersPageSize;

  CareHomeOffersBloc() : super(CareHomeOffersInitial()) {
    final repo = CareHomeOffersRepositoryImpl(
      remoteDataSource: CareHomeOffersRemoteDataSourceImpl(),
    );

    String _errMsg(dynamic f) =>
        f is ServerFailure
            ? (f.messageEn ?? f.message ?? 'Something went wrong')
        : 'Something went wrong';

    // ── Fresh fetch ────────────────────────────────────────────────────────
    on<FetchCareHomeOffersEvent>((event, emit) async {
      _cachedCareHomeId = event.careHomeId;
      _cachedSearch = event.search;
      _cachedSort = event.sort;

      emit(CareHomeOffersLoading());
      final result = await repo.getOffers(
        careHomeId: event.careHomeId,
        pageIndex: event.pageIndex,
        pageSize: event.pageSize,
        search: event.search,
        sort: event.sort,
      );
      result.fold(
            (f) => emit(CareHomeOffersError(_errMsg(f))),
            (page) =>
            emit(CareHomeOffersLoaded(
              offers: page.items,
              totalCount: page.totalCount,
              hasMore: page.hasMore,
            )),
      );
    });

    // ── Load more (append) ─────────────────────────────────────────────────
    on<LoadMoreCareHomeOffersEvent>((event, emit) async {
      final current = state;
      if (current is! CareHomeOffersLoaded || current.isLoadingMore) return;

      emit(current.copyWith(isLoadingMore: true));
      final result = await repo.getOffers(
        careHomeId: _cachedCareHomeId,
        pageIndex: event.pageIndex,
        pageSize: event.pageSize,
        search: event.search ?? _cachedSearch,
        sort: event.sort ?? _cachedSort,
      );
      result.fold(
            (_) => emit(current.copyWith(isLoadingMore: false)),
            (page) =>
            emit(CareHomeOffersLoaded(
              offers: [...current.offers, ...page.items],
              totalCount: page.totalCount,
              hasMore: page.hasMore,
              isLoadingMore: false,
            )),
      );
    });

    // ── Detail ─────────────────────────────────────────────────────────────
    on<FetchCareHomeOfferDetailEvent>((event, emit) async {
      emit(CareHomeOfferDetailLoading());
      final result = await repo.getOfferById(event.offerId);
      result.fold(
            (f) => emit(CareHomeOfferDetailError(_errMsg(f))),
            (detail) => emit(CareHomeOfferDetailLoaded(detail)),
      );
    });

    // ── Create ─────────────────────────────────────────────────────────────
    on<CreateOfferEvent>((event, emit) async {
      emit(CareHomeOfferMutationLoading());
      final result = await repo.createOffer(event.request);
      result.fold(
            (f) => emit(CareHomeOfferMutationError(_errMsg(f))),
            (_) {
          emit(CareHomeOfferMutationSuccess('Offer created successfully'));
          if (_cachedCareHomeId.isNotEmpty) {
            add(FetchCareHomeOffersEvent(
              careHomeId: _cachedCareHomeId,
              search: _cachedSearch,
              sort: _cachedSort,
            ));
          }
        },
      );
    });

    // ── Update ─────────────────────────────────────────────────────────────
    on<UpdateOfferEvent>((event, emit) async {
      emit(CareHomeOfferMutationLoading());
      final result = await repo.updateOffer(event.offerId, event.request);
      result.fold(
            (f) => emit(CareHomeOfferMutationError(_errMsg(f))),
            (_) {
          emit(CareHomeOfferMutationSuccess('Offer updated successfully'));
          if (_cachedCareHomeId.isNotEmpty) {
            add(FetchCareHomeOffersEvent(
              careHomeId: _cachedCareHomeId,
              search: _cachedSearch,
              sort: _cachedSort,
            ));
          }
        },
      );
    });

    // ── Delete ─────────────────────────────────────────────────────────────
    on<DeleteOfferEvent>((event, emit) async {
      emit(CareHomeOfferMutationLoading());
      final result = await repo.deleteOffer(event.offerId);
      result.fold(
            (f) => emit(CareHomeOfferMutationError(_errMsg(f))),
            (_) {
          emit(CareHomeOfferMutationSuccess('Offer deleted'));
          if (_cachedCareHomeId.isNotEmpty) {
            add(FetchCareHomeOffersEvent(
              careHomeId: _cachedCareHomeId,
              search: _cachedSearch,
              sort: _cachedSort,
            ));
          }
        },
      );
    });
  }
}