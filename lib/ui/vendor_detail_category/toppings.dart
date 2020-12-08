import 'package:flutter/material.dart';
import 'package:nice_customer_app/Localization/app_translations.dart';
import 'package:nice_customer_app/api/responce/ProductResponce.dart';
import 'package:nice_customer_app/mixins/const.dart';
import 'package:nice_customer_app/ui/add_to_cart/add_to_cart.dart';
import 'package:nice_customer_app/ui/cart/ProviderRestaurnatDetails.dart';
import 'package:nice_customer_app/utils/color_.dart';
import 'package:nice_customer_app/utils/padding_.dart';
import 'package:nice_customer_app/utils/textstyle_.dart';

class Toppings extends StatefulWidget {

  ProviderRestaurantDetails providerRestaurantDetails;
  List<ProductToppingsDtoList> arrProductToppingsDtoList;

  Toppings(this.providerRestaurantDetails, this.arrProductToppingsDtoList);

  @override
  _ToppingsState createState() => _ToppingsState();
}

class _ToppingsState extends State<Toppings> with Constants {
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
                "${AppTranslations.of(context).text("Key_Toppings")}",
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
                isExpanded ? "${AppTranslations.of(context).text("Key_LookforanotherVariant")}" : "${AppTranslations.of(context).text("Key_ChoosetheToppings")}",
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
              itemCount: widget.providerRestaurantDetails.getarrProductToppingsDtoList().length,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              separatorBuilder: (BuildContext context, int index) => Padding(padding: new EdgeInsets.only(top: 0, ),),
              itemBuilder: (BuildContext context, int index) {
                return _bottomSheetToppingsDtoList(widget.providerRestaurantDetails, widget.providerRestaurantDetails.getarrProductToppingsDtoList()[index]);
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

  Widget _bottomSheetToppingsDtoList(ProviderRestaurantDetails providerRestaurantDetails, ProductToppingsDtoList productToppingsDtoList){

    return Column(
      children: [
        Row(
          children: [

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: setHeight(10)),
                Text(
                  productToppingsDtoList.name,
                  style: getTextStyle(
                    context,
                    type: Type.styleBody1,
                    fontFamily: sourceSansFontFamily,
                    fontWeight: fwSemiBold,
                    txtColor: GlobalColor.black,
                  ),
                ),
                SizedBox(height: setHeight(5)),
                Text(
                  productToppingsDtoList.rate.toString(),
                  style: getTextStyle(
                    context,
                    type: Type.styleBody2,
                    fontFamily: sourceSansFontFamily,
                    fontWeight: fwSemiBold,
                    txtColor: GlobalColor.grey,
                  ),
                ),
              ],
            ),
            Spacer(),
            Container(
              width: setWidth(10.0),
              height: setWidth(10.0),
              margin: EdgeInsets.only(right: setWidth(20.0),),
              child: Theme(
                data: ThemeData(
                    unselectedWidgetColor: Color(clrGreyLightest),
                    accentColor: Color(clrPrimaryBg)
                ),
                child: Checkbox(
                  activeColor: Color(clrPrimaryBg),
                  checkColor: Color(clrBlack),
                  focusColor: Color(clrWhite),
                  tristate: false,
                  value: productToppingsDtoList.isSelectedTopping,
                  onChanged: (bool value) {
                    productToppingsDtoList.isSelectedTopping = value;
                    providerRestaurantDetails.setProductToppingsDtoList(productToppingsDtoList);

                    //--
                    if(value == true){
                      providerRestaurantDetails.setarrSingleProductCart(AddToCartPageState().arrSingleProductCart(false, providerRestaurantDetails,
                          SingleProductCart(itemID: productToppingsDtoList.id, itemName: productToppingsDtoList.name, itemAmount: productToppingsDtoList.rate,
                              isChoiceOfCurst: false, isTopping: true, isAddOns: false, isExtras: false)));
                    }
                    else{

                      List<SingleProductCart> temp = List();

                      int sameIDName;
                      for(int m=0; m<providerRestaurantDetails.getarrSingleProductCart().length; m++){
                        if(providerRestaurantDetails.getarrSingleProductCart()[m].itemID == productToppingsDtoList.id &&
                            providerRestaurantDetails.getarrSingleProductCart()[m].itemName == productToppingsDtoList.name){
                          sameIDName=m;
                        }else{
                          temp.add(providerRestaurantDetails.getarrSingleProductCart()[m]);
                        }
                      }


                      providerRestaurantDetails.getarrSingleProductCart().removeAt(sameIDName);
                      providerRestaurantDetails.setarrSingleProductCart(temp);
                    }


                  },
                ),
              ),
            ),
            SizedBox(width: 10),
          ],
        )
      ],
    );
  }

}
