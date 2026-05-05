
class ApiConstat {
  static const String baseUrl = "http://15.223.216.199:5000/";
}

class EndPoints {
  static const String login = "/api/auth/login";
  static const String offers = 'api/offers';
  static const String profile = 'api/profile';
  static const String logout = '/api/auth/logout';

  //  ------------Psw EndPoind----------------
  static const String PwRegister = "api/auth/register/psw";
  static const String pswApplyoffer = "api/applications/apply";
  static const String pswCancelApplication = "api/psw/applications/cancel";
  static const String pswMyApplications = "api/psw/applications";
  static const String completeProfile = "api/psw/profile";
  static const String updateProfileDocument = 'api/profile/update';

  static String offerById(String id) => 'api/Offers/$id';

  //  ------------CareHome EndPoind----------------

  static const String registerCareHome = 'api/auth/register/carehome';
  static const String registerIndividual = 'api/auth/register/individual';

  static String caregetApplicationsByOffer(String offerId,) =>
      "/api/applications/$offerId";
  static const String careHomeAcceptApplication = 'api/applications/accept';
  static const String careHomeRejectApplication = 'api/applications/reject';
  static const String careHomeApplications = 'api/applications';


  // -------------Admin EndPoind----------------

  static const String verifyAdminPending = '/api/admin/users/PSW';

  static String verifyAdminApprove(String pswId) =>
      'api/admin/verifications/$pswId/approve';

  static String verifyAdminReject(String pswId) =>
      'api/admin/verifications/$pswId/reject';
  static const String adminApplicationPsw = 'api/admin/applications';

  static String AdminapproveApplication(String requestId) =>
      "api/admin/applications/$requestId/approve";

  static String AdminrejectApplication(String requestId) =>
      "api/admin/applications/$requestId/reject";
  static String adminGetAllOffers = 'api/admin/offers';

  static String adminCancelOffer(String offerId) => 'api/admin/offers/$offerId';

  // PSW Profile
  static String adminPswProfile(String id) => 'api/admin/users/profile?id=$id';


}