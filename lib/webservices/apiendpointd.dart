import 'package:flutter/cupertino.dart';

class ApiEndPoints {
  static const String port = 'http://ce2925efcb09.ngrok.io/';
  //static const String port = 'http://nice.kodyinfotech.com:8602/';
  // static const String port = 'https://service.deliverynice.com/';
  static const String baseUrl = port + 'nice';

  /*
  * ---- Static data to pass in api's
  * */
  static String static_REGISTEREDVIA = "APP";
  static String static_ACTIVE = "true";
  static String static_USERTYPE = "CUSTOMER";
  static String static_TYPEEMAIL = "EMAIL";
  static String static_TYPESMS = "SMS";
  static String static_SENDINGTYPE = "OTP";
  static String static_GRANTTYPE = "refresh_token";
  static String static_OTPTYPE_EMAIL = "EMAIL";
  static String static_OTPTYPE_SMS = "SMS";
  static String static_SocialLogin_Google = "GOOGLE";
  static String static_SocialLogin_Facebook = "FACEBOOK";
  static String static_DEVICETYPE_ANDROID = "ANDROID";
  static String static_DEVICETYPE_IOS = "IOS";
  static String static_PREFERREDLANGUAGE_EN = "en";

  /*
  * ----- Api status
  * */
  static int apiStatus_200 = 200; //success
  static int apiStatus_401 = 401; //Invalid data

  /*
  * -- Api's
  * */
  static String apiRefreshToken = baseUrl + "/oauth/token"; //--refresh token
  static String apiSingup =
      baseUrl + "/customer"; //-- Signup, GetProfileDetail, EditProfile
  static String apiSocialLogin = baseUrl + "/user/login/social";
  static String apiOTPEmailVerify =
      baseUrl + "/user/login/verify/email/otp"; //OTP for -
  static String apiForgotPasswordOTPVerify =
      baseUrl + "/otp/verify/app"; //reset password Otp verify
  static String apiLoginEmail = baseUrl + "/user/login/customer/login";
  static String apiForgotPassword = baseUrl + "/user/login/forgotPassword";
  static String apiChangePassword = baseUrl + "/user/login/change/password";
  static String apiResetPassword = baseUrl + "/user/login/resetPassword";
  static String apiCheckEmailPassword = baseUrl + "/user/login/check/password";
  static String apiOTPEmailPhoneNumber =
      baseUrl + "/otp"; //--- OTP when Add/Change Phone/Email
  static String apiOTPChangeEmailVerify =
      baseUrl + "/user/login/email"; //--- Add, Change email
  static String apiOTPChangePhoneVerify =
      baseUrl + "/user/login/phone"; //--- Add, Change phone number
  static String apiSliderlist = baseUrl + "/slider/list";
  static String apiCategory =
      baseUrl + "/business/category/pageNumber/1/pageSize/100";
  static String apiVendorList =
      baseUrl + "/vendor/app/list/pageNumber/1/pageSize/100";
  static String apiVendorListPaginagation =
      baseUrl + "/vendor/app/list/pageNumber/";
  static String apiFeatureVendorList =
      baseUrl + "/vendor/app/list/pageNumber/1/pageSize/100";
  static String apiCuisinesVendor =
      baseUrl + "/cuisine/pageNumber/1/pageSize/100";
  static String apiProductlist = baseUrl + "/product/list/group/category";
  //static String apiProductVariants = baseUrl + "/product";
  static String apiVendorDetail = baseUrl + "/vendor/app/detail/";
  static String apiOrderHListForCustomer =
      baseUrl + "/order/customer/list"; //drawer orderHistory list
  static String apiGetOrderDetail = baseUrl + "/order";

  static String apiAddUpdateCustomerAddress = baseUrl + "/customer/address";
  //Cart Managment

  static String urlCheckValidCartItem({@required String vendorId}) =>
      "$baseUrl/cart/item/check/$vendorId";
  static String urlCheckValidCartItemGuest(
          {@required String uuid, @required String vendorId}) =>
      "$baseUrl/temp/cart/item/check/$uuid/$vendorId";
  static String urlAddTOCart = baseUrl + "/cart/item";
  static String urlAddTOCartGuest = baseUrl + "/temp/cart/item";
  static String urlGetAllCartItems = baseUrl + "/cart/item/list";
  static String urlGetAllCartItemsGuest = baseUrl + "/temp/cart/item/list";
  static String urlUpdateCartQty(
          {@required String cartItemId, @required String cartItemQty}) =>
      "$baseUrl/cart/item/update/qty/$cartItemId?qty=$cartItemQty";
  static String urlUpdateCartQtyGuest(
          {@required String cartItemId, @required String cartItemQty}) =>
      "$baseUrl/temp/cart/item/update/qty/$cartItemId?qty=$cartItemQty";
  static String urlDeleteCartItem({@required String cartItemId}) =>
      "$baseUrl/cart/item/$cartItemId";
  static String urlDeleteCartItemGuest({@required String cartItemId}) =>
      "$baseUrl/temp/cart/item/$cartItemId";
  static String urlCheckout(
          {@required String deliveryType, @required bool useWallet}) =>
      "$baseUrl/checkout?deliveryType=$deliveryType&useWallet=$useWallet";
  static String urlPlaceOrder = baseUrl + "/order/placeOrder";
  static String urlOrderDetails({@required String orderId}) =>
      "$baseUrl/order/$orderId";

  static String urlMoveCart({@required String uuid}) =>
      "$baseUrl/cart/item/move/$uuid";

  // static String api = baseUrl + "/";
  static String apiTicketList = baseUrl + "/ticket/list/pageNumber/";
  static String apiTicketDetail = baseUrl + "/ticket/";
  static String apiAddTicket = baseUrl + "/ticket";
  static String apiTicketReasonList =
      baseUrl + "/ticket/reason/pageNumber/1/pageSize/100?type=";

  static String apiWallet = baseUrl + "/customer/wallet";
  static String apiWalletTransactionList = baseUrl + "/wallet/pageNumber/";

  static String apiOrderRatingList = baseUrl + "/order/rating/vendor/";
  static String apiDeviceDetails = baseUrl + "/device/details";
  static String apiRatingQuestion =
      baseUrl + "/ratingQuestion/pageNumber/1/pageSize/100?";

  static String apiOrderRating = baseUrl + "/order/rating";

  static String apiTrackOrder = baseUrl + "/order/ongoing";

  //static String urlSocketTrack = "http://nice.kodyinfotech.com:8603?orderId=";
  static String urlSocketTrack = "https://socket.deliverynice.com/nice?orderId=";

  static String apiCancelOrder = baseUrl + "/order/cancel";
  static String apiReturnCancelOrder = baseUrl + "/order/return/cancel";
  static String apiReplaceCancelOrder = baseUrl + "/order/replace/cancel";

  static String apiReturnOrder = baseUrl + "/order/return";
  static String apiReplaceOrder = baseUrl + "/order/replace";

  static String apiGetNotificationList =
      baseUrl + "/push/notification/list/pageNumber/";
  static String apiDeleteNotification = baseUrl + "/push/notification";

  static String urlGetVendorDetails({@required String vendorId}) =>
      "$baseUrl/vendor/$vendorId";

  //-- OLD static String apiCustomerAddressList = baseUrl + "/customer/address/pageNumber/1/pageSize/10?customerId=";
  static String apiCompany = baseUrl + "/company";
  static String apiCustomerAddressList = baseUrl + "/customer/";
  static String apiAreaList = baseUrl + "/area/pageNumber/1/pageSize/100";
  //static String apiCityList = baseUrl + "/city/pageNumber/1/pageSize/100";
  //static String apiPincodeList = baseUrl + "/pincode/pageNumber/1/pageSize/100";
  //-- NOT USED AS ALL CITY ARE SERVICABLE -- static String apiCheckCityServicable = baseUrl + "/city/check/serviceable/";
  //-- NOT USED AS ALL CITY ARE SERVICABLE -- static String apiDefaultLocation = baseUrl + "/city/pageNumber/1/pageSize/100?activeRecords=true&isDefault=true";

}
