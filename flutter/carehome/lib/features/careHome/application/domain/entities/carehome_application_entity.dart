/// Shift status from API: 1=pending, 2=rejected, 3=accepted
class CareHomeShiftApplicationEntity {
  final String jobRequestItemId;
  final String shiftId;
  final String date;
  final String startTime;
  final String endTime;
  final int status; // 1=pending, 2=rejected, 3=accepted

  const CareHomeShiftApplicationEntity({
    required this.jobRequestItemId,
    required this.shiftId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.status,
  });

  String get statusLabel {
    switch (status) {
      case 3:
        return 'Accepted';
      case 2:
        return 'Rejected';
      default:
        return 'Pending';
    }
  }
}

class CareHomePswEntity {
  final String pswId;
  final String fullName;
  final int age;
  final bool isVerified;
  final bool workStatus;
  final String proofIdentityType;
  final String cvFileId;

  const CareHomePswEntity({
    required this.pswId,
    required this.fullName,
    required this.age,
    required this.isVerified,
    required this.workStatus,
    required this.proofIdentityType,
    required this.cvFileId,
  });
}

class CareHomeApplicationEntity {
  final String jobRequestId;
  final String appliedAt;
  final CareHomePswEntity psw;
  final List<CareHomeShiftApplicationEntity> shifts;

  const CareHomeApplicationEntity({
    required this.jobRequestId,
    required this.appliedAt,
    required this.psw,
    required this.shifts,
  });

  /// Overall status: pending if ANY shift is pending, otherwise accepted/rejected
  int get overallStatus {
    if (shifts.any((s) => s.status == 1)) return 1;
    if (shifts.any((s) => s.status == 3)) return 3;
    return 2;
  }

  String get overallStatusLabel {
    switch (overallStatus) {
      case 3:
        return 'Accepted';
      case 2:
        return 'Rejected';
      default:
        return 'Pending';
    }
  }
}
