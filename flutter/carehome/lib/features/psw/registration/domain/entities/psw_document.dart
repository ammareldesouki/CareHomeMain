enum PswDocumentType {
  proofOfId,
  workStatus,
  insurance,
  pswCertificate,
  cv,
  immunizationRecord,
  criminalRecord,
  firstAidCpr,
}

extension PswDocumentTypeExt on PswDocumentType {
  String get label {
    switch (this) {
      case PswDocumentType.proofOfId:
        return 'Proof of Identity';
      case PswDocumentType.workStatus:
        return 'Work Authorization';
      case PswDocumentType.insurance:
        return 'Insurance Certificate';
      case PswDocumentType.pswCertificate:
        return 'PSW Certificate';
      case PswDocumentType.cv:
        return 'CV / Resume';
      case PswDocumentType.immunizationRecord:
        return 'Immunization Records';
      case PswDocumentType.criminalRecord:
        return 'Criminal Record Check';
      case PswDocumentType.firstAidCpr:
        return 'First Aid / CPR Card';
    }
  }
}
