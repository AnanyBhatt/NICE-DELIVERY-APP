import 'package:flutter/material.dart';
import 'package:nice_customer_app/Localization/app_translations.dart';
import 'package:nice_customer_app/common/flaticonbutton.dart';
import 'package:nice_customer_app/framework/repository/order/model/ResOrderDetails.dart';
import 'package:nice_customer_app/framework/stateprovidermodel/provider_cart.dart';
import 'package:nice_customer_app/framework/stateprovidermodel/provider_order.dart';
import 'package:nice_customer_app/mixins/const.dart';
import 'package:nice_customer_app/ui/home/home.dart';
import 'package:nice_customer_app/utils/color_.dart';
import 'package:nice_customer_app/utils/padding_.dart';
import 'package:nice_customer_app/utils/textstyle_.dart';
import 'package:provider/provider.dart';

class OrderConfirmPage extends StatefulWidget {
  OrderConfirmPage({Key key}) : super(key: key);

  @override
  _OrderConfirmPageState createState() => _OrderConfirmPageState();
}

class _OrderConfirmPageState extends State<OrderConfirmPage> with Constants {
  ProviderOrder orderRead;
  ProviderOrder orderWrite;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    buildSetupScreenUtils(context);
    orderWrite = context.watch<ProviderOrder>();

    return SafeArea(

      child: Scaffold(
        backgroundColor: GlobalColor.white,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            "${AppTranslations.of(context).text("Key_OrderConfirm")}" ?? "",
            style: getTextStyle(
              context,
              type: Type.styleBody1,
              fontFamily: sourceSansFontFamily,
              fontWeight: fwBold,
              txtColor: GlobalColor.black,
            ),
          ),
          elevation: 0,
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: GlobalColor.black,
              ),
              onPressed: () {
                onWillPop();
              }),
        ),
        body: WillPopScope(
            child: orderWrite.isLoading
            ? Center(child: CircularProgressIndicator(),)
            : SingleChildScrollView(
          child: Container(
            padding: GlobalPadding.paddingSymmetricH_20,
            child: Column(
              children: [
                Center(
                  child: Image.asset(
                    icOrderConfirm,
                    height: setHeight(191.13),
                    width: setWidth(191.13),
                  ),
                ),
                SizedBox(
                  height: setHeight(13.14),
                ),
                Material(
                  type: MaterialType.transparency,
                  child: Text(
                    "${AppTranslations.of(context).text("Key_orderStatus")}" ??
                        "",
                    style: getTextStyle(
                      context,
                      type: Type.styleBody1,
                      fontFamily: sourceSansFontFamily,
                      fontWeight: fwRegular,
                      txtColor: GlobalColor.grey,
                    ),
                  ),
                ),
                SizedBox(
                  height: setHeight(10),
                ),
                Text(
                  "${AppTranslations.of(context).text("Key_OrderConfirm")}" ?? "",
                  style: TextStyle(
                    fontSize: setSp(20),
                    fontFamily: sourceSansFontFamily,
                    fontWeight: fwBold,
                    color: GlobalColor.black,
                  ),
                ),
                SizedBox(
                  height: setHeight(25),
                ),
                orderWrite.orderMaster.address == null ? Container(): _addressDetail(),
                //orderWrite.orderMaster.address == null ?  Container() :  _addressDetail(),
                SizedBox(
                  height: setHeight(25),
                ),
                _itemDetail(),
                SizedBox(
                  height: setHeight(25),
                ),
                _menuDetail(),
                SizedBox(
                  height: setHeight(25),
                ),
                Material(
                  type: MaterialType.transparency,
                  child: SizedBox(
                      width: infiniteSize,
                      height: setHeight(44),
                      child: FlatCustomButton(
                          onPressed: () {
                            onWillPop();
                          },
                          title:
                          "${AppTranslations.of(context).text("Key_shopMore")}")),
                ),
                SizedBox(
                  height: setHeight(25),
                ),
              ],
            ),
          ),
        ),
            onWillPop: onWillPop
        ),
      ),

    );
  }


  Future<bool> onWillPop() {
    context
        .read<ProviderCart>()
        .clearCartProvider();

    Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
            transitionDuration: Duration(
                milliseconds: pageDuration),
            pageBuilder: (_, __, ___) => HomePage(
              isStatus: false,
            )),
            (Route<dynamic> route) => false);

    //Navigator.pushReplacementNamed(context, homeRoute);

  }


  Widget _addressDetail() {

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(setSp(12)))),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Padding(
        padding: GlobalPadding.paddingAll_15,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              icMapPinDark,
              color: GlobalColor.black,
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
                  "${AppTranslations.of(context).text("Key_Address")}" ?? "",
                  style: getTextStyle(
                    context,
                    type: Type.styleBody1,
                    fontFamily: sourceSansFontFamily,
                    fontWeight: fwSemiBold,
                    txtColor: GlobalColor.black,
                  ),
                ),
                SizedBox(
                  height: setHeight(10),
                ),
                Container(
                  width: setWidth(203),
                  child: Text(
                    orderWrite.orderMaster.address ?? "",
                    style: getTextStyle(
                      context,
                      type: Type.styleBody1,
                      fontFamily: sourceSansFontFamily,
                      fontWeight: fwRegular,
                      txtColor: GlobalColor.grey,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _itemDetail() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(setSp(12)))),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Padding(
        padding: GlobalPadding.paddingAll_15,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              icShoppingBag,
              color: GlobalColor.black,
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
                  orderWrite.orderMaster.vendorName ?? "",
                  style: getTextStyle(
                    context,
                    type: Type.styleBody1,
                    fontFamily: sourceSansFontFamily,
                    fontWeight: fwSemiBold,
                    txtColor: GlobalColor.black,
                  ),
                ),
                SizedBox(
                  height: setHeight(10),
                ),
                Column(
                  children: _buildItemsData(orderWrite.orderItemList.length),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _buildItemsData(int count) {
    List<Widget> places = [];
    for (int i = 0; i < count; i++) {
      places.add(
        Container(
          margin: EdgeInsets.only(top: setHeight(15)),
          child: _itemDetailData(orderWrite.orderItemList[i]),
        ),
      );
    }
    return places;
  }

  Widget _itemDetailData(OrderItemResponseDtoList orderItem) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          orderItem?.orderQty.toString() ?? "",
          style: getTextStyle(context,
              type: Type.styleBody1,
              fontFamily: sourceSansFontFamily,
              fontWeight: fwRegular,
              txtColor: GlobalColor.black),
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
      ],
    );
  }

  Widget _menuDetail() {

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(setSp(12)))),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Container(
        padding: GlobalPadding.paddingAll_15,
        margin: EdgeInsets.symmetric(horizontal: setWidth(10)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _menuDetailData(
                "${AppTranslations.of(context).text("Key_Ordernumber")}", orderWrite.orderMaster.id.toString()),
            _menuDetailData("${AppTranslations.of(context).text("Key_Orderamount")}", "${AppTranslations.of(context).text("Key_kd")} "+orderWrite.orderMaster.customerTotalOrderAmount.toString()),
            _menuDetailData("${AppTranslations.of(context).text("Key_Payment")}", orderWrite.orderMaster.paymentMode),
          ],
        ),
      ),
    );
  }

  Widget _menuDetailData(String title, String body) {
    return Column(
      children: [
        Text(
          title ?? "",
          style: getTextStyle(context,
              type: Type.styleBody2,
              fontFamily: sourceSansFontFamily,
              fontWeight: fwRegular,
              txtColor: GlobalColor.grey),
        ),
        SizedBox(
          height: setHeight(5),
        ),
        Text(
          body ?? "",
          style: getTextStyle(context,
              type: Type.styleBody1,
              fontFamily: sourceSansFontFamily,
              fontWeight: fwRegular,
              txtColor: GlobalColor.black),
        ),
      ],
    );
  }
}
