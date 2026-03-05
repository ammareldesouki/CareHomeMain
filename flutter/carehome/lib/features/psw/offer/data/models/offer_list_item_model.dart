class OfferListItemModel {
  final String id;
  final String title;
  final String address;
  final double hourlyRate;
  final double latitude;
  final double longitude;

  const OfferListItemModel({
    required this.latitude,
    required this.longitude,
    required this.id,
    required this.title,
    required this.address,
    required this.hourlyRate,
  });

  factory OfferListItemModel.fromMap(Map<String, dynamic> map) =>
      OfferListItemModel(
        id: map['id'] ?? '',
        title: map['title'] ?? '',
        address: map['address'] ?? '',
        hourlyRate: (map['hourlyRate'] as num?)?.toDouble() ?? 0.0,
        latitude: (map['latitude'] as num?)?.toDouble() ?? 0.0,
        longitude: (map['longitude'] as num?)?.toDouble() ?? 0.0,
      );
}
