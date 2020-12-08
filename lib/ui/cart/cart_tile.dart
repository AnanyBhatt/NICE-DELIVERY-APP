import 'package:flutter/material.dart';
import 'package:nice_customer_app/common/alertDialog.dart';
import 'package:nice_customer_app/common/circle_button.dart';
import 'package:nice_customer_app/framework/repository/cart/model/ResCartList.dart';
import 'package:nice_customer_app/framework/stateprovidermodel/provider_cart.dart';
import 'package:nice_customer_app/mixins/const.dart';
import 'package:nice_customer_app/utils/color_.dart';
import 'package:nice_customer_app/utils/padding_.dart';
import 'package:nice_customer_app/utils/textstyle_.dart';
import 'package:provider/provider.dart';
import 'package:nice_customer_app/Localization/app_translations.dart';
import 'package:toast/toast.dart';

class CartListTile extends StatefulWidget {
  final int index;
  final CartItem cartItem;
  final Function refresh;
  bool manageInventory;
  CartListTile(
      {Key key, this.index, this.cartItem, this.refresh, this.manageInventory})
      : super(key: key);

  @override
  _CartListTileState createState() => _CartListTileState();
}

class _CartListTileState extends State<CartListTile> with Constants {
  ProductVariantResponseDto productVariantResponseDto;

  ProviderCart cartWatch;

  @override
  void initState() {
    // TODO: implement initState
    productVariantResponseDto = widget.cartItem.productVariantResponseDto;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    buildSetupScreenUtils(context);

    cartWatch = context.watch<ProviderCart>();

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.only(right: setWidth(30)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    height: setWidth(5),
                  ),
                  widget.index == 0
                      ? Material(
                          type: MaterialType.transparency,
                          child: Text(
                            productVariantResponseDto.productName +
                                "(" +
                                productVariantResponseDto.measurement +
                                ")",
                            style: getTextStyle(
                              context,
                              type: Type.styleHead,
                              fontFamily: sourceSansFontFamily,
                              fontWeight: fwBold,
                              txtColor: GlobalColor.black,
                            ),
                          ),
                        )
                      : Text(
                          productVariantResponseDto.productName +
                              "(" +
                              productVariantResponseDto.measurement +
                              ")",
                          style: getTextStyle(
                            context,
                            type: Type.styleHead,
                            fontFamily: sourceSansFontFamily,
                            fontWeight: fwBold,
                            txtColor: GlobalColor.black,
                          ),
                        ),
                  SizedBox(
                    height: setHeight(0),
                  ),
                  Container(
                    width: setWidth(235),
                    child: Text(
                      widget.cartItem.displayExtraStr,
                      style: getTextStyle(
                        context,
                        type: Type.styleBody2,
                        fontFamily: sourceSansFontFamily,
                        fontWeight: fwRegular,
                        txtColor: GlobalColor.grey,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: setHeight(15),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "${AppTranslations.of(context).text("Key_kd")} " +
                              widget.cartItem.displayAmt.toString(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: getTextStyle(
                            context,
                            type: Type.styleBody1,
                            fontFamily: sourceSansFontFamily,
                            fontWeight: fwBold,
                            txtColor: GlobalColor.black,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: setWidth(10),
                      ),
                      InkWell(
                        onTap: () async {
                          bool isAdded = await cartWatch.removeCartQty(
                              widget.index, widget.cartItem, context);

                          if (!isAdded) {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return CommonAlertDialog(
                                  title: removeItem,
                                  message: removeItemCart +
                                      " ${productVariantResponseDto.productName} " +
                                      fromCart,
                                  onYesPressed: () async {
                                    // Add to cart Api
                                    Navigator.pop(context);
                                    bool isDeleted =
                                        await cartWatch.deleteCartQty(
                                            widget.index,
                                            widget.cartItem,
                                            context);
                                    widget.refresh();
                                  },
                                  onNoPressed: () {
                                    Navigator.pop(context);
                                  },
                                );
                              },
                            );
                          } else {
                            widget.refresh();
                          }
                        },
                        child: Image.asset(
                          icMinus,
                        ),
                      ),
                      SizedBox(
                        width: setWidth(10),
                      ),
                      Text(
                        widget.cartItem.quantity.toString(),
                        style: getTextStyle(
                          context,
                          type: Type.styleDrawerText,
                          fontFamily: sourceSansFontFamily,
                          fontWeight: fwSemiBold,
                          txtColor: GlobalColor.black,
                        ),
                      ),
                      SizedBox(
                        width: setWidth(10),
                      ),
                      InkWell(
                        onTap: () async {
                          print("manageInventory : ${widget.manageInventory}");
                          print(
                              "availableQty : ${widget.cartItem.productVariantResponseDto.availableQty}");
                          print("quantity : ${widget.cartItem.quantity}");

                          //-- generelly used for Food Delivery Cateogry
                          if (widget.manageInventory == false) {
                            bool isAdded = await cartWatch.addCartQty(
                                widget.index, widget.cartItem, context);
                            widget.refresh();
                          }

                          //-- generelly used for Glocery, Fruite, Vegetables
                          if (widget.manageInventory == true &&
                              widget.cartItem.productVariantResponseDto
                                      .availableQty >
                                  0 &&
                              widget.cartItem.productVariantResponseDto
                                      .availableQty >
                                  widget.cartItem.quantity) {
                            bool isAdded = await cartWatch.addCartQty(
                                widget.index, widget.cartItem, context);
                            widget.refresh();
                          } else {
                            Toast.show(
                                "You have addded maximum available quantity}",
                                context,
                                duration: Toast.LENGTH_LONG,
                                gravity: Toast.BOTTOM);
                          }
                        },
                        child: Image.asset(
                          icPlus,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(setSp(15)),
                child: Image.network(
                  widget.cartItem.productVariantResponseDto.image,
                  fit: BoxFit.cover,
                  height: setWidth(80),
                  width: setWidth(80),
                ),
                /*child: Image.asset(
                    pizzaComboOffer,
                    fit: BoxFit.cover,
                    height: setWidth(80),
                    width: setWidth(80),
                  ),*/
              ),
              SizedBox(
                height: setWidth(10),
              ),
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return CommonAlertDialog(
                        title: removeItem,
                        message: removeItemCart +
                            " ${productVariantResponseDto.productName} " +
                            fromCart,
                        onYesPressed: () async {
                          // Add to cart Api
                          Navigator.pop(context);
                          bool isDeleted = await cartWatch.deleteCartQty(
                              widget.index, widget.cartItem, context);
                          widget.refresh();
                          print("...i am at delete...$isDeleted");
                        },
                        onNoPressed: () {
                          Navigator.pop(context);
                        },
                      );
                    },
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.delete,
                        color: Colors.grey,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  /*


  String getStr(CartItem cartItem) {

    String toppingStr="";
    String addOnStr="";
    String attributeStr="";
    String extraStr="";
    String finalStr="";

    List<ProductToppingsDtoList> productToppingsDtoList=List();
    List<ProductAddonsDtoList> productAddonsDtoList=List();
    List<ProductAttributeValuesDtoList> productAttributeValuesDtoList=List();
    List<ProductExtrasDtoList> productExtrasDtoList=List();

    productToppingsDtoList=cartItem.productVariantResponseDto.productToppingsDtoList;
    productAddonsDtoList=cartItem.productVariantResponseDto.productAddonsDtoList;
    productAttributeValuesDtoList=cartItem.productVariantResponseDto.productAttributeValuesDtoList;
    productExtrasDtoList=cartItem.productExtrasDtoList;


    if(productToppingsDtoList.isNotEmpty)
    {

      List<String> tempStrList=List();
      for(ProductToppingsDtoList item in productToppingsDtoList)
      {
        tempStrList.add(item.name);
      }
      toppingStr = "Topping:- "+ tempStrList.join(', ');
    }

    if(productAddonsDtoList.isNotEmpty)
    {

      List<String> tempStrList=List();
      for(ProductAddonsDtoList item in productAddonsDtoList)
      {
        tempStrList.add(item.addonsName);
      }
      addOnStr = "\n Add On:- "+ tempStrList.join(', ');
    }


    if(productAttributeValuesDtoList.isNotEmpty)
    {

      List<String> tempStrList=List();
      for(ProductAttributeValuesDtoList item in productAttributeValuesDtoList)
      {
        String attributeName=item.attributeName;
        List<ProductAttributeValueList> productAttributeValueList=item.productAttributeValueList;
        String attributeVal=productAttributeValueList[0].attributeValue;

        tempStrList.add(attributeName + " ( $attributeVal )");
      }
      attributeStr = "\n"+ tempStrList.join(', ');
    }

    if(productExtrasDtoList.isNotEmpty)
    {

      List<String> tempStrList=List();
      for(ProductExtrasDtoList item in productExtrasDtoList)
      {
        tempStrList.add(item.name);
      }
      extraStr = "\n Extras:- "+ tempStrList.join(', ');
    }












    finalStr = toppingStr + addOnStr + attributeStr + extraStr;

    print("....finalStr...$finalStr");



    return finalStr;

  }


  String getCount(CartItem cartItem) {

    double toppingCount=0.0;
    double addOnCount=0.0;
    double attributeCount=0.0;
    double extraCount=0.0;
    double finalCount=0.0;

    List<ProductToppingsDtoList> productToppingsDtoList=List();
    List<ProductAddonsDtoList> productAddonsDtoList=List();
    List<ProductAttributeValuesDtoList> productAttributeValuesDtoList=List();
    List<ProductExtrasDtoList> productExtrasDtoList=List();

    productToppingsDtoList=cartItem.productVariantResponseDto.productToppingsDtoList;
    productAddonsDtoList=cartItem.productVariantResponseDto.productAddonsDtoList;
    productAttributeValuesDtoList=cartItem.productVariantResponseDto.productAttributeValuesDtoList;
    productExtrasDtoList=cartItem.productExtrasDtoList;


    if(productToppingsDtoList.isNotEmpty)
    {


      for(ProductToppingsDtoList item in productToppingsDtoList)
      {
        toppingCount = toppingCount+item.rate;
      }

    }

    if(productAddonsDtoList.isNotEmpty)
    {

      List<String> tempStrList=List();
      for(ProductAddonsDtoList item in productAddonsDtoList)
      {
        addOnCount = addOnCount+item.rate;
      }

    }


    if(productAttributeValuesDtoList.isNotEmpty)
    {

      for(ProductAttributeValuesDtoList item in productAttributeValuesDtoList)
      {
        List<ProductAttributeValueList> productAttributeValueList=item.productAttributeValueList;
        attributeCount=attributeCount+productAttributeValueList[0].rate;


      }

    }

    if(productExtrasDtoList.isNotEmpty)
    {

      for(ProductExtrasDtoList item in productExtrasDtoList)
      {
        extraCount = extraCount+item.rate;
      }

    }



    finalCount = toppingCount + addOnCount + attributeCount + extraCount;




    return finalCount.toString();

  }

*/
}
