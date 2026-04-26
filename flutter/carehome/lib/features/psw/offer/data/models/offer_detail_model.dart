class ShiftModel {
  final String shiftId;
  final String date;
  final String startTime;
  final String endTime;
  final bool isAvailable;

  const ShiftModel({
    required this.shiftId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.isAvailable,
  });

  factory ShiftModel.fromMap(Map<String, dynamic> map) => ShiftModel(
    shiftId: map['shiftId'] ?? '',
    date: map['date'] ?? '',
    startTime: map['startTime'] ?? '',
    endTime: map['endTime'] ?? '',
    isAvailable: map['isAvailable'] ?? false,
  );
}

class OfferDetailModel {
  final String id;
  final String title;
  final String description;
  final String address;
  final double latitude;
  final double longitude;
  final double hourlyRate;
  final List<ShiftModel> shifts;
  final String? careHomeId;
  final String? individualId;
  final String posterName;
  final String posterType;
  final List<String> preferences;
  final String position;

  const OfferDetailModel({
    required this.id,
    required this.title,
    required this.description,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.hourlyRate,
    required this.shifts,
    this.careHomeId,
    this.individualId,
    required this.posterName,
    required this.posterType,
    required this.preferences,
    required this.position,
  });

  factory OfferDetailModel.fromMap(Map<String, dynamic> map) =>
      OfferDetailModel(
        id: map['id'] ?? '',
        title: map['title'] ?? '',
        description: map['description'] ?? '',
        address: map['address'] ?? '',
        latitude: (map['latitude'] as num?)?.toDouble() ?? 0.0,
        longitude: (map['longitude'] as num?)?.toDouble() ?? 0.0,
        hourlyRate: (map['hourlyRate'] as num?)?.toDouble() ?? 0.0,
        careHomeId: map['careHomeId'] as String?,
        individualId: map['individualId'] as String?,
        posterName: map['posterName'] ?? '',
        posterType: map['posterType'] ?? 'CareHome',
        preferences:
            (map['preferences'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [],
        position: map['position'] ?? '',
        shifts:
            (map['shifts'] as List<dynamic>?)
                ?.map((s) => ShiftModel.fromMap(s as Map<String, dynamic>))
                .toList() ??
            [],
      );
}
