import 'package:flutter/material.dart';
import 'package:nice_customer_app/common/drawerAppBar.dart';
import 'package:nice_customer_app/mixins/const.dart';
import 'package:nice_customer_app/ui/drawer/drawer.dart';
import 'package:nice_customer_app/utils/color_.dart';
import 'package:nice_customer_app/utils/padding_.dart';
import 'package:nice_customer_app/utils/textstyle_.dart';

class AboutPage extends StatefulWidget {
  AboutPage({Key key}) : super(key: key);

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> with Constants {
  @override
  Widget build(BuildContext context) {
    buildSetupScreenUtils(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: GlobalColor.white,
        appBar: DrawerAppBar(
          appBar: AppBar(),
          title: "About US",
        ),
        drawer: DrawerPage(),
        body: SingleChildScrollView(
          child: Container(
            padding: GlobalPadding.paddingSymmetricH_20,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                height: setHeight(15),
              ),
              Center(child: Image.asset(splashLogo)),
              SizedBox(
                height: setHeight(5),
              ),
              Divider(
                color: GlobalColor.grey,
                thickness: setHeight(1),
              ),
              SizedBox(
                height: setHeight(5),
              ),
              Text(
                "About Us",
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
                height: setHeight(25),
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
                height: setHeight(25),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
