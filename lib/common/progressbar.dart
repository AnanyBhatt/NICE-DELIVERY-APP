
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nice_customer_app/mixins/const.dart';

class ProgressBar extends StatelessWidget with Constants{

  int clr;
  ProgressBar(this.clr);

  @override
  Widget build(BuildContext context) {

    return AbsorbPointer(
      absorbing: true,
      child: Container(
        height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
        child : Padding(
          padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
          child: Center(
            child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Color(clr)),
            ),
          ),
        )
      ),
    );

  }
}