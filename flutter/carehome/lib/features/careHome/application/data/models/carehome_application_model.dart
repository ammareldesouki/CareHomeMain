import '../../domain/entities/carehome_application_entity.dart';

class CareHomeShiftApplicationModel extends CareHomeShiftApplicationEntity {
  const CareHomeShiftApplicationModel({
    required super.jobRequestItemId,
    required super.shiftId,
    required super.date,
    required super.startTime,
    required super.endTime,
    required super.status,
  });

  factory CareHomeShiftApplicationModel.fromMap(Map<String, dynamic> map) {
    return CareHomeShiftApplicationModel(
      jobRequestItemId: map['jobRequestItemId'] ?? '',
      shiftId: map['shiftId'] ?? '',
      date: map['date'] ?? '',
      startTime: map['startTime'] ?? '',
      endTime: map['endTime'] ?? '',
      status: map['status'],
    );
  }
}

class CareHomePswModel extends CareHomePswEntity {
  const CareHomePswModel({
    required super.pswId,
    required super.fullName,
    required super.age,
    required super.isVerified,
    required super.workStatus,
    required super.proofIdentityType,
    required super.cvFileId,
  });

  factory CareHomePswModel.fromMap(Map<String, dynamic> map) {
    return CareHomePswModel(
      pswId: map['pswId'] ?? '',
      fullName: map['fullName'] ?? '',
      age: map['age'] ?? 0,
      isVerified: map['isVerified'] ?? false,
      workStatus: map['workStatus'] ?? false,
      proofIdentityType: map['proofIdentityType'] ?? '',
      cvFileId: map['cvFileId'] ?? '',
    );
  }
}

class CareHomeApplicationModel extends CareHomeApplicationEntity {
  const CareHomeApplicationModel({
    required super.jobRequestId,
    required super.appliedAt,
    required super.psw,
    required super.shifts,
  });

  factory CareHomeApplicationModel.fromMap(Map<String, dynamic> map) {
    final pswMap = map['psw'] as Map<String, dynamic>? ?? {};
    final shiftList = map['shifts'] as List? ?? [];

    return CareHomeApplicationModel(
      jobRequestId: map['jobRequestId'] ?? '',
      appliedAt: map['appliedAt'] ?? '',
      psw: CareHomePswModel.fromMap(pswMap),
      shifts: shiftList
          .map((s) => CareHomeShiftApplicationModel.fromMap(s))
          .toList(),
    );
  }
}
