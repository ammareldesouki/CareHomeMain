import 'package:carehome/features/auth/data/models/signup_request.dart';
import 'package:carehome/features/auth/data/models/singIn_request.dart';
import 'package:carehome/features/auth/domain/entities/signUp_response.dart';
import 'package:carehome/features/auth/domain/repositories/auth_repo_interface.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/local_storge_key.dart';
import '../../../../core/failure/failure.dart';
import '../../../../core/failure/server_failure.dart';
import '../../domain/entities/signin_response.dart';
import '../../domain/entities/user_entity.dart';
import '../data_sources/auth_remote_datasource.dart';

class AuthRepoImpl implements AuthRepoInterFace {
  final AuthRemoteDataSource remote;

  AuthRepoImpl(this.remote);

  @override
  forgetPassword({required String email}) async {
    // TODO: implement forgetPassword
    return await remote.forgetPassword(email);
  }

  @override
  Future<Either<Failure, SignInResponse>> signIn(SignInRequest user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await remote.login(user);
    try {
      print("------------${response.toString()}");
      if (response.statusCode == 200) {
        var data = SignInResponse.fromJson(response.data);
        prefs.setString(LocalKeys.AuthToken, data.token);

        return Right(data);
      } else {
        return Left(
          ServerFailure(
            statusCode: response.statusCode.toString(),
            messageEn: response.data["message"],
          ),
        );
      }
    } on DioException catch (dioExption) {
      return Left(
        ServerFailure(
          statusCode: dioExption.response.toString(),
          messageEn: dioExption.response?.data["message"],
        ),
      );
    } catch (error) {
      return Left(
        ServerFailure(
          statusCode: response.statusCode.toString(),
          messageEn: error.toString(),
          messageAr: '',
          message: '',
        ),
      );
    }
  }
  @override
  @override
  Future<Either<Failure, SignUpResponse>> signUp(SignupRequest user) async {
    print("SignUp request: $user");
    try {
      final response = await remote.register(user);

      if (response.statusCode == 200) {
        print("SignUp response: ${response.data}");
        var data = SignUpResponse.fromJson(response.data);
        return Right(data);
      } else {
        return Left(
          ServerFailure(
            statusCode: response.statusCode.toString(),
            messageEn: response.data["message"],
          ),
        );
      }
    } on DioException catch (dioExption) {
      print("SignUp response: ${dioExption.response}");

      return Left(
        ServerFailure(
          statusCode: dioExption.response.toString(),

          messageEn: dioExption.response?.data.toString(),
        ),
      );
    }
  }
}
