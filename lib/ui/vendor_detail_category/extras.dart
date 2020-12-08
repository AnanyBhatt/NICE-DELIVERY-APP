import 'package:flutter/material.dart';
import 'package:nice_customer_app/Localization/app_translations.dart';
import 'package:nice_customer_app/api/responce/ProductResponce.dart';
import 'package:nice_customer_app/mixins/const.dart';
import 'package:nice_customer_app/ui/add_to_cart/add_to_cart.dart';
import 'package:nice_customer_app/ui/cart/ProviderRestaurnatDetails.dart';
import 'package:nice_customer_app/utils/color_.dart';
import 'package:nice_customer_app/utils/padding_.dart';
import 'package:nice_customer_app/utils/textstyle_.dart';

class Extras extends StatefulWidget {

  ProviderRestaurantDetails providerRestaurantDetails;
  List<ProductExtrasList> arrProductExtrasList;

  Extras(this.providerRestaurantDetails, this.arrProductExtrasList);

  @override
  _ExtrasState createState() => _ExtrasState();
}

class _ExtrasState extends State<Extras> with Constants {
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
                "${AppTranslations.of(context).text("Key_Extras")}",
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
                "${AppTranslations.of(context).text("Key_Chooseitemsfromthelist")}",
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
              itemCount: widget.providerRestaurantDetails.getarrProductExtrasList().length,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              separatorBuilder: (BuildContext context, int index) => Padding(padding: new EdgeInsets.only(top: 0, ),),
              itemBuilder: (BuildContext context, int index) {
                return _bottomSheetExtras(widget.providerRestaurantDetails, widget.providerRestaurantDetails.getarrProductExtrasList()[index]);
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

  Widget _bottomSheetExtras(ProviderRestaurantDetails providerRestaurantDetails, ProductExtrasList productExtrasList){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: setHeight(10)),
                Text(
                  productExtrasList.name,
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
                  productExtrasList.rate.toString(),
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
                  value: productExtrasList.isSelectedExtras,
                  onChanged: (bool value) {

                    productExtrasList.isSelectedExtras = value;
                    providerRestaurantDetails.setProductExtrasList(productExtrasList);

                    //--
                    if(value == true){
                      providerRestaurantDetails.setarrSingleProductCart(AddToCartPageState().arrSingleProductCart(false, providerRestaurantDetails,
                          SingleProductCart(itemID: productExtrasList.id, itemName: productExtrasList.name, itemAmount: productExtrasList.rate,
                              isChoiceOfCurst: false, isTopping: false, isAddOns: false, isExtras: true)));

                      //--
                      providerRestaurantDetails.setarrSingleProductCartExtras(AddToCartPageState().arrSingleProductCartExtra(false, providerRestaurantDetails,
                          SingleProductCart(itemID: productExtrasList.id, itemName: productExtrasList.name, itemAmount: productExtrasList.rate,
                            isChoiceOfCurst: false, isTopping: false, isAddOns: false, isExtras: true)));
                    }
                    else{

                      //--
                      List<SingleProductCart> tempExtra = List();
                      int sameIDNameExtra;
                      for(int m=0; m<providerRestaurantDetails.getarrSingleProductCartExtras().length; m++){
                        if(providerRestaurantDetails.getarrSingleProductCartExtras()[m].itemID == productExtrasList.id &&
                            providerRestaurantDetails.getarrSingleProductCartExtras()[m].itemName == productExtrasList.name){
                          sameIDNameExtra=m;
                        }else{
                          tempExtra.add(providerRestaurantDetails.getarrSingleProductCartExtras()[m]);
                        }
                      }
                      providerRestaurantDetails.getarrSingleProductCartExtras().removeAt(sameIDNameExtra);
                      providerRestaurantDetails.setarrSingleProductCartExtras(tempExtra);

                      //--
                      List<SingleProductCart> temp = List();
                      int sameIDName;
                      for(int m=0; m<providerRestaurantDetails.getarrSingleProductCart().length; m++){
                        if(providerRestaurantDetails.getarrSingleProductCart()[m].itemID == productExtrasList.id &&
                            providerRestaurantDetails.getarrSingleProductCart()[m].itemName == productExtrasList.name){
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
