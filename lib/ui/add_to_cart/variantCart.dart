import 'package:flutter/material.dart';
import 'package:nice_customer_app/utils/color_.dart';
import 'package:nice_customer_app/utils/padding_.dart';
import 'package:nice_customer_app/utils/textstyle_.dart';
import 'package:nice_customer_app/mixins/const.dart';

class VariantsCart extends StatefulWidget {
  final String category;
  VariantsCart({Key key, this.category}) : super(key: key);

  @override
  _VariantsCartState createState() => _VariantsCartState();
}

class _VariantsCartState extends State<VariantsCart> with Constants {
  bool isExpanded = false;
  bool isChecked = false;
  int _radioValue = 0;
  @override
  Widget build(BuildContext context) {
    buildSetupScreenUtils(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Variants:",
          style: getTextStyle(
            context,
            type: Type.styleDrawerText,
            fontFamily: sourceSansFontFamily,
            fontWeight: fwBold,
            txtColor: GlobalColor.black,
          ),
        ),
        InkWell(
            splashColor: Colors.white,
            onTap: () {
              isExpanded = !isExpanded;
              setState(() {});
            },
            child: Align(
                alignment: Alignment.centerRight,
                child: Image.asset(
                  isExpanded ? upArrow : icDropDownArrow,
                  color: GlobalColor.black,
                ))),
        Text(
          isExpanded ? "Look for another Variant" : "Look for another Variant",
          style: getTextStyle(
            context,
            type: Type.styleBody1,
            fontFamily: sourceSansFontFamily,
            fontWeight: fwRegular,
            txtColor: GlobalColor.grey,
          ),
        ),
        Visibility(
          visible: isExpanded,
          child: ListView.builder(
              itemCount: 2,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, i) {
                return Padding(
                  padding: EdgeInsets.only(top: setHeight(21)),
                  child: _variantsListRow(i),
                );
              }),
        ),
        Container(
          margin: GlobalPadding.paddingSymmetricV_25,
          color: GlobalColor.black,
          height: setHeight(0.5),
        ),
        // SizedBox(height: setHeight(18)),
      ],
    );
  }

  Widget _variantsListRow(
    int _value,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.category == "grocery" ? "250 gm" : "8' Inches",
              style: getTextStyle(
                context,
                type: Type.styleBody1,
                fontFamily: sourceSansFontFamily,
                fontWeight: fwSemiBold,
                txtColor: GlobalColor.black,
              ),
            ),
            SizedBox(height: setHeight(5)),
            Text(
              widget.category == "grocery" ? "0.450" : "0.000",
              style: getTextStyle(
                context,
                type: Type.styleBody2,
                fontFamily: sourceSansFontFamily,
                fontWeight: fwSemiBold,
                txtColor: GlobalColor.grey,
              ),
            ),
          ],
        ),
        SizedBox(
          height: setHeight(30),
          width: setWidth(30),
          child: Radio(
            value: _value,
            groupValue: _radioValue,
            onChanged: _handleRadioValueChange,
          ),
        ),
      ],
    );
  }

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;
      print("object $value");

      // switch (_radioValue) {
      //   case 0:
      //     _result = ;

      //     break;
      //   case 1:
      //     _result = ...
      //     break;
      //   case 2:
      //     _result = ...
      //     break;
      // }
    });
  }
}
