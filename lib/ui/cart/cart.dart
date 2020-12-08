import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:nice_customer_app/Localization/app_translations.dart';
import 'package:nice_customer_app/common/alertDialog.dart';
import 'package:nice_customer_app/common/appbar.dart';
import 'package:nice_customer_app/common/flaticonbutton.dart';
import 'package:nice_customer_app/common/no_data_cart.dart';
import 'package:nice_customer_app/framework/stateprovidermodel/provider_cart.dart';
import 'package:nice_customer_app/mixins/const.dart';
import 'package:nice_customer_app/ui/cart/cart_tile.dart';
import 'package:nice_customer_app/ui/checkout/checkout.dart';
import 'package:nice_customer_app/ui/login/login.dart';
import 'package:nice_customer_app/utils/color_.dart';
import 'package:nice_customer_app/utils/padding_.dart';
import 'package:nice_customer_app/utils/textstyle_.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartPage extends StatefulWidget {
  Function refresh;
  bool manageInventory;
  CartPage({this.refresh, this.manageInventory});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> with Constants {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ProviderCart cartRead;
  ProviderCart cartWatch;

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      cartRead = context.read<ProviderCart>();
      await cartRead.getAllCartItemList(context);
      int vendorId= cartRead.vendorId;

      if(vendorId>0)
        {
          cartRead.getVendorDetails(context, vendorId.toString());
        }


    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    buildSetupScreenUtils(context);
    cartWatch = context.watch<ProviderCart>();



    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: GlobalColor.white,
        appBar: CommonAppBar(
          appBar: AppBar(),
          title: "${AppTranslations.of(context).text("Key_cart")}",
        ),
        body: cartWatch.isLoading
            ? Center(child: CircularProgressIndicator())
            : cartWatch.cartList.isEmpty
                ? NoDataCart()
                : Container(
                    padding: GlobalPadding.paddingSymmetricH_20,
                    child: Column(
                      children: [
                        Center(
                          child: Text(
                            cartWatch.cartList[0].vendorName,
                            style: getTextStyle(context,
                                type: Type.styleBody2,
                                fontFamily: sourceSansFontFamily,
                                fontWeight: fwRegular,
                                txtColor: GlobalColor.grey),
                          ),
                        ),
                        SizedBox(
                          height: setHeight(25),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Container(
                              child: Column(
                                children: [
                                  _getCartItemList(cartWatch),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${AppTranslations.of(context).text("Key_subTotal")}",
                                        style: getTextStyle(context,
                                            type: Type.styleHead,
                                            fontFamily: sourceSansFontFamily,
                                            fontWeight: fwRegular,
                                            txtColor: GlobalColor.black),
                                      ),
                                      Text(
                                        "${AppTranslations.of(context).text("Key_kd")} "+  cartWatch.totCartAmount.toString(),
                                        style: getTextStyle(context,
                                            type: Type.styleHead,
                                            fontFamily: sourceSansFontFamily,
                                            fontWeight: fwBold,
                                            txtColor: GlobalColor.black),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          color: GlobalColor.grey,
                          height: setHeight(1),
                        ),
                        SizedBox(
                          height: setHeight(25),
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: FlatCustomButton(
                                    outline: true,
                                    onPressed: () {

                                      if(widget.refresh != null){
                                        widget.refresh();
                                      }

                                      Navigator.pop(context);
                                    },
                                    title:
                                        "${AppTranslations.of(context).text("Key_addMore")}")),
                            SizedBox(
                              width: setWidth(25),
                            ),
                            Expanded(
                                child: FlatCustomButton(
                                    onPressed: () async {
                                      SharedPreferences pref = await SharedPreferences.getInstance();
                                      int customerID = pref.getInt(prefInt_ID);

                                      if (customerID != null) {

                                        if(cartWatch.totCartAmount >= cartWatch.resVendorDetailsData.minimumOrderAmt){
                                          (cartWatch.resVendorDetailsData.deliveryType.toLowerCase() == "both" || cartWatch.resVendorDetailsData.deliveryType.toLowerCase() == static_Delivery.toLowerCase())
                                              ? (cartWatch.radioValueDelPick = 0) : (cartWatch.radioValueDelPick = 1);

                                          (cartWatch.resVendorDetailsData.deliveryType == static_Both || cartWatch.resVendorDetailsData.paymentMethod == static_Online)
                                              ? (cartWatch.radioPayment = 0) : (cartWatch.radioPayment = 2);

                                          Navigator.push(
                                              context,
                                              PageRouteBuilder(
                                                  transitionDuration: Duration(
                                                      milliseconds: pageDuration),
                                                  pageBuilder: (_, __, ___) =>
                                                      CheckoutPage()));
                                        }
                                        else{
                                          showDialogMinimumAmout(context, cartWatch.resVendorDetailsData.minimumOrderAmt);
                                        }


                                      } else {

                                        showDialogLogin(context);
                                      }
                                    },
                                    title:
                                        "${AppTranslations.of(context).text("Key_checkout")}")),
                          ],
                        ),
                        SizedBox(
                          height: setHeight(20),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }

  Widget _getCartItemList(ProviderCart cartWatch) {
    return ListView.builder(
        itemCount: cartWatch.cartList.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, i) {
          return Container(
            child: Column(
              children: [
                CartListTile(
                  index: i,
                  cartItem: cartWatch.cartList[i],
                  refresh: widget.refresh,
                  manageInventory: widget.manageInventory,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: setHeight(15)),
                  child: Divider(
                    color: GlobalColor.grey,
                    thickness: setHeight(1),
                  ),
                )
              ],
            ),
          );
        });
  }


  showDialogLogin(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CommonAlertDialog(
          title: "${AppTranslations.of(context).text("key_logIn")}",
          message: "${AppTranslations.of(context).text("Key_Pleaseloginforfurtherprocess")}",
          onYesPressed: () async {

            Navigator.pop(context);

            await Navigator.push(
                context,
                PageRouteBuilder(
                    transitionDuration: Duration(
                        milliseconds: pageDuration),
                    pageBuilder: (_, __, ___) =>
                        LoginPage(
                          fromCheckoutPage: true,
                        )));


          },
          onNoPressed: () {
            Navigator.pop(context);
          },
        );
      },
    );
  }

  showDialogMinimumAmout(BuildContext context, double minimumOrderAmt) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CommonAlertDialog(
          title: "${AppTranslations.of(context).text("key_MinimumAmount")}",
          message: "${AppTranslations.of(context).text("key_Pleaseaddmoreitems")} $minimumOrderAmt",
          onYesPressed: () async {

            Navigator.pop(context);

            if(widget.refresh != null){
              widget.refresh();
            }

            Navigator.pop(context);

          },
          onNoPressed: () {
            Navigator.pop(context);
          },
        );
      },
    );
  }


}
