abstract class AuthRepoInterFace {
  signIn({required String email, required String password});

  signUp({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String role,
  });

  forgetPassword({required String email});
}
