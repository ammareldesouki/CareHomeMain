class AdminApplicationPswEntity {
  final String pswId;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String proofIdentityType;
  final String proofIdentityFileId;
  final String pswCertificateFileId;
  final String cvFileId;
  final String immunizationRecordFileId;
  final String criminalRecordFileId;
  final String firstAidOrCprFileId;
  final String submittedAt;
  final int age;

  const AdminApplicationPswEntity({
    required this.pswId,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.proofIdentityType,
    required this.proofIdentityFileId,
    required this.pswCertificateFileId,
    required this.cvFileId,
    required this.immunizationRecordFileId,
    required this.criminalRecordFileId,
    required this.firstAidOrCprFileId,
    required this.submittedAt,
    required this.age,
  });
}

class AdminApplicationOfferEntity {
  final String id;
  final String title;
  final String address;
  final double hourlyRate;
  final String carehomeId;
  final String description;
  final List<AdminCareHomeShiftApplicationEntity> shifts;
  final double latitude;
  final double longitude;

  const AdminApplicationOfferEntity({
    required this.id,
    required this.title,
    required this.address,
    required this.hourlyRate,
    required this.carehomeId,
    required this.shifts,
    required this.description,
    required this.latitude,
    required this.longitude,
  });
}

class AdminCareHomeShiftApplicationEntity {
  final String jobRequestItemId;
  final String shiftId;
  final String date;
  final String startTime;
  final String endTime;
  final String status; // 1=pending, 2=rejected, 3=accepted

  const AdminCareHomeShiftApplicationEntity({
    required this.jobRequestItemId,
    required this.shiftId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.status,
  });
}

class AdminApplicationEntity {
  final String requestId;
  final AdminApplicationPswEntity psw;
  final AdminApplicationOfferEntity offer;
  final String appliedAt;

  const AdminApplicationEntity({
    required this.requestId,
    required this.psw,
    required this.offer,
    required this.appliedAt,
  });
}
