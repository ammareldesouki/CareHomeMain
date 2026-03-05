// domain/repositories/carehome_offers_repository.dart
import 'package:dartz/dartz.dart';

import '../../../../../core/failure/failure.dart';
import '../../data/models/offer_model.dart';

abstract class CareHomeOffersRepository {
  Future<Either<Failure, List<CareHomeOfferListItem>>> getOffers({
    required String careHomeId,
    int pageNumber = 1,
    int pageSize = 10,
  });

  Future<Either<Failure, CareHomeOfferDetail>> getOfferById(String id);

  Future<Either<Failure, void>> createOffer(CreateOfferRequest request);

  Future<Either<Failure, void>> updateOffer(
    String id,
    UpdateOfferRequest request,
  );

  Future<Either<Failure, void>> deleteOffer(String id);
}
