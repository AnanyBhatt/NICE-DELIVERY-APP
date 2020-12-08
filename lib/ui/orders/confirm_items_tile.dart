import 'package:flutter/material.dart';
import 'package:nice_customer_app/common/circle_button.dart';
import 'package:nice_customer_app/framework/repository/cart/model/ResCartList.dart';
import 'package:nice_customer_app/framework/repository/order/model/ResOrderDetails.dart';
import 'package:nice_customer_app/mixins/const.dart';
import 'package:nice_customer_app/utils/color_.dart';
import 'package:nice_customer_app/utils/padding_.dart';
import 'package:nice_customer_app/utils/textstyle_.dart';

class CheckoutItemListTile extends StatefulWidget {
  final OrderItemResponseDtoList item;
  CheckoutItemListTile(this.item, {Key key}) : super(key: key);

  @override
  _CheckoutItemListTileState createState() => _CheckoutItemListTileState();
}

class _CheckoutItemListTileState extends State<CheckoutItemListTile>
    with Constants {



  @override
  Widget build(BuildContext context) {


    buildSetupScreenUtils(context);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            widget.item.orderQty.toString(),
            style: getTextStyle(context,
                type: Type.styleBody1,
                txtColor: GlobalColor.black,
                fontFamily: sourceSansFontFamily,
                fontWeight: fwRegular),
          ),
          /*SizedBox(
            width: setWidth(24),
          ),*/
          Text(
            multiplySymbol,
            style: getTextStyle(context,
                type: Type.styleBody1,
                txtColor: GlobalColor.black,
                fontFamily: sourceSansFontFamily,
                fontWeight: fwRegular),
          ),
         /* SizedBox(
            width: setWidth(24),
          ),*/
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                widget.item.productName,
                style: getTextStyle(context,
                    type: Type.styleBody1,
                    txtColor: GlobalColor.black,
                    fontFamily: sourceSansFontFamily,
                    fontWeight: fwSemiBold),
              ),
              SizedBox(
                height: setHeight(5),
              ),
              SizedBox(
                width: setWidth(115),
                child: Text(
                  widget.item.displayExtra,
                  style: getTextStyle(context,
                      type: Type.styleCaption,
                      txtColor: GlobalColor.grey,
                      fontFamily: sourceSansFontFamily,
                      fontWeight: fwRegular),
                ),
              ),
            ],
          ),
         /* SizedBox(
            width: setWidth(28),
          ),*/
         /* Text(
            widget.item.displayAmt.toString(),
            style: getTextStyle(context,
                type: Type.styleBody1,
                txtColor: GlobalColor.grey,
                fontFamily: sourceSansFontFamily,
                fontWeight: fwSemiBold,
                decoration: TextDecoration.lineThrough),
          ),*/
       /*   SizedBox(
            width: setWidth(17),
          ),*/
          Text(
            widget.item.totalAmt.toString(),
            style: getTextStyle(context,
                type: Type.styleBody1,
                txtColor: GlobalColor.black,
                fontFamily: sourceSansFontFamily,
                fontWeight: fwSemiBold),
          ),
        ],
      ),
    );
  }
}
