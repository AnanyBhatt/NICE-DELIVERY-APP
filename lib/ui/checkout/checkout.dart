import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nice_customer_app/api/responce/CustomerAddressResponse.dart';
import 'package:nice_customer_app/common/appbar.dart';
import 'package:nice_customer_app/common/flaticonbutton.dart';
import 'package:nice_customer_app/common/map_utils.dart';
import 'package:nice_customer_app/Localization/app_translations.dart';
import 'package:nice_customer_app/framework/repository/cart/model/ResCartList.dart';
import 'package:nice_customer_app/framework/repository/cart/model/ResCheckOut.dart';
import 'package:nice_customer_app/framework/repository/cart/model/ResVendorDetails.dart';
import 'package:nice_customer_app/framework/repository/order/model/ReqOrder.dart';
import 'package:nice_customer_app/framework/repository/order/model/ResOrder.dart';
import 'package:nice_customer_app/framework/stateprovidermodel/provider_cart.dart';
import 'package:nice_customer_app/framework/stateprovidermodel/provider_order.dart';
import 'package:nice_customer_app/mixins/const.dart';
import 'package:nice_customer_app/ui/address_book/ProviderAddressBook.dart';
import 'package:nice_customer_app/ui/address_book/add_address.dart';
import 'package:nice_customer_app/ui/checkout/CheckoutWebview.dart';
import 'package:nice_customer_app/ui/checkout/checkout_items_tile.dart';
import 'package:nice_customer_app/ui/orders/order_confirm.dart';
import 'package:nice_customer_app/utils/color_.dart';
import 'package:nice_customer_app/utils/padding_.dart';
import 'package:nice_customer_app/utils/textstyle_.dart';
import 'package:nice_customer_app/webservices/RestClient.dart';
import 'package:nice_customer_app/webservices/apiendpointd.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckoutPage extends StatefulWidget {
  CheckoutPage({Key key}) : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> with Constants {
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  int _markerIdCounter = 0;
  Completer<GoogleMapController> _mapController = Completer();
  String _pickupVal = "";
  ProviderCart cartRead;
  ProviderCart cartWatch;
  ProviderOrder orderWrite;
  CheckoutMaster checkoutMaster = CheckoutMaster();
  ResVendorDetailsData resVendorDetailsData = ResVendorDetailsData();
  List<CartItem> cartItemList = List();
  int addressID = 0;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  ProviderAddressBook addressWatch;

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      cartRead = context.read<ProviderCart>();

      cartRead.checkOutCartItem(
          context: context,
          deliveryType:
              cartRead.radioValueDelPick == 0 ? static_Delivery : static_Pick_Up,
          useWallet: cartRead.isChecked,
          isFromInit: true);
    });

    Future.delayed(Duration(milliseconds: 10), () async {
      checkInternet().then((value) {
        if (value == true) {
          apiCustomerAddressList(
            context,
          );
        } else {
          showSnackBar(errInternetConnection);
        }
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    cartWatch = context.watch<ProviderCart>();

    checkoutMaster = cartWatch.checkoutMaster;
    resVendorDetailsData = cartWatch.getResVendorDetailsData();
    cartItemList = checkoutMaster.cartItemResponseList;
    orderWrite = context.watch<ProviderOrder>();
    addressWatch = context.watch<ProviderAddressBook>();

    buildSetupScreenUtils(context);

    return SafeArea(
        child: Scaffold(
      key: _scaffoldKey,
      backgroundColor: GlobalColor.white,
      appBar: CommonAppBar(
          title: "${AppTranslations.of(context).text("Key_checkout")}",
          appBar: AppBar()),
      body: Consumer<ProviderAddressBook>(
          builder: (context, providerAddressBook0, child) {
        return cartWatch.isLoading || addressWatch.showProgressBar
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Container(
                  padding: GlobalPadding.paddingSymmetricH_20,
                  margin: GlobalPadding.paddingSymmetricV_25,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      (cartWatch.radioValueDelPick == 1 ||
                              resVendorDetailsData.deliveryType.toLowerCase() ==
                                  static_Pick_Up.toLowerCase())
                          ? Container()
                          : (addressWatch.getCustomerAddressListData() ==
                                      null ||
                                  addressWatch
                                          .getCustomerAddressListData()
                                          .latitude ==
                                      null)
                              ? SizedBox(
                                  width: infiniteSize,
                                  child: FlatCustomButton(
                                      outline: true,
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                                transitionDuration: Duration(
                                                    milliseconds: pageDuration),
                                                pageBuilder: (_, __, ___) =>
                                                    AddAddressPage())).then(
                                            (value) {
                                          if (value) {
                                            checkInternet().then((value) {
                                              if (value == true) {
                                                apiCustomerAddressList(
                                                  context,
                                                );
                                              } else {
                                                showSnackBar(
                                                    errInternetConnection);
                                              }
                                            });
                                          }
                                        });
                                      },
                                      title: addAddress),
                                )
                              : _addressDetailsWidget(),
                      (resVendorDetailsData.deliveryType.toLowerCase() ==
                                  "both" ||
                              resVendorDetailsData.deliveryType.toLowerCase() ==
                                  static_Delivery.toLowerCase())
                          ? SizedBox(
                              height: setHeight(32.5),
                            )
                          : Container(),
                      Row(
                        children: [
                          (resVendorDetailsData.deliveryType.toLowerCase() ==
                                      "both" ||
                                  resVendorDetailsData.deliveryType
                                          .toLowerCase() ==
                                      static_Delivery.toLowerCase())
                              ? _radioButton(0,
                                  "${AppTranslations.of(context).text("Key_Delivery")}")
                              : Container(),
                          (resVendorDetailsData.deliveryType.toLowerCase() ==
                                      "both" ||
                                  resVendorDetailsData.deliveryType
                                          .toLowerCase() ==
                                      static_Delivery.toLowerCase())
                              ? SizedBox(
                                  width: setWidth(22.5),
                                )
                              : Container(),
                          (resVendorDetailsData.deliveryType.toLowerCase() ==
                                      "both" ||
                                  resVendorDetailsData.deliveryType
                                          .toLowerCase() ==
                                      static_Pick_Up.toLowerCase())
                              ? _radioButton(1,
                                  "${AppTranslations.of(context).text("Key_Pickup")}")
                              : Container(),
                        ],
                      ),
                      SizedBox(
                        height: setHeight(34.62),
                      ),
                      _vendorDetails(),
                      SizedBox(
                        height: setHeight(25),
                      ),
                      _paymentMode(),
                      SizedBox(
                        height: setHeight(25),
                      ),
                      _paymentSummary(),
                      SizedBox(
                        height: setHeight(22),
                      ),
                      RichText(
                        text: TextSpan(
                            text:
                                "${AppTranslations.of(context).text("Key_ByPlacing")}",
                            style: getTextStyle(
                              context,
                              type: Type.styleBody1,
                              fontFamily: sourceSansFontFamily,
                              fontWeight: fwLight,
                              txtColor: GlobalColor.black,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                  text:
                                      "${AppTranslations.of(context).text("Key_TermsCondition")}",
                                  style: getTextStyle(
                                    context,
                                    type: Type.styleBody1,
                                    fontFamily: sourceSansFontFamily,
                                    fontWeight: fwBold,
                                    txtColor: GlobalColor.black,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => Navigator.pushNamed(
                                        context, termsConditionsRoute)),
                            ]),
                      ),
                      SizedBox(
                        height: setHeight(31),
                      ),
                      Hero(
                        tag: "buttonTag",
                        child: Material(
                          type: MaterialType.transparency,
                          child: SizedBox(
                            height: setHeight(44),
                            width: infiniteSize,
                            child: FlatCustomButton(
                                onPressed: () async {
                                  showLog(
                                      "radioPayment : ${cartWatch.radioPayment}");
                                  showLog(
                                      "radioValueDelPick : ${cartWatch.radioValueDelPick}");

                                  cartWatch.displayLoader(true);

                                  ReqOrder orderData = ReqOrder();
                                  orderData.shippingAddressId = addressWatch.customerAddressList.id;
                                  orderData.totalOrderAmount = cartWatch.checkoutMaster.totalOrderAmount.toString();
                                  orderData.paymentMode =  (cartWatch.checkoutMaster.totalOrderAmount == 0 ? "WALLET" : (cartWatch.radioPayment == 0 ? "ONLINE" : "COD"));
                                  orderData.deliveryType = cartWatch.radioValueDelPick == 0 ? static_Delivery : static_Pick_Up;
                                  orderData.description = cartWatch.specialReq;
                                  orderData.useWallet = cartWatch.isChecked;

                                  print(".....orderData.request......${json.encode(orderData.toJson())}");

                                  ResOrder resOrder =
                                      await orderWrite.placeOrder(
                                          context: context,
                                          reqOrder: orderData);
                                  cartWatch.displayLoader(false);

                                  print("TTTT $resOrder");
                                  if (resOrder.status ==
                                      ApiEndPoints.apiStatus_200) {
                                    print(
                                        "......data......${orderWrite.successOrderId}");

                                    if (cartWatch.radioPayment == 0 &&
                                        cartWatch.checkoutMaster
                                                .totalOrderAmount !=
                                            null &&
                                        cartWatch.checkoutMaster
                                                .totalOrderAmount >
                                            0) {
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) {
                                          return CheckoutWebview(
                                            strURL: resOrder.data,
                                            strOrderId:
                                                orderWrite.successOrderId,
                                          );
                                        },
                                      ));
                                    } else {
                                      String successOrderId =
                                          orderWrite.successOrderId;

                                      cartWatch.displayLoader(true);
                                      bool isDone =
                                          await orderWrite.orderDetails(
                                              context: context,
                                              orderId: successOrderId);
                                      cartWatch.displayLoader(false);

                                      if (isDone) {
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            PageRouteBuilder(
                                                transitionDuration: Duration(
                                                    milliseconds: pageDuration),
                                                pageBuilder: (_, __, ___) =>
                                                    OrderConfirmPage()),
                                            (Route<dynamic> route) => false);
                                      }
                                    }
                                  } else {
                                    showSnackBar(resOrder.message);
                                  }
                                },
                                title:
                                    "${AppTranslations.of(context).text("Key_placeOrder")}"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
      }),
    ));
  }

  Widget _addressDetailsWidget() {
    CustomerAddressList data = addressWatch.getCustomerAddressListData();
    return Card(
      elevation: 4,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(setSp(12))),
      child: Column(
        children: [
          Container(height: setHeight(125), child: _mapWidget()),
          Padding(
            padding: GlobalPadding.paddingAll_15,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  icMapPinDark,
                  height: setHeight(30),
                  width: setWidth(30),
                ),
                SizedBox(
                  width: setWidth(10),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data == null ? "No Any" : data.addressOf,
                      style: getTextStyle(context,
                          type: Type.styleBody1,
                          txtColor: GlobalColor.black,
                          fontFamily: sourceSansFontFamily,
                          fontWeight: fwSemiBold),
                    ),
                    SizedBox(
                      height: setHeight(10),
                    ),
                    SizedBox(
                      width: setWidth(162),
                      child: Text(
                        data == null
                            ? "No Any"
                            : data.buildingName +
                                ", " +
                                data.block +
                                ", " +
                                data.streetNo +
                                ", " +
                                data.areaName,
                        style: getTextStyle(context,
                            type: Type.styleBody1,
                            txtColor: GlobalColor.black,
                            fontFamily: sourceSansFontFamily,
                            fontWeight: fwRegular),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, selectAddressRoute)
                            .then((value) {
                          if (value != null) {
                            addressWatch.setCustomerAddressListData(value);
                            print(value);
                            _moveMapWidget(
                                addressWatch
                                    .getCustomerAddressListData()
                                    .latitude,
                                addressWatch
                                    .getCustomerAddressListData()
                                    .longitude);
                          }
                        });
                      },
                      child: Text(
                        "${AppTranslations.of(context).text("Key_Change")}",
                        style: getTextStyle(context,
                            type: Type.styleBody1,
                            txtColor: GlobalColor.black,
                            fontFamily: sourceSansFontFamily,
                            fontWeight: fwSemiBold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _mapWidget() {
    return GoogleMap(
      zoomControlsEnabled: true,
      myLocationButtonEnabled: false,
      markers: Set<Marker>.of(_markers.values),
      onMapCreated: (GoogleMapController controller) {
        // _mapController.complete(controller);
        if (addressWatch.getCustomerAddressListData().latitude != null) {
          MarkerId markerId = MarkerId(_markerIdVal());
          LatLng position = LatLng(
              addressWatch.getCustomerAddressListData().latitude,
              addressWatch.getCustomerAddressListData().longitude);
          Marker marker = Marker(
              markerId: markerId,
              position: position,
              draggable: false,
              infoWindow: InfoWindow(
                title: "",
              ),
              onTap: () {
                MapUtils.openMap(
                    addressWatch.getCustomerAddressListData().latitude,
                    addressWatch.getCustomerAddressListData().longitude);
              });

          try {
            setState(() {
              _markers[markerId] = marker;
            });
          } catch (err) {}

          Future.delayed(Duration(milliseconds: 600), () async {
            GoogleMapController controller = await _mapController.future;
            controller.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: position,
                  zoom: 12.0,
                ),
              ),
            );
          });
        }
      },
      initialCameraPosition: CameraPosition(
        target: LatLng(addressWatch.getCustomerAddressListData().latitude,
            addressWatch.getCustomerAddressListData().longitude),
        zoom: 12.0,
      ),
      compassEnabled: false,
      mapToolbarEnabled: false,

      // myLocationEnabled: true,
    );
  }

  String _markerIdVal({bool increment = false}) {
    String val = 'marker_id_$_markerIdCounter';
    if (increment) _markerIdCounter++;
    return val;
  }

  void showCreditCardDetailPopup() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        builder: (builder) {
          return Container(
            color: Colors.transparent,
            // height: setHeight(291),
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              padding: GlobalPadding.paddingSymmetricH_20,
              margin: GlobalPadding.paddingSymmetricV_25,
              decoration: new BoxDecoration(
                  // color: Colors.white,
                  borderRadius: new BorderRadius.only(
                      topLeft: Radius.circular(setSp(12)),
                      topRight: Radius.circular(setSp(12)))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "${AppTranslations.of(context).text("Key_EnterDetails")}",
                    style: getTextStyle(context,
                        type: Type.styleDrawerText,
                        fontFamily: sourceSansFontFamily,
                        fontWeight: fwBold,
                        txtColor: GlobalColor.black),
                  ),
                  SizedBox(
                    height: setHeight(25),
                  ),
                  TextField(
                    style: getTextStyle(context,
                        type: Type.styleBody1,
                        fontFamily: sourceSansFontFamily,
                        fontWeight: fwRegular,
                        txtColor: GlobalColor.black),
                    decoration: InputDecoration(
                      hintText: "Card number",
                      hintStyle: getTextStyle(context,
                          type: Type.styleBody1,
                          fontFamily: sourceSansFontFamily,
                          fontWeight: fwRegular,
                          txtColor: GlobalColor.grey),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          style: getTextStyle(context,
                              type: Type.styleBody1,
                              fontFamily: sourceSansFontFamily,
                              fontWeight: fwRegular,
                              txtColor: GlobalColor.black),
                          decoration: InputDecoration(
                            hintText: "MM/YY",
                            hintStyle: getTextStyle(context,
                                type: Type.styleBody1,
                                fontFamily: sourceSansFontFamily,
                                fontWeight: fwRegular,
                                txtColor: GlobalColor.grey),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: setWidth(15),
                      ),
                      Expanded(
                        child: TextField(
                          style: getTextStyle(context,
                              type: Type.styleBody1,
                              fontFamily: sourceSansFontFamily,
                              fontWeight: fwRegular,
                              txtColor: GlobalColor.black),
                          decoration: InputDecoration(
                            hintText: "CVV",
                            hintStyle: getTextStyle(context,
                                type: Type.styleBody1,
                                fontFamily: sourceSansFontFamily,
                                fontWeight: fwRegular,
                                txtColor: GlobalColor.grey),
                          ),
                        ),
                      ),
                    ],
                  ),

                  Padding(
                    padding: GlobalPadding.paddingSymmetricV_15,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total Amount",
                          style: getTextStyle(context,
                              type: Type.styleBody1,
                              fontFamily: sourceSansFontFamily,
                              fontWeight: fwBold,
                              txtColor: GlobalColor.black),
                        ),
                        Text(
                          "KD 8.000",
                          textAlign: TextAlign.center,
                          style: getTextStyle(context,
                              type: Type.styleBody1,
                              fontFamily: sourceSansFontFamily,
                              fontWeight: fwBold,
                              txtColor: GlobalColor.black),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    color: GlobalColor.grey,
                    height: setHeight(0.5),
                  ),

                  // TextField(
                  //   // enabled: false,
                  //   style: getTextStyle(context,
                  //       type: Type.styleBody1,
                  //       fontFamily: sourceSansFontFamily,
                  //       fontWeight: fwRegular,
                  //       txtColor: GlobalColor.black),
                  //   decoration: InputDecoration(
                  //     hintText: "Total Amount",
                  //     hintStyle: getTextStyle(context,
                  //         type: Type.styleBody1,
                  //         fontFamily: sourceSansFontFamily,
                  //         fontWeight: fwBold,
                  //         txtColor: GlobalColor.black),
                  //     // suffix: Text("MNBAd,abs"),
                  //     suffixIcon: Center(
                  //       child: Text(
                  //         "KD 8.000",
                  //         textAlign: TextAlign.center,
                  //         style: getTextStyle(context,
                  //             type: Type.styleBody1,
                  //             fontFamily: sourceSansFontFamily,
                  //             fontWeight: fwBold,
                  //             txtColor: GlobalColor.black),
                  //       ),
                  //     ),
                  //     // suffixText: "KD 8.000",
                  //     // suffixStyle: getTextStyle(context,
                  //     //     type: Type.styleBody1,
                  //     //     fontFamily: sourceSansFontFamily,
                  //     //     fontWeight: fwRegular,
                  //     //     txtColor: GlobalColor.black),
                  //   ),
                  // ),

                  SizedBox(
                    height: setHeight(30),
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: FlatCustomButton(
                              outline: true,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              title:
                                  "${AppTranslations.of(context).text("Key_Cancel")}")),
                      SizedBox(
                        width: setWidth(25),
                      ),
                      Expanded(
                          child: FlatCustomButton(
                              onPressed: () {
                                Navigator.pop(context);

                                // popupMenu("Pickup");
                              },
                              title:
                                  "${AppTranslations.of(context).text("Key_Pay")}"))
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget _paymentMode() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        "${AppTranslations.of(context).text("Key_PaymentMode")}",
        style: getTextStyle(context,
            type: Type.styleDrawerText,
            txtColor: GlobalColor.black,
            fontFamily: sourceSansFontFamily,
            fontWeight: fwSemiBold),
      ),
      SizedBox(
        height: setHeight(15),
      ),
      walletAmt(),
      SizedBox(
        height: setHeight(15),
      ),

      checkoutMaster.totalOrderAmount == 0 ?  Container() : Column(
        children: [
          (resVendorDetailsData.paymentMethod == static_Both ||
              resVendorDetailsData.paymentMethod == static_Online)
              ? _paymentCard(
              0, icPay, "${AppTranslations.of(context).text("Key_Online")}")
              : Container(),

          (resVendorDetailsData.paymentMethod == static_Both ||
              resVendorDetailsData.paymentMethod.toLowerCase() ==
                  static_COD.toLowerCase())
              ? SizedBox(
            height: setHeight(15),
          )
              : Container(),

          ((resVendorDetailsData.paymentMethod == static_Both ||
              resVendorDetailsData.paymentMethod.toLowerCase() ==
                  static_COD.toLowerCase()) &&
              cartWatch.radioValueDelPick == 0)
              ? _paymentCard(
              2, icCash, "${AppTranslations.of(context).text("Key_Cash")}")
              : Container(),

        ],
      ),

      //(resVendorDetailsData.deliveryType.toLowerCase() == "both" || resVendorDetailsData.deliveryType.toLowerCase() == static_Pick_Up.toLowerCase())
    ]);
  }

  Widget walletAmt() {
    if (checkoutMaster.customerWalletAmount == 0) {
      return Container();
    } else if (checkoutMaster.customerWalletAmount < 0) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: setHeight(18),
            width: setWidth(18),
            decoration: BoxDecoration(
                border: Border.all(), borderRadius: BorderRadius.circular(5)),
            // child: Image.asset(Const.icCheck),
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Image.asset(
                icCheckDark,
                color: GlobalColor.black,
                // size: setSp(8),
              ),
            ),
          ),
          SizedBox(
            width: setWidth(15),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${AppTranslations.of(context).text("Key_YourNICEWalletAmt")}",
                style: getTextStyle(context,
                    type: Type.styleBody1,
                    txtColor: GlobalColor.black,
                    fontFamily: sourceSansFontFamily,
                    fontWeight: fwSemiBold),
              ),
              SizedBox(
                height: setHeight(2),
              ),
              Text(
                "${AppTranslations.of(context).text("Key_kd")} " +
                    checkoutMaster.customerWalletAmount.toString(),
                style: getTextStyle(context,
                    type: Type.styleBody2,
                    txtColor: GlobalColor.grey,
                    fontFamily: sourceSansFontFamily,
                    fontWeight: fwSemiBold),
              ),
            ],
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              cartWatch.updateCheck();
              cartWatch.checkOutCartItem(
                  context: context,
                  deliveryType: cartWatch.radioValueDelPick == 0
                      ? static_Delivery
                      : static_Pick_Up,
                  useWallet: cartWatch.isChecked,
                  isFromInit: false);
            },
            child: Container(
              height: setHeight(18),
              width: setWidth(18),
              decoration: BoxDecoration(
                  border: Border.all(), borderRadius: BorderRadius.circular(5)),
              // child: Image.asset(Const.icCheck),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Image.asset(
                  icCheckDark,
                  color: cartWatch.isChecked
                      ? GlobalColor.black
                      : GlobalColor.white,
                  // size: setSp(8),
                ),
              ),
            ),
          ),
          SizedBox(
            width: setWidth(15),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${AppTranslations.of(context).text("Key_YourNICEWalletAmt")}",
                style: getTextStyle(context,
                    type: Type.styleBody1,
                    txtColor: GlobalColor.black,
                    fontFamily: sourceSansFontFamily,
                    fontWeight: fwSemiBold),
              ),
              SizedBox(
                height: setHeight(2),
              ),
              Text(
                "${AppTranslations.of(context).text("Key_kd")} " +
                    checkoutMaster.customerWalletAmount.toString(),
                style: getTextStyle(context,
                    type: Type.styleBody2,
                    txtColor: GlobalColor.grey,
                    fontFamily: sourceSansFontFamily,
                    fontWeight: fwSemiBold),
              ),
            ],
          ),
        ],
      );
    }
  }

  Widget _paymentCard(int _value, String icon, String title) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(setSp(12))),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: setHeight(15)),
        child: Row(
          children: [
            Radio(
              value: _value,
              groupValue: cartWatch.radioPayment,
              onChanged: _handlePaymentChange,
            ),
            SizedBox(
              width: setWidth(18),
            ),
            Image.asset(icon),
            SizedBox(
              width: setWidth(25),
            ),
            Text(
              title,
              style: getTextStyle(context,
                  type: Type.styleBody1,
                  txtColor: GlobalColor.black,
                  fontFamily: sourceSansFontFamily,
                  fontWeight: fwSemiBold),
            ),
            title.contains("Credit")
                ? Text(
                    "(Master/Visa)",
                    style: getTextStyle(context,
                        type: Type.styleBody1,
                        txtColor: GlobalColor.grey,
                        fontFamily: sourceSansFontFamily,
                        fontWeight: fwSemiBold),
                  )
                : Offstage()
          ],
        ),
      ),
    );
  }

  Widget _paymentSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${AppTranslations.of(context).text("Key_PaymentSummary")}",
          style: getTextStyle(context,
              type: Type.styleDrawerText,
              txtColor: GlobalColor.black,
              fontFamily: sourceSansFontFamily,
              fontWeight: fwSemiBold),
        ),
        SizedBox(
          height: setHeight(15),
        ),
        _rowSummary(
            "${AppTranslations.of(context).text("Key_subTotal")}",
            "${AppTranslations.of(context).text("Key_kd")} " +
                checkoutMaster.grossOrderAmount.toString()),
        SizedBox(
          height: setHeight(15),
        ),
        _rowSummary(
            "${AppTranslations.of(context).text("Key_DeliveryCharge")}",
            "${AppTranslations.of(context).text("Key_kd")} " +
                checkoutMaster.deliveryCharge.toString()),
        checkoutMaster.walletContribution > 0
            ? Column(
                children: <Widget>[
                  SizedBox(
                    height: setHeight(15),
                  ),
                  _rowSummary(
                      "${AppTranslations.of(context).text("Key_WalletContribution")}",
                      "${AppTranslations.of(context).text("Key_kd")} " +
                          checkoutMaster.walletContribution.toString()),
                ],
              )
            : Container(),
        SizedBox(
          height: setHeight(15),
        ),
        _rowSummary(
            "${AppTranslations.of(context).text("Key_TotalAmount")}",
            "${AppTranslations.of(context).text("Key_kd")} " +
                checkoutMaster.totalOrderAmount.toString()),
        /* SizedBox(
          height: setHeight(15),
        ),
        _rowSummary("Total Pay", "KD 4.000"),*/
      ],
    );
  }

  Widget _rowSummary(String title, String amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: getTextStyle(context,
              type: Type.styleBody1,
              txtColor: GlobalColor.black,
              fontFamily: sourceSansFontFamily,
              fontWeight: title.contains(
                      "${AppTranslations.of(context).text("Key_Total")}")
                  ? fwBold
                  : fwRegular),
        ),
        Text(
          amount,
          style: getTextStyle(context,
              type: Type.styleBody1,
              txtColor: GlobalColor.black,
              fontFamily: sourceSansFontFamily,
              fontWeight: title.contains(
                      "${AppTranslations.of(context).text("Key_Total")}")
                  ? fwBold
                  : fwRegular),
        ),
      ],
    );
  }

  Widget _vendorDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          cartItemList[0].vendorName,
          style: getTextStyle(context,
              type: Type.styleDrawerText,
              txtColor: GlobalColor.black,
              fontFamily: sourceSansFontFamily,
              fontWeight: fwSemiBold),
        ),
        SizedBox(
          height: setHeight(36.62),
        ),
        ListView.builder(
            itemCount: cartItemList.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, i) {
              return Padding(
                padding: EdgeInsets.only(bottom: setHeight(15)),
                child: ConfirmItemListTile(cartItemList[i]),
              );
            }),
        Container(
          color: GlobalColor.grey,
          height: setHeight(0.5),
        ),
        SizedBox(
          height: setHeight(25),
        ),
        Row(
          children: [
            Text(
              "${AppTranslations.of(context).text("Key_AddSpecialRequest")}",
              style: getTextStyle(context,
                  type: Type.styleBody1,
                  txtColor: GlobalColor.black,
                  fontFamily: sourceSansFontFamily,
                  fontWeight: fwBold),
            ),
            SizedBox(
              width: setWidth(10),
            ),
            Text(
              "${AppTranslations.of(context).text("Key_Optional")}",
              style: getTextStyle(context,
                  type: Type.styleBody1,
                  txtColor: GlobalColor.grey,
                  fontFamily: sourceSansFontFamily,
                  fontWeight: fwRegular),
            ),
          ],
        ),
        TextField(
          onChanged: (val) {
            cartWatch.updateRequest(val);
          },
          decoration: InputDecoration(
            hintText: "${AppTranslations.of(context).text("Key_tapEnterReq")}",
            hintStyle: getTextStyle(context,
                type: Type.styleBody1,
                txtColor: GlobalColor.grey,
                fontFamily: sourceSansFontFamily,
                fontWeight: fwRegular),
          ),
        ),
      ],
    );
  }

  Widget _radioButton(int _value, String _title) {
    if (_value == 0) {
      return Row(
        children: [
          Radio(
            value: _value,
            groupValue: cartWatch.radioValueDelPick,
            onChanged: _handleRadioValueChange,
          ),
          Text(
            _title,
            style: getTextStyle(context,
                type: Type.styleBody1,
                txtColor: GlobalColor.black,
                fontFamily: sourceSansFontFamily,
                fontWeight: fwSemiBold),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Radio(
            value: _value,
            groupValue: cartWatch.radioValueDelPick,
            onChanged: (_value) {
              cartWatch.radioPayment = 0;
              _handleRadioValueChange(_value);
            },
          ),
          Text(
            _title,
            style: getTextStyle(context,
                type: Type.styleBody1,
                txtColor: GlobalColor.black,
                fontFamily: sourceSansFontFamily,
                fontWeight: fwSemiBold),
          ),
        ],
      );
    }
  }


  void _handleRadioValueChange(int value) {
    setState(() {
      cartWatch.updateValueDelPick(value);

      cartWatch.checkOutCartItem(
          context: context,
          deliveryType:
              cartWatch.radioValueDelPick == 0 ? static_Delivery : static_Pick_Up,
          useWallet: cartWatch.isChecked,
          isFromInit: false);

      print("selected radio value $value");

      switch (cartWatch.radioValueDelPick) {
        case 0:
          _pickupVal = "";
          //setState(() {});
          break;

        case 1:
          _pickupVal = "";
          break;
      }
    });
  }

  void _handlePaymentChange(int value) {
    setState(() {
      cartWatch.updateValuePayment(value);
      print("PPP object $value");

      switch (cartWatch.radioPayment) {
        case 0:
          print("Open Credit Card Sheet");
          //showCreditCardDetailPopup();
          break;

        case 1:
          break;

        case 2:
          break;
      }
    });
  }

  apiCustomerAddressList(BuildContext context) async {
    addressWatch.setShowProgressBar(true);
    SharedPreferences pref = await SharedPreferences.getInstance();
    int customerID = pref.getInt(prefInt_ID);
    String accessToken = pref.getString(prefStr_ACCESS_TOKEN);
    String endpoint = ApiEndPoints.apiCustomerAddressList +
        "$customerID" +
        "/address/pageNumber/1/pageSize/100";

    addressID = pref.getInt(prefInt_AddressID);
    print("addressID.... $addressID");

    //clear list
    List<CustomerAddressList> arrCustomerAddressList = List();
    addressWatch.setCustomerAddressList(arrCustomerAddressList);

    Response response = await RestClient.getData(
      context,
      endpoint,
      accessToken,
    );

    print("URL: ${endpoint}");
    var isAddress = false;
    if (response.statusCode == 200) {
      CustomerAddressResponse getAddressResponce =
          customerAddressResponseFromJson(response.toString());
      showLog(
          "apiCustomerAddressList :-: ${customerAddressResponseToJson(getAddressResponce)}");

      if (getAddressResponce.status == ApiEndPoints.apiStatus_200) {
        if (getAddressResponce.data != null &&
            getAddressResponce.data.length > 0) {
          isAddress = false;
          for (int i = 0; i < getAddressResponce.data.length; i++) {
            if (getAddressResponce.data[i].id == addressID) {
              addressWatch
                  .setCustomerAddressListData(getAddressResponce.data[i]);
              addressWatch.setPosition(i);
              isAddress = true;
            } else {}
          }
          if (!isAddress) {
            addressWatch.setCustomerAddressListData(getAddressResponce.data[0]);
            addressWatch.setPosition(0);
          }
        }
      } else {
        showSnackBar(getAddressResponce.message);
      }
      addressWatch.setShowProgressBar(false);
    } else {
      addressWatch.setShowProgressBar(false);

      showSnackBar(errSomethingWentWrong);
    }
  }

  void _moveMapWidget(double lat, double long) async {
    MarkerId markerId = MarkerId(_markerIdVal());

    Future.delayed(Duration(milliseconds: 600), () async {
      GoogleMapController controller = await _mapController.future;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(lat, long),
            zoom: 12.0,
          ),
        ),
      );

      //create marker
      final Marker marker = Marker(
        markerId: markerId,
        position: LatLng(lat, long),
      );

      try {
        setState(() {
          _markers[markerId] = marker;
        });
      } catch (err) {}
    });
  }

  void showSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
        value,
        style: TextStyle(
          color: Color(clrWhite),
          fontSize: setSp(14),
        ),
      ),
      backgroundColor: Color(clrBlack),
      duration: Duration(seconds: 1),
    ));
  }
}
