class ShiftEntity {
  final String shiftId;
  final String date;
  final String startTime;
  final String endTime;
  final bool isAvailable;

  const ShiftEntity({
    required this.shiftId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.isAvailable,
  });
}

class OfferListItemEntity {
  final String id;
  final String title;
  final String address;
  final double hourlyRate;
  final double latitude;
  final double longitude;

  const OfferListItemEntity({
    required this.id,
    required this.title,
    required this.address,
    required this.hourlyRate,
    required this.latitude,
    required this.longitude,
  });
}

class OfferDetailEntity {
  final String id;
  final String title;
  final String description;
  final String address;
  final double latitude;
  final double longitude;
  final double hourlyRate;
  final List<ShiftEntity> shifts;

  const OfferDetailEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.hourlyRate,
    required this.shifts,
  });
}
