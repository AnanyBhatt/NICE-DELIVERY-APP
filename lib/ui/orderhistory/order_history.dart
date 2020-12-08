import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nice_customer_app/Localization/app_translations.dart';
import 'package:nice_customer_app/api/request/OrderHistoryRequest.dart';
import 'package:nice_customer_app/api/responce/OrderHistoryResponce.dart';
import 'package:nice_customer_app/common/appbar.dart';
import 'package:nice_customer_app/common/drawerAppBar.dart';
import 'package:nice_customer_app/common/no_data_found.dart';
import 'package:nice_customer_app/common/progressbar.dart';
import 'package:nice_customer_app/ui/drawer/drawer.dart';
import 'package:nice_customer_app/ui/orderdetails/order_details.dart';
import 'package:nice_customer_app/ui/orderhistory/ProviderOrderHistory.dart';
import 'package:nice_customer_app/ui/orders/order_status.dart';
import 'package:nice_customer_app/utils/color_.dart';
import 'package:nice_customer_app/utils/padding_.dart';
import 'package:nice_customer_app/mixins/const.dart';
import 'package:nice_customer_app/utils/textstyle_.dart';
import 'package:nice_customer_app/model/order_history.dart';
import 'package:nice_customer_app/webservices/RestClient.dart';
import 'package:nice_customer_app/webservices/apiendpointd.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderHistoryPage extends StatefulWidget {
  @override
  _OrderHistoryPageState createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> with Constants {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void initState() {
    super.initState();
    var providerorderhistory =
        Provider.of<ProviderOrderHistory>(context, listen: false);

    Future.delayed(Duration(milliseconds: 1), () {
      try {
        checkInternet().then((value) async {
          if (value == true) {
            await apiorderlist(providerorderhistory);
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
    buildSetupScreenUtils(context);

    return SafeArea(
      child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: GlobalColor.white,
          appBar: DrawerAppBar(
            appBar: AppBar(),
            title: AppTranslations.of(context).text("Key_OrderHistory"),
          ),
          drawer: DrawerPage(),
          body: Consumer<ProviderOrderHistory>(
            builder: (context, providerOrderHistory, child) {
              return SafeArea(
                child: Column(
                  children: [
                    providerOrderHistory.getShowProgressBar() == true
                        ? Expanded(child: Center(child: ProgressBar(clrBlack)))
                        : Container(
                            child: providerOrderHistory.orderList.length > 0
                                ? Expanded(
                                    child: ListView.builder(
                                      itemCount: providerOrderHistory
                                                  .orderList.length ==
                                              0
                                          ? null
                                          : providerOrderHistory
                                              .orderList.length,
                                      padding: GlobalPadding.paddingAll_15,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Column(
                                          children: [
                                            _orderHistoryTileWidget(
                                                index,
                                                providerOrderHistory
                                                    .orderList[index],
                                                providerOrderHistory),
                                          ],
                                        );
                                      },
                                    ),
                                  )
                                : NoDataFound()),
                  ],
                ),
              );
            },
          )),
    );
  }

  Widget _orderHistoryTileWidget(int index, OrderHistorylist orderlist,
      ProviderOrderHistory providerOrderHistory) {
    String date = orderlist.createdAt.toString();
    String orderTypr = orderlist.orderType;

    return Material(
      type: MaterialType.transparency,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              PageRouteBuilder(
                  transitionDuration: Duration(milliseconds: pageDuration),
                  pageBuilder: (_, __, ___) => OrderDetailsPage(
                        index: index,
                        OrderId: orderlist.id,
                      ))).then((value) {
            if (value != null && value) {
              Future.delayed(Duration(milliseconds: 1), () {
                try {
                  checkInternet().then((value) async {
                    if (value == true) {
                      await apiorderlist(providerOrderHistory);
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
          });
        },
        child: Card(
          elevation: 4,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(setSp(8)),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: GlobalPadding.paddingAll_18,
            child: Row(
              children: <Widget>[
                ClipRRect(
                    borderRadius: BorderRadius.circular(setSp(10)),
                    child: Image.network(
                      orderlist.vendorImageUrl,
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
                              orderlist.vendorName ?? "-",
                              overflow: TextOverflow.ellipsis,
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
                        height: setHeight(6),
                      ),
                      Text(
                        getOrderDateTime(date),
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
                            "${AppTranslations.of(context).text("Key_OrderId")}: " +
                                    orderlist.id.toString() ??
                                "-",
                            style: getTextStyle(
                              context,
                              type: Type.styleBody2,
                              fontFamily: sourceSansFontFamily,
                              fontWeight: fwRegular,
                              txtColor: GlobalColor.black,
                            ),
                          ),
                          isDisplayTrack(orderlist.orderStatus)
                              ? GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                            transitionDuration: Duration(
                                                milliseconds: pageDuration),
                                            pageBuilder: (_, __, ___) =>
                                                OrderStatusPage(
                                                    isFromOrder: true,
                                                    orderId: orderlist.id,
                                                    orderType: orderTypr)));
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
                                      ' ${AppTranslations.of(context).text("Key_trackOrder")} ',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: setHeight(10)),
                                    ),
                                  ),
                                )
                              : Offstage(),
                        ],
                      ),
                      SizedBox(
                        height: setHeight(5),
                      ),
                      Text(
                        displayStatus(context, orderlist.orderStatus),
                        overflow: TextOverflow.ellipsis,
                        style: getTextStyle(context,
                            type: Type.styleBody2,
                            fontFamily: sourceSansFontFamily,
                            fontWeight: fwBold,
                            txtColor:
                                getOrderStatusColor(orderlist.orderStatus)),
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

  String getOrderDateTime(String datetime) {
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

  apiorderlist(ProviderOrderHistory providerOrderHistory) async {
    providerOrderHistory.setShowProgressBar(true);

    SharedPreferences pref = await SharedPreferences.getInstance();
    String accessToken = pref.getString(prefStr_ACCESS_TOKEN);
    print("-----Access Token--------$accessToken");

    OrderHistoryRequest orderHistoryRequest = new OrderHistoryRequest();
    String data = orderHistoryRequestToJson(orderHistoryRequest);

    Response response = await RestClient.postData(
        context, ApiEndPoints.apiOrderHListForCustomer, data, accessToken);

    try {
      if (response.statusCode == 200) {
        providerOrderHistory.setShowProgressBar(false);

        OrderHistoryResponce orderhistoryresponce =
            orderHistoryResponceFromJson(response.toString());
        showLog(
            "apiOrderHistoryList :-: ${orderHistoryResponceToJson(orderhistoryresponce)}");

        if (orderhistoryresponce.status == ApiEndPoints.apiStatus_200) {
          providerOrderHistory.showrestaurnat(orderhistoryresponce.data);
        } else {
          showSnackBar(orderhistoryresponce.message);
        }
      } else {
        providerOrderHistory.setShowProgressBar(false);
        showSnackBar(
            "${AppTranslations.of(context).text("Key_errSomethingWrong")}");
      }
    } catch (exception) {
      print("-----exception Occurred-----${exception.toString()}");
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
