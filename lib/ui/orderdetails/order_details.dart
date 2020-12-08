import 'package:date_format/date_format.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:nice_customer_app/Localization/app_translations.dart';
import 'package:nice_customer_app/api/responce/OrderDetailsResponce.dart';
import 'package:nice_customer_app/common/alertDialog.dart';
import 'package:nice_customer_app/common/appbar.dart';
import 'package:nice_customer_app/common/flaticonbutton.dart';
import 'package:nice_customer_app/common/no_data_found.dart';
import 'package:nice_customer_app/common/progressbar.dart';
import 'package:nice_customer_app/framework/repository/order/model/ResOrderDetails.dart';
import 'package:nice_customer_app/mixins/const.dart';
import 'package:nice_customer_app/ui/orderdetails/ProviderorderDetails.dart';
import 'package:nice_customer_app/ui/orderdetails/track_order.dart';
import 'package:nice_customer_app/ui/orders/cancel_order.dart';
import 'package:nice_customer_app/ui/orders/order_status.dart';
import 'package:nice_customer_app/ui/orders/replace_order.dart';
import 'package:nice_customer_app/ui/orders/return_order.dart';
import 'package:nice_customer_app/ui/ratings/rating_input.dart';
import 'package:nice_customer_app/utils/color_.dart';
import 'package:nice_customer_app/utils/padding_.dart';
import 'package:nice_customer_app/utils/textstyle_.dart';
import 'package:nice_customer_app/model/order_history.dart';
import 'package:nice_customer_app/webservices/RestClient.dart';
import 'package:nice_customer_app/webservices/apiendpointd.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderDetailsPage extends StatefulWidget {
  final int OrderId;
  final int index;
  OrderDetailsPage({this.OrderId, this.index});

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> with Constants {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  OrderDetailList orderDetailList;

  void initState() {
    super.initState();

    var providerorderdetails =
        Provider.of<ProviderOrderdetails>(context, listen: false);

    Future.delayed(Duration(milliseconds: 1), () {
      try {
        checkInternet().then((value) async {
          if (value == true) {
            await apiorderdetails(providerorderdetails);
          } else {
            showSnackBar(
                "${AppTranslations.of(context).text("Key_errinternet")}");
          }
        });
      } catch (e) {
        print(e.toString());
      }
    });
  }

  void refresh(ProviderOrderdetails providerorderdetails) {
    Future.delayed(Duration(milliseconds: 1), () {
      try {
        checkInternet().then((value) async {
          if (value == true) {
            await apiorderdetails(providerorderdetails);
          } else {
            showSnackBar(
                "${AppTranslations.of(context).text("Key_errinternet")}");
          }
        });
      } catch (e) {
        print(e.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: GlobalColor.white,
          appBar: CommonAppBar(
              title: "${AppTranslations.of(context).text("Key_OrderDetail")}",
              appBar: AppBar()),
          body: Consumer<ProviderOrderdetails>(
            builder: (context, providerorderdetails, child) {
              return providerorderdetails.getShowProgressBar() == true
                  ? Center(child: ProgressBar(clrBlack))
                  : Column(
                      children: [
                        Expanded(
                          child: Container(
                            padding: GlobalPadding.paddingSymmetricH_20,
                            child: ListView(
                              children: <Widget>[
                                SizedBox(
                                  height: setHeight(20),
                                ),
                                _orderHistoryTile(providerorderdetails),
                                SizedBox(
                                  height: setHeight(10),
                                ),
                                Visibility(
                                    visible: providerorderdetails
                                            .orderList.address !=
                                        null,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Divider(),
                                        SizedBox(
                                          height: setHeight(10),
                                        ),
                                        Text(
                                            "${AppTranslations.of(context).text("Key_DeliveryAddress")}",
                                            style: getTextStyle(
                                              context,
                                              type: Type.styleHead,
                                              fontFamily: sourceSansFontFamily,
                                              fontWeight: fwBold,
                                              txtColor: GlobalColor.black,
                                            )),
                                        SizedBox(
                                          height: setHeight(10),
                                        ),
                                        Text(providerorderdetails
                                                .orderList.address ??
                                            "-"),
                                      ],
                                    )),
                                SizedBox(
                                  height: setHeight(10),
                                ),
                                Divider(),
                                SizedBox(
                                  height: setHeight(10),
                                ),
                                Text(
                                    "${AppTranslations.of(context).text("Key_OrderSummary")}",
                                    style: getTextStyle(
                                      context,
                                      type: Type.styleHead,
                                      fontFamily: sourceSansFontFamily,
                                      fontWeight: fwBold,
                                      txtColor: GlobalColor.black,
                                    )),
                                SizedBox(
                                  height: setHeight(15),
                                ),
                                Container(
                                    child: providerorderdetails
                                                    .orderItemResponseDtoList !=
                                                null &&
                                            providerorderdetails
                                                    .orderItemResponseDtoList
                                                    .length >
                                                0 &&
                                            providerorderdetails
                                                    .orderItemResponseDtoList
                                                    .length !=
                                                null
                                        ? Column(
                                            children: _buildItemsData(
                                                providerorderdetails
                                                    .orderItemResponseDtoList
                                                    .length,
                                                providerorderdetails
                                                    .orderItemResponseDtoList),
                                          )
                                        : Offstage()),
                                SizedBox(
                                  height: setHeight(10),
                                ),
                                Divider(),
                                SizedBox(
                                  height: setHeight(10),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                        "${AppTranslations.of(context).text("Key_TotalGrossAmount")}",
                                        style: getTextStyle(
                                          context,
                                          type: Type.styleBody1,
                                          fontFamily: sourceSansFontFamily,
                                          fontWeight: fwRegular,
                                          txtColor: GlobalColor.black,
                                        )),
                                    Text(
                                        "${AppTranslations.of(context).text("Key_kd")} " +
                                            providerorderdetails
                                                .orderList.grossOrderAmount
                                                .toString(),
                                        style: getTextStyle(
                                          context,
                                          type: Type.styleBody1,
                                          fontFamily: sourceSansFontFamily,
                                          fontWeight: fwRegular,
                                          txtColor: GlobalColor.black,
                                        ))
                                  ],
                                ),
                                SizedBox(
                                  height: setHeight(10),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "${AppTranslations.of(context).text("Key_DeliveryCharge")}",
                                      style: getTextStyle(
                                        context,
                                        type: Type.styleBody1,
                                        fontFamily: sourceSansFontFamily,
                                        fontWeight: fwRegular,
                                        txtColor: GlobalColor.black,
                                      ),
                                    ),
                                    Text(
                                      "${AppTranslations.of(context).text("Key_kd")} " +
                                              providerorderdetails
                                                  .orderList.deliveryCharge
                                                  .toString() ??
                                          "",
                                      style: getTextStyle(
                                        context,
                                        type: Type.styleBody1,
                                        fontFamily: sourceSansFontFamily,
                                        fontWeight: fwRegular,
                                        txtColor: GlobalColor.black,
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: setHeight(10),
                                ),
                                Visibility(
                                  visible: providerorderdetails
                                              .orderList.walletContribution ==
                                          0.0
                                      ? false
                                      : true,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                          "${AppTranslations.of(context).text("Key_WalletContribution")}",
                                          style: getTextStyle(
                                            context,
                                            type: Type.styleBody1,
                                            fontFamily: sourceSansFontFamily,
                                            fontWeight: fwRegular,
                                            txtColor: GlobalColor.black,
                                          )),
                                      Text(
                                          "${AppTranslations.of(context).text("Key_kd")} " +
                                                  "" +
                                                  providerorderdetails.orderList
                                                      .walletContribution
                                                      .toString() ??
                                              "-",
                                          style: getTextStyle(
                                            context,
                                            type: Type.styleBody1,
                                            fontFamily: sourceSansFontFamily,
                                            fontWeight: fwRegular,
                                            txtColor: GlobalColor.black,
                                          ))
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: setHeight(10),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                        "${AppTranslations.of(context).text("Key_TotalAmount")}",
                                        style: getTextStyle(
                                          context,
                                          type: Type.styleBody1,
                                          fontFamily: sourceSansFontFamily,
                                          fontWeight: fwRegular,
                                          txtColor: GlobalColor.black,
                                        )),
                                    Text(
                                        "${AppTranslations.of(context).text("Key_kd")} " +
                                                providerorderdetails
                                                    .orderList.totalOrderAmount
                                                    .toString() ??
                                            "-",
                                        style: getTextStyle(
                                          context,
                                          type: Type.styleBody1,
                                          fontFamily: sourceSansFontFamily,
                                          fontWeight: fwRegular,
                                          txtColor: GlobalColor.black,
                                        ))
                                  ],
                                ),
                                SizedBox(
                                  height: setHeight(10),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                        "${AppTranslations.of(context).text("Key_PaymentMethod")}",
                                        style: getTextStyle(
                                          context,
                                          type: Type.styleBody1,
                                          fontFamily: sourceSansFontFamily,
                                          fontWeight: fwRegular,
                                          txtColor: GlobalColor.black,
                                        )),
                                    Text(
                                        providerorderdetails
                                                .orderList.paymentMode
                                                .toString() ??
                                            "",
                                        style: getTextStyle(
                                          context,
                                          type: Type.styleBody1,
                                          fontFamily: sourceSansFontFamily,
                                          fontWeight: fwRegular,
                                          txtColor: GlobalColor.black,
                                        ))
                                  ],
                                ),
                                SizedBox(
                                  height: setHeight(10),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                        "${AppTranslations.of(context).text("Key_delType")}",
                                        style: getTextStyle(
                                          context,
                                          type: Type.styleBody1,
                                          fontFamily: sourceSansFontFamily,
                                          fontWeight: fwRegular,
                                          txtColor: GlobalColor.black,
                                        )),
                                    Text(
                                        providerorderdetails
                                                .orderList.deliveryType
                                                .toString() ??
                                            "",
                                        style: getTextStyle(
                                          context,
                                          type: Type.styleBody1,
                                          fontFamily: sourceSansFontFamily,
                                          fontWeight: fwRegular,
                                          txtColor: GlobalColor.black,
                                        ))
                                  ],
                                ),
                                displayDisc(providerorderdetails),
                                Visibility(
                                  visible: providerorderdetails
                                              .orderList?.orderStatus ==
                                          delivered &&
                                      providerorderdetails
                                              .orderList?.deliveryDate !=
                                          null,
                                  child: SizedBox(
                                    height: setHeight(10),
                                  ),
                                ),
                                Visibility(
                                  visible: providerorderdetails
                                              .orderList.orderStatus ==
                                          delivered &&
                                      providerorderdetails
                                              .orderList.deliveryDate !=
                                          null,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                          "${AppTranslations.of(context).text("Key_delTime")}",
                                          style: getTextStyle(
                                            context,
                                            type: Type.styleBody1,
                                            fontFamily: sourceSansFontFamily,
                                            fontWeight: fwRegular,
                                            txtColor: GlobalColor.black,
                                          )),
                                      Text(
                                          providerorderdetails
                                                      .orderList.deliveryDate !=
                                                  null
                                              ? getOrderDateTime(
                                                  providerorderdetails
                                                      .orderList.deliveryDate
                                                      .toString())
                                              : "",
                                          style: getTextStyle(
                                            context,
                                            type: Type.styleBody1,
                                            fontFamily: sourceSansFontFamily,
                                            fontWeight: fwRegular,
                                            txtColor: GlobalColor.black,
                                          ))
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: providerorderdetails
                                              .orderList.orderStatus ==
                                          delivered &&
                                      providerorderdetails
                                              .orderRating?.avgOrderRating !=
                                          null,
                                  child: SizedBox(
                                    height: setHeight(10),
                                  ),
                                ),
                                Visibility(
                                  visible: providerorderdetails
                                              .orderList.orderStatus ==
                                          delivered &&
                                      providerorderdetails
                                              .orderRating?.avgOrderRating !=
                                          null,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                          "${AppTranslations.of(context).text("Key_yourRatings")}",
                                          style: getTextStyle(
                                            context,
                                            type: Type.styleBody1,
                                            fontFamily: sourceSansFontFamily,
                                            fontWeight: fwRegular,
                                            txtColor: GlobalColor.black,
                                          )),
                                      Text(
                                          providerorderdetails
                                                  .orderRating?.avgOrderRating
                                                  .toString() ??
                                              "-",
                                          style: getTextStyle(
                                            context,
                                            type: Type.styleBody1,
                                            fontFamily: sourceSansFontFamily,
                                            fontWeight: fwRegular,
                                            txtColor: GlobalColor.black,
                                          ))
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: setHeight(30),
                                ),
                                providerorderdetails.orderList.orderStatus ==
                                            pending ||
                                        providerorderdetails
                                                .orderList.orderStatus ==
                                            returnRequested ||
                                        providerorderdetails
                                                .orderList.orderStatus ==
                                            replaceRequested
                                    ? SizedBox(
                                        width: infiniteSize,
                                        child: FlatCustomButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return CommonAlertDialog(
                                                    title:
                                                        "${AppTranslations.of(context).text("Key_CancelOrder")}",
                                                    message:
                                                        "${AppTranslations.of(context).text("Key_areYouSureCancel")}",
                                                    onYesPressed: () {
                                                      Navigator.pop(context);

                                                      Navigator.push(
                                                          context,
                                                          PageRouteBuilder(
                                                              transitionDuration:
                                                                  Duration(
                                                                      milliseconds:
                                                                          pageDuration),
                                                              pageBuilder: (_,
                                                                      __,
                                                                      ___) =>
                                                                  CancelOrderPage(
                                                                    orderId: widget
                                                                        .OrderId,
                                                                    orderStatus:
                                                                        providerorderdetails
                                                                            .orderList
                                                                            .orderStatus,
                                                                  )));
                                                    },
                                                    onNoPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  );
                                                },
                                              );
                                            },
                                            title:
                                                "${AppTranslations.of(context).text("Key_CancelOrder")}"),
                                      )
                                    : providerorderdetails
                                                .orderList.orderStatus ==
                                            delivered
                                        ? Row(
                                            children: [
                                              Expanded(
                                                child:
                                                    providerorderdetails
                                                            .orderList.canReturn
                                                        ? FlatCustomButton(
                                                            onPressed: () {
                                                              Navigator.push(
                                                                  context,
                                                                  PageRouteBuilder(
                                                                      transitionDuration: Duration(
                                                                          milliseconds:
                                                                              pageDuration),
                                                                      pageBuilder: (_,
                                                                              __,
                                                                              ___) =>
                                                                          ReturnOrderPage(
                                                                              orderId: widget.OrderId)));
                                                            },
                                                            outline: true,
                                                            title:
                                                                "${AppTranslations.of(context).text("Key_ReturnOrder")}",
                                                          )
                                                        : Offstage(),
                                              ),
                                              SizedBox(
                                                width: setWidth(25),
                                              ),
                                              Expanded(
                                                child:
                                                    providerorderdetails
                                                            .orderList
                                                            .canReplace
                                                        ? FlatCustomButton(
                                                            onPressed: () {
                                                              Navigator.push(
                                                                  context,
                                                                  PageRouteBuilder(
                                                                      transitionDuration: Duration(
                                                                          milliseconds:
                                                                              pageDuration),
                                                                      pageBuilder: (_,
                                                                              __,
                                                                              ___) =>
                                                                          ReplaceOrderPage(
                                                                              orderId: widget.OrderId)));
                                                            },
                                                            title:
                                                                "${AppTranslations.of(context).text("Key_ReplaceOrder")}",
                                                          )
                                                        : Offstage(),
                                              )
                                            ],
                                          )
                                        : Offstage(),
                                SizedBox(
                                  height: setHeight(25),
                                ),
                                Visibility(
                                  visible: providerorderdetails
                                              .orderList.orderStatus ==
                                          delivered &&
                                      providerorderdetails
                                              .orderRating?.avgOrderRating ==
                                          null,
                                  child: FlatCustomButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                              transitionDuration: Duration(
                                                  milliseconds: pageDuration),
                                              pageBuilder: (_, __, ___) =>
                                                  RatingInputPage(
                                                    orderId: widget.OrderId,
                                                    deliveryType:
                                                        providerorderdetails
                                                            .orderList
                                                            .orderType,
                                                  ))).then((value) {
                                        if (value != null && value) {
                                          refresh(providerorderdetails);
                                        }
                                      });
                                    },
                                    title:
                                        "${AppTranslations.of(context).text("Key_rateNow")}",
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
            },
          )),
    );
  }

  Widget _orderHistoryTile(ProviderOrderdetails providerorderdetails) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: ScreenUtil().setHeight(100),
        child: Row(
          children: <Widget>[
            ClipRRect(
                borderRadius: BorderRadius.circular(setSp(10)),
                child: Image.network(
                  providerorderdetails.orderList.vendorImageUrl ?? "",
                  fit: BoxFit.cover,
                  height: setWidth(80),
                  width: setWidth(80),
                )),
            SizedBox(
              width: setHeight(10),
            ),
            Expanded(
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
                          providerorderdetails.orderList.vendorName ?? "",
                          style: getTextStyle(
                            context,
                            type: Type.styleHead,
                            fontFamily: sourceSansFontFamily,
                            fontWeight: fwBold,
                            txtColor: GlobalColor.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: setHeight(4),
                  ),
                  Text(
                    getOrderDateTime(providerorderdetails.orderList.createdAt
                            .toString()) ??
                        "",
                    style: getTextStyle(
                      context,
                      type: Type.styleBody2,
                      fontFamily: sourceSansFontFamily,
                      fontWeight: fwRegular,
                      txtColor: GlobalColor.grey,
                    ),
                  ),
                  SizedBox(
                    height: setHeight(4),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "${AppTranslations.of(context).text("Key_OrderId")}: " +
                                providerorderdetails.orderList.id.toString() ??
                            "-",
                        style: getTextStyle(
                          context,
                          type: Type.styleBody2,
                          fontFamily: sourceSansFontFamily,
                          fontWeight: fwRegular,
                          txtColor: GlobalColor.black,
                        ),
                      ),
                      isDisplayTrack(providerorderdetails.orderList.orderStatus)
                          ? InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                        transitionDuration: Duration(
                                            milliseconds: pageDuration),
                                        pageBuilder: (_, __, ___) =>
                                            OrderStatusPage(
                                              isFromOrder: true,
                                              orderId: providerorderdetails
                                                  .orderList.id,
                                              orderType: providerorderdetails
                                                  .orderList.orderType,
                                            )));
                              },
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    padding: GlobalPadding.paddingAll_5,
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: Colors.black,
                                        )),
                                    child: Text(
                                      " ${AppTranslations.of(context).text("Key_trackOrder")} ",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: setHeight(10)),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Offstage()
                    ],
                  ),
                  SizedBox(
                    height: setHeight(3),
                  ),
                  Text(
                    displayStatus(
                        context, providerorderdetails.orderList.orderStatus),
                    style: getTextStyle(context,
                        type: Type.styleBody2,
                        fontFamily: sourceSansFontFamily,
                        fontWeight: fwBold,
                        txtColor: getOrderStatusColor(
                            providerorderdetails.orderList.orderStatus)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  apiorderdetails(ProviderOrderdetails providerOrderdetails) async {
    providerOrderdetails.setShowProgressBar(true);

    SharedPreferences pref = await SharedPreferences.getInstance();
    String accessToken = pref.getString(prefStr_ACCESS_TOKEN);
    String apiOrderDetail =
        ApiEndPoints.apiGetOrderDetail + "/" + widget.OrderId.toString();
    print("-----Access Token--------$accessToken");
    print("apiOrderDetail Url-----$apiOrderDetail");

    Response response =
        await RestClient.getData(context, apiOrderDetail, accessToken);

    try {
      if (response.statusCode == 200) {
        providerOrderdetails.setShowProgressBar(false);

        OrderDetailsResponce orderDetailsResponce =
            orderDetailsResponceFromJson(response.toString());

        showLog(
            "apiOrderDetailsList :-: ${orderDetailsResponceToJson(orderDetailsResponce)}");

        if (orderDetailsResponce.status == ApiEndPoints.apiStatus_200) {
          providerOrderdetails.showorderdetails(orderDetailsResponce.data);
          providerOrderdetails.showorderSummary(
              orderDetailsResponce.data.orderItemResponseDtoList);
          providerOrderdetails
              .setOrderRating(orderDetailsResponce.data.orderRating);
        } else {
          showSnackBar(orderDetailsResponce.message);
        }
      } else {
        providerOrderdetails.setShowProgressBar(false);
        showSnackBar(
            "${AppTranslations.of(context).text("Key_errSomethingWrong")}");
      }
    } catch (exception) {
      print("-----exception Occured-----${exception.toString()}");
    }
  }

  String getOrderDateTime(String datetime) {
    if (datetime != null) {
      final DateTime now = DateTime.now();
      final String todaydate = convertDateformat(now.toString());

      String orderdate = convertDateformat(datetime);
      var ordertime = "";

      if (orderdate == todaydate) {
        ordertime = converttimeformat(datetime);

        var myordertime =
            "${AppTranslations.of(context).text("Key_today")} $ordertime";
        return myordertime;
      } else {
        var orderdatetime = convertDatetimeformat(datetime);
        return orderdatetime;
      }
    }
  }

  void showSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
        value,
        style: TextStyle(
          color: Color(clrWhite),
          fontSize: ScreenUtil().setSp(14),
        ),
      ),
      backgroundColor: Color(clrBlack),
      duration: Duration(seconds: 1),
    ));
  }

  List<Widget> _buildItemsData(
      int count, List<OrderItemResponseDtoList> orderItemResponseDtoList) {
    List<Widget> places = [];
    for (int i = 0; i < count; i++) {
      places.add(
        Container(
          margin: EdgeInsets.only(top: setHeight(15)),
          child: _itemDetailData(orderItemResponseDtoList[i]),
        ),
      );
    }
    return places;
  }

  Widget _itemDetailData(OrderItemResponseDtoList orderItem) {
    String totDisplayAmount = "";
    double totalAmt = orderItem.totalAmt;
    double que = orderItem.orderQty.toDouble();
    totDisplayAmount = (totalAmt / que).toString();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Flexible(
          child: Text(
            orderItem?.orderQty.toString() ?? "",
            overflow: TextOverflow.ellipsis,
            style: getTextStyle(context,
                type: Type.styleBody1,
                fontFamily: sourceSansFontFamily,
                fontWeight: fwRegular,
                txtColor: GlobalColor.black),
          ),
        ),
        SizedBox(
          width: setWidth(25),
        ),
        Container(
          child: Text(
            multiplySymbol,
            style: getTextStyle(context,
                type: Type.styleBody2,
                fontFamily: sourceSansFontFamily,
                fontWeight: fwRegular,
                txtColor: GlobalColor.black),
          ),
        ),
        SizedBox(
          width: setWidth(25),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              orderItem.productName ?? "",
              style: getTextStyle(context,
                  type: Type.styleBody1,
                  fontFamily: sourceSansFontFamily,
                  fontWeight: fwRegular,
                  txtColor: GlobalColor.black),
            ),
            SizedBox(
              height: setHeight(5),
            ),
            Container(
              width: setWidth(181),
              child: Text(
                orderItem.displayExtra ?? "",
                style: getTextStyle(context,
                    type: Type.styleCaption,
                    fontFamily: sourceSansFontFamily,
                    fontWeight: fwRegular,
                    txtColor: GlobalColor.grey),
              ),
            ),
          ],
        ),
        Text(
          "${AppTranslations.of(context).text("Key_kd")} " + totDisplayAmount ??
              "",
          style: getTextStyle(context,
              type: Type.styleBody1,
              fontFamily: sourceSansFontFamily,
              fontWeight: fwRegular,
              txtColor: GlobalColor.black),
        ),
      ],
    );
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

  Widget displayDisc(ProviderOrderdetails providerorderdetails) {
    return Column(
      children: <Widget>[
        Visibility(
            visible: providerorderdetails.orderList.cancelReason != null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(),
                SizedBox(
                  height: setHeight(10),
                ),
                Text(
                    "${AppTranslations.of(context).text("Key_CancelledReason")} ",
                    style: getTextStyle(
                      context,
                      type: Type.styleHead,
                      fontFamily: sourceSansFontFamily,
                      fontWeight: fwSemiBold,
                      txtColor: GlobalColor.black,
                    )),
                SizedBox(
                  height: setHeight(10),
                ),
                Text(providerorderdetails.orderList.cancelReason ?? "-"),
                SizedBox(
                  height: setHeight(10),
                ),
                Text(
                    "${AppTranslations.of(context).text("Key_CancelledDescription")}",
                    style: getTextStyle(
                      context,
                      type: Type.styleHead,
                      fontFamily: sourceSansFontFamily,
                      fontWeight: fwSemiBold,
                      txtColor: GlobalColor.black,
                    )),
                SizedBox(
                  height: setHeight(10),
                ),
                Text(providerorderdetails
                        .orderList.cancelReturnReplaceDescription ??
                    "-"),
              ],
            )),
        Visibility(
            visible: providerorderdetails.orderList.replaceReason != null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(),
                SizedBox(
                  height: setHeight(10),
                ),
                Text(
                    "${AppTranslations.of(context).text("Key_ReplacementReason")}",
                    style: getTextStyle(
                      context,
                      type: Type.styleHead,
                      fontFamily: sourceSansFontFamily,
                      fontWeight: fwSemiBold,
                      txtColor: GlobalColor.black,
                    )),
                SizedBox(
                  height: setHeight(10),
                ),
                Text(providerorderdetails.orderList.replaceReason ?? "-"),
                SizedBox(
                  height: setHeight(10),
                ),
                Text(
                    "${AppTranslations.of(context).text("Key_ReplacementDesc")}",
                    style: getTextStyle(
                      context,
                      type: Type.styleHead,
                      fontFamily: sourceSansFontFamily,
                      fontWeight: fwSemiBold,
                      txtColor: GlobalColor.black,
                    )),
                SizedBox(
                  height: setHeight(10),
                ),
                Text(providerorderdetails
                        .orderList.cancelReturnReplaceDescription ??
                    "-"),
              ],
            )),
        Visibility(
            visible: providerorderdetails.orderList.returnReason != null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(),
                SizedBox(
                  height: setHeight(10),
                ),
                Text("${AppTranslations.of(context).text("Key_ReturnReason")} ",
                    style: getTextStyle(
                      context,
                      type: Type.styleHead,
                      fontFamily: sourceSansFontFamily,
                      fontWeight: fwSemiBold,
                      txtColor: GlobalColor.black,
                    )),
                SizedBox(
                  height: setHeight(10),
                ),
                Text(providerorderdetails.orderList.returnReason ?? "-"),
                SizedBox(
                  height: setHeight(10),
                ),
                Text(
                    "${AppTranslations.of(context).text("Key_ReturnDescription")}",
                    style: getTextStyle(
                      context,
                      type: Type.styleHead,
                      fontFamily: sourceSansFontFamily,
                      fontWeight: fwSemiBold,
                      txtColor: GlobalColor.black,
                    )),
                SizedBox(
                  height: setHeight(10),
                ),
                Text(providerorderdetails
                        .orderList.cancelReturnReplaceDescription ??
                    "-"),
              ],
            )),
        Visibility(
            visible:
                providerorderdetails.orderList.returnReplaceRequestReason !=
                    null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(),
                SizedBox(
                  height: setHeight(10),
                ),
                Text(
                    providerorderdetails.orderList.orderStatus +
                        " ${AppTranslations.of(context).text("Key_Reason")} ",
                    style: getTextStyle(
                      context,
                      type: Type.styleHead,
                      fontFamily: sourceSansFontFamily,
                      fontWeight: fwSemiBold,
                      txtColor: GlobalColor.black,
                    )),
                SizedBox(
                  height: setHeight(10),
                ),
                Text(
                    providerorderdetails.orderList.returnReplaceRequestReason ??
                        "-"),
                SizedBox(
                  height: setHeight(10),
                ),
                Text(
                    providerorderdetails.orderList.orderStatus +
                        " ${AppTranslations.of(context).text("Key_Description")}",
                    style: getTextStyle(
                      context,
                      type: Type.styleHead,
                      fontFamily: sourceSansFontFamily,
                      fontWeight: fwSemiBold,
                      txtColor: GlobalColor.black,
                    )),
                SizedBox(
                  height: setHeight(10),
                ),
                Text(providerorderdetails.orderList
                        .returnReplaceRequestCancelRejectDescription ??
                    "-"),
              ],
            )),
      ],
    );
  }
}
