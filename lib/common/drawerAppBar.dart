import 'package:flutter/material.dart';
import 'package:nice_customer_app/mixins/const.dart';
import 'package:nice_customer_app/utils/color_.dart';
import 'package:nice_customer_app/utils/textstyle_.dart';

class DrawerAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String trailingImg;
  final String title;

  final AppBar appBar;
  final List<Widget> action;

  const DrawerAppBar({
    Key key,
    this.trailingImg,
    @required this.title,
    @required this.appBar,
    this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      elevation: 0,
      backgroundColor: GlobalColor.white,
      iconTheme: IconThemeData(color: GlobalColor.black),
      title: Material(
        type: MaterialType.transparency,
        child: Text(
          title,
          style: getTextStyle(context,
              type: Type.styleBody1,
              fontFamily: sourceSansFontFamily,
              fontWeight: fwBold,
              txtColor: GlobalColor.black),
        ),
      ),
      actions: action,
    );

    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: GlobalColor.black),
      leading: IconButton(
          icon: Image.asset("assets/images/menu.png"),
          onPressed: () {
            Navigator.pop(context);
          }),
      title: Material(
        type: MaterialType.transparency,
        child: Text(
          title,
          style: getTextStyle(context,
              type: Type.styleBody1,
              fontFamily: sourceSansFontFamily,
              fontWeight: fwBold,
              txtColor: GlobalColor.black),
        ),
      ),
      elevation: 0,
      actions: action,
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);
}
