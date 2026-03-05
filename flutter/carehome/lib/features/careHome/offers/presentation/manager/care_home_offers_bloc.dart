import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/failure/server_failure.dart';
import '../../data/data_sources/care_home_offers_remote_datasource.dart';
import '../../data/models/offer_model.dart';
import '../../data/repositories/carehome_offers_repository_impl.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'care_home_offers_event.dart';

part 'care_home_offers_state.dart';

class CareHomeOffersBloc
    extends Bloc<CareHomeOffersEvent, CareHomeOffersState> {
  // Keep last-loaded list so we can restore after mutations
  List<CareHomeOfferListItem> _cachedOffers = [];
  String _cachedCareHomeId = '';

  CareHomeOffersBloc() : super(CareHomeOffersInitial()) {
    final repo = CareHomeOffersRepositoryImpl(
      remoteDataSource: CareHomeOffersRemoteDataSourceImpl(),
    );

    String _errorMsg(dynamic failure) => failure is ServerFailure
        ? (failure.messageEn ?? failure.message ?? 'Something went wrong')
        : 'Something went wrong';

    // ── Fetch list ────────────────────────────────────────────────────────────
    on<FetchCareHomeOffersEvent>((event, emit) async {
      _cachedCareHomeId = event.careHomeId;
      emit(CareHomeOffersLoading());
      final result = await repo.getOffers(
        careHomeId: event.careHomeId,
        pageNumber: event.pageNumber,
        pageSize: event.pageSize,
      );
      result.fold((f) => emit(CareHomeOffersError(_errorMsg(f))), (list) {
        _cachedOffers = list;
        emit(CareHomeOffersLoaded(list));
      });
    });

    // ── Fetch detail ──────────────────────────────────────────────────────────
    on<FetchCareHomeOfferDetailEvent>((event, emit) async {
      emit(CareHomeOfferDetailLoading());
      final result = await repo.getOfferById(event.offerId);
      result.fold(
        (f) => emit(CareHomeOfferDetailError(_errorMsg(f))),
        (detail) => emit(CareHomeOfferDetailLoaded(detail)),
      );
    });

    // ── Create ────────────────────────────────────────────────────────────────
    on<CreateOfferEvent>((event, emit) async {
      emit(CareHomeOfferMutationLoading());
      final result = await repo.createOffer(event.request);
      result.fold((f) => emit(CareHomeOfferMutationError(_errorMsg(f))), (_) {
        emit(CareHomeOfferMutationSuccess('Offer created successfully'));
        // Refresh list
        if (_cachedCareHomeId.isNotEmpty) {
          add(FetchCareHomeOffersEvent(careHomeId: _cachedCareHomeId));
        }
      });
    });

    // ── Update ────────────────────────────────────────────────────────────────
    on<UpdateOfferEvent>((event, emit) async {
      emit(CareHomeOfferMutationLoading());
      final result = await repo.updateOffer(event.offerId, event.request);
      result.fold((f) => emit(CareHomeOfferMutationError(_errorMsg(f))), (_) {
        emit(CareHomeOfferMutationSuccess('Offer updated successfully'));
        if (_cachedCareHomeId.isNotEmpty) {
          add(FetchCareHomeOffersEvent(careHomeId: _cachedCareHomeId));
        }
      });
    });

    // ── Delete ────────────────────────────────────────────────────────────────
    on<DeleteOfferEvent>((event, emit) async {
      emit(CareHomeOfferMutationLoading());
      final result = await repo.deleteOffer(event.offerId);
      result.fold((f) => emit(CareHomeOfferMutationError(_errorMsg(f))), (_) {
        emit(CareHomeOfferMutationSuccess('Offer deleted'));
        if (_cachedCareHomeId.isNotEmpty) {
          add(FetchCareHomeOffersEvent(careHomeId: _cachedCareHomeId));
        }
      });
    });
  }
}
