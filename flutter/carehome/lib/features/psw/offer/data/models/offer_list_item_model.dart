class OfferListItemModel {
  final String id;
  final String title;
  final String address;
  final double hourlyRate;
  final double latitude;
  final double longitude;
  final String? careHomeId;
  final String? individualId;
  final String posterName;
  final String posterType;

  const OfferListItemModel({
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

  factory OfferListItemModel.fromMap(Map<String, dynamic> map) =>
      OfferListItemModel(
        id: map['id'] ?? '',
        title: map['title'] ?? '',
        address: map['address'] ?? '',
        hourlyRate: (map['hourlyRate'] as num?)?.toDouble() ?? 0.0,
        latitude: (map['latitude'] as num?)?.toDouble() ?? 0.0,
        longitude: (map['longitude'] as num?)?.toDouble() ?? 0.0,
        careHomeId: map['careHomeId'] as String?,
        individualId: map['individualId'] as String?,
        posterName: map['posterName'] ?? '',
        posterType: map['posterType'] ?? 'CareHome',
      );
}