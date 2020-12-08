import 'package:flutter/material.dart';
import 'package:nice_customer_app/Localization/app_translations.dart';
import 'package:nice_customer_app/common/appbar.dart';
import 'package:nice_customer_app/common/drawerAppBar.dart';
import 'package:nice_customer_app/mixins/const.dart';
import 'package:nice_customer_app/ui/drawer/drawer.dart';
import 'package:nice_customer_app/utils/color_.dart';
import 'package:nice_customer_app/utils/padding_.dart';
import 'package:nice_customer_app/utils/textstyle_.dart';

class TermsConditionsPage extends StatefulWidget {
  TermsConditionsPage({Key key}) : super(key: key);

  @override
  _TermsConditionsPageState createState() => _TermsConditionsPageState();
}

class _TermsConditionsPageState extends State<TermsConditionsPage>
    with Constants {
  @override
  Widget build(BuildContext context) {
    buildSetupScreenUtils(context);

    return SafeArea(
      child: Scaffold(
          backgroundColor: GlobalColor.white,
          appBar: DrawerAppBar(
            appBar: AppBar(),
            title: "${AppTranslations.of(context).text("Key_TermsCondition")}",
          ),
          drawer: DrawerPage(),
          body: SingleChildScrollView(
            child: Container(
              padding: GlobalPadding.paddingSymmetricH_20,
              margin: GlobalPadding.paddingSymmetricV_25,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "",
                      style: getTextStyle(context,
                          type: Type.styleDrawerText,
                          fontFamily: sourceSansFontFamily,
                          fontWeight: fwSemiBold,
                          txtColor: GlobalColor.black),
                    ),
                    Padding(
                      padding: GlobalPadding.paddingSymmetricV_10,
                      child: Container(
                        color: GlobalColor.black,
                        height: setHeight(2),
                        width: setWidth(45.42),
                      ),
                    ),
                    SizedBox(
                      height: setHeight(8),
                    ),
                    Text(
                      "",
                      style: getTextStyle(context,
                          type: Type.styleBody2,
                          fontFamily: sourceSansFontFamily,
                          fontWeight: fwRegular,
                          txtColor: GlobalColor.grey),
                    ),
                    SizedBox(
                      height: setHeight(19),
                    ),
                    Text(
                      "",
                      style: getTextStyle(context,
                          type: Type.styleDrawerText,
                          fontFamily: sourceSansFontFamily,
                          fontWeight: fwSemiBold,
                          txtColor: GlobalColor.black),
                    ),
                    Padding(
                      padding: GlobalPadding.paddingSymmetricV_10,
                      child: Container(
                        color: GlobalColor.black,
                        height: setHeight(2),
                        width: setWidth(45.42),
                      ),
                    ),
                    SizedBox(
                      height: setHeight(8),
                    ),
                    Text(
                      "",
                      style: getTextStyle(context,
                          type: Type.styleBody2,
                          fontFamily: sourceSansFontFamily,
                          fontWeight: fwRegular,
                          txtColor: GlobalColor.grey),
                    ),
                  ]),
            ),
          )),
    );
  }
}
