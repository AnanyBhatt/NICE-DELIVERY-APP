import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:nice_customer_app/Localization/app_translations.dart';
import 'package:nice_customer_app/common/flaticonbutton.dart';
import 'package:nice_customer_app/framework/repository/track/model/Status.dart';
import 'package:nice_customer_app/framework/stateprovidermodel/provider_track.dart';
import 'package:nice_customer_app/mixins/const.dart';
import 'package:nice_customer_app/ui/home/home.dart';
import 'package:nice_customer_app/ui/orderdetails/order_details.dart';
import 'package:nice_customer_app/ui/orderdetails/track_order.dart';
import 'package:nice_customer_app/utils/color_.dart';
import 'package:nice_customer_app/utils/padding_.dart';
import 'package:nice_customer_app/utils/textstyle_.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderStatusPage extends StatefulWidget {
  final int orderId;
  final bool isFromOrder;
  final String orderType;
  OrderStatusPage({this.orderId, this.isFromOrder,this.orderType});

  @override
  _OrderStatusPageState createState() => _OrderStatusPageState();
}

class _OrderStatusPageState extends State<OrderStatusPage> with Constants {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<Status> statusListData = List();
  bool isLoad = true;
  ProviderTrack providerTrackWatch;
  ProviderTrack providerTrackRead;
  String liveOrderStatus = "";

  @override
  void initState() {
    // TODO: implement initState


    if(widget.orderType=="Return")
      {
        Future.delayed(Duration(milliseconds: 10), () async {
          displayDataReturn(providerTrackRead);
        });
      }
    else if(widget.orderType=="Replacement")
      {

        Future.delayed(Duration(milliseconds: 10), () async {
          displayDataReplacement(providerTrackRead);
        });

      }
    else
      {
        Future.delayed(Duration(milliseconds: 10), () async {
          displayDataDelivery(providerTrackRead);
        });
      }




    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    buildSetupScreenUtils(context);
    providerTrackWatch = context.watch<ProviderTrack>();

    return SafeArea(
      key: _scaffoldKey,
      child: Scaffold(
        appBar: AppBar(
            elevation: 0,
            leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: GlobalColor.black,
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
            actions: <Widget>[
              InkWell(
                onTap: () {
                  statusListData = [];
                  if(widget.orderType=="Return")
                  {
                    Future.delayed(Duration(milliseconds: 10), () async {
                      displayDataReturn(providerTrackRead);
                    });
                  }
                  else if(widget.orderType=="Replacement")
                  {

                    Future.delayed(Duration(milliseconds: 10), () async {
                      displayDataReplacement(providerTrackRead);
                    });

                  }
                  else
                  {
                    Future.delayed(Duration(milliseconds: 10), () async {
                      displayDataDelivery(providerTrackRead);
                    });
                  }



                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 16,left: 16),
                  child: Icon(
                    Icons.refresh,
                    color: Colors.black,
                  ),
                ),
              )
            ],
            centerTitle: true,
            backgroundColor: Colors.white,
            title: Text(
              "${AppTranslations.of(context).text("Key_orderStatus")}",
              style: getTextStyle(context,
                  type: Type.styleBody1,
                  fontFamily: sourceSansFontFamily,
                  fontWeight: fwBold,
                  txtColor: GlobalColor.black),
            )),
        backgroundColor: GlobalColor.white,
        body: providerTrackWatch.isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Stack(children: [
                SingleChildScrollView(
                  child: Container(
                    padding: GlobalPadding.paddingSymmetricH_20,
                    margin: GlobalPadding.paddingSymmetricV_25,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _getOrderStatusList(),
                        SizedBox(
                          height: setHeight(58),
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                    bottom: 0,
                    child: Container(
                      // color: GlobalColor.white,
                      padding: EdgeInsets.only(
                          // top: setHeight(5),
                          left: setWidth(20),
                          right: setWidth(20),
                          bottom: setHeight(25)),
                      child: Row(
                        children: [
                          !widget.isFromOrder
                              ? SizedBox(
                                  height: setHeight(48),
                                  child: FlatCustomButton(
                                    outline: true,
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                              transitionDuration: Duration(
                                                  milliseconds: pageDuration),
                                              pageBuilder: (_, __, ___) =>
                                                  OrderDetailsPage(
                                                    OrderId: providerTrackWatch
                                                        .resOrderTrack.data.id,
                                                  )));
                                    },
                                    title:
                                        "${AppTranslations.of(context).text("Key_ViewOrder")}",
                                  ),
                                )
                              : Container(),
                          SizedBox(
                            width: setWidth(25),
                          ),
                      /*    liveOrderStatus == "Pending" ||
                                  liveOrderStatus == "Confirmed" ||
                                  liveOrderStatus == "Delivered"
                              ? Container()
                              : SizedBox(
                                  width: setWidth(155),
                                  height: setHeight(48),
                                  child: FlatCustomButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                                transitionDuration:
                                                    Duration(milliseconds: 1),
                                                pageBuilder: (_, __, ___) =>
                                                    TrackOrderPage()));
                                      },
                                      title: trackOrder),
                                )*/
                          isDisplayTrackButton(liveOrderStatus,providerTrackWatch) ?  SizedBox(
                            width: setWidth(155),
                            height: setHeight(48),
                            child: FlatCustomButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                          transitionDuration:
                                          Duration(milliseconds: 1),
                                          pageBuilder: (_, __, ___) =>
                                              TrackOrderPage(orderId: widget.orderId)));
                                },
                                title: trackOrder),
                          ) : Container()


                        ],
                      ),
                    ))
              ]),
      ),
    );
  }

  Widget _getOrderStatusList() {
    return ListView.builder(
        itemCount: statusListData.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, i) {
          return Container(child: _statusListData(i, true));
        });
  }

  Widget _statusListData(int i, bool _status) {
    // final app = Provider.of<package>(context);
    return Column(
      children: [
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: <Widget>[
                  Image.asset(
                    statusListData[i].active ? icStatusCheck : icStatusUnCheck,
                    height: setHeight(28.0),
                    width: setWidth(28.0),
                  ),
                  _status
                      ? Dash(
                          direction: Axis.vertical,
                          length: 52,
                          dashGap: 6,
                          dashThickness: 2,
                          dashLength: 6,
                          dashColor: GlobalColor.grey)
                      : Offstage(),
                ],
              ),
              SizedBox(
                width: setWidth(15),
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          statusListData[i].displaystatus,
                          style: getTextStyle(
                            context,
                            type: Type.styleDrawerText,
                            fontFamily: sourceSansFontFamily,
                            fontWeight: fwSemiBold,
                            txtColor: GlobalColor.black,
                          ),
                        ),
                        SizedBox(
                          height: setHeight(5),
                        ),
                        Text(
                          statusListData[i].statusdesc,
                          style: getTextStyle(
                            context,
                            type: Type.styleBody2,
                            fontFamily: sourceSansFontFamily,
                            fontWeight: fwRegular,
                            txtColor: GlobalColor.grey,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }



  Future<void> displayDataDelivery(ProviderTrack providerTrackRead) async {
    providerTrackRead = context.read<ProviderTrack>();

    providerTrackRead = context.read<ProviderTrack>();

    SharedPreferences pref = await SharedPreferences.getInstance();
    String accessToken = pref.getString(prefStr_ACCESS_TOKEN);

    await providerTrackRead.getOrderDetails(context: context,accessToken: accessToken,orderId: widget.orderId.toString());
    //await providerTrackRead.trackOrder(context: context);
    generateList(statusListData, providerTrackRead);
  }

  void generateList(
      List<Status> statusListData, ProviderTrack providerTrackRead) {

    //Delivery

    if(providerTrackWatch.deliveryType=="Delivery")
      {

        // statusListData = [];
        statusListData.clear();
        Status item = Status();
        item.active = false;
        item.displaystatus =
        "${AppTranslations.of(context).text("Key_OrderPlaced")}";
        item.orignalstatus = regularOrderPending;
        item.statusdesc =
        "${AppTranslations.of(context).text("Key_OrderPlacedDesc")}";
        statusListData.add(item);

        Status item1 = Status();
        item1.active = false;
        item1.displaystatus =
        "${AppTranslations.of(context).text("Key_OrderConfirmed")}";
        item1.orignalstatus =
            regularOrderConfirmed;
        item1.statusdesc =
        "${AppTranslations.of(context).text("Key_OrderConfirmedDesc")}";
        statusListData.add(item1);

        Status item2 = Status();
        item2.active = false;
        item2.displaystatus =
        "${AppTranslations.of(context).text("Key_OrderInProcess")}";
        item2.orignalstatus =
            regularOrderInProcess;
        item2.statusdesc =
        "${AppTranslations.of(context).text("Key_OrderInProcessDesc")}";
        statusListData.add(item2);

        Status item3 = Status();
        item3.active = false;
        item3.displaystatus =
        "${AppTranslations.of(context).text("Key_OrderReady")}";
        item3.orignalstatus =
            regularOrderIsPrepared;
        item3.statusdesc =
        "${AppTranslations.of(context).text("Key_OrderReadyDesc")}";
        statusListData.add(item3);

        Status item4 = Status();
        item4.active = false;
        item4.displaystatus =
        "${AppTranslations.of(context).text("Key_Waitingforpickup")}";
        item4.orignalstatus =
            regularOrderWaitingforpickup;
        item4.statusdesc =
        "${AppTranslations.of(context).text("Key_WaitingforpickupDesc")}";
        statusListData.add(item4);

        Status item5 = Status();
        item5.active = false;
        item5.displaystatus =
        "${AppTranslations.of(context).text("Key_OrderPickedUp")}";
        item5.orignalstatus =
            regularOrderPickedUp;
        item5.statusdesc =
        "${AppTranslations.of(context).text("Key_OrderPickedUpDesc")}";
        statusListData.add(item5);

        Status item6 = Status();
        item6.active = false;
        item6.displaystatus =
        "${AppTranslations.of(context).text("Key_OrderDelivered")}";
        item6.orignalstatus =
            regularOrderDelivered;
        item6.statusdesc =
        "${AppTranslations.of(context).text("Key_OrderIsDelivered")}";
        statusListData.add(item6);
      }
      else
        {

          print("....i am picked up....");

          // statusListData = [];
          statusListData.clear();
          Status item = Status();
          item.active = false;
          item.displaystatus =
          "${AppTranslations.of(context).text("Key_OrderPlaced")}";
          item.orignalstatus = regularOrderPending;
          item.statusdesc =
          "${AppTranslations.of(context).text("Key_OrderPlacedDesc")}";
          statusListData.add(item);



          Status item2 = Status();
          item2.active = false;
          item2.displaystatus =
          "${AppTranslations.of(context).text("Key_OrderInProcess")}";
          item2.orignalstatus =
              regularOrderInProcess;
          item2.statusdesc =
          "${AppTranslations.of(context).text("Key_OrderInProcessDesc")}";
          statusListData.add(item2);

          Status item3 = Status();
          item3.active = false;
          item3.displaystatus =
          "${AppTranslations.of(context).text("Key_OrderReady")}";
          item3.orignalstatus =
              regularOrderIsPrepared;
          item3.statusdesc =
          "${AppTranslations.of(context).text("Key_OrderReadyDesc")}";
          statusListData.add(item3);

          Status item4 = Status();
          item4.active = false;
          item4.displaystatus =
          "${AppTranslations.of(context).text("Key_Waitingforpickup")}";
          item4.orignalstatus =
              regularOrderWaitingforpickup;
          item4.statusdesc =
          "${AppTranslations.of(context).text("Key_WaitingforpickupDesc")}";
          statusListData.add(item4);

           Status item6 = Status();
          item6.active = false;
          item6.displaystatus = "${AppTranslations.of(context).text("Key_picked")}";
          //item6.displaystatus = "picked";//Key_picked
          item6.orignalstatus =
              regularOrderDelivered;
          item6.statusdesc = "${AppTranslations.of(context).text("Key_Your_order_has_been_Picked.")}";
          //item6.statusdesc = "Your order has been Picked."; //Key_Your_order_has_been_Picked
          statusListData.add(item6);


        }



    //liveOrderStatus = providerTrackRead.resOrderTrack.data.orderStatus;
    liveOrderStatus = providerTrackRead.orderFinalStatus;
    print("....orderStatus...XXXXXXXXXXXXXXXXXXXXXX...........$liveOrderStatus");

    for (Status item in statusListData) {
      item.active = true;
      print(".....item....${item.orignalstatus}");
      if (item.orignalstatus.toLowerCase() == liveOrderStatus.toLowerCase()) {
        break;
      }
    }
    checkLiveStatus(_scaffoldKey.currentContext,liveOrderStatus);
    setState(() {
      this.liveOrderStatus = liveOrderStatus;
    });
  }


  Future<void> displayDataReturn(ProviderTrack providerTrackRead) async {
    providerTrackRead = context.read<ProviderTrack>();

    SharedPreferences pref = await SharedPreferences.getInstance();
    String accessToken = pref.getString(prefStr_ACCESS_TOKEN);

    await providerTrackRead.getOrderDetails(context: context,accessToken: accessToken,orderId: widget.orderId.toString());
    generateListReturn(statusListData, providerTrackRead);
  }

  Future<void> displayDataReplacement(ProviderTrack providerTrackRead) async {
    providerTrackRead = context.read<ProviderTrack>();

    SharedPreferences pref = await SharedPreferences.getInstance();
    String accessToken = pref.getString(prefStr_ACCESS_TOKEN);

    await providerTrackRead.getOrderDetails(context: context,accessToken: accessToken,orderId: widget.orderId.toString());

    generateListReplacement(statusListData, providerTrackRead);
  }

  void generateListReturn(
      List<Status> statusListData, ProviderTrack providerTrackRead) {

    if(providerTrackWatch.deliveryType=="Delivery") {


      // statusListData = [];
      statusListData.clear();

      Status item = Status();
      item.active = false;
      item.displaystatus = "${AppTranslations.of(context).text("Key_Return_Requested")}";
      //item.displaystatus = "Return Requested"; //Key_Return_Requested
      item.orignalstatus = returnOrderRequested;
      item.statusdesc = "${AppTranslations.of(context).text("Key_your_return_order_request_hasbeen_successfully_raised")}";
      //item.statusdesc = "your return order request has been successfully raised"; //Key_your_return_order_request_hasbeen_successfully_raised
      statusListData.add(item);

      Status item1 = Status();
      item1.active = false;
      item1.displaystatus = "${AppTranslations.of(context).text("Key_Return_Confirmed")}";
      //item1.displaystatus = "Return Confirmed"; //Key_Return_Confirmed
      item1.orignalstatus =returnOrderConfirmed;
      item1.statusdesc = "${AppTranslations.of(context).text("Key_your_return_order_request_hasbeen_successfully_Confirmed")}";
     // item1.statusdesc = "your return order request has been successfully Confirmed"; //Key_your_return_order_request_hasbeen_successfully_Confirmed
      statusListData.add(item1);

      Status item2 = Status();
      item2.active = false;
      item2.displaystatus = "${AppTranslations.of(context).text("Key_Return_In_Process")}";
      //item2.displaystatus = "Return In Process"; //Key_Return_In_Process
      item2.orignalstatus =returnOrderProcessed;
      item2.statusdesc = "${AppTranslations.of(context).text("Key_Your_Return_order_is_ready_to_pick_by_deliveryboy.")}";
      //item2.statusdesc = "Your Return order is ready to pick by delivery boy."; //Key_Your_Return_order_is_ready_to_pick_by_deliveryboy.
      statusListData.add(item2);

      Status item3 = Status();
      item3.active = false;
      item3.displaystatus = "${AppTranslations.of(context).text("Key_Return_Picked_Up")}";
      //item3.displaystatus = "Return Picked Up"; //Key_Return_Picked_Up
      item3.orignalstatus =returnOrderPickedUp;
      item3.statusdesc = "${AppTranslations.of(context).text("Key_Delivery_boy_has_Picked_your_Return_order.")}";
      //item3.statusdesc = "Delivery boy has Picked your Return order."; //Key_Delivery_boy_has_Picked_your_Return_order
      statusListData.add(item3);

      Status item4 = Status();
      item4.active = false;
      item4.displaystatus = "${AppTranslations.of(context).text("Key_Returned")}";
      //item4.displaystatus = "Returned"; //Key_Returned
      item4.orignalstatus =returnOrderReturned;
      item4.statusdesc = "${AppTranslations.of(context).text("Key_Your_order_has_been_returned_successfully.")}";
      //item4.statusdesc = "Your order has been returned successfully."; //Key_Your_order_has_been_returned_successfully.
      statusListData.add(item4);



    }
    else
      {


        // statusListData = [];
        statusListData.clear();

        Status item = Status();
        item.active = false;
        item.displaystatus = "${AppTranslations.of(context).text("Key_Return_Requested")}";
        //item.displaystatus = "Return Requested"; //Key_Return_Requested
        item.orignalstatus = returnOrderRequested;
        item.statusdesc = "${AppTranslations.of(context).text("Key_your_return_order_request_hasbeen_successfully_raised")}";
        //item.statusdesc = "your return order request has been successfully raised"; //Key_your_return_order_request_hasbeen_successfully_raised
        statusListData.add(item);

        Status item1 = Status();
        item1.active = false;
        item1.displaystatus = "${AppTranslations.of(context).text("Key_Return_Confirmed")}";
        //item1.displaystatus = "Return Confirmed"; //Key_Return_Confirmed
        item1.orignalstatus =returnOrderConfirmed;
        item1.statusdesc = "${AppTranslations.of(context).text("Key_your_return_order_request_hasbeen_successfully_Confirmed")}";
        //item1.statusdesc = "your return order request has been successfully Confirmed"; //Key_your_return_order_request_hasbeen_successfully_Confirmed
        statusListData.add(item1);


        Status item2 = Status();
        item2.active = false;
        item2.displaystatus = "${AppTranslations.of(context).text("Key_Return_In_Process")}";
        //item2.displaystatus = "Return In Process"; //Key_Return_In_Process
        item2.orignalstatus =returnOrderProcessed;
        item2.statusdesc = "${AppTranslations.of(context).text("Key_Your_Return_order_is_ready_to_pick_by_deliveryboy.")}";
        //item2.statusdesc = "Your Return order is ready to pick by delivery boy."; //Key_Your_Return_order_is_ready_to_pick_by_deliveryboy
        statusListData.add(item2);


        Status item3 = Status();
        item3.active = false;
        item3.displaystatus = "${AppTranslations.of(context).text("Key_Return_Picked_Up")}";
        //item3.displaystatus = "Return Picked Up"; //Key_Return_Picked_Up
        item3.orignalstatus =returnOrderPickedUp;
        item3.statusdesc = "${AppTranslations.of(context).text("Key_Delivery_boy_has_Picked_your_Return_order.")}";
        //item3.statusdesc = "Delivery boy has Picked your Return order."; //Key_Delivery_boy_has_Picked_your_Return_order
        statusListData.add(item3);

        Status item4 = Status();
        item4.active = false;
        item4.displaystatus = "${AppTranslations.of(context).text("Key_Returned")}";
        //item4.displaystatus = "Returned"; //Key_Returned
        item4.orignalstatus =returnOrderReturned;
        item4.statusdesc = "${AppTranslations.of(context).text("Key_Your_order_has_been_returned_successfully.")}";
        //item4.statusdesc = "Your order has been returned successfully."; //Key_Your_order_has_been_returned_successfully
        statusListData.add(item4);




      }



    liveOrderStatus = providerTrackRead.orderFinalStatus;
    print("....orderStatus....$liveOrderStatus");

    checkLiveStatus(_scaffoldKey.currentContext,liveOrderStatus);

    for (Status item in statusListData) {
      item.active = true;
      print(".....item....${item.orignalstatus}");
      if (item.orignalstatus == liveOrderStatus) {
        break;
      }
    }

    setState(() {
      this.liveOrderStatus = liveOrderStatus;
    });
  }

  void generateListReplacement(
      List<Status> statusListData, ProviderTrack providerTrackRead) {
    // statusListData = [];


    if(providerTrackWatch.deliveryType.toLowerCase()=="Delivery") {

      statusListData.clear();

      Status item = Status();
      item.active = false;
      item.displaystatus = "${AppTranslations.of(context).text("Key_Replacement_Requested")}";
      //item.displaystatus = "Replacement Requested"; //Key_Replacement_Requested
      item.orignalstatus = replacementOrderRequested;
      item.statusdesc = "${AppTranslations.of(context).text("Key_your_replacement_order_request_has_been_successfully_raised.")}";
      //item.statusdesc = "your replacement order request has been successfully raised."; //Key_your_replacement_order_request_has_been_successfully_raised
      statusListData.add(item);

      Status item1 = Status();
      item1.active = false;
      item1.displaystatus = "${AppTranslations.of(context).text("Key_Replacement_Confirmed")}";
      //item1.displaystatus = "Replacement Confirmed"; //Key_Replacement_Confirmed
      item1.orignalstatus =replacementOrderConfirmed;
      item1.statusdesc = "${AppTranslations.of(context).text("Key_Your_Replacement_Order_Request_Has_Been_Successfully_Confirmed..")}";
      //item1.statusdesc = "Your Replacement Order Request Has Been Successfully Confirmed.."; //Key_Your_Replacement_Order_Request_Has_Been_Successfully_Confirmed..
      statusListData.add(item1);

      Status item2 = Status();
      item2.active = false;
      item2.displaystatus = "${AppTranslations.of(context).text("Key_Replacement_in_process")}";
     // item2.displaystatus = "Replacement in process"; //Key_Replacement_in_process
      item2.orignalstatus =replacementOrderProcessed;
      item2.statusdesc = "${AppTranslations.of(context).text("Key_your_replacement_order_is_ready_to_pickby_deliveryboy.")}";
      //item2.statusdesc = "your replacement order is ready to pick by delivery boy."; //Key_your_replacement_order_is_ready_to_pickby_deliveryboy.
      statusListData.add(item2);

      Status item3 = Status();
      item3.active = false;
      item3.displaystatus = "${AppTranslations.of(context).text("Key_Replacement_Prepared")}";
      //item3.displaystatus = "Replacement Prepared"; //Key_Replacement_Prepared
      item3.orignalstatus =replacementOrderPrepared;
      item3.statusdesc = "${AppTranslations.of(context).text("Key_Replacement_Prepared.")}";
      //item3.statusdesc = "Replacement Prepared."; //Key_Replacement_Prepared.
      statusListData.add(item3);

      Status item4 = Status();
      item4.active = false;
      item4.displaystatus = "${AppTranslations.of(context).text("Key_Replacement_Order_Waiting_for_pickup")}";
      //item4.displaystatus = "Replacement Order Waiting for pickup"; //Key_Replacement_Order_Waiting_for_pickup
      item4.orignalstatus =replacementOrderWaitingforpickup;
      item4.statusdesc = "${AppTranslations.of(context).text("Key_Replacement_Order_Waiting_for_pickup")}";
      //item4.statusdesc = "Replacement Order Waiting for pickup"; //Key_Replacement_Order_Waiting_for_pickup
      statusListData.add(item4);



      Status item5 = Status();
      item5.active = false;
      item5.displaystatus = "${AppTranslations.of(context).text("Key_Replacement_Picked_Up")}";
      //item5.displaystatus = "Replacement Picked Up"; //Key_Replacement_Picked_Up
      item5.orignalstatus =replacementOrderPickedUp;
      item5.statusdesc = "${AppTranslations.of(context).text("Key_Deliveryboy_has_Picked_your_Replacement_order.")}";
      //item5.statusdesc = "Delivery boy has Picked your Replacement order."; //Key_Deliveryboy_has_Picked_your_Replacement_order.
      statusListData.add(item5);


      Status item6 = Status();
      item6.active = false;
      item6.displaystatus = "${AppTranslations.of(context).text("Key_Replaced")}";
      //item6.displaystatus = "Replaced"; //Key_Replaced
      item6.orignalstatus =replacementOrderReplaced;
      item6.statusdesc = "${AppTranslations.of(context).text("Key_Your_order_has_been_Replaced_Successfully.")}";
      //item6.statusdesc = "Your order has been Replaced Successfully."; //Key_Your_order_has_been_Replaced_Successfully.
      statusListData.add(item6);

    }
    else
      {


        statusListData.clear();

        Status item = Status();
        item.active = false;
        item.displaystatus = "${AppTranslations.of(context).text("Key_Replacement_Requested")}";
        //item.displaystatus = "Replacement Requested"; //Key_Replacement_Requested
        item.orignalstatus = replacementOrderRequested;
        item.statusdesc = "${AppTranslations.of(context).text("Key_your_replacement_order_request_has_been_successfully_raised.")}";
        //item.statusdesc = "your replacement order request has been successfully raised."; //Key_your_replacement_order_request_has_been_successfully_raised
        statusListData.add(item);

        Status item1 = Status();
        item1.active = false;
        item1.displaystatus = "${AppTranslations.of(context).text("Key_Replacement_Confirmed")}";
        //item1.displaystatus = "Replacement Confirmed"; //Key_Replacement_Confirmed
        item1.orignalstatus =replacementOrderConfirmed;
        item1.statusdesc = "${AppTranslations.of(context).text("Key_Your_Replacement_Order_Request_Has_Been_Successfully_Confirmed..")}";
        //item1.statusdesc = "Your Replacement Order Request Has Been Successfully Confirmed.."; //Key_Your_Replacement_Order_Request_Has_Been_Successfully_Confirmed
        statusListData.add(item1);


        Status item2 = Status();
        item2.active = false;
        item2.displaystatus = "${AppTranslations.of(context).text("Key_Replacement_in_process")}";
        //item2.displaystatus = "Replacement in process"; //Key_Replacement_in_process
        item2.orignalstatus =replacementOrderProcessed;
        item2.statusdesc = "${AppTranslations.of(context).text("Key_your_replacement_order_is_ready_to_pickby_deliveryboy.")}";
        //item2.statusdesc = "your replacement order is ready to pick by delivery boy."; //Key_your_replacement_order_is_ready_to_pickby_deliveryboy
        statusListData.add(item2);

        Status item3 = Status();
        item3.active = false;
        item3.displaystatus = "${AppTranslations.of(context).text("Key_Replacement_Prepared")}";
        //item3.displaystatus = "Replacement Prepared"; //Key_Replacement_Prepared
        item3.orignalstatus =replacementOrderPrepared;
        item3.statusdesc = "${AppTranslations.of(context).text("Key_Replacement_Prepared.")}";
        //item3.statusdesc = "Replacement Prepared."; //Key_Replacement_Prepared.
        statusListData.add(item3);


        Status item4 = Status();
        item4.active = false;
        item4.displaystatus = "${AppTranslations.of(context).text("Key_Replacement_Order_Waiting_for_pickup")}";
        //item4.displaystatus = "Replacement Order Waiting for pickup"; //Key_Replacement_Order_Waiting_for_pickup
        item4.orignalstatus =replacementOrderWaitingforpickup;
        item4.statusdesc = "${AppTranslations.of(context).text("Key_Replacement_Order_Waiting_for_pickup")}";
        //item4.statusdesc = "Replacement Order Waiting for pickup"; //Key_Replacement_Order_Waiting_for_pickup
        statusListData.add(item4);


        Status item6 = Status();
        item6.active = false;
        item6.displaystatus = "${AppTranslations.of(context).text("Key_Replaced")}";
        //item6.displaystatus = "Replaced"; //Key_Replaced
        item6.orignalstatus =replacementOrderReplaced;
        item6.statusdesc = "${AppTranslations.of(context).text("Key_Your_order_has_been_Replaced_Successfully.")}";
        //item6.statusdesc = "Your order has been Replaced Successfully."; //Key_Your_order_has_been_Replaced_Successfully
        statusListData.add(item6);


      }





    liveOrderStatus = providerTrackRead.orderFinalStatus;
    print("....orderStatus....$liveOrderStatus");

    for (Status item in statusListData) {
      item.active = true;
      print(".....item....${item.orignalstatus}");
      if (item.orignalstatus == liveOrderStatus) {
        break;
      }
    }

    checkLiveStatus(_scaffoldKey.currentContext,liveOrderStatus);

    setState(() {
      this.liveOrderStatus = liveOrderStatus;
    });
  }



  bool isDisplayTrackButton(String status, ProviderTrack providerTrackWatch) {
    bool isDisplay = false;


    if(providerTrackWatch.deliveryType=="Delivery")
    {
      if (status == regularOrderInProcess || status == regularOrderIsPrepared || status == regularOrderWaitingforpickup || status == regularOrderPickedUp || status == replacementOrderProcessed
          || status == replacementOrderPrepared || status == replacementOrderWaitingforpickup || status == replacementOrderPickedUp
          || status == returnOrderProcessed || status == returnOrderPickedUp ) {
        isDisplay = true;
      }
      else {
        isDisplay = false;
      }
    }
    else
    {
      isDisplay = false;
    }



    return isDisplay;
  }

  void checkLiveStatus(BuildContext currentContext, String liveOrderStatus) {


    if(liveOrderStatus == "Delivered" || liveOrderStatus == "Replaced" || liveOrderStatus == "Returned"
        || liveOrderStatus == "Cancelled"  || liveOrderStatus == "Replace Cancelled"  || liveOrderStatus == "Return Cancelled")
    {

      showAlertDialog(currentContext,liveOrderStatus);
    }



  }

  showAlertDialog(BuildContext context, String orderSta) {

    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {

        Navigator.pushAndRemoveUntil(
            context,
            PageRouteBuilder(
                transitionDuration: Duration(
                    milliseconds: pageDuration),
                pageBuilder: (_, __, ___) => HomePage(
                  isStatus: false,
                )),
                (Route<dynamic> route) => false);

      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Nice App"),
      content: Text("Your order has been $orderSta. "),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }





}
