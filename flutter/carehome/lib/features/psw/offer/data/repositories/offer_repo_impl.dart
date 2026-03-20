import 'package:dartz/dartz.dart';

import '../../../../../core/failure/failure.dart';
import '../../../../../core/failure/server_failure.dart';
import '../../domain/entities/offer_entity.dart';
import '../../domain/repositories/offers_repo.dart';
import '../data_sources/offers_remote_dataSource.dart';

class OffersRepositoryImpl implements OffersRepository {
  final OffersRemoteDataSource remoteDataSource;

  OffersRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<OfferListItemEntity>>> getOffers({
    required int pageIndex,
    required int pageSize,
    String? careHomeId,
    String? search,
    String? sort,
  }) async {
    try {
      final models = await remoteDataSource.getOffers(
        pageIndex: pageIndex,
        pageSize: pageSize,
        careHomeId: careHomeId,
        search: search,
        sort: sort,
      );
      final entities = models
          .map((m) =>
          OfferListItemEntity(
            id: m.id,
            title: m.title,
            address: m.address,
            hourlyRate: m.hourlyRate,
            latitude: m.latitude,
            longitude: m.longitude,
            careHomeId: m.careHomeId,
            individualId: m.individualId,
            posterName: m.posterName,
            posterType: m.posterType,
          ))
          .toList();
      return Right(entities);
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, OfferDetailEntity>> getOfferById(String id) async {
    try {
      final model = await remoteDataSource.getOfferById(id);
      final entity = OfferDetailEntity(
        id: model.id,
        title: model.title,
        description: model.description,
        address: model.address,
        latitude: model.latitude,
        longitude: model.longitude,
        hourlyRate: model.hourlyRate,
        careHomeId: model.careHomeId,
        individualId: model.individualId,
        posterName: model.posterName,
        posterType: model.posterType,
        shifts: model.shifts
            .map((s) =>
            ShiftEntity(
              shiftId: s.shiftId,
              date: s.date,
              startTime: s.startTime,
              endTime: s.endTime,
              isAvailable: s.isAvailable,
            ))
            .toList(),
      );
      return Right(entity);
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}