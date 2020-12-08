import 'package:flutter/material.dart';
import 'package:nice_customer_app/Localization/app_translations.dart';
import 'package:nice_customer_app/mixins/const.dart';
import 'package:nice_customer_app/utils/textstyle_.dart';

class NoDataCart extends StatelessWidget with Constants {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: setWidth(35)),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              emptyCart,
            ),
            SizedBox(
              height: setHeight(61),
            ),
            Text(
              "${AppTranslations.of(context).text("Key_emptyCart")}",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: setSp(20),
                  fontFamily: sourceSansFontFamily,
                  fontWeight: fwBold,
                  color: Color(clrBlack)),
            ),
            SizedBox(
              height: setHeight(26),
            ),
            Text(
              txtNoDataFoundMsg,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: setSp(14),
                  fontFamily: sourceSansFontFamily,
                  fontWeight: fwRegular,
                  color: Color(clrGreyFont)),
            ),
          ],
        ),
      ),
    );
  }
}
