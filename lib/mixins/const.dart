import 'dart:io';
import 'package:nice_customer_app/utils/color_.dart';

import 'package:date_format/date_format.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nice_customer_app/Localization/app_translations.dart';
import 'package:nice_customer_app/api/responce/loginResponce.dart';
import 'package:nice_customer_app/framework/stateprovidermodel/provider_cart.dart';
import 'package:nice_customer_app/framework/stateprovidermodel/provider_track.dart';
import 'package:nice_customer_app/profile/ProviderProfile.dart';
import 'package:nice_customer_app/ui/address_book/ProviderAddressBook.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Constants {
  //App details
  final String appName = 'Nice App ';
  final String appVersion = '1.0';
  final int appVersionCode = 1;
  final bool isDebugMode = true;
  static String appLanguage;
  static const String active_app_language = 'ApplicationLanguage';
  final bool showOtp = false;
  final int showOtpDuration = 3;

  //Dimen
  final double infiniteSize = double.infinity;

  /*
  * -- DO NOT CHANGE -  Static values used for comperison
  * */
  final String constant_static_en = "en";
  final String constant_static_ar = "ar";
  final String constant_static_English = "English";
  final String constant_static_Arabic = "Arabic";

  /*
  * -- Time Formate
  * */
  String str12Hr = "hh:mm a";
  String str24Hr = "hh:mm:ss";
  String strDateTimeFormateBackend = "yyyy-MM-dd'T'HH:mm:ss.SSS";
  String strDateFormateDDMMYYYY = "dd-MM-yyyy";
  String strDateFormateYYYYMMDD = "yyyy-MM-dd";

  final String apiKey = "AIzaSyDH27q-1sMs4227dzRuPhCqafJLuaIaWhc";

  //29.3759 , 47.9774

  LatLng kuwaitLatLng = LatLng(29.3353, 48.0716);
  LatLng abadLatLng = LatLng(23.0325, 72.5077);
  LatLng defaultLatLng = LatLng(29.3759, 47.9774);

  /*
  * -- ScreenUtils with common height and width
  * */
  buildSetupScreenUtils(BuildContext context) {
    ScreenUtil.init(context, width: 375, height: 667, allowFontScaling: false);
  }

  double setHeight(var height) {
    return ScreenUtil().setHeight(height);
  }

  double setWidth(var width) {
    return ScreenUtil().setWidth(width);
  }

  double setSp(var fontSize) {
    return ScreenUtil().setSp(fontSize);
  }

  /*
  * -- Common Funcations
  * */
  showLog(String str) {
    print("-> $str");
  }

  isEmailValid(String str) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!(regex.hasMatch(str)))
      return false;
    else
      return true;
  }

  isPhoneNumberlValid(String str) {
    if (str != null && str.length >= 7 && str.length <= 10)
      return true;
    else
      return false;
  }

  isPasswordlValid(String str) {
    if (str != null && str.length >= 8)
      return true;
    else
      return false;
  }

  hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  String convertDatetimeformat(String strDate) {
    // DateTime Date = DateTime.parse(strDate);
    if (strDate != null && strDate.isNotEmpty) {
      try {
        DateTime myDatetime = DateTime.parse(strDate).toLocal();

        String orderdatetime = formatDate(myDatetime, [
          dd,
          '-',
          mm,
          '-',
          yyyy,
          ' ',
          hh,
          ':',
          nn,
        ]);
        return orderdatetime;
      } catch (onErr) {
        print("convertDatetimeformat ${onErr.toString()}");
      }
    }
  }

  String convertDateformat(String strDate) {
    if (strDate != null && strDate.isNotEmpty) {
      try {
        DateTime Date = DateTime.parse(strDate).toLocal();

        // print(Date);
        // print("--------formated date----------${formatDate(Date, [
        //   yyyy,
        //   '/',
        //   mm,
        //   '/',
        //   dd,
        //   ' ',
        //   hh,
        //   ':',
        //   nn,
        //   ':',
        //   ss
        // ])}");
        String orderdatetime = formatDate(Date, [
          dd,
          '-',
          mm,
          '-',
          yyyy,
        ]);
        return orderdatetime;
      } catch (onErr) {
        showLog("convertDateformattttt $onErr");
        return "";
      }
    }
  }

  String convert24HrTo12Hr(
      {String inputFormate, String outputFormate, String strDate}) {
    DateTime date = DateFormat(inputFormate).parse(strDate);
    String strOutputDate = DateFormat(outputFormate).format(date);
    print("strDate : $strDate");
    print("strOutputDate : $strOutputDate");
    return strOutputDate;
  }

  // convertStringToDate(String dateValue, String dateFormat) {
  //   DateTime myDatetime = DateTime.parse(dateValue);
  //   var myDate = myDatetime;
  //   var formatter = new DateFormat(dateFormat);
  //   String strValue = formatter.format(myDate);
  //   return strValue;
  // }

  String convertStringToDate(String dateValue, String dateFormat) {
    DateTime myDatetime = DateTime.parse(dateValue).toLocal();
    var myDate = myDatetime;
    var formatter = new DateFormat(dateFormat);
    String strValue = formatter.format(myDate);
    return strValue;
  }

  String compareTwoDates(DateTime dateTime) {
    final date2 = DateTime.now();
    final difference = date2.difference(dateTime).inDays;

    return "$difference";
  }

  //for time format
  String converttimeformat(String strDate) {
    DateTime Date = DateTime.parse(strDate).toLocal();
    // print(Date);
    // print("--------formated time----------${formatDate(Date, [
    //   hh,
    //   ':',
    //   nn,
    //   ':',
    //   ss
    // ])}");
    String date = formatDate(Date, [
      hh,
      ':',
      nn,
    ]);
    return date;
  }

  strDateTimeWithTimeZone(String strDateTimeFormateBackend) {
    DateTime dateTime = DateTime.now();
    String strCurrentTime =
        DateFormat(strDateTimeFormateBackend).format(dateTime);
    var offset = dateTime.timeZoneOffset;
    var hours = offset.inHours > 0
        ? offset.inHours
        : 1; // For fixing divide by zero error
    if (!offset.isNegative) {
      strCurrentTime = strCurrentTime +
          "+" +
          offset.inHours.toString().padLeft(2, '0') +
          ":" +
          (offset.inMinutes % (hours * 60)).toString().padLeft(2, '0');
    } else {
      strCurrentTime = strCurrentTime +
          offset.inHours.toString().padLeft(2, '0') +
          ":" +
          (offset.inMinutes % (hours * 60)).toString().padLeft(2, '0');
    }
    showLog("strCurrentTime : $strCurrentTime");
    return strCurrentTime;
  }

  String getOnlyDateFormated(String str) {
    String strDateWithoutTimeZone = str;

    if (str.contains("+")) {
      strDateWithoutTimeZone = str.split("+")[0];
    }

    DateTime tempDate =
        new DateFormat(strDateTimeFormateBackend).parse(strDateWithoutTimeZone);
    String strDate = DateFormat(strDateFormateDDMMYYYY).format(tempDate);

    return strDate;
  }

  String getOnlyDateFormatedDDMMYYYY(
      String str, String inputFormate, String outputFormate) {
    if (str.isNotEmpty) {
      DateTime tempDate = new DateFormat(inputFormate).parse(str);
      String strDate = DateFormat(outputFormate).format(tempDate);
      return strDate;
    } else {
      return "";
    }
  }

  getSelectedLanguage(Function() resultBlock) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    appLanguage = preferences.getString(Constants.active_app_language);

    print("Constant Lan - $appLanguage");
    if (appLanguage == "" || appLanguage == null) {
      preferences.setString(Constants.active_app_language, "en");
      appLanguage = preferences.getString(Constants.active_app_language);
      print(
          "Preference Lan - ${preferences.getString(Constants.active_app_language)}");
    }
    print("Constant APP Lan - $appLanguage");

    resultBlock();
  }

  updateSelectedLanguage(String language, Function() resultBlock) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print("Old Language - ${preferences.getString(active_app_language)}");
    preferences.setString(Constants.active_app_language, language);
    print("New Language - ${preferences.getString(active_app_language)}");
    appLanguage = preferences.getString(Constants.active_app_language);

    resultBlock();
  }

  Future<bool> checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        print('--------------TRY ELSE----------------');
        print('--> ${result.isNotEmpty.toString()}');
        return false;
      }
    } on SocketException catch (_) {
      return false;
    }
  }

  /*
  * -- Save & get SharePreference
  * */
  sharePref_saveString(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  sharePref_saveInt(String key, int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
  }

  sharePref_saveBool(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  Future<void> logoutFromApp(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String deviceToken = prefs.getString(prefStr_FCM_DEVICE_TOKEN);
    await prefs.clear().then((value) {
      sharePref_saveString(prefStr_FCM_DEVICE_TOKEN, deviceToken);
      prefs.setString(active_app_language, appLanguage);
      var providerProfile =
          Provider.of<ProviderProfile>(context, listen: false);
      providerProfile.clearUserData();

      var providerCart = Provider.of<ProviderCart>(context, listen: false);
      providerCart.clearCartProvider();

      var providertrack = Provider.of<ProviderTrack>(context, listen: false);
      providertrack.clearValue();

      Navigator.pushNamedAndRemoveUntil(
          context, getStartedRoute, (Route<dynamic> route) => false);
    });
  }

  /*
  * -- Colors
  * */
  int primarycolor = 0xff3368A9;
  int themeColor = 0xff33876E;
  int clrWhite = 0xffffffff;
  int clrBlack = 0xff000000;
  int clrPrimaryBg = 0xff00D9AE;
  int clrGreyFont = 0xff989898;
  int clrGreyLight = 0xffF5F5F5;
  int clrGreyLightest = 0xff9A9A9A;
  int clrDarkGreyFont = 0xff8E8E8E;
  int clrLightGreyFont = 0xffD6D6D6;
  int clrBlue = 0xff007FFF;
  int clrTransparent = 0x00000000;
  int clrred = 0xffFF8282;
  int clryellow = 0xffFFC300;

  /*
  * -- SharedPreference Data
  * */
  String prefStr_PREFERREDLANGUAGE = 'PREFERREDLANGUAGE';
  String prefStr_SCOPE = 'SCOPE';
  String prefStr_FNAME = 'FNAME';
  String prefStr_LNAME = 'LNAME';
  String prefStr_MESSAGE = 'MESSAGE';
  String prefStr_ENTITYTYPE = 'ENTITYTYPE';
  String prefStr_EMAIL = 'EMAIL';
  String prefStr_PHONENUMBER = 'PHONENUMBER';
  String prefStr_GENDER = 'GENDER';
  String prefStr_REGISTEREDVIA = 'REGISTEREDVIA';
  String prefStr_CREATEDAT = 'CREATEDAT';
  String prefStr_BIRTHDATE = 'BIRTHDATE';
  String prefStr_ADDRESSLIST = 'ADDRESSLIST';
  String prefStr_ROLE = 'ROLE';
  String prefStr_FCM_DEVICE_TOKEN = 'FCM_DEVICE_TOKEN';
  String prefStr_ACCESS_TOKEN = 'ACCESS_TOKEN';
  String prefStr_TOKEN_TYPE = 'TOKEN_TYPE';
  String prefStr_REFRESH_TOKEN = 'REFRESH_TOKEN';
  String prefInt_googlemessage_id = 'googlemessage_id';

  String prefInt_ID =
      'ID'; //-- ID & EntitiyID are same (EntitiyID - before Login) -##- (ID - after Login)
  String prefInt_USERID = 'USERID';
  String prefInt_EXPIRES_IN = 'EXPIRES_IN';
  String prefInt_STATUS = 'STATUS';

  String prefBool_ACTIVE = 'ACTIVE';
  String prefBool_EMAILVERIFIED = 'EMAILVERIFIED';
  String prefBool_PHONEVERIFIED = 'PHONEVERIFIED';
  String prefBool_CANCHANGEPASSWORD = 'CANCHANGEPASSWORD';
  String prefBool_ISLOGIN = 'ISLOGIN';
  String prefBool_UUID = 'UUID';
  String prefStr_UNIQUE_ID = "FCM_UNIQUE_ID";

  /*
  * -- SharedPreferece Address & Location of User
  * */
  //String prefInt_CityID = 'CityID';
  //String prefStr_CityName = 'CityName';
  String prefInt_AddressID = 'AddressID';
  String prefStr_Latitute = 'Latitute';
  String prefStr_Longitude = 'Longitude';
  String prefStr_Area = 'Area';
  String prefStr_FullAddress = 'FullAddress';
  //String prefStr_State = 'State';
  //String prefStr_Address = 'Address';

  /*
  * -- Static values
  * */
  static String static_REGISTEREDVIA = "APP";
  static bool static_ACTIVE = true;
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

  final int pageDuration = 900;

  /*
  * -- Routes Name
  * */
  final String getStartedRoute = '/GetStartedPage';
  final String loginRoute = '/LoginPage';
  final String forgotPwdRoute = '/ForgotPwdPage';
  final String signupRoute = '/SignUpPage';
  final String homeRoute = "/HomePage";
  final String chooseLocationRoute = "/ChooseLocationPage";
  final String viewMoreRoute = "/ViewMorePage";
  final String cartRoute = "/CartPage";
  final String checkoutRoute = "/CheckoutPage";
  final String orderConfirmRoute = "/OrderConfirmPage";
  final String aboutRoute = "/AboutPage";
  final String termsConditionsRoute = "/TermsConditionsPage";
  final String notificationRoute = "/NotificationPage";
  final String niceWalletRoute = "/NiceWalletPage";
  final String orderHistoryRoute = "/OrderHistory";
  final String addressBookRoute = "/AddressBookPage";
  final String selectAddressRoute = "/SelectAddressPage";
  final String addAddressRoute = "/AddAddressPage";
  final String ticketListRoute = "/TicketListPage";
  final String addTicketRoute = "/AddTicketPage";
  final String ticketDetailRoute = "/TicketDetailPage";
  final String profileRoute = "/ProfilePage";
  final String changePwdRoute = "/ChangePwdPage";
  final String orderDetailsRoute = "/OrderDetailsPage";
  final String addToCartGroceryRoute = "/AddToCartGroceryPage";
  final String cuisinesRoute = "/CuisinesPage";
  final String cancelOrderRoute = "/CancelOrderPage";
  final String returnOrderRoute = "/ReturnOrderPage";
  final String replaceOrderRoute = "/ReplaceOrderPage";
  final String trackOrderRoute = "/TrackOrderPage";
  final String orderStatusRoute = "/OrderStatusPage";

  /*
  * -- Strings
  * */
  final String welcome = 'Welcome';
  final String errSomethingWentWrong = "Something went wrong";
  final String errInternetConnection = "Please check your internet connection";
  final String welcomeMsg = '';
  final String facebook = 'Facebook';
  final String google = 'Google';
  final String login = 'Login';
  final String dontHaveAcc = 'Don’t have an account? ';
  final String createAcc = 'Create account';
  final String continueAs = 'Continue as Guest';
  final String email = 'Email';
  final String rupee = '₹';
  final String currency = 'KD ';
  final String password = 'Password';
  final String confirmPassword = 'Confirm Password';
  final String currentPassword = 'Current Password';
  final String newPassword = 'New Password';
  final String phone = 'Phone';
  final String phoneverify = 'Phone Verify';
  final String firstName = 'First Name';
  final String lastName = 'Last Name';
  final String forgotPassword = 'Forgot Password';
  final String forgotPwdMsg = "";
  final String pwdResetLink = "Password Reset Link";
  final String pwdResetLinkMsg =
      "We have send password reset link to your registered email address. Please check.";
  final String verifyEmail = "Verify Email";
  final String verifyEmailMsg =
      "We've sent an account verification link on your registered email address. Please go through that link to verify your email.";
  final String submit = 'Submit';
  final String signup = 'Sign Up';
  final String logIn = 'Log In';
  final String alreadyAcc = "Already have an account? ";
  final String next = "Next";
  final String okay = "Okay";
  final String congrats = "Congratulations";
  final String congratsMsg =
      "Congratulations, \nYour account has been successfully verified.";
  final String resetpassword = 'Reset Password';
  final String resetpassmessage =
      'To reset a password you need to enter\nnew password & confirm it.';
  final String confirmnewPassword = 'Confirm New Password';
  final String deliverTo = "Deliver to ";
  final String selectLocation = "Select Location";
  final String whatWouldYouLike = "What would you like to order,";
  final String saveAddresses = "Save Addresses";
  final String chooseLoc = "Choose Location";
  final String searchAdd = "Search for your address";
  final String deliveryLoc = "Delivery Location";
  final String relocate = "Relocate";
  final String deliverHere = "Yes, Deliver Here";
  final String filter = "Filter";
  final String filterBy = "Filter By";
  final String aToz = "A to Z";
  final String done = "Done";
  final String search = "Search";
  final String sort = "Sort";
  final String sortBy = "Sort By";
  final String dotSymbol = "•";
  final String cuisines = "Cuisines";
  final String reset = "Reset";
  final String ratings = "Ratings";
  final String apply = "Apply";
  final String home = "Home";
  final String orderHistory = "Order History";
  final String niceWallet = "NICE Wallet";
  final String niceWalletAmount = "NICE Wallet Amount";
  final String history = "History";
  final String addressBook = "Address Book";
  final String selectAddress = "Select Address";
  final String addAddress = "Add Address";
  final String saveAddress = "Save Address";
  final String notification = "Notification";
  final String termsConditions = "Terms & Condition";
  final String tickets = "Tickets";
  final String about = "About";
  final String logOut = "Logout";
  final String cart = "Cart";
  final String addMore = "Add More";
  final String viewMore = "View More";
  final String checkout = "Checkout";
  final String subtotal = "Subtotal";
  final String orderConfirm = "Order Confirmation";
  final String orderStatus = "Order Status";
  final String shopMore = "Shop More";
  final String multiplySymbol = "x";
  final String work = "Work";
  final String pending = "Pending";
  final String returnRequested = "Return Requested";
  final String replaceRequested = "Replace Requested";

  final String acknowledged = "Acknowledged";
  final String resolved = "Resolved";
  final String addTickets = "Add Tickets";
  final String ticketDetails = "Ticket Detail";
  final String profile = "Profile";
  final String editProfile = "Edit Profile";
  final String chngEmail = "Change Email";
  final String chngPwd = "Change Password";
  final String save = "Save";
  final String verifyNewEmail = "Verify New Email";

  // order Status

  // Regular
  final String regularOrderPending = "Pending";
  final String regularOrderRejected = "Rejected";
  final String regularOrderConfirmed = "Confirmed";
  final String regularOrderInProcess = "In-Process";
  final String regularOrderIsPrepared = "Order Is Prepared";
  final String regularOrderWaitingforpickup = "Waiting for pickup";
  final String regularOrderPickedUp = "Order Picked Up";
  final String regularOrderDelivered = "Delivered";
  final String regularOrderCancelled = "Cancelled";

  // Replacement
  final String replacementOrderRequested = "Replace Requested";
  final String replacementOrderConfirmed = "Replace Confirmed";
  final String replacementOrderRejected = "Replace Rejected";
  final String replacementOrderProcessed = "Replace Processed";
  final String replacementOrderPrepared = "Replace Order Prepared";
  final String replacementOrderWaitingforpickup =
      "Replace Waiting for Picked Up";
  final String replacementOrderPickedUp = "Replace Order Picked Up";
  final String replacementOrderReplaced = "Replaced";
  final String replacementOrderCancelled = "Replace Cancelled";

  // Return
  final String returnOrderRequested = "Return Requested";
  final String returnOrderConfirmed = "Return Confirmed";
  final String returnOrderRejected = "Return Rejected";
  final String returnOrderProcessed = "Return Processed";
  final String returnOrderPickedUp = "Return Order Picked Up";
  final String returnOrderReturned = "Returned";
  final String returnOrderCancelled = "Return Cancelled";

  final String delivered = "Delivered";
  final String returnOrder = "Return Order";
  final String replaceOrder = "Replace Order";
  final String cancelOrder = "Cancel Order";
  final String viewOrder = "View Order";

  final String placeOrder = "Place Order";
  final String trackOrder = "Track Order";
  final String vendorInfo = "Restaurant Info";
  final String orderDetail = "Order Detail";
  final String rateYourExperience = "Rate Your Experience";
  final String ratingsReviews = "Ratings & Reviews";
  final String comingSoon = "Coming Soon...";
  final String conStrLoginErrorGmail =
      "Couldn't log in with your Google account, please try again!";
  final String otpVerify = 'OTP Verification';
  final String verificationmessage =
      'We have Sent You A Verification Code On \n Your Registered Email \n Please Verify Email';
  final String verificationmessage1 =
      'We have Sent You A Verification Code On Your New Email. Please Verify Email';
  final String verificationmessage2 =
      'We have Sent You A Verification Code On Your New Phone. Please Verify Phone Number';
  final String txtresend = "RESEND";
  final String txtresendmessage = "Did not receive a code";
  final String txtsubmit = "Submit";
  final String txtdeliveryaddress = "Delivery Address";
  final String txtordersummary = "Order Summary";
  final String txtKd = "KD ";
  final String noDataFound = "No data found";
  final String date = "Date";
  final String orderId = "Order ID";
  final String newCart = "Start A new Cart ? ";
  final String newCartMsg =
      "Products are exists  in the cart Are you sure want to clear cart ?";
  final String noItemCart = "No Items in cart ";
  final String removeItem = "Remove Item";
  final String removeItemCart = "Are you want to remove ";
  final String fromCart = "from cart ?";

  final String building = "Building";
  final String block = "Block";
  final String street = "Street";
  final String area = "Area";
  final String city = "City";
  final String zipcode = "Zipcode";

  final String ticketNo = "Ticket No";
  final String ticketDate = "Ticket Date";
  final String ticketStatus = "Ticket Status";
  final String ticketReason = "Ticket Reason";
  final String ticketPayout = "Didn't received payout";
  final String ticketEnquiryReason = "Enquiry Reason";
  final String ticketDescription = "Description";
  final String ticketSelectEnquiryReason = "Select enquiry reason";
  final String strDate = "Date";
  final String strKD = "KD";
  //final String ticket = "";

  final String valTicketReason = "Please Select enquiry reason";
  final String valTicketDescription = "Please enter description";
  final String anySuggestions = "Any Suggestions";
  final String strToday = "Today";

  // checkout

  final String strCheckOutAddSpe = "Add Special Request?";
  final String strCheckoutOptional = "(Optional)";
  final String strTapTo = "Tap to enter request";
  final String strPaymentMode = "Payment Mode";
  final String strYourNiceWallet = "Your NICE wallet amount";
  final String strCheckoutOnline = "Online";
  final String strCheckoutCash = "Cash";
  final String strCheckoutTerms = "By placing this order you agree to our";
  final String strDelivery = "Delivery";
  final String strPickup = "Pickup";
  final String strOrderConfirmed = "Order Confirmed";
  final String address = "Address";
  final String strOrderNumber = "Order number";
  final String strOrderAmt = "Order amount";
  final String strPayment = "Payment";

  final String enterBuilding = "Enter building";
  final String enterBlock = "Enter block";
  final String enterStreet = "Enter street";
  final String enterArea = "Enter area";
  final String selectCity = "Select city";
  final String selectZipcode = "Select zipcode";
  final String enterPhone = "Enter phone";

  final String txtNoDataFound = "";

  final String txtNoDataFoundMsg = "";

  /*
  * --- Images
  * */
  final String splashgif = 'assets/images/splash.gif';
  final String splashLogo = 'assets/images/splash_logo.png';
  final String getStartedBg = 'assets/images/get_started_bg.png';
  final String blackShade = 'assets/images/black_shade.png';
  final String icGoogle = 'assets/images/ic_google.png';
  final String icFacebook = 'assets/images/ic_facebook.png';
  final String loginBg = 'assets/images/login_bg.png';
  final String signUpBg = 'assets/images/get_started_bg.png';
  final String icCheck = 'assets/images/ic_check.png';
  final String icSearch = 'assets/images/search.png';
  final String icDownArrow = 'assets/images/ic_down_arrow.png';
  final String icDropDownArrow = 'assets/images/drop_down.png';
  final String food = 'assets/images/food.png';
  final String grocery = 'assets/images/grocery.png';
  final String categoryGradient = 'assets/images/category_gradient.png';
  final String bannerImage = 'assets/images/banner_image.png';
  final String icUser = 'assets/images/user.png';
  final String icHome = 'assets/images/ic_home.png';
  final String icHistory = 'assets/images/history.png';
  final String icWallet = 'assets/images/wallet.png';
  final String icInfo = 'assets/images/info.png';
  final String icTicket = 'assets/images/ticket.png';
  final String icBell = 'assets/images/bell.png';
  final String icMapPin = 'assets/images/map_pin.png';
  final String icHelpCircle = 'assets/images/help_circle.png';
  final String icCurrentLoc = 'assets/images/current_loc.png';
  final String icLocSearch = 'assets/images/loc_search.png';
  final String icMapPinSolid = 'assets/images/map_pin_solid.png';
  final String icFilter = 'assets/images/filter.png';
  final String icStar = 'assets/images/star.png';
  final String icShoppingBag = 'assets/images/shopping_bag.png';
  final String icPlus = 'assets/images/plus.png';
  final String icMinus = 'assets/images/minus.png';
  final String icOrderConfirm = 'assets/images/order_confirm.png';
  final String icMapPinDark = 'assets/images/map_pin_dark.png';
  final String icDelete = 'assets/images/trash.png';
  final String icNiceWallet = 'assets/images/nice_wallet.png';
  final String icEdit = 'assets/images/edit.png';
  final String icCalendar = 'assets/images/calendar.png';
  final String icStatusCheck = 'assets/images/status_check.png';
  final String icStatusUnCheck = 'assets/images/status_uncheck.png';
  final String icCheckDark = 'assets/images/ic_check_dark.png';
  final String icKNET = 'assets/images/knet.png';
  final String icCash = 'assets/images/cash.png';
  final String icPay = 'assets/images/pay.png';
  final String pizzaPic = 'assets/images/pizzaPic.png';
  final String icMenu = 'assets/images/bx-food-menu.png';
  final String detailBlackShade = 'assets/images/detail_black_shade.png';
  final String forwardArrow = 'assets/images/forward_arrow.png';
  final String icArrowRound = 'assets/images/arrow_round.png';
  final String pizzaComboOffer = 'assets/images/pizza_combo_offer.png';
  final String icProfile = 'assets/images/ic_profile.png';
  final String icPhone = 'assets/images/ic_phone.png';
  final String upArrow = 'assets/images/up_arrow.png';
  final String groceryShopFeatured = 'assets/images/grocery_shop_featured.png';
  final String groceryShop = 'assets/images/grocery_shop.png';
  final String lays = 'assets/images/lays.png';
  final String mango = 'assets/images/mango.png';
  final String menu = 'assets/images/menu.png';

  final String mapPinSource = 'assets/images/map_Pin_Source.png';
  final String mapPinDestination = 'assets/images/map_pin_destination.png';
  final String icNoDataFound = 'assets/images/icNoDataFound.png';
  final String emptyCart = 'assets/images/emptyCart.png';
  final String icNoServiceableArea = 'assets/images/noServiceableArea.png';

  /*
  * -- User details saved
  * */
  saveLoginUserDetails(LoginEmailResponce loginResponce) {
    sharePref_saveString(prefStr_SCOPE, loginResponce.data.scope);
    sharePref_saveString(prefStr_FNAME, loginResponce.data.firstName);
    sharePref_saveString(prefStr_LNAME, loginResponce.data.lastName);
    sharePref_saveString(prefStr_MESSAGE, loginResponce.data.message);
    sharePref_saveString(prefStr_ENTITYTYPE, loginResponce.data.entityType);
    sharePref_saveString(prefStr_EMAIL, loginResponce.data.email);
    sharePref_saveString(prefStr_PHONENUMBER, loginResponce.data.phoneNumber);
    sharePref_saveString(prefStr_ROLE, loginResponce.data.role);
    sharePref_saveString(prefStr_ACCESS_TOKEN, loginResponce.data.accessToken);
    sharePref_saveString(prefStr_TOKEN_TYPE, loginResponce.data.tokenType);
    sharePref_saveString(
        prefStr_REFRESH_TOKEN, loginResponce.data.refreshToken);

    sharePref_saveInt(prefInt_USERID, loginResponce.data.userId);
    sharePref_saveInt(prefInt_ID, loginResponce.data.entityId);
    sharePref_saveInt(prefInt_EXPIRES_IN, loginResponce.data.expiresIn);

    sharePref_saveBool(
        prefBool_CANCHANGEPASSWORD, loginResponce.data.canChangePassword);
    sharePref_saveBool(
        prefBool_PHONEVERIFIED, loginResponce.data.phoneVerified);
    sharePref_saveBool(
        prefBool_EMAILVERIFIED, loginResponce.data.emailVerified);

    sharePref_saveBool(prefBool_ISLOGIN, true);
  }

  saveLoginUserAdreessLocation(
      ProviderAddressBook providerAddressBook, SelectedAddressModel model) {
    //sharePref_saveInt(prefInt_CityID, model.cityId);
    //sharePref_saveString(prefStr_CityName, model.cityName);
    sharePref_saveInt(prefInt_AddressID, model.addressID);
    sharePref_saveString(prefStr_Latitute, model.latitude.toString());
    sharePref_saveString(prefStr_Longitude, model.longitude.toString());
    sharePref_saveString(prefStr_Area, model.areaName);
    sharePref_saveString(prefStr_FullAddress, model.fullAdddress);
    //sharePref_saveString(prefStr_State, model.state);

    showLog("---------saveLoginUserAdreessLocation----------");
    //showLog("CityID : ${model.cityId}");
    //showLog("CityName : ${model.cityName}");
    //showLog("state : ${model.state}");
    showLog("AddressID : ${model.addressID}");
    showLog("Latitute : ${model.latitude}");
    showLog("Longitude : ${model.longitude}");
    showLog("Area : ${model.areaName}");
    showLog("FullAddress : ${model.fullAdddress}");
    //showLog("state : ${model.state}");

    /* if (model.cityName != null) {
      if (model.area != null && model.area.isNotEmpty) {
        model.address = "${model.area},  ${model.cityName}";
        sharePref_saveString(prefStr_Address, model.area + " " + model.cityName);
      } else {
        model.address = "${model.cityName},  ${model.state}";
        sharePref_saveString(prefStr_Address, model.cityName + " " + model.state);
      }
    } else {
      model.address = "";
      sharePref_saveString(prefStr_Address, "");
    }*/

    providerAddressBook.setSelectedAddressModel(model);
  }

  /*
  * -- DoNot Change This values
  * */
  String static_Both = "Both";
  String static_Pick_Up = "Pick-Up";
  String static_Delivery = "Delivery";
  String static_Online = "Online";
  String static_COD = "COD";

  String displayStatus(BuildContext context, String orignalStatus) {
    if (orignalStatus == "Pending") {
      return "${AppTranslations.of(context).text("Key_status_Pending")}";
    } else if (orignalStatus == "Rejected") {
      return "${AppTranslations.of(context).text("Key_status_Rejected")}";
    } else if (orignalStatus == "Cancelled") {
      return "${AppTranslations.of(context).text("Key_status_Cancelled")}";
    } else if (orignalStatus == "Confirmed") {
      return "${AppTranslations.of(context).text("Key_status_Confirmed")}";
    } else if (orignalStatus == "In-Process") {
      return "${AppTranslations.of(context).text("Key_status_InProcess")}";
    } else if (orignalStatus == "Waiting for pickup") {
      return "${AppTranslations.of(context).text("Key_status_Waitingforpickup")}";
    } else if (orignalStatus == "Order Picked Up") {
      return "${AppTranslations.of(context).text("Key_status_OrderPickedUp")}";
    } else if (orignalStatus == "Delivered") {
      return "${AppTranslations.of(context).text("Key_status_Delivered")}";
    } else if (orignalStatus == "Return Requested") {
      return "${AppTranslations.of(context).text("Key_status_ReturnRequested")}";
    } else if (orignalStatus == "Return Rejected") {
      return "${AppTranslations.of(context).text("Key_status_ReturnRejected")}";
    } else if (orignalStatus == "Return Confirmed") {
      return "${AppTranslations.of(context).text("Key_status_ReturnConfirmed")}";
    } else if (orignalStatus == "Return Processed") {
      return "${AppTranslations.of(context).text("Key_status_ReturnProcessed")}";
    } else if (orignalStatus == "Order Is Prepared") {
      return "${AppTranslations.of(context).text("Key_status_OrderIsPrepared")}";
    } else if (orignalStatus == "Returned") {
      return "${AppTranslations.of(context).text("Key_status_Returned")}";
    } else if (orignalStatus == "Return Order Picked Up") {
      return "${AppTranslations.of(context).text("Key_status_ReturnOrderPickedUp")}";
    } else if (orignalStatus == "Replace Requested") {
      return "${AppTranslations.of(context).text("Key_status_ReplaceRequested")}";
    } else if (orignalStatus == "Replace Rejected") {
      return "${AppTranslations.of(context).text("Key_status_ReplaceRejected")}";
    } else if (orignalStatus == "Replace Confirmed") {
      return "${AppTranslations.of(context).text("Key_status_ReplaceConfirmed")}";
    } else if (orignalStatus == "Replace Processed") {
      return "${AppTranslations.of(context).text("Key_status_ReplaceProcessed")}";
    } else if (orignalStatus == "Replace Waiting for Picked Up") {
      return "${AppTranslations.of(context).text("Key_status_ReplaceWaitingPickedUp")}";
    } else if (orignalStatus == "Replace Order Picked Up") {
      return "${AppTranslations.of(context).text("Key_status_ReplaceOrderPickedUp")}";
    } else if (orignalStatus == "Replaced") {
      return "${AppTranslations.of(context).text("Key_status_Replaced")}";
    } else if (orignalStatus == "Replace Order Prepared") {
      return "${AppTranslations.of(context).text("Key_status_ReplaceOrderPrepared")}";
    } else if (orignalStatus == "Replace Cancelled") {
      return "${AppTranslations.of(context).text("Key_status_ReplaceCancelled")}";
    } else if (orignalStatus == "Return Cancelled") {
      return "${AppTranslations.of(context).text("Key_status_ReturnCancelled")}";
    } else {
      return "";
    }
  }

  Color getOrderStatusColor(String orderStatus) {
    if (orderStatus == regularOrderPending) {
      return GlobalColor.orange;
    } else if (orderStatus == returnOrderReturned) {
      return GlobalColor.pink;
    } else if (orderStatus == replacementOrderReplaced) {
      return GlobalColor.peach;
    } else if (orderStatus == regularOrderRejected) {
      return GlobalColor.red;
    } else {
      return GlobalColor.green;
    }
  }
}

/*----

1. Converte Date to String & String to Date
  - https://stackoverflow.com/questions/51042621/unable-to-convert-string-date-in-format-yyyymmddhhmmss-to-datetime-dart
  - TimeZone - https://stackoverflow.com/questions/60854312/datetime-flutter-format


*/
