/// Status codes from API: 1=pending, 2=accepted, 3=rejected, 4=cancelled
class PswApplicationEntity {
  final String jobRequestItemId;
  final String offerId;
  final String offerTitle;
  final String careHomeName;
  final String address;
  final double hourlyRate;
  final String shiftDate;
  final String startTime;
  final String endTime;
  final String statusCode;

  const PswApplicationEntity({
    required this.jobRequestItemId,
    required this.offerId,
    required this.offerTitle,
    required this.careHomeName,
    required this.address,
    required this.hourlyRate,
    required this.shiftDate,
    required this.startTime,
    required this.endTime,
    required this.statusCode,
  });

}
