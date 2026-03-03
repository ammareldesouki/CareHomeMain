// lib/features/careHome/offers/data/models/offer_model.dart

class OfferShift {
  final String date;
  final String from;
  final String to;

  OfferShift({required this.date, required this.from, required this.to});
}

class OfferModel {
  final String id;
  final String title;
  final String branch;
  final double lat;
  final double lng;
  final List<OfferShift> shifts;
  bool isActive;
  final int applicationsCount;

  OfferModel({
    required this.id,
    required this.title,
    required this.branch,
    required this.lat,
    required this.lng,
    required this.shifts,
    this.isActive = true,
    this.applicationsCount = 0,
  });
}
