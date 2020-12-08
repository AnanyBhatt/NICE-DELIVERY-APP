import 'package:flutter/material.dart';
import 'package:nice_customer_app/Localization/app_translations.dart';
import 'package:nice_customer_app/mixins/const.dart';
import 'package:nice_customer_app/ui/drawer/drawer.dart';
import 'package:nice_customer_app/utils/color_.dart';
import 'package:nice_customer_app/utils/padding_.dart';
import 'package:nice_customer_app/utils/textstyle_.dart';

import 'package:nice_customer_app/ui/nice_wallet/ProviderNiceWallet.dart';
import 'package:nice_customer_app/api/responce/WalletListResponse.dart';
import 'package:nice_customer_app/webservices/RestClient.dart';
import 'package:nice_customer_app/webservices/apiendpointd.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NICEWalletTile extends StatefulWidget {
  final WalletList walletData;
  NICEWalletTile({Key key, this.walletData}) : super(key: key);

  @override
  _NICEWalletTileState createState() => _NICEWalletTileState();
}

class _NICEWalletTileState extends State<NICEWalletTile> with Constants {
  @override
  Widget build(BuildContext context) {
    buildSetupScreenUtils(context);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: colData(
                    "${AppTranslations.of(context).text("Key_OrderId")}",
                    widget.walletData.orderId.toString())),
            Expanded(
                child: colData(
                    "${AppTranslations.of(context).text("Key_date")}",
                    convertDateformat(widget.walletData.createdAt.toString()))),
            Expanded(
              child: Column(
                children: [
                  Text(""),
                  SizedBox(
                    height: setHeight(6),
                  ),
                  Text(
                    "+  ${AppTranslations.of(context).text("Key_kd")} ${widget.walletData.amount}",
                    textAlign: TextAlign.right,
                    style: getTextStyle(context,
                        type: Type.styleDrawerText,
                        fontFamily: sourceSansFontFamily,
                        fontWeight: fwBold,
                        txtColor: GlobalColor.black),
                  ),
                ],
              ),
            ),
          ],
        ),
        Divider(
          color: GlobalColor.grey,
          thickness: setHeight(0.5),
        ),
      ],
    );
  }

  Widget colData(String title, String body) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: getTextStyle(context,
              type: Type.styleBody2,
              fontFamily: sourceSansFontFamily,
              fontWeight: fwRegular,
              txtColor: GlobalColor.grey),
        ),
        SizedBox(
          height: setHeight(6),
        ),
        Text(
          body,
          style: getTextStyle(context,
              type: Type.styleBody1,
              fontFamily: sourceSansFontFamily,
              fontWeight: fwSemiBold,
              txtColor: GlobalColor.black),
        ),
      ],
    );
  }
}
