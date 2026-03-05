import 'package:dartz/dartz.dart';

import '../../../../../core/failure/failure.dart';
import '../../../../../core/failure/server_failure.dart';
import '../../domain/repositories/carehome_offers_repository.dart';
import '../data_sources/care_home_offers_remote_datasource.dart';
import '../models/offer_model.dart';

class CareHomeOffersRepositoryImpl implements CareHomeOffersRepository {
  final CareHomeOffersRemoteDataSource remoteDataSource;

  CareHomeOffersRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<CareHomeOfferListItem>>> getOffers({
    required String careHomeId,
    int pageNumber = 1,
    int pageSize = 10,
  }) async {
    try {
      final list = await remoteDataSource.getOffers(
        careHomeId: careHomeId,
        pageNumber: pageNumber,
        pageSize: pageSize,
      );
      return Right(list);
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CareHomeOfferDetail>> getOfferById(String id) async {
    try {
      return Right(await remoteDataSource.getOfferById(id));
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> createOffer(CreateOfferRequest request) async {
    try {
      await remoteDataSource.createOffer(request);
      return const Right(null);
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateOffer(
    String id,
    UpdateOfferRequest request,
  ) async {
    try {
      await remoteDataSource.updateOffer(id, request);
      return const Right(null);
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteOffer(String id) async {
    try {
      await remoteDataSource.deleteOffer(id);
      return const Right(null);
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
