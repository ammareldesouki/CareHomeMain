import 'package:dartz/dartz.dart';

import '../../../../../core/failure/failure.dart';
import '../entities/offer_entity.dart';
import '../repositories/offers_repo.dart';

class GetOfferByIdUseCase {
  final OffersRepository repository;

  GetOfferByIdUseCase(this.repository);

  Future<Either<Failure, OfferDetailEntity>> call(String id) =>
      repository.getOfferById(id);
}
