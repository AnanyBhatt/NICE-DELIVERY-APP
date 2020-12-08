import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nice_customer_app/api/responce/OrderHistoryResponce.dart';
import 'package:nice_customer_app/mixins/const.dart';
import 'package:nice_customer_app/ui/orderdetails/order_details.dart';
import 'package:nice_customer_app/ui/orders/order_status.dart';
import 'package:nice_customer_app/utils/color_.dart';
import 'package:nice_customer_app/utils/padding_.dart';
import 'package:nice_customer_app/utils/textstyle_.dart';
import 'package:nice_customer_app/model/order_history.dart';

import 'package:intl/intl.dart';

class OrderHistoryTile extends StatefulWidget {
  final int index;
  final OrderHistorylist orderlist;

  OrderHistoryTile({this.index, this.orderlist});

  @override
  _ItemListTileState createState() => _ItemListTileState();
}

class _ItemListTileState extends State<OrderHistoryTile> with Constants {
  String orderdatetime = "";
  String ordertime = "";
  String myordertime = "";

  bool isTodaydate = false;

  void initState() {
    super.initState();

    String date = widget.orderlist.createdAt.toString();
    checktodaydate2(date);
  }

  @override
  Widget build(BuildContext context) {
    buildSetupScreenUtils(context);

    return Material(
      type: MaterialType.transparency,
      child: GestureDetector(
        onTap: () {
          int orderId = widget.orderlist.id;
          print("orderId----$orderId");
          Navigator.push(
              context,
              PageRouteBuilder(
                  transitionDuration: Duration(milliseconds: pageDuration),
                  pageBuilder: (_, __, ___) => OrderDetailsPage(
                        index: widget.index,
                        OrderId: orderId,
                      )));
        },
        child: Card(
          elevation: 4,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(setSp(8)),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            //height: ScreenUtil().setWidth(110),
            padding: GlobalPadding.paddingAll_18,
            child: Row(
              children: <Widget>[
                ClipRRect(
                    borderRadius: BorderRadius.circular(setSp(10)),
                    child: Image.network(
                      widget.orderlist.vendorImageUrl,
                      fit: BoxFit.cover,
                      height: setHeight(70),
                      width: setWidth(70),
                    )),
                SizedBox(
                  width: setHeight(10),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              widget.orderlist.vendorName ?? "-",
                              style: getTextStyle(
                                context,
                                type: Type.styleHead,
                                fontFamily: sourceSansFontFamily,
                                fontWeight: fwBold,
                                txtColor: GlobalColor.black,
                              ),
                            ),
                            Text(
                              widget.orderlist.orderStatus,
                              style: getTextStyle(context,
                                  type: Type.styleBody2,
                                  fontFamily: sourceSansFontFamily,
                                  fontWeight: fwBold,
                                  txtColor: getOrderStatusColor(
                                      widget.orderlist.orderStatus)),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: setHeight(6),
                      ),
                      Text(
                        myordertime,
                        style: getTextStyle(
                          context,
                          type: Type.styleBody2,
                          fontFamily: sourceSansFontFamily,
                          fontWeight: fwRegular,
                          txtColor: GlobalColor.grey,
                        ),
                      ),
                      SizedBox(
                        height: setHeight(5),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Order ID: " + widget.orderlist.id.toString() ??
                                "-",
                            style: getTextStyle(
                              context,
                              type: Type.styleBody2,
                              fontFamily: sourceSansFontFamily,
                              fontWeight: fwRegular,
                              txtColor: GlobalColor.black,
                            ),
                          ),
                          isDisplayTrack(widget.orderlist.orderStatus)
                              ? GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                            transitionDuration: Duration(
                                                milliseconds: pageDuration),
                                            pageBuilder: (_, __, ___) =>
                                                OrderStatusPage(
                                                    isFromOrder: true)));
                                  },
                                  child: Container(
                                    padding: GlobalPadding.paddingAll_5,
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: Colors.black,
                                        )),
                                    child: Text(
                                      ' Track Order ',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: setHeight(10)),
                                    ),
                                  ),
                                )
                              : Offstage(),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void checktodaydate2(String datetime) {
    final DateTime now = DateTime.now();
    final String todaydate = convertDateformat(now.toString());
    print("Today's date---$todaydate");

    String orderdate = convertDateformat(datetime);
    print('Orderdate----$orderdate');

    if (orderdate == todaydate) {
      ordertime = converttimeformat(datetime);
      print("Today's Order Date Time---$ordertime");
      setState(() {
        isTodaydate == true;
      });
      myordertime = "$strToday $ordertime";
    } else {
      orderdatetime = convertDatetimeformat(datetime);
      myordertime = orderdatetime;
      print("Orderdatetime---$orderdatetime");
    }
  }

  bool isDisplayTrack(String status) {
    bool isDisplay = false;

    if (status == regularOrderRejected ||
        status == regularOrderDelivered ||
        status == regularOrderCancelled ||
        status == replacementOrderRejected ||
        status == replacementOrderReplaced ||
        status == replacementOrderCancelled ||
        status == returnOrderRejected ||
        status == returnOrderReturned ||
        status == returnOrderCancelled) {
      isDisplay = false;
    } else {
      isDisplay = true;
    }

    return isDisplay;
  }
}
