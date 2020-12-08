import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:nice_customer_app/Localization/app_translations.dart';
import 'package:nice_customer_app/api/request/ProductRequest.dart';
import 'package:nice_customer_app/api/responce/ProductResponce.dart';
import 'package:nice_customer_app/api/responce/VendorDetailResponce.dart';
import 'package:nice_customer_app/common/addTocartButton.dart';
import 'package:nice_customer_app/common/no_data_found.dart';
import 'package:nice_customer_app/framework/stateprovidermodel/provider_cart.dart';
import 'package:nice_customer_app/mixins/const.dart';
import 'package:nice_customer_app/ui/add_to_cart/add_to_cart.dart';
import 'package:nice_customer_app/ui/address_book/ProviderAddressBook.dart';
import 'package:nice_customer_app/ui/cart/ProviderRestaurnatDetails.dart';
import 'package:nice_customer_app/ui/cart/cart.dart';
import 'package:nice_customer_app/ui/ratings/rating_delivery_boy.dart';
import 'package:nice_customer_app/ui/vendor_info/vendor_info.dart';
import 'package:nice_customer_app/utils/color_.dart';
import 'package:nice_customer_app/utils/padding_.dart';
import 'package:nice_customer_app/utils/textstyle_.dart';
import 'package:nice_customer_app/webservices/RestClient.dart';
import 'package:nice_customer_app/webservices/apiendpointd.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailsPage extends StatefulWidget {
  final String index = "1";
  static int cartCount = 0;

  int intVendorID = 0;
  bool manageInventory;
  DetailsPage(this.intVendorID, this.manageInventory);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage>
    with Constants, SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  bool isSwitched = false;

  TabController _Categorycontroller;
  List<Widget> _generalWidgets = List<Widget>();

  ProviderCart cartWatch;
  ProviderRestaurantDetails providerRestaurantDetails;

  void initState() {
    super.initState();

    DetailsPage.cartCount = 0;

    //--
    providerRestaurantDetails =
        Provider.of<ProviderRestaurantDetails>(context, listen: false);
    List<Productlist> categoryList = new List();

    //--
    Future.delayed(Duration(milliseconds: 1), () {
      providerRestaurantDetails.setArrAddressList(categoryList);
      providerRestaurantDetails.setarrMainCart(new List<MainCart>());
    });

    //--
    //--
    providerRestaurantDetails =
        Provider.of<ProviderRestaurantDetails>(context, listen: false);
    var providerAddressBook =
        Provider.of<ProviderAddressBook>(context, listen: false);

    checkInternet().then((value) async {
      if (value == true) {
        await apiVendorDetail(
            context, providerRestaurantDetails, providerAddressBook);
        _Categorycontroller = new TabController(
            length: providerRestaurantDetails.getArrAddressList().length == 0
                ? 0
                : providerRestaurantDetails.getArrAddressList().length,
            vsync: this);
      } else {
        showSnackBar(errInternetConnection);
      }
    });
  }

  refresh() {

    //--
    providerRestaurantDetails =
        Provider.of<ProviderRestaurantDetails>(context, listen: false);

    checkInternet().then((value) async {
      if (value == true) {
        providerRestaurantDetails.setArrAddressList(new List());
        await apiProductlistCall(
            context, providerRestaurantDetails, 2);
      } else {
        showSnackBar(errInternetConnection);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    buildSetupScreenUtils(context);

    cartWatch = context.watch<ProviderCart>();
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: GlobalColor.white,
        body: Consumer<ProviderRestaurantDetails>(
            builder: (context, providerRestaurantDetails, child) {
          return Stack(
            children: [
              providerRestaurantDetails.getShowProgressBar() == true
                  ? Center(child: CircularProgressIndicator())
                  : Container(
                      child: Column(
                        children: [
                          _header(
                              providerRestaurantDetails.getVendorDetailData()),
                          _middlePart(providerRestaurantDetails,
                              providerRestaurantDetails.getVendorDetailData()),
                          (providerRestaurantDetails.getArrAddressList() !=
                                      null &&
                                  providerRestaurantDetails
                                          .getArrAddressList()
                                          .length >
                                      0)
                              ? Expanded(
                                  child: TabBarView(
                                    controller: _Categorycontroller,
                                    children: _generalWidgets,
                                  ),
                                )
                              : Expanded(child: NoDataFound()),
                        ],
                      ),
                    ),

              Positioned(
                bottom: 30,
                left: 10,
                right: 10,
                child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: cartWatch.totCartCount > 0
                        ? AddToCartButton(
                            onPressed: () {

                              Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                      transitionDuration:
                                          Duration(milliseconds: pageDuration),
                                      pageBuilder: (_, __, ___) => CartPage(
                                            refresh: refresh,
                                        manageInventory: widget.manageInventory,
                                          )));
                            },

                            title: "${AppTranslations.of(context).text("Key_ViewCart")} ( ${cartWatch.totCartCount} ${AppTranslations.of(context).text("Key_items")} )",
                            trailing: "${AppTranslations.of(context).text("Key_Total")}  ${cartWatch.totCartAmount}",
                          )
                        : Offstage()),
              ),

            ],
          );
        }),
      ),
    );
  }

  Widget _middlePart(ProviderRestaurantDetails providerRestaurantDetails,
      VendorDetailData model) {
    return Container(
      margin: GlobalPadding.paddingSymmetricH_20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Material(
                type: MaterialType.transparency,
                child: Text(
                  "${model.distance != null ? model.distance.toStringAsFixed(2) : ""} ${AppTranslations.of(context).text("Key_kmAway")}",
                  style: getTextStyle(context,
                      type: Type.styleBody1,
                      fontFamily: sourceSansFontFamily,
                      fontWeight: fwRegular,
                      txtColor: GlobalColor.black),
                ),
              ),
              SizedBox(
                width: setWidth(15),
              ),
              (model.paymentMethod == "Both" || model.paymentMethod == "Online")
                  ? Image.asset(icPay)
                  : Container(),
              (model.paymentMethod == "Both" || model.paymentMethod == "Online")
                  ? SizedBox(
                      width: setWidth(7),
                    )
                  : Container(),
              (model.paymentMethod == "Both" || model.paymentMethod == "COD")
                  ? Image.asset(icCash)
                  : Container(),
              Expanded(
                child: Row(
                  children: <Widget>[
                    Spacer(),
                    Text(
                      "${AppTranslations.of(context).text("Key_VegOnly")}",
                      style: getTextStyle(context,
                          type: Type.styleBody1,
                          fontFamily: sourceSansFontFamily,
                          fontWeight: fwRegular,
                          txtColor: GlobalColor.black),
                    ),
                    SizedBox(
                      width: setWidth(15),
                    ),
                    Switch(
                      value: isSwitched,
                      onChanged: (value) {
                        setState(() {
                          isSwitched = value;

                          if (isSwitched == false) {
                            apiProductlistCall(context, providerRestaurantDetails, 2);
                          } else if (isSwitched == true) {
                            apiProductlistCall(context, providerRestaurantDetails, 0);
                          }
                        });
                      },
                      activeTrackColor: Colors.grey.shade300,
                      activeColor: Colors.black,
                    ),
                  ],
                ),
              ),

            ],
          ),
          Container(
            height: setHeight(0.5),
            color: GlobalColor.darkGrey,
          ),
          Row(
            children: [
              Image.asset(icMenu),
              providerRestaurantDetails.getArrAddressList().length == 0
                  ? Container()
                  : Expanded(child: _tabBar(providerRestaurantDetails)),
            ],
          ),
          SizedBox(
            height: setHeight(10),
          ),
        ],
      ),
    );
  }

  Widget _tabBar(ProviderRestaurantDetails providerRestaurantDetails) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: GlobalColor.white,
      child: DefaultTabController(
        length: providerRestaurantDetails.getArrAddressList().length,
        child: Column(
          children: [
            Container(
              child: TabBar(
                controller: _Categorycontroller,
                isScrollable: true,
                unselectedLabelColor: Colors.grey.withOpacity(0.3),
                indicatorColor: GlobalColor.black,
                indicatorPadding: EdgeInsets.zero,
                tabs: List<Widget>.generate(
                  providerRestaurantDetails.getArrAddressList().length,
                  (int index) {
                    var Productname =
                        providerRestaurantDetails.getArrAddressList()[index];
                    return Container(
                      child: new Tab(
                        child: Text(
                          Productname.categoryName,
                          style: new TextStyle(
                              fontSize: 18, color: Color(clrBlack)),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(VendorDetailData model) {
    String cusines = "";

    for (int i = 0; i < model.vendorCuisines.length; i++) {
      if (i == 0) {
        cusines = model.vendorCuisines[i].cuisineName;
      } else {
        cusines = cusines + ", " + model.vendorCuisines[i].cuisineName;
      }
    }

    return (model.id.toString().length == 0 || model.id == null)
        ? Container()
        : Container(
            child: Stack(
              children: [
                Material(
                  type: MaterialType.transparency,
                  child: Container(
                    child: Image.network(
                      model.storeDetailImageUrl,
                      fit: BoxFit.cover,
                      height: setHeight(170),
                      width: infiniteSize,
                    ),
                  ),
                ),
                Container(
                    height: setHeight(185),
                    padding: EdgeInsets.only(left: setWidth(5), right: setWidth(5)),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(blackShade),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: GlobalColor.white,
                                ),
                                onPressed: () {

                                  Navigator.pop(context);
                                }),
                            IconButton(
                                icon: Image.asset(
                                  icInfo,
                                  color: GlobalColor.white,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                          transitionDuration: Duration(
                                              milliseconds: pageDuration),
                                          pageBuilder: (_, __, ___) =>
                                              VendorInfoPage(model)));

                                }),
                          ],
                        ),
                        Material(
                          type: MaterialType.transparency,
                          child: Text(
                            "${model.storeName}",
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: getTextStyle(context,
                                type: Type.styleSubTitle,
                                fontFamily: sourceSansFontFamily,
                                fontWeight: fwBold,
                                txtColor: GlobalColor.white),
                          ),
                        ),
                        Material(
                          type: MaterialType.transparency,
                          child: Text(
                            "${cusines}",
                            style: getTextStyle(context,
                                type: Type.styleBody1,
                                fontFamily: sourceSansFontFamily,
                                fontWeight: fwRegular,
                                txtColor: GlobalColor.white),
                          ),
                        ),
                        SizedBox(
                          height: setHeight(3),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ReviewRatingsPage(
                                      intVendorID: widget.intVendorID),
                                ));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                icStar,
                                color: GlobalColor.white,
                              ),
                              SizedBox(
                                width: setWidth(6),
                              ),
                              Text(
                                "${model.rating}",
                                style: getTextStyle(context,
                                    type: Type.styleBody1,
                                    fontFamily: sourceSansFontFamily,
                                    fontWeight: fwRegular,
                                    txtColor: GlobalColor.white),
                              ),
                              SizedBox(
                                width: setWidth(6),
                              ),
                              Text(
                                "(${model.noOfRating}+) ${"${AppTranslations.of(context).text("Key_Ratings")}"}",
                                style: getTextStyle(context,
                                    type: Type.styleBody1,
                                    fontFamily: sourceSansFontFamily,
                                    fontWeight: fwRegular,
                                    txtColor: GlobalColor.white),
                              ),
                              SizedBox(
                                width: setWidth(6),
                              ),
                              Image.asset(
                                forwardArrow,
                                color: GlobalColor.white,
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Text(
                          model.deliveryType == "Both"
                              ? "${AppTranslations.of(context).text("Key_Delivery")} - ${AppTranslations.of(context).text("Key_Pickup")}"
                              : model.deliveryType,
                          style: getTextStyle(context,
                              type: Type.styleBody1,
                              fontFamily: sourceSansFontFamily,
                              fontWeight: fwSemiBold,
                              txtColor: GlobalColor.white),
                        ),
                      ],
                    )),
              ],
            ),
          );
  }

  //-- 1. List of Main category & Sub Category
  List<Widget> widgetMainSubCateList(List<Productlist> arrProductlist,
      ProviderRestaurantDetails providerRestaurantDetails) {
    _generalWidgets.clear();
    for (int i = 0; i < arrProductlist.length; i++) {
      _generalWidgets.add(widgetSingleMainSubCate(
          arrProductlist[i], providerRestaurantDetails));
    }
    return _generalWidgets;
  }

  //-- 2. Only Single Main category & Sub Category
  Widget widgetSingleMainSubCate(Productlist modelProduct,
      ProviderRestaurantDetails providerRestaurantDetails) {
    List<SubcateogryList> subcateogryList = modelProduct.subcateogryList;

    return SingleChildScrollView(
      child: Padding(
        padding: new EdgeInsets.only(
          top: 0,
          bottom: 100,
          left: ScreenUtil().setWidth(15),
          right: ScreenUtil().setWidth(15),
        ),
        child: ListView.separated(
            itemCount: subcateogryList.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) {
              return Padding(
                padding: new EdgeInsets.only(top: setWidth(20)),
              );
            },
            primary: false,
            itemBuilder: (context, i) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                      subcateogryList[i].subCategoryName,
                      style: getTextStyle(context,
                          type: Type.styleDrawerText,
                          fontFamily: sourceSansFontFamily,
                          fontWeight: fwBold,
                          txtColor: GlobalColor.black),
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setWidth(10),
                  ),
                  Container(
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, index) {
                        return Padding(
                          padding: new EdgeInsets.only(top: setWidth(10)),
                        );
                      },
                      itemCount: subcateogryList[i].productResponseList.length,
                      itemBuilder: (context, j) {

                        return widgetSingleSubCate(subcateogryList[i].productResponseList[j], providerRestaurantDetails);
                      },
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setWidth(10),
                  ),
                ],
              );
            }),
      ),
    );
  }

  //-- 3. Only Signle Sub Category
  Widget widgetSingleSubCate(ProductResponseList productResponseList,
      ProviderRestaurantDetails providerRestaurantDetails) {

    int addedToCart = 0;

    if (productResponseList.productVariantList != null && productResponseList.productVariantList.length > 0) {


      for (int p = 0; p < productResponseList.productVariantList.length; p++) {
        if (productResponseList.productVariantList[p].cartQtyList != null && productResponseList.productVariantList[p].cartQtyList.length > 0) {


          for (int i = 0; i < productResponseList.productVariantList[p].cartQtyList.length; i++) {
            addedToCart = addedToCart + productResponseList.productVariantList[p].cartQtyList[i];
          }

        }

      }
    }



    return Card(
      elevation: 4,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(setSp(12))),
      child: (productResponseList.productVariantList != null &&
              productResponseList.productVariantList.length > 0)
          ? Container(
              padding: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(10), horizontal: ScreenUtil().setWidth(10)),
              child: Column(
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Material(
                                type: MaterialType.transparency,
                                child: Text(
                                  productResponseList
                                      .productVariantList[0].productName,
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
                                height: setHeight(6),
                              ),
                              Container(
                                width: setWidth(164),
                                child: Text(
                                  productResponseList.productVariantList[0].productName,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: getTextStyle(
                                    context,
                                    type: Type.styleBody2,
                                    fontFamily: sourceSansFontFamily,
                                    fontWeight: fwRegular,
                                    txtColor: GlobalColor.grey,
                                  ),
                                ),
                              ),

                              DetailsPage.cartCount == 0 ? SizedBox(height: setHeight(8)) : Offstage(),


                            ],
                          ),
                        ),
                      ),
                      ClipRRect(
                          borderRadius: BorderRadius.circular(setSp(15)),
                          child: Image.network(
                            productResponseList.image,
                            fit: BoxFit.cover,
                            height: setWidth(80),
                            width: setWidth(80),
                          ),
                      ),
                    ],
                  ),
                  Container(
                    child: Row(
                      children: [
                        Material(
                          type: MaterialType.transparency,
                          child:  Row(
                            mainAxisAlignment:
                            MainAxisAlignment.start,
                            children: [
                              (productResponseList.productVariantList[0].discountedRate != null
                                  && productResponseList.productVariantList[0].discountedRate.toString().length>0)
                                  ? Text("${AppTranslations.of(context).text("Key_kd")}" + productResponseList.productVariantList[0].rate.toString(),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: getTextStyle(
                                  context,
                                  type: Type.styleBody1,
                                  fontFamily: sourceSansFontFamily,
                                  fontWeight: fwBold,
                                  decoration: TextDecoration.lineThrough,
                                  txtColor: GlobalColor.grey,
                                ),
                              ) : Container(height: 0,),

                              (productResponseList.productVariantList[0].discountedRate != null
                                  && productResponseList.productVariantList[0].discountedRate.toString().length>0) ? SizedBox(width: setWidth(5),) : Container(),

                              Text(
                                (productResponseList.productVariantList[0].discountedRate != null
                                    && productResponseList.productVariantList[0].discountedRate.toString().length>0)
                                    ? "${AppTranslations.of(context).text("Key_kd")}" + productResponseList.productVariantList[0].discountedRate.toString() : "${AppTranslations.of(context).text("Key_kd")}" + productResponseList.productVariantList[0].rate.toString(),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
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

                        ),
                        SizedBox(
                          width: setWidth(10),
                        ),
                        (addedToCart == 0)
                            ? GestureDetector(
                          onTap: (productResponseList.productAvailable == true && productResponseList.productOutOfStock == false) ? () {
                            goToProductVariantPage(
                                productResponseList,
                                providerRestaurantDetails);
                          } : null,
                          child: (productResponseList.productAvailable == true && productResponseList.productOutOfStock == false) ? Text(
                            "${AppTranslations.of(context).text("Key_Addtocart")}",
                            style: getTextStyle(context,
                                type: Type.styleBody1,
                                fontFamily: sourceSansFontFamily,
                                fontWeight: fwSemiBold,
                                txtColor: GlobalColor.black),
                          ) : Text(
                            "${AppTranslations.of(context).text("Key_Outofstock")}",
                            style: getTextStyle(context,
                                type: Type.styleBody1,
                                fontFamily: sourceSansFontFamily,
                                fontWeight: fwSemiBold,
                                txtColor: GlobalColor.black),
                          ),
                        )
                            : Row(
                          crossAxisAlignment:
                          CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              child: Image.asset(
                                icMinus,
                              ),
                              onTap: () async {

                                Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                        transitionDuration:
                                        Duration(milliseconds: pageDuration),
                                        pageBuilder: (_, __, ___) => CartPage(
                                          refresh: refresh,
                                          manageInventory: widget.manageInventory,
                                        )));


                              },
                            ),
                            SizedBox(
                              width: setWidth(10),
                            ),
                            Text(
                              "${addedToCart.toString()}",
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
                            GestureDetector(
                              child: Image.asset(
                                icPlus,
                              ),
                              onTap: () {

                                goToProductVariantPage(productResponseList, providerRestaurantDetails);


                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : Container(),
    );
  }


  goToProductVariantPage(ProductResponseList productResponseList,
      ProviderRestaurantDetails providerRestaurantDetails) {
    if (productResponseList.productVariantList != null &&
        productResponseList.productVariantList.length > 0) {
      providerRestaurantDetails.setProductResponseList(productResponseList);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddToCartPage(
              manageInventory : widget.manageInventory,
              refresh: refresh,
              intVendorID: widget.intVendorID,
              productResponseList: productResponseList,
            ),
          ));
    } else {
      showSnackBar("No Item Found");
    }
  }


  apiVendorDetail(
      BuildContext context,
      ProviderRestaurantDetails providerRestaurantDetails,
      ProviderAddressBook providerAddressBook) async {
    providerRestaurantDetails.setShowProgressBar(true);

    SharedPreferences pref = await SharedPreferences.getInstance();

    String endpoint = ApiEndPoints.apiVendorDetail +
        widget.intVendorID.toString() +
        "?latitude=" +
        providerAddressBook.getSelectedAddressModel().latitude.toString() +
        "&longitude=" +
        providerAddressBook.getSelectedAddressModel().longitude.toString();

    String accessToken = pref.getString(prefStr_ACCESS_TOKEN);


    Response response =
        await RestClient.getData(context, endpoint, accessToken);

    if (response.statusCode == 200) {
      VendorDetailResponce vendorDetailResponce =
          vendorDetailResponceFromJson(response.toString());

      if (vendorDetailResponce.status == ApiEndPoints.apiStatus_200) {
        providerRestaurantDetails
            .setVendorDetailData(vendorDetailResponce.data);
      } else {
        showSnackBar(vendorDetailResponce.message);
      }

      await apiProductlistCall(
          context, providerRestaurantDetails, 2);

    } else {
      providerRestaurantDetails.setShowProgressBar(false);
      showSnackBar(errSomethingWentWrong);
    }
  }

  apiProductlistCall(BuildContext context,
      ProviderRestaurantDetails providerRestaurantDetails, int isVeg) async {

    await apiProductlist(context, providerRestaurantDetails, isVeg);
  }

  apiProductlist(BuildContext context,
      ProviderRestaurantDetails providerRestaurantDetails, int isVeg) async {
    providerRestaurantDetails.setShowProgressBar(true);

    SharedPreferences pref = await SharedPreferences.getInstance();
    String uuidStr = pref.getString(prefBool_UUID);
    String accessToken = pref.getString(prefStr_ACCESS_TOKEN);
    bool isLogin = pref.getBool(prefBool_ISLOGIN);

    ProductRequest productRequest = new ProductRequest();
    productRequest.vendorId = widget.intVendorID;
    productRequest.productFoodType = isVeg;
    productRequest.searchKeyword = "";
    productRequest.activeRecords = true;
    if (isLogin != true) {
      productRequest.uuid = uuidStr;
    }

    String data = productRequestToJson(productRequest);

    Response response = await RestClient.postData(
        context, ApiEndPoints.apiProductlist, data, accessToken);

    try {
      if (response.statusCode == 200) {
        ProductResponce productResponce =
            productResponceFromJson(response.toString());
        providerRestaurantDetails.setShowProgressBar(false);

        if (productResponce.status == ApiEndPoints.apiStatus_200) {
          if (productResponce.data != null && productResponce.data.length > 0) {
            providerRestaurantDetails.setArrAddressList(productResponce.data);
            widgetMainSubCateList(
                productResponce.data, providerRestaurantDetails);
          } else {

            providerRestaurantDetails.setArrAddressList(new List());
          }
        } else {
          showSnackBar(productResponce.message);
        }
      } else {
        providerRestaurantDetails.setShowProgressBar(false);
        showSnackBar(errSomethingWentWrong);
      }
    } catch (exception) {
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
