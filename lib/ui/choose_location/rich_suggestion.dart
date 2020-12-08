import 'package:flutter/material.dart';
import 'package:nice_customer_app/mixins/const.dart';
import 'package:nice_customer_app/ui/choose_location/auto_complete_item.dart';
import 'package:nice_customer_app/utils/textstyle_.dart';

class RichSuggestion extends StatelessWidget with Constants {
  final VoidCallback onTap;
  final AutoCompleteItem autoCompleteItem;

  RichSuggestion(this.autoCompleteItem, this.onTap);

  @override
  Widget build(BuildContext context) {
    buildSetupScreenUtils(context);

    return Material(
      child: InkWell(
        child: Container(
            margin: EdgeInsets.only(bottom: setHeight(15)),
            padding: EdgeInsets.symmetric(horizontal: setWidth(24)),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: RichText(
                    text: TextSpan(children: getStyledTexts(context)),
                  ),
                )
              ],
            )),
        onTap: onTap,
      ),
    );
  }

  List<TextSpan> getStyledTexts(BuildContext context) {
    final List<TextSpan> result = [];

    String startText =
        autoCompleteItem.text.substring(0, autoCompleteItem.offset);
    if (startText.isNotEmpty) {
      result.add(
        TextSpan(
            text: startText,
            style: getTextStyle(context,
                type: Type.styleBody1,
                fontFamily: sourceSansFontFamily,
                fontWeight: fwRegular,
                txtColor: Colors.black)),
      );
    }

    String boldText = autoCompleteItem.text.substring(autoCompleteItem.offset,
        autoCompleteItem.offset + autoCompleteItem.length);

    result.add(
      TextSpan(
          text: boldText,
          style: getTextStyle(context,
              type: Type.styleBody1,
              fontFamily: sourceSansFontFamily,
              fontWeight: fwSemiBold,
              txtColor: Colors.black)),
    );

    String remainingText = this
        .autoCompleteItem
        .text
        .substring(autoCompleteItem.offset + autoCompleteItem.length);
    result.add(
      TextSpan(
        text: remainingText,
        style: TextStyle(color: Colors.grey, fontSize: 15),
      ),
    );

    return result;
  }
}
