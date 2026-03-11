/// Shift status from API: 1=pending, 2=rejected, 3=accepted
class CareHomeShiftApplicationEntity {
  final String jobRequestItemId;
  final String shiftId;
  final String date;
  final String startTime;
  final String endTime;
  final String status; // 1=pending, 2=rejected, 3=accepted

  const CareHomeShiftApplicationEntity({
    required this.jobRequestItemId,
    required this.shiftId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.status,
  });

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
  String get overallStatus {
    if (shifts.any((s) => s.status == "QualifiedByAdmin")) return "Pending";
    if (shifts.any((s) => s.status == "RejectedByCareHome")) return "Rejected";
    return "Accepted";
  }

  String get overallStatusLabel {
    switch (overallStatus) {
      case "QualifiedByAdmin":
        return 'Pending';

      case "Accepted":
        return 'Accepted';
      case "RejectedByCareHome":
        return 'Rejected';
      default:
        return 'Pending';
    }
  }
}
