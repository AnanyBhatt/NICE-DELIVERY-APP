import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nice_customer_app/Localization/app_translations.dart';
import 'package:nice_customer_app/api/responce/ProductResponce.dart';
import 'package:nice_customer_app/common/addTocartButton.dart';
import 'package:nice_customer_app/common/alertDialog.dart';
import 'package:nice_customer_app/common/appbar.dart';
import 'package:nice_customer_app/framework/repository/cart/model/AddCartModel.dart';
import 'package:nice_customer_app/framework/repository/cart/model/demo_data.dart';
import 'package:nice_customer_app/framework/stateprovidermodel/provider_cart.dart';
import 'package:nice_customer_app/mixins/const.dart';
import 'package:nice_customer_app/ui/cart/ProviderRestaurnatDetails.dart';
import 'package:nice_customer_app/ui/vendor_detail_category/add_on.dart';
import 'package:nice_customer_app/ui/vendor_detail_category/choice_crust.dart';
import 'package:nice_customer_app/ui/vendor_detail_category/extras.dart';
import 'package:nice_customer_app/ui/vendor_detail_category/toppings.dart';
import 'package:nice_customer_app/ui/vendor_detail_category/variants.dart';
import 'package:nice_customer_app/utils/color_.dart';
import 'package:nice_customer_app/utils/padding_.dart';
import 'package:nice_customer_app/utils/textstyle_.dart';
import 'package:provider/provider.dart';


class AddToCartPage extends StatefulWidget {

  Function refresh;
  ProductResponseList productResponseList;
  int intVendorID;
  bool manageInventory;
  AddToCartPage({this.refresh, this.intVendorID, this.productResponseList, this.manageInventory});

  @override
  AddToCartPageState createState() => AddToCartPageState();

}

class AddToCartPageState extends State<AddToCartPage> with Constants {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String foos = 'One';

  bool isExpanded = false;
  bool isChecked = false;

  ProviderCart cartWatch;

  @override
  void initState() {
    super.initState();

    var providerRestaurantDetails = Provider.of<ProviderRestaurantDetails>(context, listen: false);

    Future.delayed(Duration(milliseconds: 1), () {

      ProductResponseList productResponseList = widget.productResponseList;
      providerRestaurantDetails.setSingleCartTotalCounts(1);

      //-- set all default values...
      var productFoodType = providerRestaurantDetails.getProductResponseList().productFoodType;

      double itemAmount = (productResponseList.productVariantList[0].discountedRate != null && productResponseList.productVariantList[0].discountedRate.toString().length>0) ? productResponseList.productVariantList[0].discountedRate :  productResponseList.productVariantList[0].rate;

      //-- single product amout for variant
      providerRestaurantDetails.setarrSingleProductCart(arrSingleProductCart(true, providerRestaurantDetails,
          SingleProductCart(itemID: productResponseList.productVariantList[0].id, itemName: productResponseList.productVariantList[0].uomLabel, itemAmount: itemAmount,
              isChoiceOfCurst: false, isTopping: false, isAddOns: false, isExtras: false)));

      providerRestaurantDetails.setarrSingleProductCartExtras(new List<SingleProductCart>());

      //--  Extras
      providerRestaurantDetails.setarrProductExtrasList(getArrExtra(providerRestaurantDetails.getProductResponseList().productExtrasList));


      //-- set selected variant
      providerRestaurantDetails.setSelectedProductVariant(productResponseList.productVariantList[0].id);
      providerRestaurantDetails.setProductVariantList(productResponseList.productVariantList[0]);
      providerRestaurantDetails.setarrProductToppingsDtoList(getArrToppints(productResponseList.productVariantList[0].productToppingsDtoList));
      providerRestaurantDetails.setarrProductAddonsDtoList(getArrAddons(providerRestaurantDetails.getProductResponseList().productVariantList[0].productAddonsDtoList));
      providerRestaurantDetails.setarrProductAttributeValuesDtoList(getArrChoiceOfCrust(providerRestaurantDetails, providerRestaurantDetails.getProductResponseList().productVariantList[0].productAttributeValuesDtoList));



    });

  }


  @override
  Widget build(BuildContext context) {
    buildSetupScreenUtils(context);
    cartWatch=context.watch<ProviderCart>();

    return SafeArea(
      child: Scaffold(
        /*appBar: CommonAppBar(
            title: "",
            appBar: AppBar()),*/
        key: _scaffoldKey,
          backgroundColor: GlobalColor.white,
          body: cartWatch.isLoading ? Center(child: CircularProgressIndicator()) : Consumer<ProviderRestaurantDetails>(
            builder: (context, providerRestaurantDetails, child) {
              return Container(
                  height: infiniteSize,
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        child: Container(
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  Image.network(
                                    providerRestaurantDetails.getProductResponseList().detailImage,
                                    fit: BoxFit.cover,
                                    height: setHeight(164),
                                    width: infiniteSize,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(20.0),
                                    child: InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Image.asset(icArrowRound)),
                                  ),
                                ],
                              ),
                              Container(
                                width: infiniteSize,
                                padding: GlobalPadding.paddingSymmetricH_20,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: setHeight(21),
                                    ),
                                    Hero(
                                      tag: "${providerRestaurantDetails.getProductResponseList().name}",
                                      child: Material(
                                        type: MaterialType.transparency,
                                        child: Text(
                                          "${providerRestaurantDetails.getProductResponseList().name}",
                                          style: getTextStyle(
                                            context,
                                            type: Type.styleDrawerText,
                                            fontFamily: sourceSansFontFamily,
                                            fontWeight: fwBold,
                                            txtColor: GlobalColor.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: setHeight(10),
                                    ),
                                    Text(
                                      "${providerRestaurantDetails.getProductResponseList().description}",
                                      style: getTextStyle(
                                        context,
                                        type: Type.styleBody1,
                                        fontFamily: sourceSansFontFamily,
                                        fontWeight: fwRegular,
                                        txtColor: GlobalColor.black,
                                      ),
                                    ),
                                    SizedBox(
                                      height: setHeight(10),
                                    ),

                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      children: [
                                        (providerRestaurantDetails.getProductResponseList().productVariantList[0].discountedRate != null
                                            && providerRestaurantDetails.getProductResponseList().productVariantList[0].discountedRate.toString().length>0) ? Padding(
                                          padding: EdgeInsets.only(left: 10.0),
                                          child: Text("${AppTranslations.of(context).text("Key_kd")}" + providerRestaurantDetails.getProductResponseList().productVariantList[0].rate.toString(),
                                            style: getTextStyle(context,
                                                type: Type.styleBody1,
                                                fontFamily: sourceSansFontFamily,
                                                fontWeight: fwSemiBold,
                                                txtColor: GlobalColor.grey,
                                                decoration:
                                                TextDecoration.lineThrough),
                                          ),
                                        ) : Container(height: 0,),

                                        (providerRestaurantDetails.getProductResponseList().productVariantList[0].discountedRate != null
                                            && providerRestaurantDetails.getProductResponseList().productVariantList[0].discountedRate.toString().length>0) ? SizedBox(width: setWidth(10),) : Container(),

                                        Text(
                                          (providerRestaurantDetails.getProductResponseList().productVariantList[0].discountedRate != null
                                              && providerRestaurantDetails.getProductResponseList().productVariantList[0].discountedRate.toString().length>0)
                                              ? "${AppTranslations.of(context).text("Key_kd")}" + providerRestaurantDetails.getProductResponseList().productVariantList[0].discountedRate.toString() : "${AppTranslations.of(context).text("Key_kd")}" + providerRestaurantDetails.getProductResponseList().productVariantList[0].rate.toString(),
                                          style: getTextStyle(
                                            context,
                                            type: Type.styleBody1,
                                            fontFamily: sourceSansFontFamily,
                                            fontWeight: fwBold,
                                            txtColor: GlobalColor.black,
                                          ),
                                        ),
                                      ],
                                    ),


                                    SizedBox(height: setHeight(35),),

                                    providerRestaurantDetails.getProductResponseList().productVariantList.length == 0 ? Container()
                                        : Variants(widget.manageInventory, providerRestaurantDetails, providerRestaurantDetails.getProductResponseList().productVariantList),

                                    providerRestaurantDetails.getarrProductAttributeValuesDtoList().length == 0 ? Container()
                                        : ChoiceCrust(providerRestaurantDetails, providerRestaurantDetails.getarrProductAttributeValuesDtoList()),

                                    providerRestaurantDetails.getarrProductToppingsDtoList().length == 0 ? Container()
                                        : Toppings(providerRestaurantDetails, providerRestaurantDetails.getarrProductToppingsDtoList()),

                                    providerRestaurantDetails.getarrProductAddonsDtoList().length == 0 ? Container()
                                        : AddOn(providerRestaurantDetails, providerRestaurantDetails.getarrProductAddonsDtoList()),

                                    providerRestaurantDetails.getarrProductExtrasList().length == 0 ? Container()
                                        : Extras(providerRestaurantDetails, providerRestaurantDetails.getarrProductExtrasList()),



                                    SizedBox(
                                      height: setHeight(100),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 30,
                        left: 20,
                        right: 20,
                        child: SizedBox(
                          width: setWidth(335),
                          child: AddToCartButton(
                            onPressed: () async {

                              /// AddCartModel cartItem please generate this model from below code


                              print("......SingleCartProductAddonsId.......${providerRestaurantDetails.SingleCartProductAddonsId.length}");
                              print("......SingleCartProductExtrasId.......${providerRestaurantDetails.SingleCartProductExtrasId.length}");
                              print("......SingleCartAttributeValueIds.......${providerRestaurantDetails.SingleCartAttributeValueIds.length}");
                              print("......SingleCartProductToppingsIds.......${providerRestaurantDetails.SingleCartProductToppingsIds.length}");




                              AddCartModel cartItem= AddCartModel();
                              /*cartItem.productAddonsId.addAll(providerRestaurantDetails.SingleCartProductAddonsId);
                              cartItem.productExtrasId.addAll(providerRestaurantDetails.SingleCartProductExtrasId);
                              cartItem.attributeValueIds.addAll(providerRestaurantDetails.SingleCartAttributeValueIds);
                              cartItem.productToppingsIds.addAll(providerRestaurantDetails.SingleCartProductToppingsIds);
                              cartItem.productVariantId = providerRestaurantDetails.SingleCartVariantID;*/
                              cartItem.uuid="";
                              cartItem.active=true;
                              cartItem.productAddonsId=providerRestaurantDetails.SingleCartProductAddonsId;
                              cartItem.productExtrasId=providerRestaurantDetails.SingleCartProductExtrasId;
                              cartItem.attributeValueIds=providerRestaurantDetails.SingleCartAttributeValueIds;
                              cartItem.productToppingsIds=providerRestaurantDetails.SingleCartProductToppingsIds;
                              cartItem.productVariantId = providerRestaurantDetails.SingleCartVariantID;
                              cartItem.quantity=providerRestaurantDetails.SingleCartTotalCounts;

                              print("...cart..json....${json.encode(cartItem.toJson())}");

                              List<MainCart> temp = List();
                              temp.addAll(providerRestaurantDetails.getarrMainCart());
                              temp.add(MainCart(temp.length, providerRestaurantDetails.totalSingleCart, providerRestaurantDetails.getarrSingleProductCart()));
                              providerRestaurantDetails.setarrMainCart(temp);


                              String vendorId = widget.intVendorID.toString();

                             /// Check Valid cart item @params :- Vendor ID
                              /// if Response is true then Ask Dialog for clear cart , on yes button add cart

                             bool notValidCartItem = await cartWatch.checkCartItem(context, vendorId);

                             //print("........notValidCartItem.....$notValidCartItem");


                             if(notValidCartItem)
                               {
                                   showDialog(
                                context: _scaffoldKey.currentContext,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return CommonAlertDialog(
                                    title: cancelOrder,
                                    message:
                                    newCartMsg,
                                    onYesPressed: () {

                                      // Add to cart Api
                                      Navigator.pop(context);
                                      //AddCartModel cartItem = addCartModelFromJson(sampleDataCart);
                                      callAddToCartApi(_scaffoldKey.currentContext,cartWatch,cartItem);


                                    },
                                    onNoPressed: () {
                                      Navigator.pop(context);
                                    },
                                  );
                                },
                              );
                               }
                             else
                               {

                                 //AddCartModel cartItem = addCartModelFromJson(sampleDataCart);
                                callAddToCartApi(_scaffoldKey.currentContext,cartWatch,cartItem);


                               }





                    },

                            title: "${AppTranslations.of(context).text("Key_Addtocart")}",
                            trailing: "${AppTranslations.of(context).text("Key_Total")} ${AppTranslations.of(context).text("Key_kd")} ${providerRestaurantDetails.totalSingleCart.toDouble() * providerRestaurantDetails.getSingleCartTotalCounts().toDouble()}",
                            //trailing: "${AppTranslations.of(context).text("Key_Total")} ${AppTranslations.of(context).text("Key_kd")} ${double.parse(providerRestaurantDetails.totalSingleCart) * double.parse(providerRestaurantDetails.getSingleCartTotalCounts())}",
                          ),
                        ),
                      ),
                    ],
                  ));
            },
          ),

      ),
    );

  }







  /*
  * -- Clear all data and pass new array and data
  * */
  List<ProductToppingsDtoList> getArrToppints(List<ProductToppingsDtoList> arr){
    List<ProductToppingsDtoList> arrToppings = List();
    for(int i=0; i<arr.length; i++){
      arr[i].isSelectedTopping = false;
      arrToppings.add(arr[i]);
    }
    return arrToppings;
  }

  List<ProductExtrasList> getArrExtra(List<ProductExtrasList> arr){
    List<ProductExtrasList> arrExtras = List();
    for(int i=0; i<arr.length; i++){
      arr[i].isSelectedExtras = false;
      arrExtras.add(arr[i]);
    }
    return arrExtras;
  }

  List<ProductAddonsDtoList> getArrAddons(List<ProductAddonsDtoList> arr){
    List<ProductAddonsDtoList> arrAddons = List();
    for(int i=0; i<arr.length; i++){
      arr[i].isSelectedAddons = false;
      arrAddons.add(arr[i]);
    }
    return arrAddons;
  }

  List<ProductAttributeValuesDtoList> getArrChoiceOfCrust(ProviderRestaurantDetails providerRestaurantDetails, List<ProductAttributeValuesDtoList> arr){

    List<ProductAttributeValuesDtoList> arrChoiceOfCrust = List();
    for(int i=0; i<arr.length; i++){
      for(int j=0; j<arr[i].productAttributeValueList.length; j++){
        arr[i].productAttributeValueList[j].selectedID = null;
      }
      arrChoiceOfCrust.add(arr[i]);
    }


    List<ProductAttributeValueList> arrProductAttributeValueList = List();
    for(int p=0; p<arr.length; p++){

      //-- set ChoiceOfCrust 1st item prices
      providerRestaurantDetails.setarrSingleProductCart(arrSingleProductCart(false, providerRestaurantDetails,
          //SingleProductCart(arr[p].productAttributeValueList[0].id, arr[p].productAttributeValueList[0].attributeValue, arr[p].productAttributeValueList[0].rate.toInt(), 0)));
      SingleProductCart(itemID: arr[p].productAttributeValueList[0].id, itemName: arr[p].productAttributeValueList[0].attributeValue, itemAmount: arr[p].productAttributeValueList[0].rate,
          isChoiceOfCurst: true, isTopping: false, isAddOns: false, isExtras: false)));

      for(int q=0; q<arr[p].productAttributeValueList.length; q++){
        arr[p].productAttributeValueList[q].selectedID = arr[p].productAttributeValueList[0].id;
        print("selectedID : ${arr[p].productAttributeValueList[0].selectedID}");
      }

      arrProductAttributeValueList.addAll(arr[p].productAttributeValueList);


    }
    providerRestaurantDetails.setarrProductAttributeValueList(arrProductAttributeValueList);


    return arrChoiceOfCrust;
  }




  List<SingleProductCart> arrSingleProductCart(bool clearData, ProviderRestaurantDetails providerRestaurantDetails, SingleProductCart arr){
    List<SingleProductCart> arrSingleProductCart = List();

    if(clearData == true)
      arrSingleProductCart.clear();
    else {
      arrSingleProductCart.addAll(providerRestaurantDetails.getarrSingleProductCart());
    }

    arrSingleProductCart.add(arr);

    return arrSingleProductCart;
  }

  List<SingleProductCart> arrSingleProductCartExtra(bool clearData, ProviderRestaurantDetails providerRestaurantDetails, SingleProductCart arr){
    List<SingleProductCart> arrSingleProductCartExtra = List();

    if(clearData == true)
      arrSingleProductCartExtra.clear();
    else {
      arrSingleProductCartExtra.addAll(providerRestaurantDetails.getarrSingleProductCartExtras());
    }

    arrSingleProductCartExtra.add(arr);

    return arrSingleProductCartExtra;
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

  void callAddToCartApi(BuildContext context, ProviderCart cartWatch, AddCartModel cartItem) async{


     bool isSuccess =  await cartWatch.addCartItem(context, cartItem);

     print(".....callAddToCartApi.......$isSuccess");

     if(isSuccess)
       {

         widget.refresh();
       Navigator.pop(context);
       }
  }



}
