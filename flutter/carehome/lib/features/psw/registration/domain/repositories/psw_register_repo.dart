import 'package:dartz/dartz.dart';

import '../../../../../core/failure/failure.dart';
import '../../data/models/signup_register_psw.dart';
import '../entities/auth_entity.dart';

abstract class PswRegistrationRepository {
  Future<Either<Failure, AuthEntity>> registerPsw(PswRegisterRequest request);

  Future<Either<Failure, void>> completeProfile({
    required String proofIdentityType,
    required bool workStatus,
    required String proofIdentityFilePath,
    required String pswCertificateFilePath,
    required String cvFilePath,
    required String immunizationRecordFilePath,
    required String criminalRecordFilePath,
    String? firstAidOrCprFilePath,
  });
}
