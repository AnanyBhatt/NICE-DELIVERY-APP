import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:nice_customer_app/common/flaticonbutton.dart';
import 'package:nice_customer_app/mixins/const.dart';
import 'package:nice_customer_app/utils/color_.dart';
import 'package:nice_customer_app/utils/textstyle_.dart';

class ShowAppPopUp with Constants {
  Future<bool> showMessagePopUp(
    BuildContext context, {
    @required String title,
    @required String message,
    @required String btnText,
    @required Function btnOnPress,
  }) async {
    return await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Dialog(
            backgroundColor: GlobalColor.white,
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(setSp(25))), //this right here
            child: Container(
              width: setWidth(335),
              padding: EdgeInsets.symmetric(
                horizontal: setWidth(18),
                vertical: setHeight(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: getTextStyle(
                      context,
                      type: Type.styleSubTitle,
                      fontFamily: ralewayFontFamily,
                      fontWeight: fwBold,
                      txtColor: GlobalColor.black,
                    ),
                  ),
                  SizedBox(
                    height: setHeight(16.36),
                  ),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: getTextStyle(
                      context,
                      type: Type.styleBody1,
                      fontFamily: poppinsFontFamily,
                      fontWeight: fwRegular,
                      txtColor: GlobalColor.black,
                    ),
                  ),
                  SizedBox(
                    height: setHeight(16.64),
                  ),
                  SizedBox(
                    width: infiniteSize,
                    child: FlatCustomButton(
                      onPressed: btnOnPress,
                      title: btnText,
                      outline: true,
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
