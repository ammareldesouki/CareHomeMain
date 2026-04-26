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

  // ── New fields from API ────────────────────────────────────────────────────
  final String? careHomeId;
  final String? individualId;
  final String posterName;
  final String posterType; // "Individual" | "CareHome"

  const OfferListItemEntity({
    required this.id,
    required this.title,
    required this.address,
    required this.hourlyRate,
    required this.latitude,
    required this.longitude,
    this.careHomeId,
    this.individualId,
    required this.posterName,
    required this.posterType,
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

  // ── New fields ─────────────────────────────────────────────────────────────
  final String? careHomeId;
  final String? individualId;
  final String posterName;
  final String posterType; // "Individual" | "CareHome"
  final List<String> preferences;
  final String position;

  const OfferDetailEntity({
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

  /// For Individual offers the address is shown as a postal-code only label.
  bool get isIndividual => posterType.toLowerCase() == 'individual';
}
