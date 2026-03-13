
class ApiConstat {
  static const String baseUrl = "http://3.99.158.214:5000/";
}

class EndPoints {
  static const String login = "/api/auth/login";
  static const String offers = '/api/Offers';
  static const String profile = '/api/profile';
  static const String logout = '/api/auth/logout';

  //  ------------Psw EndPoind----------------
  static const String PwRegister = "api/auth/register/psw";
  static const String pswApplyoffer = "api/applications/apply";
  static const String pswCancelApplication = "api/psw/applications/cancel";
  static const String pswMyApplications = "api/psw/applications";
  static const String completeProfile = "api/psw/profile";
  static const String updateProfileDocument = '/api/profile/';

  static String offerById(String id) => 'api/Offers/$id';

  //  ------------CareHome EndPoind----------------

  static const String registerCareHome = 'api/auth/register/carehome';
  static const String registerIndividual = 'api/auth/register/individual';

  static String caregetApplicationsByOffer(String offerId,) =>
      "/api/applications/$offerId";
  static const String careHomeAcceptApplication = 'api/applications/accept';
  static const String careHomeRejectApplication = 'api/applications/reject';

  // -------------Admin EndPoind----------------

  static const String verifyAdminPending = 'api/admin/verifications/pending';

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


}