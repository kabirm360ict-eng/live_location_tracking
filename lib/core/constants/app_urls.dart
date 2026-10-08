import '../../env/env.dart';


bool? overrideIsLive = false;
bool? isLiveFromRemote;
const bool isLocal = false;
bool get isLive => overrideIsLive ?? isLiveFromRemote ?? false;
// bool get isLive => overrideIsLive ?? isLiveFromRemote ?? kReleaseMode;

class AppUrls {
    // static String get versionManager => Env.versionManager; //for production
  static String get versionManager => Env.versionManager2; //for dev
  static String get imageUrl => Env.imageUrl;

  static String get stripePublishableKey => isLocal
      ? Env.stripePublishableKeyLocal
      : isLive
      ? Env.stripePublishableKeyLive
      : Env.stripePublishableKeyLocal;

  static String get googleMapsApiKey => Env.googleMapsApiKey;
  static String get openRouteServiceApiKey => Env.heigitApiKey;
  static String get placeApi => Env.placeApi;
  static String get placeSession => Env.placeSession;

  static String get baseUrl => isLocal
      ? Env.localBaseUrl
      : isLive
      ? Env.prodBaseUrl
      : Env.devBaseUrl;
  static String get socketUrl => isLocal
      ? Env.localSocketUrl
      : isLive
      ? Env.prodSocketUrl
      : Env.devSocketUrl;

  static String get jobCategories => '$baseUrl/public/category';
  static String get publicJobPosts => '$baseUrl/public/public-job-post';
  static String get verifyPaymentCheckout => '$baseUrl/public/job-payment/verify-checkout-session';

  static String get upcomingJobs => '$baseUrl/job-seeker/job-application';
  static String get todayJobs => '$baseUrl/job-seeker/job-application';
  static String get jobSeekerDashboardData => '$baseUrl/job-seeker/dashboard';

  static String get allJobs => "$baseUrl/job-seeker/jobs";

  static String get loginJob => '$baseUrl/auth/job-seeker/login';
  static String get registrationJob => '$baseUrl/auth/job-seeker/registration';
  static String get forgetPasswordJob => '$baseUrl/auth/job-seeker/forget-password';
  static String get changePasswordJob => '$baseUrl/job-seeker/profile/change-password';
  static String get jobPostJobSeeker => '$baseUrl/job-seeker/jobs';
  static String get jobSaveJobSeeker => '$baseUrl/job-seeker/jobs/save-job';
  static String get applyJob => '$baseUrl/job-seeker/job-application';
  static String get applyJobList => '$baseUrl/job-seeker/job-application';
  static String get jobApplyDetails => '$baseUrl/job-seeker/job-application';
  static String get jobApplyCancel => '$baseUrl/job-seeker/job-application';
  static String get profileJobSeeker => '$baseUrl/job-seeker/profile';
  static String get jobTaskActivityRequestJobSeeker => '$baseUrl/job-seeker/job-task-activity';
  static String get jobTaskActivityList => '$baseUrl/job-seeker/job-task-activity/task';
  static String get jobReportJobSeeker => '$baseUrl/job-seeker/reports';

  static String get notificationJobSeeker => '$baseUrl/job-seeker/notification';

  static String get completeProfileJobSeeker => '$baseUrl/job-seeker/profile/verify-details';
  static String get bankListJobSeeker => '$baseUrl/job-seeker/bank-details';
  static String get payoutRequestJobSeeker => '$baseUrl/job-seeker/payouts';

  //! hiring manager
  static String get notificationHiring => '$baseUrl/hotelier/notification';

  //!for country & city
  // static String city({required String countryId}) =>
  //     '$baseUrl/public/city?state_id=$countryId';
  // static String state({required String countryId}) =>
  //     '$baseUrl/public/state?country_id=$countryId';
  // static String get countries => '$baseUrl/public/country';
  // static String flagImage({required String iso}) =>
  //     'https://flagsapi.com/${iso.toUpperCase()}/flat/64.png';

  // static String get nationality => "$baseUrl/public/nationality";

  //!for auth hiring manager
  static String get sendEmailOtp => '$baseUrl/public/send-email-otp';
  static String get matchEmailOtp => '$baseUrl/public/match-email-otp';
  static String get registrationHiring => '$baseUrl/auth/hotelier/registration';
  static String get changePasswordHiring => '$baseUrl/auth/hotelier/forget-password';
  static String get loginHiring => '$baseUrl/auth/hotelier/login';
  static String get updateProfileHiring => '$baseUrl/hotelier/profile';
  static String get changePasswordHiringProfile => '$baseUrl/hotelier/profile/change-password';
  static String get profileHiring => '$baseUrl/hotelier/profile';

  //!for job hiring manager
  static String get jobPostsHiring => '$baseUrl/hotelier/job-post';
  static String get myRequestsHiring => '$baseUrl/hotelier/cancellation-reports';
  static String get reportJobPostHiring => '$baseUrl/hotelier/reports';

  //!for hotilier job task activity
  static String get jobTaskActivityHiring => '$baseUrl/hotelier/job-task-activity';

  //! for hotilier job task create
  static String get jobTaskCreateHiring => '$baseUrl/hotelier/job-task-activity/task';

  //! for hotilier task approve
  static String get jobTaskApproveJobSeeker => '$baseUrl/job-seeker/job-task-activity';

  //! for hotilier task approve
  static String get jobTaskApproveJobHotelier => '$baseUrl/hotelier/job-task-activity';

  //! for hotilier approve clock in job seeker
  static String get hotelierJobTaskActivity => '$baseUrl/hotelier/job-task-activity';

  //!for  hotilier job task update
  static String get jobTaskDeleteHiring => '$baseUrl/hotelier/job-task-activity/task';

  //!for payment checkout
  static String get paymentCheckoutHotelier => '$baseUrl/hotelier/payment/create-checkout-session';
  static String get createPaymentProfile => '$baseUrl/job-seeker/stripe/add-stripe-payout-account';
  static String get loginStripe => "$baseUrl/job-seeker/stripe/auth/login";

  //!for payment history
  static String get paymentHistory => '$baseUrl/hotelier/payment/get-initialize-payments';
  static String get paymentHistoryJobSeeker => '$baseUrl/job-seeker/payments';
  static String get verifyPayment => '$baseUrl/hotelier/payment/verify-checkout-session';

  //!for messaging Workers
  static String get chatListJobSeeker => '$baseUrl/job-seeker/chat/chat-sessions';
  static String get chatSingleJobSeeker => '$baseUrl/job-seeker/chat/messages';
  static String get getSessionIdAdminJobSeeker => '$baseUrl/job-seeker/chat/support';
  static String get getSessionIdJobSeeker => '$baseUrl/job-seeker/chat/chat-session/';

  //!for messaging hiring manager
  static String get chatListHiring => '$baseUrl/hotelier/chat/chat-sessions';
  static String get chatSingleHiring => '$baseUrl/hotelier/chat/messages';
  static String get getSessionIdAdminHiring => '$baseUrl/hotelier/chat/support';
  static String get getSessionIdHiring => '$baseUrl/hotelier/chat/chat-session/';

  //!job cancel payment
  static String get jobCancelPaymentCheckout => '$baseUrl/public/job-cancel-payment/verify-checkout-session';

  //! Log out
  static String get logoutJobSeeker => "$baseUrl/auth/job-seeker/logout";
  static String get logoutHotelier => "$baseUrl/auth/hotelier/logout";

  //! for residential
  static String get loginResidential => "$baseUrl/auth/residential/login";
  static String get dashboardResidential => "$baseUrl/residential/dashboard";
  static String get dashboardHotelier => "$baseUrl/hotelier/dashboard";
  static String get notificationResidential => "$baseUrl/residential/notification";
  static String get jobPostResidential => "$baseUrl/residential/job-post";
  static String get jobTaskActivityResidential => "$baseUrl/residential/job-task-activity/task";
  static String get residentialJobTaskActivity => "$baseUrl/residential/job-task-activity";
  static String get paymentCheckoutResidential => '$baseUrl/residential/payment/create-checkout-session';
  static String get paymentVerifyCheckoutSessionResidential => "$baseUrl/public/job-payment/verify-checkout-session";
  static String get chatListResidential => '$baseUrl/residential/chat/chat-sessions';
  static String get chatMessagesResidential => '$baseUrl/residential/chat/messages';
  static String get chatSupportResidential => '$baseUrl/residential/chat/support';
  static String get profileResidential => "$baseUrl/residential/profile";
  static String get changePasswordResidential => "$baseUrl/residential/profile/change-password";
  static String get paymentHistoryResidential => "$baseUrl/residential/payment/get-initialize-payments";
  static String get sendSmsResidential => "$baseUrl/public/sms/send-otp";
  static String get verifyOtpResidential => "$baseUrl/public/sms/match-otp";
  static String get registerResidential => "$baseUrl/auth/residential/registration";
  static String get forgetPasswordResidential => "$baseUrl/auth/residential/forget-password";

  //! Store Links
  static const String playStoreUrl = 'https://play.google.com/store/apps/details?id=com.m360ictappstudio.tovozo';
  static const String appStoreUrl = 'https://apps.apple.com/us/app/tovozo/id6749312196';
}