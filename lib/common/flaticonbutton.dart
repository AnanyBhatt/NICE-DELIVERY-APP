import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:nice_customer_app/utils/color_.dart';
import 'package:nice_customer_app/utils/textstyle_.dart';

class FlatCustomButton extends StatelessWidget {
  final Gradient gradient;
  final double width;
  final double height;
  final Widget icon;
  final String title;
  final Function onPressed;
  final bool outline;
  final bool darkMode;
  final Type textType;
  final double borderRadius;
  final String tag;
  final bool isEnabled;

  FlatCustomButton(
      {Key key,
      this.gradient,
      this.width = double.infinity,
      this.height,
      @required this.onPressed,
      this.icon,
      @required this.title,
      this.outline = false,
      this.darkMode = false,
      this.textType = Type.styleHead,
      this.tag,
      this.isEnabled,
      this.borderRadius})
      : super(key: key);

  double _borderRadius;

  @override
  Widget build(BuildContext context) {
    if (borderRadius == null) {
      _borderRadius = ScreenUtil().setSp(25);
    } else {
      _borderRadius = this.borderRadius;
    }

    if (darkMode) {
      return outline
          ? MaterialButton(
              elevation: 0,
              // minWidth: SizeConfig.widthMultiplier * 28.8,
              height: ScreenUtil().setHeight(44),
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: GlobalColor.white,
                  width: ScreenUtil().setWidth(1),
                ),
                borderRadius: BorderRadius.circular(_borderRadius),
              ),
              color: GlobalColor.black,
              onPressed: onPressed,
              child: Padding(
                padding: EdgeInsets.zero,
                child: Text(title,
                    style: getTextStyle(
                      context,
                      type: textType,
                      fontFamily: sourceSansFontFamily,
                      fontWeight: FontWeight.w400,
                      txtColor: GlobalColor.white,
                    )),
              ),
            )
          : MaterialButton(
              elevation: 0,
              // minWidth: SizeConfig.widthMultiplier * 28.8,
              height: ScreenUtil().setHeight(44),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(_borderRadius),
              ),
              color: GlobalColor.white,
              onPressed: onPressed,
              child: Padding(
                padding: EdgeInsets.zero,
                child: Text(title,
                    style: getTextStyle(
                      context,
                      type: textType,
                      fontFamily: sourceSansFontFamily,
                      fontWeight: FontWeight.w400,
                      txtColor: GlobalColor.black,
                    )),
              ),
            );
    } else {
      return outline
          ? MaterialButton(
              elevation: 0,
              // minWidth: SizeConfig.widthMultiplier * 28.8,
              height: ScreenUtil().setHeight(44),
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: GlobalColor.black,
                  width: ScreenUtil().setWidth(1),
                ),
                borderRadius: BorderRadius.circular(_borderRadius),
              ),
              color: GlobalColor.white,
              onPressed: onPressed,
              child: Padding(
                padding: EdgeInsets.zero,
                child: Text(title,
                    style: getTextStyle(
                      context,
                      type: textType,
                      fontFamily: sourceSansFontFamily,
                      fontWeight: FontWeight.w400,
                      txtColor: GlobalColor.black,
                    )),
              ),
            )
          : MaterialButton(
              elevation: 0,
              // minWidth: SizeConfig.widthMultiplier * 38.8,
              height: ScreenUtil().setHeight(44),

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(_borderRadius),
              ),
              color: GlobalColor.black,
              onPressed: onPressed,
              child: Padding(
                padding: EdgeInsets.zero,
                child: tag != null
                    ? Hero(
                        tag: tag,
                        child: Material(
                          type: MaterialType.transparency,
                          child: Text(title,
                              style: getTextStyle(
                                context,
                                type: textType,
                                fontFamily: sourceSansFontFamily,
                                fontWeight: FontWeight.w400,
                                txtColor: GlobalColor.white,
                              )),
                        ))
                    : Text(title,
                        style: getTextStyle(
                          context,
                          type: textType,
                          fontFamily: sourceSansFontFamily,
                          fontWeight: FontWeight.w400,
                          txtColor: GlobalColor.white,
                        )),
              ),
            );
    }
  }
}
