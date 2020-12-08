import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nice_customer_app/Localization/app_translations.dart';
import 'package:nice_customer_app/common/flaticonbutton.dart';
import 'package:nice_customer_app/mixins/const.dart';
import 'package:nice_customer_app/utils/color_.dart';
import 'package:nice_customer_app/utils/textstyle_.dart';

class CommonAlertDialog extends StatefulWidget {
  final String message;
  final String title;

  final Function onYesPressed;
  final Function onNoPressed;

  const CommonAlertDialog(
      {Key key,
      @required this.message,
      @required this.onYesPressed,
      @required this.onNoPressed,
      @required this.title})
      : super(key: key);

  @override
  _CommonAlertDialogState createState() => _CommonAlertDialogState();
}

class _CommonAlertDialogState extends State<CommonAlertDialog> with Constants {
  @override
  Widget build(BuildContext context) {
    buildSetupScreenUtils(context);

    return AlertDialog(
      content: Container(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.title,
            style: getTextStyle(context,
                type: Type.styleDrawerText,
                fontFamily: sourceSansFontFamily,
                txtColor: GlobalColor.black,
                fontWeight: fwBold),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(12),
          ),
          Text(
            widget.message,
            style: getTextStyle(context,
                type: Type.styleBody1,
                fontFamily: sourceSansFontFamily,
                txtColor: GlobalColor.black,
                fontWeight: fwRegular),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(14),
          ),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                    width: ScreenUtil().setWidth(134),
                    child: FlatCustomButton(
                      onPressed: widget.onNoPressed,
                      title: "${AppTranslations.of(context).text("Key_no")}",
                      outline: true,
                    )),
              ),
              SizedBox(
                width: ScreenUtil().setWidth(21),
              ),
              Expanded(
                child: SizedBox(
                    width: ScreenUtil().setWidth(134),
                    child: FlatCustomButton(
                        onPressed: widget.onYesPressed,
                        title:
                            "${AppTranslations.of(context).text("Key_yes")}")),
              ),
            ],
          )
        ],
      )),
    );
  }
}
