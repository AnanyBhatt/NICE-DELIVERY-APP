import 'package:flutter/material.dart';
import 'package:nice_customer_app/mixins/const.dart';
import 'package:nice_customer_app/utils/color_.dart';

class CheckBoxCustom extends StatefulWidget {
  bool isChecked;
  CheckBoxCustom({Key key, @required this.isChecked}) : super(key: key);

  @override
  _CheckBoxCustomState createState() => _CheckBoxCustomState();
}

class _CheckBoxCustomState extends State<CheckBoxCustom> with Constants {
  @override
  Widget build(BuildContext context) {
    buildSetupScreenUtils(context);

    return GestureDetector(
      onTap: () {
        widget.isChecked = !(widget.isChecked);
        setState(() {});
      },
      child: InkWell(
        child: Container(
          height: setHeight(18),
          width: setWidth(18),
          decoration: BoxDecoration(
              border: Border.all(), borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Image.asset(
              icCheckDark,
              color: widget.isChecked ? GlobalColor.black : GlobalColor.white,
            ),
          ),
        ),
      ),
    );
  }
}
