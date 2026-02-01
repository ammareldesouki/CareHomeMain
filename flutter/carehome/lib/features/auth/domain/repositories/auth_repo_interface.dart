import 'package:carehome/core/failure/failure.dart';
import 'package:carehome/features/auth/data/models/signup_request.dart';
import 'package:carehome/features/auth/data/models/singIn_request.dart';
import 'package:carehome/features/auth/domain/entities/signUp_response.dart';
import 'package:carehome/features/auth/domain/entities/signin_response.dart';
import 'package:carehome/features/auth/domain/entities/user_entity.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepoInterFace {
  Future<Either<Failure, SignInResponse>> signIn(SignInRequest user);

  Future<Either<Failure, SignUpResponse>> signUp(SignupRequest user);

  forgetPassword({required String email});
}
