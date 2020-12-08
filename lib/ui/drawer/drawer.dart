import 'package:flutter/material.dart';
import 'package:nice_customer_app/Localization/ProviderAppLocalization.dart';
import 'package:nice_customer_app/Localization/app_translations.dart';
import 'package:nice_customer_app/common/alertDialog.dart';
import 'package:nice_customer_app/mixins/const.dart';
import 'package:nice_customer_app/profile/ProviderProfile.dart';
import 'package:nice_customer_app/ui/about/about.dart';
import 'package:nice_customer_app/ui/address_book/address_book.dart';
import 'package:nice_customer_app/ui/home/home.dart';
import 'package:nice_customer_app/ui/login/login.dart';
import 'package:nice_customer_app/ui/nice_wallet/nice_wallet.dart';
import 'package:nice_customer_app/ui/notification/notification.dart';
import 'package:nice_customer_app/ui/orderhistory/order_history.dart';
import 'package:nice_customer_app/ui/terms_condition/terms_condition.dart';
import 'package:nice_customer_app/ui/ticket/ticket_list.dart';
import 'package:nice_customer_app/utils/color_.dart';
import 'package:nice_customer_app/utils/padding_.dart';
import 'package:nice_customer_app/utils/textstyle_.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerPage extends StatefulWidget {
  DrawerPage({Key key}) : super(key: key);

  @override
  _DrawerPageState createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> with Constants {
  ProviderProfile providerProfile;
  var _menuItems = [];

  var appLanguage;

  @override
  void initState() {
    super.initState();

    providerProfile = Provider.of<ProviderProfile>(context, listen: false);

    Future.delayed(Duration(milliseconds: 10), () async {
      await providerProfile.setUserData();
      providerProfile.setIsLogin();
      SharedPreferences preferences = await SharedPreferences.getInstance();

      appLanguage = preferences.getString(Constants.active_app_language);

      if (appLanguage == constant_static_ar) {
        providerProfile.setPREFERREDLANGUAGE(constant_static_ar);
      } else {
        providerProfile.setPREFERREDLANGUAGE(constant_static_en);
      }

      if (providerProfile.isLogin != null && providerProfile.isLogin) {
        _menuItems = [
          [icHome, "${AppTranslations.of(context).text("Key_home")}"],
          [
            icHistory,
            "${AppTranslations.of(context).text("Key_OrderHistory")}"
          ],
          [icWallet, "${AppTranslations.of(context).text("Key_NICEWallet")}"],
          [icMapPin, "${AppTranslations.of(context).text("Key_AddressBook")}"],
          [icBell, "${AppTranslations.of(context).text("Key_notification")}"],
          [
            icHelpCircle,
            "${AppTranslations.of(context).text("Key_TermsCondition")}"
          ],
          [icTicket, "${AppTranslations.of(context).text("Key_Ticket")}"],
          [icInfo, "${AppTranslations.of(context).text("Key_About")}"],
        ];
      } else {
        _menuItems = [
          [icHome, "${AppTranslations.of(context).text("Key_home")}"],
          [
            icHelpCircle,
            "${AppTranslations.of(context).text("Key_TermsCondition")}"
          ],
          [icInfo, "${AppTranslations.of(context).text("Key_About")}"],
        ];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizationState = Provider.of<ProviderAppLocalization>(context);

    buildSetupScreenUtils(context);

    return SizedBox(
      width: setWidth(281),
      child: Theme(
        data: ThemeData(
          canvasColor: GlobalColor.white,
        ),
        child: SafeArea(child: Consumer<ProviderProfile>(
          builder: (context, providerProfile, child) {
            if (providerProfile.isLogin != null && providerProfile.isLogin) {
              _menuItems = [
                [icHome, "${AppTranslations.of(context).text("Key_home")}"],
                [
                  icHistory,
                  "${AppTranslations.of(context).text("Key_OrderHistory")}"
                ],
                [
                  icWallet,
                  "${AppTranslations.of(context).text("Key_NICEWallet")}"
                ],
                [
                  icMapPin,
                  "${AppTranslations.of(context).text("Key_AddressBook")}"
                ],
                [
                  icBell,
                  "${AppTranslations.of(context).text("Key_notification")}"
                ],
                [
                  icHelpCircle,
                  "${AppTranslations.of(context).text("Key_TermsCondition")}"
                ],
                [icTicket, "${AppTranslations.of(context).text("Key_Ticket")}"],
                [icInfo, "${AppTranslations.of(context).text("Key_About")}"],
              ];
            } else {
              _menuItems = [
                [icHome, "${AppTranslations.of(context).text("Key_home")}"],
                [
                  icHelpCircle,
                  "${AppTranslations.of(context).text("Key_TermsCondition")}"
                ],
                [icInfo, "${AppTranslations.of(context).text("Key_About")}"],
              ];
            }

            return Scaffold(
              body: Padding(
                padding: EdgeInsets.only(
                    top: setHeight(20), left: setWidth(5), right: setWidth(15)),
                child: Column(
                  children: [
                    providerProfile.getIsLogin() != null &&
                            providerProfile.getIsLogin()
                        ? ListTile(
                            contentPadding: EdgeInsets.only(left: setWidth(20)),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.of(context)
                                  .popUntil((route) => route.isFirst);
                              Navigator.pushNamed(context, profileRoute);
                            },
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${providerProfile.getFName() + " " + providerProfile.getLName()}",
                                  style: getTextStyle(context,
                                      type: Type.styleDrawerText,
                                      fontFamily: sourceSansFontFamily,
                                      fontWeight: fwBold,
                                      txtColor: GlobalColor.black),
                                ),
                                Text(
                                  "${providerProfile.getEMAIL()}",
                                  style: getTextStyle(context,
                                      type: Type.styleBody2,
                                      fontFamily: sourceSansFontFamily,
                                      fontWeight: fwRegular,
                                      txtColor: GlobalColor.black),
                                ),
                              ],
                            ),
                          )
                        : Offstage(),
                    SizedBox(
                      height: setHeight(10),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: _menuItems != null ? _menuItems.length : 0,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                            dense: true,
                            leading: Image.asset(
                              _menuItems[index][0],
                              height: setHeight(24),
                              width: setWidth(24),
                            ),
                            title: Material(
                              type: MaterialType.transparency,
                              child: Text(
                                _menuItems[index][1],
                                style: getTextStyle(context,
                                    type: Type.styleDrawerText,
                                    fontFamily: sourceSansFontFamily,
                                    fontWeight: fwSemiBold,
                                    txtColor: GlobalColor.black),
                              ),
                            ),
                            onTap: () async {
                              String menuitemname =
                                  _menuItems[index][1].toString();

                              if ("${AppTranslations.of(context).text("Key_home")}" ==
                                  menuitemname) {
                                Navigator.pop(context);
                                Navigator.of(context)
                                    .popUntil((route) => route.isFirst);

                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                      transitionDuration:
                                          Duration(milliseconds: pageDuration),
                                      pageBuilder: (_, __, ___) => HomePage()),
                                );
                              } else if ("${AppTranslations.of(context).text("Key_OrderHistory")}" ==
                                  menuitemname) {
                                Navigator.pop(context);
                                Navigator.of(context)
                                    .popUntil((route) => route.isFirst);

                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                      transitionDuration:
                                          Duration(milliseconds: pageDuration),
                                      pageBuilder: (_, __, ___) =>
                                          OrderHistoryPage()),
                                );
                              } else if ("${AppTranslations.of(context).text("Key_NICEWallet")}" ==
                                  menuitemname) {
                                Navigator.pop(context);
                                Navigator.of(context)
                                    .popUntil((route) => route.isFirst);

                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                      transitionDuration:
                                          Duration(milliseconds: pageDuration),
                                      pageBuilder: (_, __, ___) =>
                                          NiceWalletPage()),
                                );
                              } else if ("${AppTranslations.of(context).text("Key_AddressBook")}" ==
                                  menuitemname) {
                                Navigator.pop(context);
                                Navigator.of(context)
                                    .popUntil((route) => route.isFirst);

                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                      transitionDuration:
                                          Duration(milliseconds: pageDuration),
                                      pageBuilder: (_, __, ___) =>
                                          AddressBookPage()),
                                );
                              } else if ("${AppTranslations.of(context).text("Key_TermsCondition")}" ==
                                  menuitemname) {
                                Navigator.pop(context);
                                Navigator.of(context)
                                    .popUntil((route) => route.isFirst);

                                Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                        transitionDuration: Duration(
                                            milliseconds: pageDuration),
                                        pageBuilder: (_, __, ___) =>
                                            TermsConditionsPage()));
                              } else if ("${AppTranslations.of(context).text("Key_Ticket")}" ==
                                  menuitemname) {
                                Navigator.pop(context);
                                Navigator.of(context)
                                    .popUntil((route) => route.isFirst);

                                Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                        transitionDuration: Duration(
                                            milliseconds: pageDuration),
                                        pageBuilder: (_, __, ___) =>
                                            TicketListPage()));
                              } else if ("${AppTranslations.of(context).text("Key_notification")}" ==
                                  menuitemname) {
                                Navigator.pop(context);
                                Navigator.of(context)
                                    .popUntil((route) => route.isFirst);
                                Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                        transitionDuration: Duration(
                                            milliseconds: pageDuration),
                                        pageBuilder: (_, __, ___) =>
                                            NotificationPage()));
                              } else if ("${AppTranslations.of(context).text("Key_About")}" ==
                                  menuitemname) {
                                Navigator.pop(context);
                                Navigator.of(context)
                                    .popUntil((route) => route.isFirst);

                                Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                        transitionDuration: Duration(
                                            milliseconds: pageDuration),
                                        pageBuilder: (_, __, ___) =>
                                            AboutPage()));
                              }
                            });
                      },
                    ),
                    Visibility(
                      visible: !(providerProfile.getIsLogin() != null &&
                          providerProfile.getIsLogin()),
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: setWidth(18), right: setWidth(15)),
                        child: Row(
                          children: [
                            Text(
                              "${AppTranslations.of(context).text("Key_Arabic")}",
                              style: getTextStyle(context,
                                  type: Type.styleDrawerText,
                                  fontFamily: sourceSansFontFamily,
                                  fontWeight: fwSemiBold,
                                  txtColor: GlobalColor.black),
                            ),
                            Switch(
                              value: providerProfile.getPREFERREDLANGUAGE() ==
                                  constant_static_en,
                              onChanged: (value) async {
                                if (value) {
                                  var strLang = constant_static_en;
                                  localizationState.selectevent(strLang);
                                  await updateSelectedLanguage(
                                      strLang, () => {});
                                  providerProfile
                                      .setPREFERREDLANGUAGE(constant_static_en);
                                } else {
                                  var strLang = constant_static_ar;

                                  localizationState.selectevent(strLang);
                                  await updateSelectedLanguage(
                                      strLang, () => {});
                                  providerProfile
                                      .setPREFERREDLANGUAGE(constant_static_ar);
                                }
                              },
                              activeTrackColor: Colors.grey.shade300,
                              activeColor: Colors.black,
                            ),
                            Text(
                              "${AppTranslations.of(context).text("Key_English")}",
                              style: getTextStyle(context,
                                  type: Type.styleDrawerText,
                                  fontFamily: sourceSansFontFamily,
                                  fontWeight: fwSemiBold,
                                  txtColor: GlobalColor.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: providerProfile.getIsLogin() != null &&
                                providerProfile.getIsLogin()
                            ? ListTile(
                                onTap: () {
                                  Navigator.pop(context);
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CommonAlertDialog(
                                        title:
                                            "${AppTranslations.of(context).text("Key_logOut")}",
                                        message:
                                            "${AppTranslations.of(context).text("Key_messagelogout")}",
                                        onYesPressed: () async {
                                          await logoutFromApp(context);
                                        },
                                        onNoPressed: () {
                                          Navigator.pop(context);
                                        },
                                      );
                                    },
                                  );
                                },
                                leading: Text(
                                  "${AppTranslations.of(context).text("Key_logOut")}",
                                  style: getTextStyle(context,
                                      type: Type.styleDrawerText,
                                      fontFamily: sourceSansFontFamily,
                                      fontWeight: fwSemiBold,
                                      txtColor: GlobalColor.black),
                                ),
                              )
                            : ListTile(
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                          transitionDuration: Duration(
                                              milliseconds: pageDuration),
                                          pageBuilder: (_, __, ___) =>
                                              LoginPage()));
                                },
                                leading: Text(
                                  "${AppTranslations.of(context).text("key_logInHere")}",
                                  style: getTextStyle(context,
                                      type: Type.styleDrawerText,
                                      fontFamily: sourceSansFontFamily,
                                      fontWeight: fwSemiBold,
                                      txtColor: GlobalColor.black),
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        )),
      ),
    );
  }
}
