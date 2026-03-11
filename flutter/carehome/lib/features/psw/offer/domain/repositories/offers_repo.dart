import 'package:dartz/dartz.dart';

import '../../../../../core/failure/failure.dart';
import '../entities/offer_entity.dart';

abstract class OffersRepository {
  Future<Either<Failure, List<OfferListItemEntity>>> getOffers({
    required int pageNumber,
    required int pageSize,
  });

  Future<Either<Failure, OfferDetailEntity>> getOfferById(String id);
}
