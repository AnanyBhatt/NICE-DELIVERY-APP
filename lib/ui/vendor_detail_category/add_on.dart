import 'package:flutter/material.dart';
import 'package:nice_customer_app/Localization/app_translations.dart';
import 'package:nice_customer_app/api/responce/ProductResponce.dart';
import 'package:nice_customer_app/mixins/const.dart';
import 'package:nice_customer_app/ui/add_to_cart/add_to_cart.dart';
import 'package:nice_customer_app/ui/cart/ProviderRestaurnatDetails.dart';
import 'package:nice_customer_app/utils/color_.dart';
import 'package:nice_customer_app/utils/padding_.dart';
import 'package:nice_customer_app/utils/textstyle_.dart';

class AddOn extends StatefulWidget {

  ProviderRestaurantDetails providerRestaurantDetails;
  List<ProductAddonsDtoList> arrProductAddonsDtoList;

  AddOn(this.providerRestaurantDetails, this.arrProductAddonsDtoList);

  @override
  _AddOnState createState() => _AddOnState();
}

class _AddOnState extends State<AddOn> with Constants {
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
                "${AppTranslations.of(context).text("Key_AddOns")}",
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
                isExpanded ? "${AppTranslations.of(context).text("Key_AddExtraItems")}" : "${AppTranslations.of(context).text("Key_ChoosetheAddOns")}",
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
              itemCount: widget.providerRestaurantDetails.getarrProductAddonsDtoList().length,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              separatorBuilder: (BuildContext context, int index) => Padding(padding: new EdgeInsets.only(top: 0, ),),
              itemBuilder: (BuildContext context, int index) {
                return _bottomSheetAddonsDtoList(widget.providerRestaurantDetails, widget.providerRestaurantDetails.getarrProductAddonsDtoList()[index]);
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


  Widget _bottomSheetAddonsDtoList(ProviderRestaurantDetails providerRestaurantDetails, ProductAddonsDtoList productAddonsDtoList){
    return Column(
      children: [
        Row(
          children: [

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: setHeight(10)),
                Text(
                  productAddonsDtoList.addonsName,
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
                  productAddonsDtoList.rate.toString(),
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
                  value: productAddonsDtoList.isSelectedAddons,
                  onChanged: (bool value) {

                    productAddonsDtoList.isSelectedAddons = value;
                    providerRestaurantDetails.setProductAddonsDtoList(productAddonsDtoList);

                    //--
                    if(value == true){
                      providerRestaurantDetails.setarrSingleProductCart(AddToCartPageState().arrSingleProductCart(false, providerRestaurantDetails,
                          SingleProductCart(itemID: productAddonsDtoList.id, itemName: productAddonsDtoList.addonsName, itemAmount: productAddonsDtoList.rate,
                              isChoiceOfCurst: false, isTopping: false, isAddOns: true, isExtras: false)));
                    }
                    else{

                      List<SingleProductCart> temp = List();

                      int sameIDName;
                      for(int m=0; m<providerRestaurantDetails.getarrSingleProductCart().length; m++){
                        if(providerRestaurantDetails.getarrSingleProductCart()[m].itemID == productAddonsDtoList.id &&
                            providerRestaurantDetails.getarrSingleProductCart()[m].itemName == productAddonsDtoList.addonsName){
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
