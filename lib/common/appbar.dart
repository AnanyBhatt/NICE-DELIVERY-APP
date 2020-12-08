import 'package:flutter/material.dart';
import 'package:nice_customer_app/utils/color_.dart';
import 'package:nice_customer_app/utils/textstyle_.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String trailingImg;
  final String title;
  final String tag;

  final AppBar appBar;
  final List<Widget> action;

  const CommonAppBar(
      {Key key,
      this.trailingImg,
      @required this.title,
      @required this.appBar,
      this.action,
      this.tag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        elevation: 0,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: GlobalColor.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        actions: action,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: tag == null
            ? Text(
                title,
                style: getTextStyle(context,
                    type: Type.styleBody1,
                    fontFamily: sourceSansFontFamily,
                    fontWeight: fwBold,
                    txtColor: GlobalColor.black),
              )
            : Hero(
                tag: "buttonTag",
                child: Material(
                  type: MaterialType.transparency,
                  child: Text(
                    title,
                    style: getTextStyle(context,
                        type: Type.styleBody1,
                        fontFamily: sourceSansFontFamily,
                        fontWeight: fwBold,
                        txtColor: GlobalColor.black),
                  ),
                )));
  }

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);
}
