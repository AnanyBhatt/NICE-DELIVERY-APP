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

class ChoiceCrust extends StatefulWidget {

  ProviderRestaurantDetails providerRestaurantDetails;
  List<ProductAttributeValuesDtoList>  arrProductAttributeValuesDtoList;

  ChoiceCrust(this.providerRestaurantDetails, this.arrProductAttributeValuesDtoList);

  @override
  _ChoiceCrustState createState() => _ChoiceCrustState();
}

class _ChoiceCrustState extends State<ChoiceCrust> with Constants {
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
                "${AppTranslations.of(context).text("Key_ChoiceOfCrust")}",
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
                isExpanded ? AppTranslations.of(context).text("Key_LookforanotherVariant") : "${AppTranslations.of(context).text("Key_ChoiceOfCrust")}",
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
              itemCount: widget.providerRestaurantDetails.getarrProductAttributeValuesDtoList().length,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              separatorBuilder: (BuildContext context, int index) => Padding(padding: new EdgeInsets.only(top: 0, ),),
              itemBuilder: (BuildContext context, int i) {
                return ChoiceOfCrust(widget.providerRestaurantDetails, widget.providerRestaurantDetails.getarrProductAttributeValuesDtoList()[i], i);
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

  Widget ChoiceOfCrust(ProviderRestaurantDetails providerRestaurantDetails, ProductAttributeValuesDtoList productAttributeValuesDtoList, int i){

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[

        SizedBox(height: setWidth(20)),

        Text("${productAttributeValuesDtoList.attributeName}",
          style: getTextStyle(
            context,
            type: Type.styleBody1,
            fontFamily: sourceSansFontFamily,
            fontWeight: fwBold,
            txtColor: GlobalColor.black,
          ),
        ),

        SizedBox(height: setHeight(10),),

        ListView.separated(
            itemCount: productAttributeValuesDtoList.productAttributeValueList.length,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            separatorBuilder: (BuildContext context, int index) => Padding(padding: new EdgeInsets.only(top: 10, ),),
            itemBuilder: (BuildContext context, int j) {

              ProductAttributeValueList item =  productAttributeValuesDtoList.productAttributeValueList[j];
              return _bottomSheetChoiceOfCrust(providerRestaurantDetails, item, i, j, productAttributeValuesDtoList.productAttributeValueList);
            }),


      ],
    );
  }

  Widget _bottomSheetChoiceOfCrust(ProviderRestaurantDetails providerRestaurantDetails,
      ProductAttributeValueList productAttributeValueList, int i, int j, List<ProductAttributeValueList> arrProductAttributeValueList){


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "${productAttributeValueList.attributeValue}",
                  style: getTextStyle(
                    context,
                    type: Type.styleBody1,
                    fontFamily: sourceSansFontFamily,
                    fontWeight: fwRegular,
                    txtColor: GlobalColor.black,
                  ),
                ),
                SizedBox(height: setHeight(5)),
                Text(
                  productAttributeValueList.rate.toString(),
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
                    value: productAttributeValueList.id,
                    groupValue: productAttributeValueList.selectedID,
                    onChanged: (value) {


                      List<ProductAttributeValueList> arrProductAttributeValueList = List();
                      ProductAttributeValueList tempObj = ProductAttributeValueList();
                      int sameIDName;

                      for(int p=0; p<providerRestaurantDetails.getProductVariantList().productAttributeValuesDtoList.length; p++){

                        for(int q=0; q<providerRestaurantDetails.getProductVariantList().productAttributeValuesDtoList[p].productAttributeValueList.length; q++){
                          if(i == p){

                            ProductAttributeValueList obj = providerRestaurantDetails.getProductVariantList().productAttributeValuesDtoList[p].productAttributeValueList[q];
                            obj.selectedID = value;

                            //--
                            if(obj.id == value){
                              tempObj = obj;
                            }

                            for(int m=0; m<providerRestaurantDetails.getarrSingleProductCart().length; m++){
                              if(providerRestaurantDetails.getarrSingleProductCart()[m].itemID == obj.id &&
                                  providerRestaurantDetails.getarrSingleProductCart()[m].itemName == obj.attributeValue){
                                sameIDName=m;
                                break;
                              }
                            }
                          }

                        }
                        arrProductAttributeValueList.addAll(providerRestaurantDetails.getProductVariantList().productAttributeValuesDtoList[p].productAttributeValueList);
                      }

                      //--
                      providerRestaurantDetails.getarrSingleProductCart().removeAt(sameIDName);
                      providerRestaurantDetails.setarrSingleProductCart(AddToCartPageState().arrSingleProductCart(false, providerRestaurantDetails,
                          SingleProductCart(itemID: tempObj.id, itemName: tempObj.attributeValue, itemAmount: tempObj.rate,
                              isChoiceOfCurst: true, isTopping: false, isAddOns: false, isExtras: false)));
                      providerRestaurantDetails.setarrProductAttributeValueList(arrProductAttributeValueList);


                    }
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

}
