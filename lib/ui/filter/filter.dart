import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:nice_customer_app/Localization/app_translations.dart';
import 'package:nice_customer_app/common/flaticonbutton.dart';
import 'package:nice_customer_app/mixins/const.dart';
import 'package:nice_customer_app/ui/vendor_details/ProviderVendorList.dart';
import 'package:nice_customer_app/utils/color_.dart';
import 'package:nice_customer_app/utils/padding_.dart';
import 'package:nice_customer_app/utils/textstyle_.dart';
import 'package:provider/provider.dart';

class FilterPage extends StatefulWidget {
  int intCategoryID;
  bool manageInventory;
  Function refresh;
  FilterPage(this.refresh, this.intCategoryID, this.manageInventory);

  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> with Constants {
  int _currentIndex = 1;
  bool isChecked = false;
  double templowerValue;
  double tempupperValue;



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: GlobalColor.white,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            "${AppTranslations.of(context).text("Key_Filters")}",
            style: getTextStyle(context,
                type: Type.styleBody1,
                fontFamily: sourceSansFontFamily,
                fontWeight: fwBold,
                txtColor: GlobalColor.black),
          ),
          leading: Consumer<ProviderVendorList>(
            builder: (context, providerVendorList, child) {
              return IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: GlobalColor.black,
                  ),
                  onPressed: () {
                    widget.refresh();
                    Navigator.pop(context);
                    if (providerVendorList.getIsFilterApply() == false) {
                      providerVendorList.resetFilter();
                    }
                  });
            },
          ),
          actions: [
            Consumer<ProviderVendorList>(
              builder: (context, providerVendorList, child) {
                return Row(
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          templowerValue = null;
                          tempupperValue = null;
                          providerVendorList.resetFilter();
                        },
                        child: Text(
                          "${AppTranslations.of(context).text("Key_Reset")}",
                          style: getTextStyle(context,
                              type: Type.styleBody1,
                              fontFamily: sourceSansFontFamily,
                              fontWeight: fwRegular,
                              txtColor: GlobalColor.black),
                        ),
                      ),
                    ),
                    SizedBox(width: setWidth(20))
                  ],
                );
              },
            ),
          ],
        ),
        body: Consumer<ProviderVendorList>(
          builder: (context, providerVendorList, child) {
            return Column(
              children: [
                _getFilterRow(),
                _currentIndex == 1
                    ? _getFilterBy(providerVendorList)
                    : _getSortBy(providerVendorList),
              ],
            );
          },
        ),
        bottomNavigationBar: Consumer<ProviderVendorList>(
          builder: (context, providerVendorList, child) {
            return Padding(
              padding: EdgeInsets.all(setWidth(10)),
              child: FlatCustomButton(
                title: "${AppTranslations.of(context).text("Key_Apply")}",
                onPressed: () {
                  providerVendorList.setLowerRatingValue(templowerValue);
                  providerVendorList.setUpperRatingValue(tempupperValue);

                  providerVendorList.setIsFilterApply(true);
                  widget.refresh();
                  Navigator.pop(context);
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _getFilterRow() {
    return Material(
      elevation: 6,
      child: Container(
        color: GlobalColor.white,
        height: setHeight(30),
        padding: EdgeInsets.only(bottom: setHeight(5)),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentIndex = 1;
                    });
                  },
                  child: Text(
                    "${AppTranslations.of(context).text("Key_FilterBy")}",
                    textAlign: TextAlign.end,
                    style: getTextStyle(
                      context,
                      type: Type.styleBody1,
                      fontFamily: sourceSansFontFamily,
                      fontWeight: fwSemiBold,
                      txtColor: _currentIndex == 1
                          ? GlobalColor.black
                          : GlobalColor.grey,
                    ),
                  )),
            ),
            SizedBox(
              width: setWidth(50),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _currentIndex = 2;
                  });
                },
                child: Row(
                  children: [
                    Text(
                      "${AppTranslations.of(context).text("Key_SortBy")}",
                      style: getTextStyle(
                        context,
                        type: Type.styleBody1,
                        fontFamily: sourceSansFontFamily,
                        fontWeight: fwSemiBold,
                        txtColor: _currentIndex == 2
                            ? GlobalColor.black
                            : GlobalColor.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getFilterBy(ProviderVendorList providerVendorList) {
    return Container(
      padding: GlobalPadding.paddingSymmetricH_20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.manageInventory == true
              ? Container()
              : GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, cuisinesRoute);
                  },
                  child: Padding(
                    padding: GlobalPadding.paddingSymmetricV_15,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${AppTranslations.of(context).text("Key_Cuisines")}",
                          style: getTextStyle(context,
                              type: Type.styleBody1,
                              fontFamily: sourceSansFontFamily,
                              fontWeight: fwBold,
                              txtColor: GlobalColor.black),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: setSp(18),
                        ),
                      ],
                    ),
                  ),
                ),
          widget.manageInventory == true
              ? Container()
              : Divider(
                  color: GlobalColor.black,
                  height: setHeight(0.6),
                ),
          SizedBox(
            height: setHeight(15),
          ),
          providerVendorList.getCuisineListSelected().length == 0
              ? Container()
              : _cuisinesList(providerVendorList),
          providerVendorList.getCuisineListSelected().length == 0
              ? Container()
              : SizedBox(
                  height: setHeight(20),
                ),
          Text(
            "${AppTranslations.of(context).text("Key_Ratings")}",
            style: getTextStyle(context,
                type: Type.styleBody1,
                fontFamily: sourceSansFontFamily,
                fontWeight: fwBold,
                txtColor: GlobalColor.black),
          ),
          SizedBox(
            height: setHeight(15),
          ),
          Divider(
            color: GlobalColor.black,
            height: setHeight(0.6),
          ),
          FlutterSlider(
            handlerHeight: 45,
            values: [
              providerVendorList.getLowerRatingValue() != null
                  ? providerVendorList.getLowerRatingValue()
                  : 1,
              providerVendorList.getUpperRatingValue() != null
                  ? providerVendorList.getUpperRatingValue()
                  : 5
            ],
            rangeSlider: true,
            max: 5,
            min: 1,
            jump: true,
            trackBar: FlutterSliderTrackBar(
              inactiveTrackBar: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.black12,
              ),
              activeTrackBar: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.black.withOpacity(0.8)),
              inactiveTrackBarHeight: setHeight(16),
              activeTrackBarHeight: setHeight(16),
            ),
            handlerAnimation: FlutterSliderHandlerAnimation(
                curve: Curves.elasticOut,
                reverseCurve: Curves.bounceIn,
                duration: Duration(milliseconds: 500),
                scale: 1.5),

            onDragCompleted: (handlerIndex, lowerValue, upperValue) {
              templowerValue = lowerValue;
              tempupperValue = upperValue;
            },
            tooltip: FlutterSliderTooltip(
              textStyle: getTextStyle(context,
                  type: Type.styleBody1,
                  fontFamily: sourceSansFontFamily,
                  fontWeight: fwSemiBold,
                  txtColor: Colors.black),
            ),
            rightHandler: FlutterSliderHandler(
              decoration: BoxDecoration(),
              child: Container(
                width: setWidth(5),
                height: setHeight(25),
                decoration: new BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.rectangle,
                ),
              ),
            ),
            handler: FlutterSliderHandler(
              decoration: BoxDecoration(),
              child: Container(
                width: setWidth(5),
                height: setHeight(25),
                decoration: new BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.rectangle,
                ),
              ),
            ),
            hatchMark: FlutterSliderHatchMark(
              linesDistanceFromTrackBar: 5,

              density: 0.2,
              labels: [
                FlutterSliderHatchMarkLabel(percent: 0, label: Text('1')),
                FlutterSliderHatchMarkLabel(percent: 25, label: Text('2')),
                FlutterSliderHatchMarkLabel(percent: 50, label: Text('3')),
                FlutterSliderHatchMarkLabel(percent: 75, label: Text('4')),
                FlutterSliderHatchMarkLabel(percent: 100, label: Text('5')),
              ],
              labelsDistanceFromTrackBar: setHeight(43),
            ),
          ),
          SizedBox(
            height: setHeight(20),
          ),
          Text(
            "${AppTranslations.of(context).text("Key_Deliverymode")}",
            style: getTextStyle(context,
                type: Type.styleBody1,
                fontFamily: sourceSansFontFamily,
                fontWeight: fwBold,
                txtColor: GlobalColor.black),
          ),
          Container(
            margin: GlobalPadding.paddingSymmetricV_15,
            color: GlobalColor.darkGrey,
            height: setHeight(0.5),
          ),

          Row(
            children: [
              _radioButton(
                  0,
                  "${AppTranslations.of(context).text("Key_Delivery")}",
                  providerVendorList),
              SizedBox(
                width: setWidth(22.5),
              ),
              _radioButton(
                  1,
                  "${AppTranslations.of(context).text("Key_Pickup")}",
                  providerVendorList),
            ],
          ),
        ],
      ),
    );
  }

  Widget _cuisinesList(ProviderVendorList providerVendorList) {
    return ListView.separated(
        shrinkWrap: true,
        itemCount: providerVendorList.getCuisineListSelected().length,
        separatorBuilder: (context, index) => SizedBox(
              height: setWidth(10),
            ),
        itemBuilder: (context, i) {
          return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  providerVendorList.getCuisineListSelected()[i].name,
                  style: getTextStyle(context,
                      type: Type.styleBody1,
                      fontFamily: sourceSansFontFamily,
                      fontWeight: fwRegular,
                      txtColor: GlobalColor.black),
                ),
                Container(
                  height: setHeight(18),
                  width: setWidth(18),
                  decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(2)),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Image.asset(
                      icCheckDark,
                      color: providerVendorList
                              .getCuisineListSelected()[i]
                              .isSelected
                          ? GlobalColor.black
                          : GlobalColor.white,

                    ),
                  ),
                ),
              ]);
        });
  }

  Widget _getSortBy(ProviderVendorList providerVendorList) {
    return Container(
      padding: GlobalPadding.paddingSymmetricH_20,
      child: Column(
        children: [
          SizedBox(height: setHeight(30)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${AppTranslations.of(context).text("Key_AtoZ")}",
                style: getTextStyle(context,
                    type: Type.styleBody1,
                    fontFamily: sourceSansFontFamily,
                    fontWeight: fwBold,
                    txtColor: GlobalColor.black),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    if (providerVendorList.getIsSortBy() == true)
                      providerVendorList.setIsSortBy(false);
                    else
                      providerVendorList.setIsSortBy(true);
                  });
                },
                child: Container(
                  height: setHeight(18),
                  width: setWidth(18),
                  decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(2)),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Image.asset(
                      icCheckDark,
                      color: providerVendorList.getIsSortBy() == true
                          ? GlobalColor.black
                          : GlobalColor.white,

                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: GlobalPadding.paddingSymmetricV_15,
            color: GlobalColor.grey,
            height: setHeight(0.5),
          ),
        ],
      ),
    );
  }

  Widget _radioButton(
      int poss, String _title, ProviderVendorList providerVendorList) {
    return Row(
      children: [
        SizedBox(
          height: setHeight(30),
          width: setWidth(30),
          child: Radio(
            value: poss,
            groupValue: providerVendorList.getRadioValue(),
            onChanged: (radioValue) {
              providerVendorList.setRadioValue(radioValue);
            },
          ),
        ),
        Text(
          _title,
          style: getTextStyle(context,
              type: Type.styleBody1,
              txtColor: GlobalColor.black,
              fontFamily: sourceSansFontFamily,
              fontWeight: fwSemiBold),
        ),
      ],
    );
  }
}
