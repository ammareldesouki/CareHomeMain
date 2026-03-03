// lib/features/psw/data/models/psw_model.dart

class PswProfile {
  String name;
  String email;
  String phone;
  String address;
  String experience;
  String qualifications;
  String bio;
  double rating;
  int completedShifts;

  PswProfile({
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.experience,
    required this.qualifications,
    required this.bio,
    this.rating = 4.8,
    this.completedShifts = 0,
  });
}

class AppliedJob {
  final String id;
  final String offerTitle;
  final String careHomeName;
  final String branch;
  final String date;
  final String timeFrom;
  final String timeTo;
  final double hourlyRate;
  final String appliedDate;
  String status; // pending | accepted | rejected

  AppliedJob({
    required this.id,
    required this.offerTitle,
    required this.careHomeName,
    required this.branch,
    required this.date,
    required this.timeFrom,
    required this.timeTo,
    required this.hourlyRate,
    required this.appliedDate,
    this.status = 'pending',
  });
}
