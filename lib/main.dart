
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:nice_customer_app/Localization/app_delegate.dart';
import 'package:nice_customer_app/common/mybehavior.dart';
import 'package:nice_customer_app/framework/stateprovidermodel/provider_cart.dart';
import 'package:nice_customer_app/framework/stateprovidermodel/provider_order.dart';
import 'package:nice_customer_app/framework/stateprovidermodel/provider_track.dart';
import 'package:nice_customer_app/mixins/const.dart';
import 'package:nice_customer_app/profile/ProviderEditProfile.dart';
import 'package:nice_customer_app/profile/ProviderProfile.dart';
import 'package:nice_customer_app/profile/change_pwd.dart';
import 'package:nice_customer_app/profile/profile.dart';
import 'package:nice_customer_app/provider/userinfo.dart';
import 'package:nice_customer_app/provider/viewCart.dart';
import 'package:nice_customer_app/ui/about/about.dart';
import 'package:nice_customer_app/ui/add_to_cart/add_to_cart_grocery.dart';
import 'package:nice_customer_app/ui/address_book/ProviderAddAddress.dart';
import 'package:nice_customer_app/ui/address_book/ProviderAddressBook.dart';
import 'package:nice_customer_app/ui/address_book/address_book.dart';
import 'package:nice_customer_app/ui/address_book/select_address.dart';
import 'package:nice_customer_app/ui/cart/ProviderRestaurnatDetails.dart';
import 'package:nice_customer_app/ui/cart/cart.dart';
import 'package:nice_customer_app/ui/checkout/checkout.dart';
import 'package:nice_customer_app/ui/choose_location/ProviderChooseLocation.dart';
import 'package:nice_customer_app/ui/filter/cuisines.dart';
import 'package:nice_customer_app/ui/forgot_pwd/ProviderforgotPassword.dart';
import 'package:nice_customer_app/ui/forgot_pwd/forgot_pwd.dart';
import 'package:nice_customer_app/ui/get_started/get_started.dart';
import 'package:nice_customer_app/ui/home/Providerhome.dart';
import 'package:nice_customer_app/ui/home/home.dart';
import 'package:nice_customer_app/ui/login/ProviderResetPassword.dart';
import 'package:nice_customer_app/ui/login/Providerlogin.dart';
import 'package:nice_customer_app/ui/login/login.dart';
import 'package:nice_customer_app/ui/nice_wallet/ProviderNiceWallet.dart';
import 'package:nice_customer_app/ui/nice_wallet/nice_wallet.dart';
import 'package:nice_customer_app/ui/notification/ProviderNotification.dart';
import 'package:nice_customer_app/ui/notification/notification.dart';
import 'package:nice_customer_app/ui/orderdetails/ProviderorderDetails.dart';
import 'package:nice_customer_app/ui/orderdetails/order_details.dart';
import 'package:nice_customer_app/ui/orderdetails/track_order.dart';
import 'package:nice_customer_app/ui/orderhistory/ProviderOrderHistory.dart';
import 'package:nice_customer_app/ui/orderhistory/order_history.dart';
import 'package:nice_customer_app/ui/orders/ProviderCancelOrder.dart';
import 'package:nice_customer_app/ui/orders/cancel_order.dart';
import 'package:nice_customer_app/ui/orders/order_confirm.dart';
import 'package:nice_customer_app/ui/orders/order_status.dart';
import 'package:nice_customer_app/ui/orders/replace_order.dart';
import 'package:nice_customer_app/ui/orders/return_order.dart';
import 'package:nice_customer_app/ui/ratings/ProviderReviewRatings.dart';
import 'package:nice_customer_app/ui/sign_up/ProviderOtp.dart';
import 'package:nice_customer_app/ui/sign_up/ProviderSignup.dart';
import 'package:nice_customer_app/ui/sign_up/sign_up.dart';
import 'package:nice_customer_app/ui/splash/splash_screen.dart';
import 'package:nice_customer_app/ui/terms_condition/terms_condition.dart';
import 'package:nice_customer_app/ui/ticket/ProviderAddTicket.dart';
import 'package:nice_customer_app/ui/ticket/ProviderTicket.dart';
import 'package:nice_customer_app/ui/ticket/ProviderTicketDetail.dart';
import 'package:nice_customer_app/ui/ticket/ticket_detail.dart';
import 'package:nice_customer_app/ui/ticket/ticket_list.dart';
import 'package:nice_customer_app/ui/vendor_details/ProviderVendorList.dart';
import 'package:nice_customer_app/ui/view_more/view_more.dart';
import 'package:nice_customer_app/utils/color_.dart';
import 'package:provider/provider.dart';

import 'Localization/ProviderAppLocalization.dart';
import 'Localization/application.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => UserData()),
      ChangeNotifierProvider(create: (_) => ProviderHome()),
      ChangeNotifierProvider(create: (_) => ViewCart()),
      ChangeNotifierProvider(create: (context) => ProviderLogin()),
      ChangeNotifierProvider(create: (context) => ProviderSignup()),
      ChangeNotifierProvider(create: (context) => ProviderForgotPassword()),
      ChangeNotifierProvider(create: (context) => ProviderProfile()),
      ChangeNotifierProvider(create: (context) => ProviderEditProfile()),
      ChangeNotifierProvider(create: (context) => ProviderRestaurantDetails()),
      ChangeNotifierProvider(create: (context) => ProviderVendorList()),
      ChangeNotifierProvider(create: (context) => ProviderOtp()),
      ChangeNotifierProvider(create: (context) => ResetPasswordProvider()),
      ChangeNotifierProvider(create: (context) => ProviderOrderHistory()),
      ChangeNotifierProvider(create: (context) => ProviderOrderdetails()),
      ChangeNotifierProvider(create: (context) => ProviderCart()),
      ChangeNotifierProvider(create: (context) => ProviderOrder()),
      ChangeNotifierProvider(create: (context) => ProviderAddressBook()),
      ChangeNotifierProvider(create: (context) => ProviderAddAddress()),
      ChangeNotifierProvider(create: (context) => ProviderTicket()),
      ChangeNotifierProvider(create: (context) => ProviderTicketDetail()),
      ChangeNotifierProvider(create: (context) => ProviderAddTicket()),
      ChangeNotifierProvider(create: (context) => ProviderNiceWallet()),
      ChangeNotifierProvider(create: (context) => ProviderChooseLocation()),
      ChangeNotifierProvider(create: (context) => ProviderReviewRatings()),
      ChangeNotifierProvider(create: (context) => ProviderAppLocalization()),
      ChangeNotifierProvider(create: (context) => ProviderTrack()),
      ChangeNotifierProvider(create: (context) => ProviderCancelOrder()),
      ChangeNotifierProvider(create: (context) => ProviderNotification()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget with Constants {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with Constants {
  AppTranslationsDelegate _newLocaleDelegate;

  @override
  void initState() {
    super.initState();
    _newLocaleDelegate = AppTranslationsDelegate(newLocale: null);
    application.onLocaleChanged = onLocaleChange;
    onLocaleChange(Locale("en", ""));
    getSelectedLanguage(() => {});
  }

  @override
  Widget build(BuildContext context) {
    final appstate = Provider.of<ProviderAppLocalization>(context);
    WidgetsFlutterBinding.ensureInitialized();

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: GlobalColor.black,
        statusBarBrightness:
            Brightness.dark
        ));
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: MyBehavior(),
          child: child,
        );
      },

      debugShowCheckedModeBanner: false,
      title: appName,
      home: SplashPage(),
      localizationsDelegates: [
        _newLocaleDelegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      routes: _routes(),
      theme: ThemeData(
        primaryColor: GlobalColor.black,
        accentColor: GlobalColor.black,
        primarySwatch: GlobalColor.colorPrimary,
        iconTheme: IconThemeData(color: GlobalColor.black),
        cursorColor: GlobalColor.black,
      ),

      supportedLocales: [
        const Locale('en', ''),
        const Locale('ar', ''),
      ],
      locale: appstate.appLocal,
    );
  }

  void onLocaleChange(Locale locale) {
    setState(() {
      _newLocaleDelegate = AppTranslationsDelegate(newLocale: locale);
    });
  }

  Map<String, WidgetBuilder> _routes() {
    return <String, WidgetBuilder>{
      getStartedRoute: (BuildContext context) => GetStartedPage(),
      loginRoute: (BuildContext context) => LoginPage(),
      forgotPwdRoute: (BuildContext context) => ForgotPwdPage(),
      signupRoute: (BuildContext context) => SignUpPage(),
      homeRoute: (BuildContext context) => HomePage(),
      viewMoreRoute: (BuildContext context) => ViewMorePage(),
      cartRoute: (BuildContext context) => CartPage(),
      checkoutRoute: (BuildContext context) => CheckoutPage(),
      orderConfirmRoute: (BuildContext context) => OrderConfirmPage(),
      aboutRoute: (BuildContext context) => AboutPage(),
      termsConditionsRoute: (BuildContext context) => TermsConditionsPage(),
      notificationRoute: (BuildContext context) => NotificationPage(),
      niceWalletRoute: (BuildContext context) => NiceWalletPage(),
      addressBookRoute: (BuildContext context) => AddressBookPage(),
      selectAddressRoute: (BuildContext context) => SelectAddressPage(),
      ticketListRoute: (BuildContext context) => TicketListPage(),
      ticketDetailRoute: (BuildContext context) => TicketDetailPage(),

      profileRoute: (BuildContext context) => ProfilePage(),
      changePwdRoute: (BuildContext context) => ChangePasswordPage(),
      orderDetailsRoute: (BuildContext context) => OrderDetailsPage(),
      addToCartGroceryRoute: (BuildContext context) => AddToCartGroceryPage(),
      cuisinesRoute: (BuildContext context) => CuisinesPage(),
      orderHistoryRoute: (BuildContext context) => OrderHistoryPage(),
      cancelOrderRoute: (BuildContext context) => CancelOrderPage(),
      orderStatusRoute: (BuildContext context) => OrderStatusPage(),
      trackOrderRoute: (BuildContext context) => TrackOrderPage(),
      replaceOrderRoute: (BuildContext context) => ReplaceOrderPage(),
      returnOrderRoute: (BuildContext context) => ReturnOrderPage(),
    };
  }
}
