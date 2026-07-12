// ignore_for_file: file_names

class APIList {
  // static String? baseUrl = "https://demo.foodking.dev";
  static String? baseUrl = "https://food.taskat.net";
  // static String? baseUrl = "https://food.taskat.net/mirkazalhijaz";
  static String? customerUrl = "mirkazalhijaz";
  // static String? customerUrl = baseUrl;
  static String? mapApiKey = "AIzaSyB3S4fcKMcU-Ll9RSPkCiwdk1jXPmrTC_c";
  static String? licenseCode = "c9fefaf1a17747e9b6910ecc6dcfaf68";
  static String? paymentUrl = "${baseUrl!}/payment/";
  static String? login = "${baseUrl!}/api/${customerUrl!}/auth/login";
  static String? otpSignUp = "${baseUrl!}/api/${customerUrl!}/auth/signup/otp";
  static String? otpVarify = "${baseUrl!}/api/${customerUrl!}/auth/signup/verify";
  static String? register = "${baseUrl!}/api/${customerUrl!}/auth/signup/register";
  static String? guestOtpSignUp = "${baseUrl!}/api/${customerUrl!}/auth/guest-signup/otp";
  static String? guestOtpVarify = "${baseUrl!}/api/${customerUrl!}/auth/guest-signup/verify";
  static String? guestRegister = "${baseUrl!}/api/${customerUrl!}/auth/signup/register";
  static String? forgetPassword = "${baseUrl!}/api/${customerUrl!}/auth/forgot-password";
  static String? passwordResetVarifyCode = "${baseUrl!}/api/${customerUrl!}/auth/forgot-password/verify-code";
  static String? passwordReset = "${baseUrl!}/api/${customerUrl!}/auth/forgot-password/reset-password";
  static String? profile = "${baseUrl!}/api/${customerUrl!}/profile";
  static String? changeProfileImage = "${baseUrl!}/api/${customerUrl!}/profile/change-image";
  static String? updateProfile = "${baseUrl!}/api/${customerUrl!}/profile/update";
  static String? changePassword = "${baseUrl!}/api/${customerUrl!}/profile/change-password";
  static String? offer = "${baseUrl!}/api/${customerUrl!}/frontend/offer";
  static String? offerItems = "${baseUrl!}/api/${customerUrl!}/frontend/offer/show/";
  static String? category = "${baseUrl!}/api/${customerUrl!}/frontend/item-category";
  static String? categoryWiseItem =
      "${baseUrl!}/api/${customerUrl!}/frontend/item-category/show/";
  static String? branch = "${baseUrl!}/api/${customerUrl!}/frontend/branch";
  static String? itemList = "${baseUrl!}/api/${customerUrl!}/frontend/item";
  static String? popularItems = "${baseUrl!}/api/${customerUrl!}/frontend/item/popular-items";
  static String? featuredItems = "${baseUrl!}/api/${customerUrl!}/frontend/item/featured-items";
  static String? order = "${baseUrl!}/api/${customerUrl!}/frontend/order";
  static String? orderDetails = "${baseUrl!}/api/${customerUrl!}/frontend/order/show/";
  static String? addressList = "${baseUrl!}/api/${customerUrl!}/frontend/address";
  static String? addressSave = "${baseUrl!}/api/${customerUrl!}/frontend/address";
  static String? addressDelete = "${baseUrl!}/api/${customerUrl!}/frontend/address/";
  static String? addressUpdate = "${baseUrl!}/api/${customerUrl!}/frontend/address/";
  static String? todayTimeSlot = "${baseUrl!}/api/${customerUrl!}/frontend/time-slot/today";
  static String? tomorrowTimeSlot =
      "${baseUrl!}/api/${customerUrl!}/frontend/time-slot/tomorrow";
  static String? couponList = "${baseUrl!}/api/${customerUrl!}/frontend/coupon";
  static String? branchByLatLong({
    required double addressLat,
    required double addressLong,
  }) =>
      "$baseUrl/api/${customerUrl!}/frontend/branch/lat-long?latitude=$addressLat&longitude=$addressLong";
  static String? checkCoupon =
      "${baseUrl!}/api/${customerUrl!}/frontend/coupon/coupon-checking";
  static String? configuration = "${baseUrl!}/api/${customerUrl!}/frontend/setting";
  static String? countryInfo = "${baseUrl!}/api/${customerUrl!}/frontend/country-code/show/";
  static String? cancelOrder = "${baseUrl!}/api/${customerUrl!}/frontend/order/change-status/";
  static String? activeOrder =
      "${baseUrl!}/api/${customerUrl!}/frontend/order?excepts=13|16|19|22?order_by=asc";
  static String? token = "${baseUrl!}/api/${customerUrl!}/frontend/device-token/mobile";
  static String? refreshToken = "${baseUrl!}/api/${customerUrl!}/refresh-token?token=";
  static String? pages = "${baseUrl!}/api/${customerUrl!}/frontend/page";
  static String? language = "${baseUrl!}/api/${customerUrl!}/frontend/language";
  static String? deleteAccount = "${baseUrl!}/api/${customerUrl!}/auth/delete-account";
  static String? itemDetails = "${baseUrl!}/api/${customerUrl!}/frontend/item/details/";
}
