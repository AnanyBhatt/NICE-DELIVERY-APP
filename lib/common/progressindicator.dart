import 'package:flutter/material.dart';
import 'package:nice_customer_app/utils/color_.dart';
import 'package:nice_customer_app/utils/padding_.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomProgressIndicator extends StatelessWidget {
  final double size;

  const CustomProgressIndicator({Key key, this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Container(
      // padding: GlobalPadding.paddingAll_10,
      child: Center(
        child: SpinKitCircle(
          color: Colors.orange,
          size: size != null ? size : 50,
        ),
      ),
    ));
  }
}
