class AdminOfferEntity {
  final String id;
  final String title;
  final String address;
  final double hourlyRate;
  final double? latitude;
  final double? longitude;
  final String careHomeName;

  const AdminOfferEntity({
    required this.id,
    required this.title,
    required this.address,
    required this.hourlyRate,
    required this.careHomeName,
    this.latitude,
    this.longitude,
  });
}
