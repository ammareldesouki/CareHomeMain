import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/failure/server_failure.dart';
import '../../data/data_sources/offers_remote_dataSource.dart';
import '../../data/repositories/offer_repo_impl.dart';
import '../../domain/entities/offer_entity.dart';
import '../../domain/use_cases/get_offer_by_id_usecase.dart';
import '../../domain/use_cases/get_offers_usecase.dart';

part 'offers_event.dart';

part 'offers_state.dart';

class OffersBloc extends Bloc<OffersEvent, OffersState> {
  OffersBloc() : super(const OffersState()) {
    final repository = OffersRepositoryImpl(
      remoteDataSource: OffersRemoteDataSourceImpl(),
    );
    final getOffersUseCase = GetOffersUseCase(repository);
    final getOfferByIdUseCase = GetOfferByIdUseCase(repository);

    // ── Fetch list ────────────────────────────────────────────────────────────
    on<FetchOffersEvent>((event, emit) async {
      emit(state.copyWith(listLoading: true, clearListError: true));
      final result = await getOffersUseCase(
        pageNumber: event.pageNumber,
        pageSize: event.pageSize,
      );
      result.fold(
        (failure) {
          final msg = failure is ServerFailure
              ? (failure.messageEn ??
                    failure.message ??
                    'Failed to load offers')
              : 'Something went wrong';
          emit(state.copyWith(listLoading: false, listError: msg));
        },
        (offers) => emit(
          state.copyWith(
            listLoading: false,
            offers: offers,
            clearListError: true,
          ),
        ),
      );
    });

    // ── Fetch detail — NEVER touches list fields ───────────────────────────────
    on<FetchOfferDetailEvent>((event, emit) async {
      emit(
        state.copyWith(
          detailLoading: true,
          clearDetailError: true,
          clearDetail: true,
        ),
      );
      final result = await getOfferByIdUseCase(event.offerId);
      result.fold(
        (failure) {
          final msg = failure is ServerFailure
              ? (failure.messageEn ?? failure.message ?? 'Failed to load offer')
              : 'Something went wrong';
          emit(state.copyWith(detailLoading: false, detailError: msg));
        },
        (offer) => emit(
          state.copyWith(
            detailLoading: false,
            detail: offer,
            clearDetailError: true,
          ),
        ),
      );
    });
  }
}
