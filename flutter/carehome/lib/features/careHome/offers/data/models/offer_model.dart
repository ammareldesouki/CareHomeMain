// ── Shift request — used in both Create and Update ────────────────────────────
class ShiftRequest {
  final String? shiftId; // null for new shifts; required by PUT for existing
  final String date; // "2026-03-04"
  final String startTime; // "09:00:00"
  final String endTime; // "17:00:00"

  const ShiftRequest({
    this.shiftId,
    required this.date,
    required this.startTime,
    required this.endTime,
  });

  Map<String, dynamic> toMap() {
    final m = <String, dynamic>{
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
    };
    if (shiftId != null && shiftId!.isNotEmpty) m['shiftId'] = shiftId;
    return m;
  }
}

// ── Create offer request ──────────────────────────────────────────────────────
class CreateOfferRequest {
  final String title;
  final String description;
  final String address;
  final double latitude;
  final double longitude;
  final double hourlyRate;
  final List<ShiftRequest> shifts;

  const CreateOfferRequest({
    required this.title,
    required this.description,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.hourlyRate,
    required this.shifts,
  });

  Map<String, dynamic> toMap() => {
    'title': title,
    'description': description,
    'address': address,
    'latitude': latitude,
    'longitude': longitude,
    'hourlyRate': hourlyRate,
    'shifts': shifts.map((s) => s.toMap()).toList(),
  };
}

// ── Update offer request — same shape but shifts carry shiftId ────────────────
class UpdateOfferRequest extends CreateOfferRequest {
  const UpdateOfferRequest({
    required super.title,
    required super.description,
    required super.address,
    required super.latitude,
    required super.longitude,
    required super.hourlyRate,
    required super.shifts,
  });
}

// ── Paginated wrapper returned by GET /api/offers ─────────────────────────────
class OffersPage {
  final List<CareHomeOfferListItem> items;
  final int totalCount;
  final int pageIndex;
  final int pageSize;

  const OffersPage({
    required this.items,
    required this.totalCount,
    required this.pageIndex,
    required this.pageSize,
  });

  // Used for infinite scroll: determines if the *next* page exists.
  // Works for both 0-based and 1-based pageIndex.
  int get _startOffset => pageIndex == 0 ? 0 : (pageIndex - 1) * pageSize;

  bool get hasMore => _startOffset + items.length < totalCount;
}

// ── List item (GET /api/offers?careHomeId=) ───────────────────────────────────
class CareHomeOfferListItem {
  final String id;
  final String title;
  final String address;
  final double hourlyRate;

  const CareHomeOfferListItem({
    required this.id,
    required this.title,
    required this.address,
    required this.hourlyRate,
  });

  factory CareHomeOfferListItem.fromMap(Map<String, dynamic> map) =>
      CareHomeOfferListItem(
        id: map['id'] ?? '',
        title: map['title'] ?? '',
        address: map['address'] ?? '',
        hourlyRate: (map['hourlyRate'] as num?)?.toDouble() ?? 0.0,
      );
}

// ── Detail (GET /api/offers/{id}) ─────────────────────────────────────────────
class CareHomeShift {
  final String shiftId;
  final String date;
  final String startTime;
  final String endTime;
  final bool isAvailable;

  const CareHomeShift({
    required this.shiftId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.isAvailable,
  });

  factory CareHomeShift.fromMap(Map<String, dynamic> map) => CareHomeShift(
    shiftId: map['shiftId'] ?? '',
    date: map['date'] ?? '',
    startTime: map['startTime'] ?? '',
    endTime: map['endTime'] ?? '',
    isAvailable: map['isAvailable'] ?? false,
  );
}

class CareHomeOfferDetail {
  final String id;
  final String title;
  final String description;
  final String address;
  final double latitude;
  final double longitude;
  final double hourlyRate;
  final List<CareHomeShift> shifts;

  const CareHomeOfferDetail({
    required this.id,
    required this.title,
    required this.description,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.hourlyRate,
    required this.shifts,
  });

  factory CareHomeOfferDetail.fromMap(Map<String, dynamic> map) =>
      CareHomeOfferDetail(
        id: map['id'] ?? '',
        title: map['title'] ?? '',
        description: map['description'] ?? '',
        address: map['address'] ?? '',
        latitude: (map['latitude'] as num?)?.toDouble() ?? 0.0,
        longitude: (map['longitude'] as num?)?.toDouble() ?? 0.0,
        hourlyRate: (map['hourlyRate'] as num?)?.toDouble() ?? 0.0,
        shifts: (map['shifts'] as List<dynamic>? ?? [])
            .map((s) => CareHomeShift.fromMap(s as Map<String, dynamic>))
            .toList(),
      );
}