import 'package:dartz/dartz.dart';

import '../../../../../core/failure/failure.dart';
import '../../data/models/offer_model.dart';

abstract class CareHomeOffersRepository {
  Future<Either<Failure, OffersPage>> getOffers({
    required String careHomeId,
    required int pageIndex,
    required int pageSize,
    required String? search,
    required String? sort,
  });

  Future<Either<Failure, CareHomeOfferDetail>> getOfferById(String id);
  Future<Either<Failure, void>> createOffer(CreateOfferRequest request);

  Future<Either<Failure, void>> updateOffer(String id,
      UpdateOfferRequest request);
  Future<Either<Failure, void>> deleteOffer(String id);
}