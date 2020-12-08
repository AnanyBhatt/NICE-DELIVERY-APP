import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nice_customer_app/mixins/const.dart';
import 'package:flutter/cupertino.dart';

class GlobalPadding with Constants {
  GlobalPadding._();

  static final paddingAll_5 = EdgeInsets.symmetric(
      horizontal: ScreenUtil().setWidth(5),
      vertical: ScreenUtil().setHeight(5));
  static final paddingAll_6 = EdgeInsets.symmetric(
      horizontal: ScreenUtil().setWidth(6),
      vertical: ScreenUtil().setHeight(6));
  static final paddingAll_8 = EdgeInsets.symmetric(
      horizontal: ScreenUtil().setWidth(8),
      vertical: ScreenUtil().setHeight(8));
  static final paddingAll_10 = EdgeInsets.symmetric(
      horizontal: ScreenUtil().setWidth(10),
      vertical: ScreenUtil().setHeight(10));
  static final paddingAll_12 = EdgeInsets.symmetric(
      horizontal: ScreenUtil().setWidth(12),
      vertical: ScreenUtil().setHeight(12));
  static final paddingAll_14 = EdgeInsets.symmetric(
      horizontal: ScreenUtil().setWidth(14),
      vertical: ScreenUtil().setHeight(14));
  static final paddingAll_15 = EdgeInsets.symmetric(
      horizontal: ScreenUtil().setWidth(15),
      vertical: ScreenUtil().setHeight(15));
  static final paddingAll_18 = EdgeInsets.symmetric(
      horizontal: ScreenUtil().setWidth(18),
      vertical: ScreenUtil().setHeight(18));
  static final paddingAll_20 = EdgeInsets.symmetric(
      horizontal: ScreenUtil().setWidth(20),
      vertical: ScreenUtil().setHeight(20));

  static final paddingSymmetricH_20 =
      EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20));
  static final paddingSymmetricH_25 =
      EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(25));
  static final paddingSymmetricH_15 = EdgeInsets.symmetric(
      vertical: ScreenUtil().setHeight(11),
      horizontal: ScreenUtil().setHeight(15));
  static final paddingSymmetricH_13 = EdgeInsets.symmetric(
      vertical: ScreenUtil().setHeight(6),
      horizontal: ScreenUtil().setHeight(15));
  static final paddingSymmetricH_16 =
      EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(16));

  static final paddingSymmetricV_25 =
      EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(25));
  static final paddingSymmetricV_20 =
      EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(20));
  static final paddingSymmetricV_16 =
      EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(16));
  static final paddingSymmetricV_15 =
      EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(15));
  static final paddingSymmetricV_13 =
      EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(13));
  static final paddingSymmetricV_10 =
      EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(10));
  static final paddingSymmetricV_8 =
      EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(8));
}
