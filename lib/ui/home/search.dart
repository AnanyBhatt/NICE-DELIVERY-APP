import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nice_customer_app/Localization/app_translations.dart';
import 'package:nice_customer_app/api/request/VendorListRequest.dart';
import 'package:nice_customer_app/api/responce/VendorListResponce.dart';
import 'package:nice_customer_app/common/appbar.dart';
import 'package:nice_customer_app/common/no_data_found.dart';
import 'package:nice_customer_app/mixins/const.dart';
import 'package:nice_customer_app/ui/address_book/ProviderAddressBook.dart';
import 'package:nice_customer_app/ui/vendor_details/ProviderVendorList.dart';
import 'package:nice_customer_app/ui/vendor_details/food_details.dart';
import 'package:nice_customer_app/utils/color_.dart';
import 'package:nice_customer_app/utils/padding_.dart';
import 'package:nice_customer_app/utils/textstyle_.dart';
import 'package:nice_customer_app/webservices/RestClient.dart';
import 'package:nice_customer_app/webservices/apiendpointd.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchPage extends StatefulWidget {
  int intCategoryID;
  bool manageInventory;
  Function refresh;
  SearchPage(this.refresh, this.intCategoryID, this.manageInventory);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with Constants {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _searchController = new TextEditingController();
  ProviderAddressBook providerAddressBook;

  String strKeyword = "";
  int intCurrentPage = 1;
  ScrollController _sc = new ScrollController();

  @override
  void initState() {
    super.initState();

    strKeyword = "";
    var providerVendorList =
        Provider.of<ProviderVendorList>(context, listen: false);
    providerAddressBook =
        Provider.of<ProviderAddressBook>(context, listen: false);

    //--
    Future.delayed(Duration(milliseconds: 10), () async {
      providerVendorList.setVendorListSearch(new List());
    });

    //--
    Future.delayed(Duration(milliseconds: 10), () async {
      checkInternet().then((value) {
        if (value == true) {
          apiVendorList(context, providerVendorList, providerAddressBook,
              strKeyword, true, intCurrentPage);
        } else {
          showSnackBar(errInternetConnection);
        }
      });
    });

    //--
    _sc.addListener(() {
      if (_sc.position.pixels == _sc.position.maxScrollExtent) {

        if (providerVendorList.getSearchtotalCount() >
            providerVendorList.getVendorListSearch().length) {
          //--
          checkInternet().then((value) {
            if (value == true) {
              intCurrentPage++;
              apiVendorList(context, providerVendorList, providerAddressBook,
                  strKeyword, true, intCurrentPage);
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
  Widget build(BuildContext context) {
    buildSetupScreenUtils(context);

    return SafeArea(
      key: _scaffoldKey,
      child: Scaffold(
        backgroundColor: GlobalColor.white,
        appBar: CommonAppBar(
          appBar: AppBar(),
          title: "${AppTranslations.of(context).text("Key_Search")}",
        ),
        body: Consumer<ProviderVendorList>(
          builder: (context, providerVendorList, child) {
            return Stack(
              children: <Widget>[
                Column(
                  children: [
                    Container(
                      margin: GlobalPadding.paddingAll_20,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(setSp(32)),
                          border: Border.all(color: GlobalColor.black),
                          color: GlobalColor.white),
                      padding: EdgeInsets.symmetric(horizontal: setWidth(15)),
                      child: TextField(
                        controller: _searchController,
                        style: getTextStyle(
                          context,
                          type: Type.styleBody1,
                          fontFamily: sourceSansFontFamily,
                          fontWeight: fwRegular,
                          txtColor: GlobalColor.black,
                        ),
                        decoration: InputDecoration(
                            hintText:
                                "${AppTranslations.of(context).text("Key_SearchHere")}",
                            border: InputBorder.none,
                            prefixIcon: Image.asset(icLocSearch),
                            hintStyle: getTextStyle(
                              context,
                              type: Type.styleBody1,
                              fontFamily: sourceSansFontFamily,
                              fontWeight: fwRegular,
                              txtColor: GlobalColor.grey,
                            )),
                        onChanged: (str) {
                          //--
                          checkInternet().then((value) {
                            if (value == true) {
                              strKeyword = str;
                              intCurrentPage = 1;
                              apiVendorList(
                                  context,
                                  providerVendorList,
                                  providerAddressBook,
                                  strKeyword,
                                  false,
                                  intCurrentPage);
                            } else {
                              showSnackBar(errInternetConnection);
                            }
                          });
                        },
                      ),
                    ),
                    providerVendorList.getShowProgressBarMain()
                        ? Container(
                    child: Center(child: CircularProgressIndicator()))
                        : providerVendorList.getVendorListSearch().length == 0
                            ? Container(child: NoDataFound())
                            : Expanded(
                                child: vendorListSearch(providerVendorList,
                                    providerVendorList.getVendorListSearch())),
                  ],
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

  Widget vendorListSearch(
      ProviderVendorList providerVendorList, List<VendorList> arr) {
    return ListView.separated(
      controller: _sc,
      itemCount: arr.length,
      padding: GlobalPadding.paddingSymmetricH_20,
      separatorBuilder: (context, index) {
        return SizedBox(
          height: setWidth(13),
        );
      },
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemBuilder: (BuildContext context, int index) {
        return vendorListItemSearch(arr[index]);
      },
    );
  }

  Widget vendorListItemSearch(VendorList model) {
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
                        height: setHeight(70),
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
                              "(${model.noOfRating}+) Ratings",
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

  apiVendorList(
      BuildContext context,
      ProviderVendorList providerVendorList,
      ProviderAddressBook providerAddressBook,
      String strKeyword,
      bool showProgressBar,
      int page) async {
    if (page == 1) {
      providerVendorList.setShowProgressBarMain(true);
    } else if (showProgressBar == true) {
      providerVendorList.setShowProgressBar(true);
    }

    SharedPreferences pref = await SharedPreferences.getInstance();
    String accessToken = pref.getString(prefStr_ACCESS_TOKEN);


    VendorListRequest vendorListRequest = VendorListRequest();
    vendorListRequest.searchKeyword = strKeyword;
    vendorListRequest.businessCategoryId = widget.intCategoryID;
    vendorListRequest.latitude =
        providerAddressBook.getSelectedAddressModel().latitude;
    vendorListRequest.longitude =
        providerAddressBook.getSelectedAddressModel().longitude;
    vendorListRequest.openingHour =
        strDateTimeWithTimeZone(strDateTimeFormateBackend);
    vendorListRequest.isFeatured = null;

    //--
    vendorListRequest.cuisineIds = null;
    vendorListRequest.ratingFrom = null;
    vendorListRequest.ratingTo = null;
    vendorListRequest.deliveryType = null;
    vendorListRequest.isNameSorting = null;

    String data = vendorListRequestToJson(vendorListRequest);

    String endpoint =
        ApiEndPoints.apiVendorListPaginagation + "$page" + "/pageSize/10";
    Response response =
        await RestClient.putData(context, endpoint, data, accessToken);

    if (response.statusCode == 200) {
      VendorListResponce vendorListResponce =
          vendorListResponceFromJson(response.toString());

      if (page == 1) {
        providerVendorList.setShowProgressBarMain(false);
      } else if (showProgressBar == true) {
        providerVendorList.setShowProgressBar(false);
      }

      if (vendorListResponce.status == ApiEndPoints.apiStatus_200) {
        if (page == 1) {
          providerVendorList.arrVendorListSearch = new List();
          providerVendorList.setVendorListSearch(new List());
        }

        if (vendorListResponce.data != null &&
            vendorListResponce.data.length > 0) {
          providerVendorList.setSearchtotalCount(vendorListResponce.totalCount);
          providerVendorList.setVendorListSearch(vendorListResponce.data);
        } else {
          providerVendorList.setSearchtotalCount(0);
        }
      } else {
        showSnackBar(vendorListResponce.message);
      }
    } else {
      if (page == 1) {
        providerVendorList.setShowProgressBarMain(false);
      } else if (showProgressBar == true) {
        providerVendorList.setShowProgressBar(false);
      }

      showSnackBar(errSomethingWentWrong);
    }
  }

  void showSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
        value,
        style: TextStyle(
          color: Color(clrWhite),
          fontSize: setSp(14),
        ),
      ),
      backgroundColor: Color(clrBlack),
      duration: Duration(seconds: 1),
    ));
  }
}
