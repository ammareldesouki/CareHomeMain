import 'package:dartz/dartz.dart';

import '../../../../../core/failure/failure.dart';
import '../entities/offer_entity.dart';

abstract class OffersRepository {
  Future<Either<Failure, List<OfferListItemEntity>>> getOffers({
    required int pageIndex,
    required int pageSize,
    String? careHomeId,
    String? search,
    String? sort,
  });

  Future<Either<Failure, OfferDetailEntity>> getOfferById(String id);
}