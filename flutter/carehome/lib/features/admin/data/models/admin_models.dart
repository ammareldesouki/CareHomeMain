import '../../domain/entities/admin_application_entity.dart';
import '../../domain/entities/admin_offer_entity.dart';
import '../../domain/entities/admin_psw_verification_entity.dart';

class AdminPswVerificationModel extends AdminPswVerificationEntity {
  const AdminPswVerificationModel({
    required super.pswId,
    required super.fullName,
    required super.email,
    required super.phoneNumber,
    required super.proofIdentityType,
    required super.proofIdentityFileId,
    required super.pswCertificateFileId,
    required super.cvFileId,
    required super.immunizationRecordFileId,
    required super.criminalRecordFileId,
    required super.firstAidOrCprFileId,
    required super.submittedAt,
    required super.verificationStatus,
  });

  factory AdminPswVerificationModel.fromMap(Map<String, dynamic> map) {
    return AdminPswVerificationModel(
      pswId: map['pswUserId'] ?? map['pswId'] ?? map['id'] ?? '',
      fullName:
          map['fullName'] ??
          '${map['firstName'] ?? ''} ${map['lastName'] ?? ''}'.trim(),
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      proofIdentityType: map['proofIdentityType'] ?? '',
      submittedAt:
          map['profileCompletedAt'] ??
          map['submittedAt'] ??
          map['createdAt'] ??
          '',
      proofIdentityFileId: map['proofIdentityFileId'] ?? '',
      pswCertificateFileId: map['pswCertificateFileId'] ?? '',
      cvFileId: map['cvFileId'] ?? '',
      immunizationRecordFileId: map['immunizationRecordFileId'] ?? '',
      criminalRecordFileId: map['criminalRecordFileId'] ?? '',
      firstAidOrCprFileId:
          map['firstAidOrCPRFileId'] ?? map['firstAidOrCprFileId'] ?? '',
      verificationStatus: map['verificationStatus'] ?? 'None',
    );
  }
}

class AdminOfferModel extends AdminOfferEntity {
  const AdminOfferModel({
    required super.id,
    required super.title,
    required super.address,
    required super.hourlyRate,
    required super.careHomeName,
    super.latitude,
    super.longitude,
    required super.careHomeId,
    required super.individualId,
  });

  factory AdminOfferModel.fromMap(Map<String, dynamic> map) {
    return AdminOfferModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      careHomeId: map['posterId'] ?? '',
      individualId: map['individualId'] ?? '',

      address: map['address'] ?? '',
      hourlyRate: (map['hourlyRate'] ?? 0).toDouble(),
      careHomeName: map['careHomeName'] ?? map['careHome']?['name'] ?? '',
      latitude: (map['latitude'] ?? 0).toDouble(),
      longitude: (map['longitude'] ?? 0).toDouble(),
    );
  }
}

// ── Application models ────────────────────────────────────────────────────────
//
// The API at GET /api/admin/applications/pending returns a FLAT structure:
//
// {
//   "jobRequestId": "...",
//   "offerId": "...",
//   "offerTitle": "try qlif by admin",
//   "status": "Pending",
//   "appliedAt": "2026-03-10T13:52:42.007553",
//   "pswId": "...",
//   "pswFullName": "ammar Eldesouki",
//   "pswPhone": "+441343342432",
//   "pswEmail": "ammareldesouki130@gmail.com",
//   "isVerified": true,
//   "shifts": [ { "jobRequestItemId": "...", "shiftId": "...",
//                 "date": "2026-03-15", "startTime": "16:51:00",
//                 "endTime": "20:52:00", "status": 0 } ]
// }
//
// There are NO nested "psw" or "offer" objects — all fields are at root level.

class AdminApplicationPswModel extends AdminApplicationPswEntity {
  const AdminApplicationPswModel({
    required super.pswId,
    required super.fullName,
    required super.email,
    required super.phoneNumber,
    required super.proofIdentityType,
    required super.proofIdentityFileId,
    required super.pswCertificateFileId,
    required super.cvFileId,
    required super.immunizationRecordFileId,
    required super.criminalRecordFileId,
    required super.firstAidOrCprFileId,
    required super.submittedAt,
    required super.age,
  });

  /// Reads PSW fields directly from the flat root map.
  factory AdminApplicationPswModel.fromFlatMap(Map<String, dynamic> map) {
    return AdminApplicationPswModel(
      pswId: map['pswId'] ?? '',
      fullName: map['pswFullName'] ?? '',
      email: map['pswEmail'] ?? map['email'] ?? '',
      phoneNumber: map['pswPhone'] ?? map['phoneNumber'] ?? '',
      age: (map['age'] ?? 0) is int
          ? (map['age'] ?? 0)
          : int.tryParse('${map['age']}') ?? 0,
      proofIdentityType: map['proofIdentityType'] ?? '',
      submittedAt: map['appliedAt'] ?? map['createdAt'] ?? '',
      // Document file IDs are not in the list response; leave empty.
      // They can be loaded later via GET /api/profile/{pswId}.
      proofIdentityFileId: map['proofIdentityFileId'] ?? '',
      pswCertificateFileId: map['pswCertificateFileId'] ?? '',
      cvFileId: map['cvFileId'] ?? '',
      immunizationRecordFileId: map['immunizationRecordFileId'] ?? '',
      criminalRecordFileId: map['criminalRecordFileId'] ?? '',
      firstAidOrCprFileId: map['firstAidOrCprFileId'] ?? '',
    );
  }

  /// Legacy nested constructor kept for any place that passes a sub-map.
  factory AdminApplicationPswModel.fromMap(Map<String, dynamic> map) =>
      AdminApplicationPswModel.fromFlatMap(map);
}

class AdminApplicationOfferModel extends AdminApplicationOfferEntity {
  const AdminApplicationOfferModel({
    required super.id,
    required super.title,
    required super.address,
    required super.hourlyRate,
    required super.carehomeId,
    required super.shifts,
    required super.description,
    required super.latitude,
    required super.longitude,
  });

  /// Reads offer fields directly from the flat root map.
  factory AdminApplicationOfferModel.fromFlatMap(Map<String, dynamic> map) {
    // Parse shifts array at root level
    final rawShifts = map['shifts'] as List<dynamic>? ?? [];
    final shifts = rawShifts.map((s) {
      final sm = s as Map<String, dynamic>;
      return AdminCareHomeShiftApplicationEntity(
        jobRequestItemId: sm['jobRequestItemId'] ?? '',
        shiftId: sm['shiftId'] ?? '',
        date: sm['date'] ?? '',
        startTime: sm['startTime'] ?? '',
        endTime: sm['endTime'] ?? '',
        status: '${sm['status'] ?? 0}',
      );
    }).toList();

    return AdminApplicationOfferModel(
      id: map['offerId'] ?? map['id'] ?? '',
      title: map['offerTitle'] ?? map['title'] ?? '',
      address: map['offerAddress'] ?? map['address'] ?? '',
      hourlyRate: (map['hourlyRate'] ?? 0).toDouble(),
      carehomeId: map['careHomeId'] ?? '',
      description: map['description'] ?? '',
      latitude: (map['latitude'] ?? 0).toDouble(),
      longitude: (map['longitude'] ?? 0).toDouble(),
      shifts: shifts,
    );
  }

  /// Legacy nested constructor kept for any place that passes a sub-map.
  factory AdminApplicationOfferModel.fromMap(Map<String, dynamic> map) =>
      AdminApplicationOfferModel.fromFlatMap(map);
}

class AdminApplicationModel extends AdminApplicationEntity {
  const AdminApplicationModel({
    required super.requestId,
    required super.psw,
    required super.offer,
    required super.appliedAt,
  });

  factory AdminApplicationModel.fromMap(Map<String, dynamic> map) {
    // The API returns a single flat object — pass the whole map to both
    // sub-models so each can pick out its own prefixed fields.
    return AdminApplicationModel(
      requestId: map['jobRequestId'] ?? map['requestId'] ?? '',
      psw: AdminApplicationPswModel.fromFlatMap(map),
      offer: AdminApplicationOfferModel.fromFlatMap(map),
      appliedAt: map['appliedAt'] ?? map['createdAt'] ?? '',
    );
  }
}