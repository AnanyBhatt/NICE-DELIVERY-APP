import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:nice_customer_app/Localization/app_translations.dart';
import 'package:nice_customer_app/api/responce/VendorDetailResponce.dart';
import 'package:nice_customer_app/common/appbar.dart';
import 'package:nice_customer_app/common/flaticonbutton.dart';
import 'package:nice_customer_app/mixins/const.dart';
import 'package:nice_customer_app/profile/ProviderProfile.dart';
import 'package:nice_customer_app/utils/color_.dart';
import 'package:nice_customer_app/utils/padding_.dart';
import 'package:nice_customer_app/utils/textstyle_.dart';
import 'package:provider/provider.dart';

class VendorInfoPage extends StatefulWidget {

  VendorDetailData model;
  VendorInfoPage(this.model);

  @override
  _VendorInfoPageState createState() => _VendorInfoPageState();

}

class _VendorInfoPageState extends State<VendorInfoPage> with Constants {

  ProviderProfile profileRead;
  ProviderProfile profileWatch;

  @override
  void initState() {

    SchedulerBinding.instance.addPostFrameCallback((_) {
      profileRead = context.read<ProviderProfile>();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    profileWatch = context.watch<ProviderProfile>();
    buildSetupScreenUtils(context);

    String cusines = "";

    for(int i=0; i<widget.model.vendorCuisines.length; i++){

      if(i == 0){
        cusines = widget.model.vendorCuisines[i].cuisineName;
      }else{
        cusines = cusines+ ", " + widget.model.vendorCuisines[i].cuisineName;
      }
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: GlobalColor.white,
        appBar: CommonAppBar(
          appBar: AppBar(),
          title: "${AppTranslations.of(context).text("Key_vendorInfo")}",
        ),
        body: Container(
          padding: GlobalPadding.paddingSymmetricH_20,
          margin: GlobalPadding.paddingSymmetricV_25,
          child: ListView(
            children: [
              Hero(
                tag: "itemPicTag",
                child: Material(
                  type: MaterialType.transparency,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      widget.model.storeDetailImageUrl,
                      fit: BoxFit.cover,
                      height: setHeight(146),
                      width: setWidth(335),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: setHeight(15),
              ),
              Hero(
                tag: "${widget.model.storeName}",
                child: Material(
                  type: MaterialType.transparency,
                  child: Text(
                    "${widget.model.storeName}",
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
              Hero(
                tag: "itemTag",
                child: Material(
                  type: MaterialType.transparency,
                  child: Text(
                    "${cusines}",
                    style: getTextStyle(
                      context,
                      type: Type.styleBody1,
                      fontFamily: sourceSansFontFamily,
                      fontWeight: fwRegular,
                      txtColor: GlobalColor.black,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: setHeight(20),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  (widget.model.accepts == "Return") ? Container(
                    height: setWidth(40),
                    child: FlatCustomButton(
                        title: "${AppTranslations.of(context).text("Key_Returnaccepted")}",
                        outline: true,
                    ),
                  ) : Container(),

                  (widget.model.accepts == "Replace" ) ? SizedBox(
                    width: setHeight(20),
                  ) : Container(),

                  (widget.model.accepts == "Replace" ) ? Container(
                    height: setWidth(40),
                    child: FlatCustomButton(
                        title: "${AppTranslations.of(context).text("Key_Replaceaccepted")}",
                        outline: true,
                    ),
                  ) : Container(),

                ],
              ),

              SizedBox(
                height: setHeight(20),
              ),

              _rowDetail("${AppTranslations.of(context).text("Key_Minorderamount")}", widget.model.minimumOrderAmt.toString()+ " ${AppTranslations.of(context).text("Key_kd")}"),
              _rowDetail("Key_Deliverymode", ""),
              _rowDetail("${AppTranslations.of(context).text("Key_Ratings")}", widget.model.rating.toString()),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      "${AppTranslations.of(context).text("Key_PaymentModes")}",
                      style: getTextStyle(
                        context,
                        type: Type.styleBody1,
                        fontFamily: sourceSansFontFamily,
                        fontWeight: fwRegular,
                        txtColor: GlobalColor.black,
                      ),
                    ),
                  ),

                  Container(
                    width: setWidth(70),
                    child: Row(
                      children: <Widget>[
                        (widget.model.paymentMethod == "Both" || widget.model.paymentMethod == "Online") ? Expanded(
                          child: Image.asset(icPay),
                        ) : Container(),
                        (widget.model.paymentMethod == "Both" || widget.model.paymentMethod == "Online") ? SizedBox(width: setWidth(7),) : Container(),
                        (widget.model.paymentMethod == "Both" || widget.model.paymentMethod == "COD") ? Image.asset(icCash) : Container(),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: setHeight(15),
              ),
              _rowDetail("${AppTranslations.of(context).text("Key_Distance")}", "${widget.model.distance != null ? widget.model.distance.toStringAsFixed(2):""} ${AppTranslations.of(context).text("Key_km")}"),
              _rowDetail("Key_OpeningHours", ""),
              _rowDetail("${AppTranslations.of(context).text("Key_Zipcode")}", widget.model.codeValue),
            ],
          ),
        ),
      ),
    );
  }

  Widget _rowDetail(String title, String body) {
    String strStartTime="";
    String strEndTime="";

    if(title.contains("Key_OpeningHours") && widget.model.openingHoursFrom != null && widget.model.openingHoursFrom.length>0 &&
        widget.model.openingHoursTo != null && widget.model.openingHoursTo.length>0) {

      title = "${AppTranslations.of(context).text("Key_OpeningHours")} ";


      if(profileWatch.getPREFERREDLANGUAGE() == constant_static_en){
        strStartTime = convert24HrTo12Hr(inputFormate: str24Hr, outputFormate: str12Hr, strDate: widget.model.openingHoursFrom);
        strEndTime = convert24HrTo12Hr(inputFormate: str24Hr, outputFormate: str12Hr, strDate: widget.model.openingHoursTo);
        body = strStartTime +" to "+ strEndTime;
      }else{
        strStartTime = Arabicconvert24HrTo12Hr(inputFormate: str24Hr, outputFormate: str12Hr, strDate: widget.model.openingHoursFrom);
        strEndTime = Arabicconvert24HrTo12Hr(inputFormate: str24Hr, outputFormate: str12Hr, strDate: widget.model.openingHoursTo);
        body =  strStartTime +" ${AppTranslations.of(context).text("Key_To")} "+ strEndTime;

      }

    }



    if(title == "Key_Deliverymode"){
      title = "${AppTranslations.of(context).text("Key_Deliverymode")}";

      String strDeliveryBothArabic = "${AppTranslations.of(context).text("Key_Delivery")} - ${AppTranslations.of(context).text("Key_Pickup")}";
      body = widget.model.deliveryType == "Both" ? strDeliveryBothArabic : widget.model.deliveryType;
    }

    return (body ==null || body.length == 0 || body=="") ? Container() : Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: getTextStyle(
                context,
                type: Type.styleBody1,
                fontFamily: sourceSansFontFamily,
                fontWeight: fwRegular,
                txtColor: GlobalColor.black,
              ),
            ),
            Text(
              (body != null && body.length>0) ? body : "",
              style: getTextStyle(
                context,
                type: Type.styleBody1,
                fontFamily: sourceSansFontFamily,
                fontWeight: fwRegular,
                txtColor: GlobalColor.black,
              ),
            ),
          ],
        ),
        SizedBox(
          height: setHeight(15),
        ),
      ],
    );
  }

  String Arabicconvert24HrTo12Hr({String inputFormate, String outputFormate, String strDate}) {
    DateTime date = DateFormat(inputFormate).parse(strDate);
    String strOutputDate = DateFormat(outputFormate, "ar").format(date);
    return strOutputDate;
  }


}
