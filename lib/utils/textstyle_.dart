import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const styleTitle = 'title';
const styleSubTitle = 'subtitle';
const styleHead = 'head';
const styleHeadBold = 'head_bold';
const styleSubHead = 'subhead';
const styleCaption = 'caption';
const styleCaptionBold = 'caption_bold';
const styleBody1 = 'body1';
const styleBody2 = 'body2';
const styleSubTitleBold = 'subtitle_bold';
const styleTitleBold = 'title_bold';
const styleTitleLight = "titleLight";
const styleDrawerText = "drawer";

enum Type {
  styleTitle,
  styleSubTitle,
  styleHead,
  styleSubHead,
  styleCaption,
  styleBody1,
  styleBody2,
  styleSmallText,
  styleXsmallText,
  styleLargeText,
  styleDrawerText,
}

var titleFontSize = ScreenUtil().setSp(24); // 24
var subTitleFontSize = ScreenUtil().setSp(22); //22

var drawerFontSize = ScreenUtil().setSp(18); //18

var headerFontSize = ScreenUtil().setSp(16); //16
var subHeaderFontSize = ScreenUtil().setSp(15); //15

var body1FontSize = ScreenUtil().setSp(14); // 14
var body2FontSize = ScreenUtil().setSp(12); // 12

var normalTextFontSize = ScreenUtil().setSp(10);
var largeFontSize = ScreenUtil().setSp(26);

var xSmallFontSize = 16.0;
var smallFontSize = 12.0;

const String ralewayFontFamily = 'Raleway';
const String poppinsFontFamily = 'Poppins';
const String moskFontFamily = 'Mosk';
const String sourceSansFontFamily = 'SourceSansPro';

const FontWeight fwThin = FontWeight.w100;
const FontWeight fwExtraLight = FontWeight.w200;
const FontWeight fwLight = FontWeight.w300;
const FontWeight fwRegular = FontWeight.w400;
const FontWeight fwMedium = FontWeight.w500;
const FontWeight fwSemiBold = FontWeight.w600;
const FontWeight fwBold = FontWeight.w700;
const FontWeight fwExtraBold = FontWeight.w800;

TextStyle getTextStyle(
  BuildContext context, {
  @required Type type,
  @required String fontFamily,
  @required FontWeight fontWeight,
  Color txtColor = const Color.fromARGB(0, 0, 0, 1),
  double letterSpacing = 0.0,
  TextDecoration decoration = TextDecoration.none,
}) {
  switch (type) {
    case Type.styleTitle:
      return TextStyle(
        fontWeight: fontWeight,
        color: txtColor,
        fontSize: titleFontSize,
        fontFamily: fontFamily,
        letterSpacing: letterSpacing,
        decoration: decoration,
      );
      break;

    case Type.styleSubTitle:
      return TextStyle(
        fontWeight: fontWeight,
        color: txtColor,
        fontSize: subTitleFontSize,
        fontFamily: fontFamily,
        letterSpacing: letterSpacing,
        decoration: decoration,
      );
      break;

    case Type.styleHead:
      return TextStyle(
        fontWeight: fontWeight,
        color: txtColor,
        fontSize: headerFontSize,
        fontFamily: fontFamily,
        letterSpacing: letterSpacing,
        decoration: decoration,
      );
      break;

    case Type.styleSubHead:
      return TextStyle(
        fontWeight: fontWeight,
        color: txtColor,
        fontSize: subHeaderFontSize,
        fontFamily: fontFamily,
        letterSpacing: letterSpacing,
        decoration: decoration,
      );
      break;

    case Type.styleCaption:
      return TextStyle(
        fontWeight: fontWeight,
        color: txtColor,
        fontSize: normalTextFontSize,
        fontFamily: fontFamily,
        letterSpacing: letterSpacing,
        decoration: decoration,
      );
      break;

    case Type.styleBody1:
      return TextStyle(
        color: txtColor,
        fontSize: body1FontSize,
        fontWeight: fontWeight,
        fontFamily: fontFamily,
        letterSpacing: letterSpacing,
        decoration: decoration,
      );
      break;

    case Type.styleBody2:
      return TextStyle(
        color: txtColor,
        fontSize: body2FontSize,
        fontWeight: fontWeight,
        fontFamily: fontFamily,
        letterSpacing: letterSpacing,
        decoration: decoration,
      );
      break;

    case Type.styleSmallText:
      return TextStyle(
        color: txtColor,
        fontSize: smallFontSize,
        fontWeight: fontWeight,
        fontFamily: fontFamily,
        letterSpacing: letterSpacing,
        decoration: decoration,
      );
      break;
    case Type.styleXsmallText:
      return TextStyle(
        color: txtColor,
        fontSize: xSmallFontSize,
        fontFamily: fontFamily,
        fontWeight: fontWeight,
        decoration: decoration,
      );

      break;

    case Type.styleLargeText:
      return TextStyle(
        color: txtColor,
        fontWeight: fontWeight,
        fontSize: largeFontSize,
        fontFamily: fontFamily,
        decoration: decoration,
      );

      break;
    case Type.styleDrawerText:
      return TextStyle(
        color: txtColor,
        fontWeight: fontWeight,
        fontSize: drawerFontSize,
        fontFamily: fontFamily,
        decoration: decoration,
      );
      break;
  }

  return TextStyle(
    color: txtColor,
    fontWeight: FontWeight.w200,
    fontFamily: fontFamily,
    letterSpacing: letterSpacing,
    decoration: decoration,
  );
}
