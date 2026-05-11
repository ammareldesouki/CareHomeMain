// ── Shift request — used in both Create and Update ────────────────────────────
class ShiftRequest {
  final String? shiftId; // null for new shifts; required by PUT for existing
  final String date; // "2026-03-04"
  final String startTime; // "09:00:00.0000000"
  final String endTime; // "17:00:00.0000000"

  const ShiftRequest({
    this.shiftId,
    required this.date,
    required this.startTime,
    required this.endTime,
  });

  Map<String, dynamic> toMap() {
    final m = <String, dynamic>{
      'Date': date,
      'StartTime': startTime,
      'EndTime': endTime,
    };
    if (shiftId != null && shiftId!.isNotEmpty) m['ShiftId'] = shiftId;
    return m;
  }
}

// ── Create offer request ──────────────────────────────────────────────────────
class CreateOfferRequest {
  final String title;
  final String position;
  final String description;
  final String address;
  final String? address2;
  final String city;
  final String postalCode;
  final String province;
  final double latitude;
  final double longitude;
  final double hourlyRate;
  final List<String> preferences;
  final List<ShiftRequest> shifts;

  const CreateOfferRequest({
    required this.title,
    required this.position,
    required this.description,
    required this.address,
    this.address2,
    required this.city,
    required this.postalCode,
    required this.province,
    required this.latitude,
    required this.longitude,
    required this.hourlyRate,
    required this.preferences,
    required this.shifts,
  });

  Map<String, dynamic> toMap() => {
    'Title': title,
    'Position': position,
    'Description': description,
    'Address': address,
    if (address2 != null) 'Address2': address2,
    'City': city,
    'PostalCode': postalCode,
    'Province': province,
    'Latitude': latitude,
    'Longitude': longitude,
    'HourlyRate': hourlyRate,
    'Preferences': preferences,
    'Shifts': shifts.map((s) => s.toMap()).toList(),
  };
}

// ── Update offer request — same shape but shifts carry shiftId ────────────────
class UpdateOfferRequest extends CreateOfferRequest {
  final String id;

  const UpdateOfferRequest({
    required this.id,
    required super.title,
    required super.position,
    required super.description,
    required super.address,
    super.address2,
    required super.city,
    required super.postalCode,
    required super.province,
    required super.latitude,
    required super.longitude,
    required super.hourlyRate,
    required super.preferences,
    required super.shifts,
  });

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map['Id'] = id;
    return map;
  }
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
        id: map['id'] ?? map['Id'] ?? '',
        title: map['title'] ?? map['Title'] ?? '',
        address: map['address'] ?? map['Address'] ?? '',
        hourlyRate: (map['hourlyRate'] ?? map['HourlyRate'] ?? 0.0).toDouble(),
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
    shiftId: map['shiftId'] ?? map['ShiftId'] ?? map['id'] ?? map['Id'] ?? '',
    date: map['date'] ?? map['Date'] ?? '',
    startTime: map['startTime'] ?? map['StartTime'] ?? '',
    endTime: map['endTime'] ?? map['EndTime'] ?? '',
    isAvailable: map['isAvailable'] ?? map['IsAvailable'] ?? false,
  );
}

class CareHomeOfferDetail {
  final String id;
  final String title;
  final String position;
  final String description;
  final String address;
  final String? address2;
  final String city;
  final String postalCode;
  final String province;
  final double latitude;
  final double longitude;
  final double hourlyRate;
  final List<String> preferences;
  final List<CareHomeShift> shifts;

  const CareHomeOfferDetail({
    required this.id,
    required this.title,
    required this.position,
    required this.description,
    required this.address,
    this.address2,
    required this.city,
    required this.postalCode,
    required this.province,
    required this.latitude,
    required this.longitude,
    required this.hourlyRate,
    required this.preferences,
    required this.shifts,
  });

  factory CareHomeOfferDetail.fromMap(Map<String, dynamic> map) =>
      CareHomeOfferDetail(
        id: map['id'] ?? map['Id'] ?? '',
        title: map['title'] ?? map['Title'] ?? '',
        position: map['position'] ?? map['Position'] ?? '',
        description: map['description'] ?? map['Description'] ?? '',
        address: map['address'] ?? map['Address'] ?? '',
        address2: map['address2'] ?? map['Address2'],
        city: map['city'] ?? map['City'] ?? '',
        postalCode: map['postalCode'] ?? map['PostalCode'] ?? '',
        province: map['province'] ?? map['Province'] ?? '',
        latitude: (map['latitude'] ?? map['Latitude'] ?? 0.0).toDouble(),
        longitude: (map['longitude'] ?? map['Longitude'] ?? 0.0).toDouble(),
        hourlyRate: (map['hourlyRate'] ?? map['HourlyRate'] ?? 0.0).toDouble(),
        preferences: List<String>.from(
            map['preferences'] ?? map['Preferences'] ?? []),
        shifts: ((map['shifts'] ?? map['Shifts'] ?? []) as List)
            .map((s) => CareHomeShift.fromMap(s as Map<String, dynamic>))
            .toList(),
      );
}
