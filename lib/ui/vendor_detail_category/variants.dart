import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:nice_customer_app/Localization/app_translations.dart';
import 'package:nice_customer_app/api/responce/ProductResponce.dart';
import 'package:nice_customer_app/mixins/const.dart';
import 'package:nice_customer_app/ui/add_to_cart/add_to_cart.dart';
import 'package:nice_customer_app/ui/cart/ProviderRestaurnatDetails.dart';
import 'package:nice_customer_app/utils/color_.dart';
import 'package:nice_customer_app/utils/padding_.dart';
import 'package:nice_customer_app/utils/textstyle_.dart';

class Variants extends StatefulWidget {

  ProviderRestaurantDetails providerRestaurantDetails;
  List<ProductVariantList> productVariantList;
  bool manageInventory;

  Variants(this.manageInventory, this.providerRestaurantDetails, this.productVariantList);

  @override
  _VariantsState createState() => _VariantsState();
}

class _VariantsState extends State<Variants> with Constants {
  bool isExpanded = false;
  bool isChecked = false;


  @override
  Widget build(BuildContext context) {
    buildSetupScreenUtils(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        InkWell(
          splashColor: Colors.white,
          onTap: () {
            isExpanded = !isExpanded;
            setState(() {});
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "${AppTranslations.of(context).text("Key_Variants")}",
                style: getTextStyle(
                  context,
                  type: Type.styleDrawerText,
                  fontFamily: sourceSansFontFamily,
                  fontWeight: fwBold,
                  txtColor: GlobalColor.black,
                ),
              ),
              Align(
                  alignment: Alignment.centerRight,
                  child: Image.asset(
                    isExpanded ? upArrow : icDropDownArrow,
                    color: GlobalColor.black,
                  )),
              Text(
                "${AppTranslations.of(context).text("Key_LookforanotherVariant")}",
                style: getTextStyle(
                  context,
                  type: Type.styleBody1,
                  fontFamily: sourceSansFontFamily,
                  fontWeight: fwRegular,
                  txtColor: GlobalColor.grey,
                ),
              ),
            ],
          ),
        ),

        Visibility(
          visible: isExpanded,
          child: ListView.separated(
              itemCount: widget.providerRestaurantDetails.getProductResponseList().productVariantList.length,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              separatorBuilder: (BuildContext context, int index) => Padding(padding: EdgeInsets.only(top: 10, ),),
              itemBuilder: (BuildContext context, int index) {

                int singleAddedVariantQty=0;

                if (widget.providerRestaurantDetails.getProductResponseList().productVariantList[index].cartQtyList != null && widget.providerRestaurantDetails.getProductResponseList().productVariantList[index].cartQtyList.length > 0) {

                  for (int i = 0; i < widget.providerRestaurantDetails.getProductResponseList().productVariantList[index].cartQtyList.length; i++) {
                    singleAddedVariantQty = singleAddedVariantQty + widget.providerRestaurantDetails.getProductResponseList().productVariantList[index].cartQtyList[i];
                  }
                }


                if(widget.manageInventory == false){
                  return _variantsListRow(widget.providerRestaurantDetails, widget.providerRestaurantDetails.getProductResponseList().productVariantList[index]);
                }

                else if(widget.manageInventory == true && widget.providerRestaurantDetails.getProductResponseList().productVariantList[index].availableQty>0
                    && widget.providerRestaurantDetails.getProductResponseList().productVariantList[index].availableQty > singleAddedVariantQty){
                  return _variantsListRow(widget.providerRestaurantDetails, widget.providerRestaurantDetails.getProductResponseList().productVariantList[index]);
                }

                else{
                  return Container();
                }

              }),
        ),
        Container(
          margin: GlobalPadding.paddingSymmetricV_25,
          color: GlobalColor.black,
          height: setHeight(0.5),
        ),
      ],
    );
  }

  Widget _variantsListRow(ProviderRestaurantDetails providerRestaurantDetails, ProductVariantList productVariantList) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${productVariantList.measurement}",
              style: getTextStyle(
                context,
                type: Type.styleBody1,
                fontFamily: sourceSansFontFamily,
                fontWeight: fwSemiBold,
                txtColor: GlobalColor.black,
              ),
            ),
            SizedBox(height: setHeight(5)),

            Row(
              mainAxisAlignment:
              MainAxisAlignment.start,
              children: [
                (productVariantList.discountedRate != null
                    && productVariantList.discountedRate.toString().length>0)
                    ? Text(currency + productVariantList.rate.toString(),
                  style: getTextStyle(
                    context,
                    type: Type.styleBody1,
                    fontFamily: sourceSansFontFamily,
                    fontWeight: fwBold,
                    decoration: TextDecoration.lineThrough,
                    txtColor: GlobalColor.grey,
                  ),
                ) : Container(height: 0,),

                (productVariantList.discountedRate != null
                    && productVariantList.discountedRate.toString().length>0) ? SizedBox(width: setWidth(5),) : Container(),

                Text(
                  (productVariantList.discountedRate != null
                      && productVariantList.discountedRate.toString().length>0)
                      ? currency + productVariantList.discountedRate.toString() : currency + productVariantList.rate.toString(),
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
          ],
        ),

        Spacer(),

        Container(
          width: setWidth(70.0),
          height: setWidth(20.0),
          child: Theme(
            data: ThemeData(
                unselectedWidgetColor: Color(clrGreyLightest),
                accentColor: Color(clrPrimaryBg)
            ),
            child: RadioButton(
                textPosition: RadioButtonTextPosition.left,
                description: "",
                value: productVariantList.id,
                groupValue: providerRestaurantDetails.getSelectedProductVariant(),
                onChanged: (value) {

                  double itemAmount = (productVariantList.discountedRate != null && productVariantList.discountedRate.toString().length>0) ? productVariantList.discountedRate :  productVariantList.rate;

                  //--
                  providerRestaurantDetails.setarrSingleProductCart(AddToCartPageState().arrSingleProductCart(true, providerRestaurantDetails,
                      SingleProductCart(itemID: productVariantList.id, itemName: productVariantList.uomLabel, itemAmount: itemAmount,
                          isChoiceOfCurst: false, isTopping: false, isAddOns: false, isExtras: false)));


                  //--
                  List<SingleProductCart> temp = List();
                  temp.addAll(providerRestaurantDetails.getarrSingleProductCartExtras());
                  temp.addAll(providerRestaurantDetails.getarrSingleProductCart());
                  providerRestaurantDetails.setarrSingleProductCart(temp);


                  providerRestaurantDetails.setSelectedProductVariant(value);
                  providerRestaurantDetails.setProductVariantList(productVariantList);
                  providerRestaurantDetails.setarrProductToppingsDtoList(AddToCartPageState().getArrToppints(productVariantList.productToppingsDtoList));
                  providerRestaurantDetails.setarrProductAddonsDtoList(AddToCartPageState().getArrAddons(productVariantList.productAddonsDtoList));
                  providerRestaurantDetails.setarrProductAttributeValuesDtoList(AddToCartPageState().getArrChoiceOfCrust(providerRestaurantDetails, productVariantList.productAttributeValuesDtoList));

                }
            ),
          ),
        ),

      ],
    );
  }
}
