import '../../domain/entities/psw_application_entity.dart';

class PswApplicationModel extends PswApplicationEntity {
  const PswApplicationModel({
    required super.jobRequestItemId,
    required super.offerId,
    required super.offerTitle,
    required super.careHomeName,
    required super.address,
    required super.hourlyRate,
    required super.shiftDate,
    required super.startTime,
    required super.endTime,
    required super.statusCode,
  });

  factory PswApplicationModel.fromMap(Map<String, dynamic> map) {
    return PswApplicationModel(
      jobRequestItemId: map['jobRequestItemId'] ?? map['id'] ?? '',
      offerId: map['offerId'] ?? '',
      offerTitle: map['offerTitle'] ?? map['title'] ?? '',
      careHomeName: map['careHomeName'] ?? '',
      address: map['address'] ?? '',
      hourlyRate: (map['hourlyRate'] ?? 0).toDouble(),
      shiftDate: map['shiftDate'] ?? map['date'] ?? '',
      startTime: map['startTime'] ?? '',
      endTime: map['endTime'] ?? '',
      statusCode: map['status'] ?? 1,
    );
  }
}
