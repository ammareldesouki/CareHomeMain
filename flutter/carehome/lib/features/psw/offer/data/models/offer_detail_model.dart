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

  const OfferDetailModel({
    required this.id,
    required this.title,
    required this.description,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.hourlyRate,
    required this.shifts,
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
        shifts:
            (map['shifts'] as List<dynamic>?)
                ?.map((s) => ShiftModel.fromMap(s as Map<String, dynamic>))
                .toList() ??
            [],
      );
}
