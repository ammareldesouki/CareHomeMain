import 'package:dartz/dartz.dart';

import '../../../../../core/failure/failure.dart';
import '../entities/offer_entity.dart';
import '../repositories/offers_repo.dart';

class GetOffersUseCase {
  final OffersRepository repository;

  GetOffersUseCase(this.repository);

  Future<Either<Failure, List<OfferListItemEntity>>> call({
    int pageIndex = 1,
    int pageSize = 10,
    String? careHomeId,
    String? search,
    String? sort,
  }) => repository.getOffers(
    pageIndex: pageIndex,
    pageSize: pageSize,
    careHomeId: careHomeId,
    search: search,
    sort: sort,
  );
}