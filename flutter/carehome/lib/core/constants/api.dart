
class ApiConstat {
  static const String baseUrl = "http://3.99.158.214:5000/";
}

class EndPoints {
  static const String PwRegister = "api/auth/register/psw";
  static const String login = "/api/auth/login";
  static const String completeProfile = "/api/CompleteProfile/complete-profile";
  static const String offers = '/api/Offers';

  static String offerById(String id) => '/api/Offers/$id';
  static const String registerCareHome = '/api/auth/register/carehome';
  static const String registerIndividual = '/api/auth/register/individual';
}