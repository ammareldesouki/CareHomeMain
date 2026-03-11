import 'package:dartz/dartz.dart';

import '../../../../../core/failure/failure.dart';
import '../repositories/psw_register_repo.dart';

class CompleteProfileParams {
  final String proofIdentityType;
  final bool workStatus;
  final String proofIdentityFilePath;
  final String pswCertificateFilePath;
  final String cvFilePath;
  final String immunizationRecordFilePath;
  final String criminalRecordFilePath;
  final String? firstAidOrCprFilePath;

  const CompleteProfileParams({
    required this.proofIdentityType,
    required this.workStatus,
    required this.proofIdentityFilePath,
    required this.pswCertificateFilePath,
    required this.cvFilePath,
    required this.immunizationRecordFilePath,
    required this.criminalRecordFilePath,
    this.firstAidOrCprFilePath,
  });
}

class CompleteProfileUseCase {
  final PswRegistrationRepository repository;

  CompleteProfileUseCase(this.repository);

  Future<Either<Failure, void>> call(CompleteProfileParams params) =>
      repository.completeProfile(
        proofIdentityType: params.proofIdentityType,
        workStatus: params.workStatus,
        proofIdentityFilePath: params.proofIdentityFilePath,
        pswCertificateFilePath: params.pswCertificateFilePath,
        cvFilePath: params.cvFilePath,
        immunizationRecordFilePath: params.immunizationRecordFilePath,
        criminalRecordFilePath: params.criminalRecordFilePath,
        firstAidOrCprFilePath: params.firstAidOrCprFilePath,
      );
}
