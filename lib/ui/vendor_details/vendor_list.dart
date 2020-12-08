import 'package:badges/badges.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nice_customer_app/Localization/app_translations.dart';
import 'package:nice_customer_app/api/request/VendorListRequest.dart';
import 'package:nice_customer_app/api/responce/VendorListResponce.dart';
import 'package:nice_customer_app/common/no_data_found.dart';
import 'package:nice_customer_app/common/progressbar.dart';
import 'package:nice_customer_app/framework/stateprovidermodel/provider_cart.dart';
import 'package:nice_customer_app/mixins/const.dart';
import 'package:nice_customer_app/ui/address_book/ProviderAddressBook.dart';
import 'package:nice_customer_app/ui/cart/cart.dart';
import 'package:nice_customer_app/ui/filter/filter.dart';
import 'package:nice_customer_app/ui/home/search.dart';
import 'package:nice_customer_app/ui/vendor_details/ProviderVendorList.dart';
import 'package:nice_customer_app/ui/vendor_details/food_details.dart';
import 'package:nice_customer_app/utils/color_.dart';
import 'package:nice_customer_app/utils/padding_.dart';
import 'package:nice_customer_app/utils/textstyle_.dart';
import 'package:nice_customer_app/webservices/RestClient.dart';
import 'package:nice_customer_app/webservices/apiendpointd.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VendorListPage extends StatefulWidget {
  int intCategoryID;
  bool manageInventory;
  VendorListPage(this.intCategoryID, this.manageInventory);

  @override
  _VendorListPageState createState() => _VendorListPageState();
}

class _VendorListPageState extends State<VendorListPage> with Constants {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  ProviderCart cartWatch;

  int intCurrentPage = 1;
  ScrollController _sc = new ScrollController();

  void initState() {
    super.initState();

    //--
    ProviderVendorList providerVendorList =
        Provider.of<ProviderVendorList>(context, listen: false);

    //--
    Future.delayed(Duration(milliseconds: 10), () async {
      providerVendorList.setVendorList(new List());
      providerVendorList.setFeatureList(new List());
      providerVendorList.setMostPopular(new List());
      providerVendorList.setNewOnNice(new List());
      providerVendorList.setVendorListSearch(new List());

      providerVendorList.arrVendorList = new List();
      providerVendorList.arrFeatureList = new List();
      providerVendorList.arrMostPopular = new List();
      providerVendorList.arrNewOnNice = new List();
      providerVendorList.arrVendorListSearch = new List();

      //--
      providerVendorList.resetFilter();

      //--
      refresh();
    });
  }

  refresh() {

    //--
    ProviderVendorList providerVendorList =
        Provider.of<ProviderVendorList>(context, listen: false);

    //--
    providerVendorList =
        Provider.of<ProviderVendorList>(context, listen: false);
    var providerAddressBook =
        Provider.of<ProviderAddressBook>(context, listen: false);

    //--
    checkInternet().then((value) {
      if (value == true) {
        apiFeatureVendorList(
            context, providerVendorList, providerAddressBook, intCurrentPage);
      } else {
        showSnackBar("${AppTranslations.of(context).text("Key_errinternet")}");
      }
    });

    //--
    _sc.addListener(() {
      if (_sc.position.pixels == _sc.position.maxScrollExtent) {
        if (providerVendorList.getTotalCount() >
            providerVendorList.getVendorList().length) {
          //--
          checkInternet().then((value) {
            if (value == true) {
              intCurrentPage++;
              apiVendorList(context, providerVendorList, providerAddressBook,
                  intCurrentPage, false);
            } else {
              showSnackBar(
                  "${AppTranslations.of(context).text("Key_errinternet")}");
            }
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _sc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    buildSetupScreenUtils(context);
    cartWatch = context.watch<ProviderCart>();

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: GlobalColor.white,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: GlobalColor.white,
          iconTheme: IconThemeData(color: GlobalColor.black),
          title: GestureDetector(
            onTap: () {},
            child: Consumer<ProviderAddressBook>(
              builder: (context, providerAddressBook, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: RichText(
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                            text:
                                "${AppTranslations.of(context).text("Key_deliverTo")}",
                            style: getTextStyle(
                              context,
                              type: Type.styleBody1,
                              fontFamily: sourceSansFontFamily,
                              fontWeight: fwLight,
                              txtColor: GlobalColor.grey,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: (providerAddressBook
                                                .getSelectedAddressModel()
                                                .areaName !=
                                            null &&
                                        providerAddressBook
                                                .getSelectedAddressModel()
                                                .areaName
                                                .toString()
                                                .length >
                                            0)
                                    ? " ${providerAddressBook.getSelectedAddressModel().areaName}"
                                    : "",
                                style: getTextStyle(
                                  context,
                                  type: Type.styleBody1,
                                  fontFamily: sourceSansFontFamily,
                                  fontWeight: fwBold,
                                  txtColor: GlobalColor.black,
                                ),
                              ),
                            ]),
                      ),
                    ),

                  ],
                );
              },
            ),
          ),
          actions: [

            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartPage(
                        refresh: refresh,
                        manageInventory: widget.manageInventory,
                      ),
                    ));


              },
              child: Badge(
                showBadge: cartWatch.totCartCount > 0 ? true : false,
                toAnimate: true,
                badgeColor: Colors.green,
                animationType: BadgeAnimationType.slide,
                position: BadgePosition.topRight(top: 2, right: 0),
                padding: EdgeInsets.all(6),
                badgeContent: Text(cartWatch.totCartCount.toString(),
                    style: TextStyle(color: Colors.white)),
                child: Image.asset(
                  icShoppingBag,

                ),
              ),
            ),
            SizedBox(
              width: setWidth(20),
            )
          ],
        ),
        body: Consumer<ProviderVendorList>(
          builder: (context, providerVendorList, child) {
            return Stack(
              children: <Widget>[
                Container(
                  child: Column(
                    children: [
                      _getFilterRow(),
                      Expanded(
                        child: providerVendorList.getShowProgressBarMain()
                            ? ProgressBar(clrBlack)
                            : (providerVendorList.getFeatureList().length ==
                                        0 &&
                                    providerVendorList.getVendorList().length ==
                                        0)
                                ? NoDataFound()
                                : SingleChildScrollView(
                                    controller: _sc,
                                    child: Container(
                                      padding:
                                          GlobalPadding.paddingSymmetricV_20,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          providerVendorList
                                                      .getFeatureList()
                                                      .length ==
                                                  0
                                              ? Container()
                                              : featureList(providerVendorList
                                                  .getFeatureList()),
                                          SizedBox(
                                            height: setHeight(25),
                                          ),
                                          providerVendorList
                                                      .getVendorList()
                                                      .length ==
                                                  0
                                              ? Container()
                                              : vendorList(
                                                  providerVendorList,
                                                  providerVendorList
                                                      .getVendorList()),
                                        ],
                                      ),
                                    ),
                                  ),
                      ),
                    ],
                  ),
                ),
                providerVendorList.getShowProgressBar() == false
                    ? Container()
                    : Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: Center(child: CircularProgressIndicator())),
              ],
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
        padding: EdgeInsets.only(bottom: setHeight(5)),
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FilterPage(refresh,
                            widget.intCategoryID, widget.manageInventory),
                      ));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Image.asset(
                      icFilter,
                      color: GlobalColor.black,
                      height: setHeight(30),
                      width: setWidth(30),
                    ),
                    Text(
                      "${AppTranslations.of(context).text("Key_Filter")}",
                      textAlign: TextAlign.end,
                      style: getTextStyle(
                        context,
                        type: Type.styleBody1,
                        fontFamily: sourceSansFontFamily,
                        fontWeight: fwSemiBold,
                        txtColor: GlobalColor.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: setWidth(50),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchPage(refresh,
                            widget.intCategoryID, widget.manageInventory),
                      ));
                },
                child: Row(
                  children: [
                    Image.asset(
                      icLocSearch,
                      color: GlobalColor.grey,
                      height: setHeight(30),
                      width: setWidth(30),
                    ),
                    Text(
                      "${AppTranslations.of(context).text("Key_Search")}",
                      style: getTextStyle(
                        context,
                        type: Type.styleBody1,
                        fontFamily: sourceSansFontFamily,
                        fontWeight: fwSemiBold,
                        txtColor: GlobalColor.black,
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

  /*
  * 1. Feature List
  * */
  Widget featureList(List<VendorList> arr) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: GlobalPadding.paddingSymmetricH_20,
          child: Text(
            "${AppTranslations.of(context).text("Key_Featured")}",
            textAlign: TextAlign.start,
            style: getTextStyle(
              context,
              type: Type.styleHead,
              fontFamily: sourceSansFontFamily,
              fontWeight: fwBold,
              txtColor: GlobalColor.black,
            ),
          ),
        ),
        Container(
          padding: GlobalPadding.paddingSymmetricV_10,
          height: setHeight(252),
          child: ListView.builder(

            itemCount: arr.length,
            padding: GlobalPadding.paddingSymmetricH_20,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return Row(
                children: [
                  featureListItem(arr[index]),
                  SizedBox(
                    width: setWidth(13),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget featureListItem(VendorList model) {
    return Container(
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    DetailsPage(model.id, widget.manageInventory),
              ));
        },
        child: Card(
          elevation: 1,
          clipBehavior: Clip.antiAliasWithSaveLayer,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(setSp(10)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(setSp(8)),
                  child: Image.network(
                    model.featuredImageUrl,
                    fit: BoxFit.cover,
                    height: setHeight(110),
                    width: setWidth(270),
                  )),
              Container(
                padding: GlobalPadding.paddingSymmetricH_15,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Material(
                      type: MaterialType.transparency,
                      child: Text(
                        model.storeName,
                        style: getTextStyle(
                          context,
                          type: Type.styleHead,
                          fontFamily: sourceSansFontFamily,
                          fontWeight: fwBold,
                          txtColor: GlobalColor.black,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: setHeight(6),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(icStar),
                        SizedBox(
                          width: setWidth(5),
                        ),
                        Text(
                          "${model.rating.toString()}",
                          style: getTextStyle(
                            context,
                            type: Type.styleBody2,
                            fontFamily: sourceSansFontFamily,
                            fontWeight: fwRegular,
                            txtColor: GlobalColor.black,
                          ),
                        ),
                        SizedBox(
                          width: setWidth(4),
                        ),
                        Text(
                          "(${model.noOfRating.toString()}+)",
                          style: getTextStyle(
                            context,
                            type: Type.styleBody2,
                            fontFamily: sourceSansFontFamily,
                            fontWeight: fwRegular,
                            txtColor: GlobalColor.grey,
                          ),
                        ),
                        SizedBox(
                          width: setWidth(5),
                        ),
                        Text(
                          dotSymbol,
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(
                          width: setWidth(5),
                        ),
                        Text(
                          "American",
                          style: getTextStyle(
                            context,
                            type: Type.styleBody2,
                            fontFamily: sourceSansFontFamily,
                            fontWeight: fwRegular,
                            txtColor: GlobalColor.grey,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: setHeight(5),
                    ),
                    Material(
                      type: MaterialType.transparency,
                      child: Text(
                        "${model.distance != null ? model.distance.toStringAsFixed(2) : ""} ${AppTranslations.of(context).text("Key_kmAway")}",
                        style: getTextStyle(
                          context,
                          type: Type.styleBody2,
                          fontFamily: sourceSansFontFamily,
                          fontWeight: fwRegular,
                          txtColor: GlobalColor.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /*
  * 2. Vendor List
  * */
  Widget vendorList(
      ProviderVendorList providerVendorList, List<VendorList> arr) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: GlobalPadding.paddingSymmetricH_20,
          child: Text(
            "${providerVendorList.getTotalCount()} ${AppTranslations.of(context).text("Key_OpenRestaurants")}",
            textAlign: TextAlign.start,
            style: getTextStyle(
              context,
              type: Type.styleHead,
              fontFamily: sourceSansFontFamily,
              fontWeight: fwBold,
              txtColor: GlobalColor.black,
            ),
          ),
        ),
        Container(
          padding: GlobalPadding.paddingSymmetricV_10,
          child: ListView.separated(
            itemCount: arr.length,
            physics: NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) {
              return SizedBox(
                height: setWidth(13),
              );
            },
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              if (arr.length <= 6 &&
                  arr.length <= 12 &&
                  arr.length == (index + 1)) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    vendorListItem(arr[index]),
                    (providerVendorList.getMostPopular() != null &&
                            providerVendorList.getMostPopular().length > 0)
                        ? SizedBox(
                            height: setHeight(25),
                          )
                        : Container(),
                    (providerVendorList.getMostPopular() != null &&
                            providerVendorList.getMostPopular().length > 0)
                        ? mostPopularList(arr)
                        : Container(),
                    (providerVendorList.getNewOnNice() != null &&
                            providerVendorList.getNewOnNice().length > 0)
                        ? SizedBox(
                            height: setHeight(25),
                          )
                        : Container(),
                    (providerVendorList.getNewOnNice() != null &&
                            providerVendorList.getNewOnNice().length > 0)
                        ? newOnNiceList(arr)
                        : Container(),
                  ],
                );
              } else if ((index == 11) ||
                  (arr.length <= 12 && arr.length == (index + 1)) &&
                      (providerVendorList.getNewOnNice() != null &&
                          providerVendorList.getNewOnNice().length > 0)) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    vendorListItem(arr[index]),
                    SizedBox(
                      height: setHeight(25),
                    ),
                    newOnNiceList(arr),
                  ],
                );
              } else if ((index == 5) ||
                  (arr.length <= 6 && arr.length == (index + 1)) &&
                      (providerVendorList.getMostPopular() != null &&
                          providerVendorList.getMostPopular().length > 0)) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    vendorListItem(arr[index]),
                    SizedBox(
                      height: setHeight(25),
                    ),
                    mostPopularList(arr),
                  ],
                );
              } else {
                return vendorListItem(arr[index]);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget vendorListItem(VendorList model) {
    return Container(
      padding: GlobalPadding.paddingSymmetricH_20,
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    DetailsPage(model.id, widget.manageInventory),
              ));
        },
        child: Card(
          elevation: 4,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(setSp(8)),
          ),
          child: Padding(
            padding: GlobalPadding.paddingAll_15,
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(setSp(15)),
                      child: Image.network(
                        model.storeImageUrl,
                        fit: BoxFit.cover,
                        height: setWidth(70),
                        width: setWidth(70),
                      )),
                  Container(
                    margin: EdgeInsets.only(
                        left: setWidth(15), right: setWidth(15)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          model.storeName,
                          style: getTextStyle(
                            context,
                            type: Type.styleHead,
                            fontFamily: sourceSansFontFamily,
                            fontWeight: fwBold,
                            txtColor: GlobalColor.black,
                          ),
                        ),
                        SizedBox(
                          height: setHeight(6),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(icStar),
                            SizedBox(
                              width: setWidth(5),
                            ),
                            Text(
                              "${model.rating}",
                              style: getTextStyle(
                                context,
                                type: Type.styleBody2,
                                fontFamily: sourceSansFontFamily,
                                fontWeight: fwRegular,
                                txtColor: GlobalColor.black,
                              ),
                            ),
                            SizedBox(
                              width: setWidth(4),
                            ),
                            Text(
                              "(${model.noOfRating}+) ${AppTranslations.of(context).text("Key_Ratings")}",
                              style: getTextStyle(
                                context,
                                type: Type.styleBody2,
                                fontFamily: sourceSansFontFamily,
                                fontWeight: fwRegular,
                                txtColor: GlobalColor.grey,
                              ),
                            ),
                            SizedBox(
                              width: setWidth(5),
                            ),
                            Text(
                              dotSymbol,
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(
                              width: setWidth(5),
                            ),
                            Text(
                              "American",
                              style: getTextStyle(
                                context,
                                type: Type.styleBody2,
                                fontFamily: sourceSansFontFamily,
                                fontWeight: fwRegular,
                                txtColor: GlobalColor.grey,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: setHeight(5),
                        ),
                        Text(
                          "${model.distance != null ? model.distance.toStringAsFixed(2) : ""} ${AppTranslations.of(context).text("Key_kmAway")}",
                          style: getTextStyle(
                            context,
                            type: Type.styleBody2,
                            fontFamily: sourceSansFontFamily,
                            fontWeight: fwRegular,
                            txtColor: GlobalColor.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /*
  * 3. Most Popular
  * */
  Widget mostPopularList(List<VendorList> arr) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: GlobalPadding.paddingSymmetricH_20,
          child: Text(
            "${AppTranslations.of(context).text("Key_MostPopular")}",
            textAlign: TextAlign.start,
            style: getTextStyle(
              context,
              type: Type.styleHead,
              fontFamily: sourceSansFontFamily,
              fontWeight: fwBold,
              txtColor: GlobalColor.black,
            ),
          ),
        ),
        Container(
          padding: GlobalPadding.paddingSymmetricV_10,
          height: setWidth(275),
          child: ListView.builder(
            itemCount: arr.length,

            padding: GlobalPadding.paddingSymmetricH_20,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return Row(
                children: [
                  mostPopularListItem(arr[index]),
                  SizedBox(
                    width: setWidth(13),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget mostPopularListItem(VendorList model) {
    return Container(
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    DetailsPage(model.id, widget.manageInventory),
              ));
        },
        child: Card(
          elevation: 1,
          clipBehavior: Clip.antiAliasWithSaveLayer,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(setSp(10)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(setSp(8)),
                  child: Image.network(
                    model.featuredImageUrl,
                    fit: BoxFit.cover,
                    height: setHeight(110),
                    width: setWidth(270),
                  )),
              Container(
                padding: GlobalPadding.paddingSymmetricH_15,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Material(
                      type: MaterialType.transparency,
                      child: Text(
                        model.storeName,
                        style: getTextStyle(
                          context,
                          type: Type.styleHead,
                          fontFamily: sourceSansFontFamily,
                          fontWeight: fwBold,
                          txtColor: GlobalColor.black,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: setHeight(6),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(icStar),
                        SizedBox(
                          width: setWidth(5),
                        ),
                        Text(
                          "${model.rating.toString()}",
                          style: getTextStyle(
                            context,
                            type: Type.styleBody2,
                            fontFamily: sourceSansFontFamily,
                            fontWeight: fwRegular,
                            txtColor: GlobalColor.black,
                          ),
                        ),
                        SizedBox(
                          width: setWidth(4),
                        ),
                        Text(
                          "(${model.noOfRating.toString()}+)",
                          style: getTextStyle(
                            context,
                            type: Type.styleBody2,
                            fontFamily: sourceSansFontFamily,
                            fontWeight: fwRegular,
                            txtColor: GlobalColor.grey,
                          ),
                        ),
                        SizedBox(
                          width: setWidth(5),
                        ),
                        Text(
                          dotSymbol,
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(
                          width: setWidth(5),
                        ),
                        Text(
                          "American",
                          style: getTextStyle(
                            context,
                            type: Type.styleBody2,
                            fontFamily: sourceSansFontFamily,
                            fontWeight: fwRegular,
                            txtColor: GlobalColor.grey,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: setHeight(5),
                    ),
                    Material(
                      type: MaterialType.transparency,
                      child: Text(
                        "${model.distance != null ? model.distance.toStringAsFixed(2) : ""} ${AppTranslations.of(context).text("Key_kmAway")}",
                        style: getTextStyle(
                          context,
                          type: Type.styleBody2,
                          fontFamily: sourceSansFontFamily,
                          fontWeight: fwRegular,
                          txtColor: GlobalColor.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /*
  * 4. New On Nice
  * */
  Widget newOnNiceList(List<VendorList> arr) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: GlobalPadding.paddingSymmetricH_20,
          child: Text(
            "${AppTranslations.of(context).text("Key_NewOnNice")}",
            textAlign: TextAlign.start,
            style: getTextStyle(
              context,
              type: Type.styleHead,
              fontFamily: sourceSansFontFamily,
              fontWeight: fwBold,
              txtColor: GlobalColor.black,
            ),
          ),
        ),
        Container(
          padding: GlobalPadding.paddingSymmetricV_10,
          height: setWidth(275),
          child: ListView.builder(
            itemCount: arr.length,

            padding: GlobalPadding.paddingSymmetricH_20,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return Row(
                children: [
                  newOnNiceListItem(arr[index]),
                  SizedBox(
                    width: setWidth(13),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget newOnNiceListItem(VendorList model) {
    return Container(
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    DetailsPage(model.id, widget.manageInventory),
              ));
        },
        child: Card(
          elevation: 1,
          clipBehavior: Clip.antiAliasWithSaveLayer,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(setSp(10)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(setSp(8)),
                  child: Image.network(
                    model.featuredImageUrl,
                    fit: BoxFit.cover,
                    height: setHeight(110),
                    width: setWidth(270),
                  )),
              Container(
                padding: GlobalPadding.paddingSymmetricH_15,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Material(
                      type: MaterialType.transparency,
                      child: Text(
                        model.storeName,
                        style: getTextStyle(
                          context,
                          type: Type.styleHead,
                          fontFamily: sourceSansFontFamily,
                          fontWeight: fwBold,
                          txtColor: GlobalColor.black,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: setHeight(6),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(icStar),
                        SizedBox(
                          width: setWidth(5),
                        ),
                        Text(
                          "${model.rating.toString()}",
                          style: getTextStyle(
                            context,
                            type: Type.styleBody2,
                            fontFamily: sourceSansFontFamily,
                            fontWeight: fwRegular,
                            txtColor: GlobalColor.black,
                          ),
                        ),
                        SizedBox(
                          width: setWidth(4),
                        ),
                        Text(
                          "(${model.noOfRating.toString()}+)",
                          style: getTextStyle(
                            context,
                            type: Type.styleBody2,
                            fontFamily: sourceSansFontFamily,
                            fontWeight: fwRegular,
                            txtColor: GlobalColor.grey,
                          ),
                        ),
                        SizedBox(
                          width: setWidth(5),
                        ),
                        Text(
                          dotSymbol,
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(
                          width: setWidth(5),
                        ),
                        Text(
                          "American",
                          style: getTextStyle(
                            context,
                            type: Type.styleBody2,
                            fontFamily: sourceSansFontFamily,
                            fontWeight: fwRegular,
                            txtColor: GlobalColor.grey,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: setHeight(5),
                    ),
                    Material(
                      type: MaterialType.transparency,
                      child: Text(
                        "${model.distance != null ? model.distance.toStringAsFixed(2) : ""} ${AppTranslations.of(context).text("Key_kmAway")}",
                        style: getTextStyle(
                          context,
                          type: Type.styleBody2,
                          fontFamily: sourceSansFontFamily,
                          fontWeight: fwRegular,
                          txtColor: GlobalColor.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  apiFeatureVendorList(
      BuildContext context,
      ProviderVendorList providerVendorList,
      ProviderAddressBook providerAddressBook,
      int page) async {
    if (page == 1) {
      providerVendorList.setShowProgressBarMain(true);
    } else {
      providerVendorList.setShowProgressBar(true);
    }

    SharedPreferences pref = await SharedPreferences.getInstance();
    String accessToken = pref.getString(prefStr_ACCESS_TOKEN);

    VendorListRequest vendorListRequest = VendorListRequest();
    vendorListRequest.businessCategoryId = widget.intCategoryID;

    vendorListRequest.latitude =
        providerAddressBook.getSelectedAddressModel().latitude;
    vendorListRequest.longitude =
        providerAddressBook.getSelectedAddressModel().longitude;
    vendorListRequest.openingHour =
        strDateTimeWithTimeZone(strDateTimeFormateBackend);
    vendorListRequest.isFeatured = true;
    vendorListRequest.isPopular = false;
    vendorListRequest.isNewArrival = false;

    //--
    if (providerVendorList.getCuisineListSelected() != null &&
        providerVendorList.getCuisineListSelected().length > 0) {
      List<int> arrCuisinID = List();
      for (int i = 0;
          i < providerVendorList.getCuisineListSelected().length;
          i++) {
        arrCuisinID.add(providerVendorList.getCuisineListSelected()[i].id);
      }

      vendorListRequest.cuisineIds = arrCuisinID;
    } else {
      vendorListRequest.cuisineIds = null;
    }

    if (providerVendorList.isFilterApply == true &&
        providerVendorList.getLowerRatingValue() != null &&
        providerVendorList.getLowerRatingValue() > 0) {
      vendorListRequest.ratingFrom = providerVendorList.getLowerRatingValue();
    } else {
      vendorListRequest.ratingFrom = null;
    }

    if (providerVendorList.isFilterApply == true &&
        providerVendorList.getUpperRatingValue() != null &&
        providerVendorList.getUpperRatingValue() > 0) {
      vendorListRequest.ratingTo = providerVendorList.getUpperRatingValue();
    } else {
      vendorListRequest.ratingTo = null;
    }

    if (providerVendorList.getRadioValue() != null &&
        providerVendorList.getRadioValue().toString().length > 0) {
      vendorListRequest.deliveryType = providerVendorList.getRadioValue() == 0
          ? static_Delivery
          : static_Pick_Up;
    } else {
      vendorListRequest.deliveryType = null;
    }

    if (providerVendorList.getIsSortBy() != null &&
        providerVendorList.getIsSortBy().toString().length > 0) {
      vendorListRequest.isNameSorting = providerVendorList.getIsSortBy();
    } else {
      vendorListRequest.isNameSorting = null;
    }

    String data = vendorListRequestToJson(vendorListRequest);

    Response response = await RestClient.putData(
        context, ApiEndPoints.apiFeatureVendorList, data, accessToken);

    if (response.statusCode == 200) {
      VendorListResponce vendorListResponce =
          vendorListResponceFromJson(response.toString());

      if (vendorListResponce.status == ApiEndPoints.apiStatus_200) {
        if (vendorListResponce.data != null &&
            vendorListResponce.data.length > 0) {

          providerVendorList.setFeatureList(vendorListResponce.data);
        } else {
          providerVendorList.setFeatureList(new List());
        }
      } else {
        showSnackBar(vendorListResponce.message);
      }

      apiVendorList(
          context, providerVendorList, providerAddressBook, page, false);
    } else {
      providerVendorList.setShowProgressBar(false);
      showSnackBar(
          "${AppTranslations.of(context).text("Key_errSomethingWrong")}");
    }
  }

  apiVendorList(
      BuildContext context,
      ProviderVendorList providerVendorList,
      ProviderAddressBook providerAddressBook,
      int page,
      bool isPagination) async {
    if (page == 1) {
      providerVendorList.setShowProgressBarMain(true);
    } else if (isPagination == false) {
      providerVendorList.setShowProgressBar(true);
    }

    SharedPreferences pref = await SharedPreferences.getInstance();
    String accessToken = pref.getString(prefStr_ACCESS_TOKEN);

    VendorListRequest vendorListRequest = VendorListRequest();
    vendorListRequest.businessCategoryId = widget.intCategoryID;
    vendorListRequest.latitude =
        providerAddressBook.getSelectedAddressModel().latitude;
    vendorListRequest.longitude =
        providerAddressBook.getSelectedAddressModel().longitude;
    vendorListRequest.openingHour =
        strDateTimeWithTimeZone(strDateTimeFormateBackend);
    vendorListRequest.isFeatured = false;
    vendorListRequest.isPopular = false;
    vendorListRequest.isNewArrival = false;

    //--
    if (providerVendorList.getCuisineListSelected() != null &&
        providerVendorList.getCuisineListSelected().length > 0) {
      List<int> arrCuisinID = List();
      for (int i = 0;
          i < providerVendorList.getCuisineListSelected().length;
          i++) {
        arrCuisinID.add(providerVendorList.getCuisineListSelected()[i].id);
      }

      vendorListRequest.cuisineIds = arrCuisinID;
    } else {
      vendorListRequest.cuisineIds = null;
    }

    if (providerVendorList.isFilterApply == true &&
        providerVendorList.getLowerRatingValue() != null &&
        providerVendorList.getLowerRatingValue() > 0) {
      vendorListRequest.ratingFrom = providerVendorList.getLowerRatingValue();
    } else {
      vendorListRequest.ratingFrom = null;
    }

    if (providerVendorList.isFilterApply == true &&
        providerVendorList.getUpperRatingValue() != null &&
        providerVendorList.getUpperRatingValue() > 0) {
      vendorListRequest.ratingTo = providerVendorList.getUpperRatingValue();
    } else {
      vendorListRequest.ratingTo = null;
    }

    if (providerVendorList.getRadioValue() != null &&
        providerVendorList.getRadioValue().toString().length > 0) {
      vendorListRequest.deliveryType = providerVendorList.getRadioValue() == 0
          ? static_Delivery
          : static_Pick_Up;
    } else {
      vendorListRequest.deliveryType = null;
    }

    if (providerVendorList.getIsSortBy() != null &&
        providerVendorList.getIsSortBy().toString().length > 0) {
      vendorListRequest.isNameSorting = providerVendorList.getIsSortBy();
    } else {
      vendorListRequest.isNameSorting = null;
    }

    String data = vendorListRequestToJson(vendorListRequest);

    String endpoint =
        ApiEndPoints.apiVendorListPaginagation + "$page" + "/pageSize/10";

    Response response =
        await RestClient.putData(context, endpoint, data, accessToken);

    if (response.statusCode == 200) {
      VendorListResponce vendorListResponce =
          vendorListResponceFromJson(response.toString());

      if (vendorListResponce.status == ApiEndPoints.apiStatus_200) {
        if (page == 1) {
          providerVendorList.arrVendorList = new List();
          providerVendorList.setVendorList(new List());
        }

        if (vendorListResponce.data != null &&
            vendorListResponce.data.length > 0) {

          providerVendorList.setTotalCount(vendorListResponce.totalCount);
          providerVendorList.setVendorList(vendorListResponce.data);
        } else {
          providerVendorList.setTotalCount(0);
        }
      } else {
        showSnackBar(vendorListResponce.message);
      }

      if (page == 1) {
        providerVendorList.setShowProgressBarMain(false);
        apiMostPopularList(context, providerVendorList, providerAddressBook);
      } else if (isPagination == false) {
        providerVendorList.setShowProgressBar(false);
      }
    } else {
      if (page == 1) {
        providerVendorList.setShowProgressBarMain(false);
      } else {
        providerVendorList.setShowProgressBar(false);
      }

      showSnackBar(
          "${AppTranslations.of(context).text("Key_errSomethingWrong")}");
    }
  }

  apiMostPopularList(
      BuildContext context,
      ProviderVendorList providerVendorList,
      ProviderAddressBook providerAddressBook) async {
    providerVendorList.setShowProgressBar(true);

    SharedPreferences pref = await SharedPreferences.getInstance();
    String accessToken = pref.getString(prefStr_ACCESS_TOKEN);

    VendorListRequest vendorListRequest = VendorListRequest();
    vendorListRequest.businessCategoryId = widget.intCategoryID;
    vendorListRequest.latitude =
        providerAddressBook.getSelectedAddressModel().latitude;
    vendorListRequest.longitude =
        providerAddressBook.getSelectedAddressModel().longitude;
    vendorListRequest.openingHour =
        strDateTimeWithTimeZone(strDateTimeFormateBackend);
    vendorListRequest.isPopular = true;
    vendorListRequest.isNewArrival = false;

    //--
    if (providerVendorList.getCuisineListSelected() != null &&
        providerVendorList.getCuisineListSelected().length > 0) {
      List<int> arrCuisinID = List();
      for (int i = 0;
          i < providerVendorList.getCuisineListSelected().length;
          i++) {
        arrCuisinID.add(providerVendorList.getCuisineListSelected()[i].id);
      }

      vendorListRequest.cuisineIds = arrCuisinID;
    } else {
      vendorListRequest.cuisineIds = null;
    }

    if (providerVendorList.isFilterApply == true &&
        providerVendorList.getLowerRatingValue() != null &&
        providerVendorList.getLowerRatingValue() > 0) {
      vendorListRequest.ratingFrom = providerVendorList.getLowerRatingValue();
    } else {
      vendorListRequest.ratingFrom = null;
    }

    if (providerVendorList.isFilterApply == true &&
        providerVendorList.getUpperRatingValue() != null &&
        providerVendorList.getUpperRatingValue() > 0) {
      vendorListRequest.ratingTo = providerVendorList.getUpperRatingValue();
    } else {
      vendorListRequest.ratingTo = null;
    }

    if (providerVendorList.getRadioValue() != null &&
        providerVendorList.getRadioValue().toString().length > 0) {
      vendorListRequest.deliveryType = providerVendorList.getRadioValue() == 0
          ? static_Delivery
          : static_Pick_Up;
    } else {
      vendorListRequest.deliveryType = null;
    }

    if (providerVendorList.getIsSortBy() != null &&
        providerVendorList.getIsSortBy().toString().length > 0) {
      vendorListRequest.isNameSorting = providerVendorList.getIsSortBy();
    } else {
      vendorListRequest.isNameSorting = null;
    }

    String data = vendorListRequestToJson(vendorListRequest);

    Response response = await RestClient.putData(
        context, ApiEndPoints.apiVendorList, data, accessToken);

    if (response.statusCode == 200) {
      VendorListResponce vendorListResponce =
          vendorListResponceFromJson(response.toString());

      if (vendorListResponce.status == ApiEndPoints.apiStatus_200) {
        if (vendorListResponce.data != null &&
            vendorListResponce.data.length > 0) {
          providerVendorList.setMostPopular(vendorListResponce.data);
        } else {
          providerVendorList.setMostPopular(new List());
        }
      } else {
        showSnackBar(vendorListResponce.message);
      }

      apiNewOnNiceList(context, providerVendorList, providerAddressBook);
    } else {
      providerVendorList.setShowProgressBar(false);
      showSnackBar(
          "${AppTranslations.of(context).text("Key_errSomethingWrong")}");
    }
  }

  apiNewOnNiceList(BuildContext context, ProviderVendorList providerVendorList,
      ProviderAddressBook providerAddressBook) async {
    providerVendorList.setShowProgressBar(true);

    SharedPreferences pref = await SharedPreferences.getInstance();
    String accessToken = pref.getString(prefStr_ACCESS_TOKEN);

    VendorListRequest vendorListRequest = VendorListRequest();
    vendorListRequest.businessCategoryId = widget.intCategoryID;
    vendorListRequest.latitude =
        providerAddressBook.getSelectedAddressModel().latitude;
    vendorListRequest.longitude =
        providerAddressBook.getSelectedAddressModel().longitude;
    vendorListRequest.openingHour =
        strDateTimeWithTimeZone(strDateTimeFormateBackend);
    vendorListRequest.isPopular = false;
    vendorListRequest.isNewArrival = true;

    //--
    if (providerVendorList.getCuisineListSelected() != null &&
        providerVendorList.getCuisineListSelected().length > 0) {
      List<int> arrCuisinID = List();
      for (int i = 0;
          i < providerVendorList.getCuisineListSelected().length;
          i++) {
        arrCuisinID.add(providerVendorList.getCuisineListSelected()[i].id);
      }

      vendorListRequest.cuisineIds = arrCuisinID;
    } else {
      vendorListRequest.cuisineIds = null;
    }

    if (providerVendorList.isFilterApply == true &&
        providerVendorList.getLowerRatingValue() != null &&
        providerVendorList.getLowerRatingValue() > 0) {
      vendorListRequest.ratingFrom = providerVendorList.getLowerRatingValue();
    } else {
      vendorListRequest.ratingFrom = null;
    }

    if (providerVendorList.isFilterApply == true &&
        providerVendorList.getUpperRatingValue() != null &&
        providerVendorList.getUpperRatingValue() > 0) {
      vendorListRequest.ratingTo = providerVendorList.getUpperRatingValue();
    } else {
      vendorListRequest.ratingTo = null;
    }

    if (providerVendorList.getRadioValue() != null &&
        providerVendorList.getRadioValue().toString().length > 0) {
      vendorListRequest.deliveryType = providerVendorList.getRadioValue() == 0
          ? static_Delivery
          : static_Pick_Up;
    } else {
      vendorListRequest.deliveryType = null;
    }

    if (providerVendorList.getIsSortBy() != null &&
        providerVendorList.getIsSortBy().toString().length > 0) {
      vendorListRequest.isNameSorting = providerVendorList.getIsSortBy();
    } else {
      vendorListRequest.isNameSorting = null;
    }

    String data = vendorListRequestToJson(vendorListRequest);

    Response response = await RestClient.putData(
        context, ApiEndPoints.apiVendorList, data, accessToken);

    if (response.statusCode == 200) {
      VendorListResponce vendorListResponce =
          vendorListResponceFromJson(response.toString());

      providerVendorList.setShowProgressBar(false);

      if (vendorListResponce.status == ApiEndPoints.apiStatus_200) {
        if (vendorListResponce.data != null &&
            vendorListResponce.data.length > 0) {
          providerVendorList.setNewOnNice(vendorListResponce.data);
        } else {
          providerVendorList.setNewOnNice(new List());
        }
      } else {
        showSnackBar(vendorListResponce.message);
      }
    } else {
      providerVendorList.setShowProgressBar(false);
      showSnackBar(
          "${AppTranslations.of(context).text("Key_errSomethingWrong")}");
    }
  }

  void showSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
        value,
        style: TextStyle(
          color: Color(clrWhite),
          fontSize: ScreenUtil().setSp(14),
        ),
      ),
      backgroundColor: Color(clrBlack),
      duration: Duration(seconds: 1),
    ));
  }
}
