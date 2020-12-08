import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nice_customer_app/api/responce/CommonResponce.dart';
import 'package:nice_customer_app/api/responce/CustomerAddressResponse.dart';
import 'package:nice_customer_app/common/drawerAppBar.dart';
import 'package:nice_customer_app/common/no_data_found.dart';
import 'package:nice_customer_app/common/progressbar.dart';
import 'package:nice_customer_app/mixins/const.dart';
import 'package:nice_customer_app/Localization/app_translations.dart';

import 'package:nice_customer_app/ui/address_book/ProviderAddressBook.dart';
import 'package:nice_customer_app/ui/address_book/add_address.dart';
import 'package:nice_customer_app/ui/drawer/drawer.dart';
import 'package:nice_customer_app/utils/color_.dart';
import 'package:nice_customer_app/utils/padding_.dart';
import 'package:nice_customer_app/utils/textstyle_.dart';
import 'package:nice_customer_app/webservices/RestClient.dart';
import 'package:nice_customer_app/webservices/apiendpointd.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddressBookPage extends StatefulWidget {
  AddressBookPage({Key key}) : super(key: key);

  @override
  _AddressBookPageState createState() => _AddressBookPageState();
}

class _AddressBookPageState extends State<AddressBookPage> with Constants {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<CustomerAddressList> customerAddList = List();
  var providerAddressBook;

  @override
  void initState() {
    super.initState();

    providerAddressBook =
        Provider.of<ProviderAddressBook>(context, listen: false);

    Future.delayed(Duration(milliseconds: 10), () async {
      checkInternet().then((value) {
        if (value == true) {
          apiCustomerAddressList(context, providerAddressBook);
        } else {
          showSnackBar(
              "${AppTranslations.of(context).text("Key_errinternet")}");
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    buildSetupScreenUtils(context);

    return SafeArea(
        child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: GlobalColor.white,
            appBar: DrawerAppBar(
              appBar: AppBar(),
              title: "${AppTranslations.of(context).text("Key_addAddress")}",
              action: [
                IconButton(
                    icon: Icon(
                      Icons.add,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          PageRouteBuilder(
                              transitionDuration:
                                  Duration(milliseconds: pageDuration),
                              pageBuilder: (_, __, ___) =>
                                  AddAddressPage())).then((value) {
                        if (value != null && value) {
                          apiCustomerAddressList(context, providerAddressBook);
                        }
                      });
                    })
              ],
            ),
            drawer: DrawerPage(),
            body: Consumer<ProviderAddressBook>(
                builder: (context, providerAddressBook, child) {
              return Container(
                  child: providerAddressBook.getShowProgressBar()
                      ? ProgressBar(clrBlack)
                      : providerAddressBook.getCustomerAddressList().length > 0
                          ? SingleChildScrollView(
                              child: Container(
                                padding: GlobalPadding.paddingSymmetricH_20,
                                margin: GlobalPadding.paddingSymmetricV_25,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    addressListWidget(providerAddressBook)
                                  ],
                                ),
                              ),
                            )
                          : NoDataFound());
            })));
  }

  Widget addressListWidget(ProviderAddressBook providerAddressBook) {
    return ListView.builder(
        itemCount: providerAddressBook.getCustomerAddressList().length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, i) {
          return Container(
              margin: EdgeInsets.only(bottom: setHeight(10)),
              child: addressBookTile(
                i,
                providerAddressBook.getCustomerAddressList()[i],
                providerAddressBook,
              ));
        });
  }

  Widget addressBookTile(int i, CustomerAddressList data,
      ProviderAddressBook providerAddressBook) {
    return Card(
      elevation: 4,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(setSp(8)),
      ),
      child: Container(
        padding: GlobalPadding.paddingAll_15,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Material(
                  type: MaterialType.transparency,
                  child: Text(
                    data.addressOf,
                    style: getTextStyle(context,
                        type: Type.styleBody1,
                        fontFamily: sourceSansFontFamily,
                        fontWeight: fwSemiBold,
                        txtColor: GlobalColor.black),
                  ),
                ),
                Expanded(
                    child: Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    child: Image.asset(
                      icEdit,
                      height: setHeight(30),
                      width: setWidth(30),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          PageRouteBuilder(
                              transitionDuration:
                                  Duration(milliseconds: pageDuration),
                              pageBuilder: (_, __, ___) => AddAddressPage(
                                    model: data,
                                  ))).then((value) {
                        if (value) {
                          checkInternet().then((value) {
                            if (value == true) {
                              apiCustomerAddressList(
                                  context, providerAddressBook);
                            } else {
                              showSnackBar(
                                  "${AppTranslations.of(context).text("Key_errinternet")}");
                            }
                          });
                        }
                      });
                    },
                  ),
                )),
                InkWell(
                  child: Image.asset(
                    icDelete,
                    height: setHeight(30),
                    width: setWidth(30),
                  ),
                  onTap: () {
                    checkInternet().then((value) {
                      if (value == true) {
                        apiDeleteCustomerAddress(
                            context, data, providerAddressBook);
                      } else {
                        showSnackBar(
                            "${AppTranslations.of(context).text("Key_errinternet")}");
                      }
                    });
                  },
                ),
              ],
            ),
            SizedBox(
              height: setHeight(10),
            ),
            Container(
              child: Text(
                data.buildingName +
                    ", " +
                    data.streetNo +
                    ", " +
                    data.areaName +
                    "\n" +
                    data.countryName,
                overflow: TextOverflow.ellipsis,
                maxLines: 5,
                style: getTextStyle(context,
                    type: Type.styleBody1,
                    fontFamily: sourceSansFontFamily,
                    fontWeight: fwRegular,
                    txtColor: GlobalColor.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  apiCustomerAddressList(
      BuildContext context, ProviderAddressBook providerAddressBook) async {
    providerAddressBook.setShowProgressBar(true);
    SharedPreferences pref = await SharedPreferences.getInstance();
    int customerID = pref.getInt(prefInt_ID);
    String accessToken = pref.getString(prefStr_ACCESS_TOKEN);

    String endpoint = ApiEndPoints.apiCustomerAddressList +
        "$customerID" +
        "/address/pageNumber/1/pageSize/100";

    //clear list
    List<CustomerAddressList> arrCustomerAddressList = List();
    providerAddressBook.setCustomerAddressList(arrCustomerAddressList);

    Response response = await RestClient.getData(
      context,
      endpoint,
      accessToken,
    );

    if (response.statusCode == 200) {
      CustomerAddressResponse getAddressResponce =
          customerAddressResponseFromJson(response.toString());
      showLog(
          "apiCustomerAddressList :-: ${customerAddressResponseToJson(getAddressResponce)}");

      if (getAddressResponce.status == ApiEndPoints.apiStatus_200) {
        if (getAddressResponce.data != null &&
            getAddressResponce.data.length > 0) {
          providerAddressBook.setCustomerAddressList(getAddressResponce.data);
        }
      } else {
        showSnackBar(getAddressResponce.message);
      }
      providerAddressBook.setShowProgressBar(false);
    } else {
      providerAddressBook.setShowProgressBar(false);

      showSnackBar(
          "${AppTranslations.of(context).text("Key_errSomethingWrong")}");
    }
  }

  apiDeleteCustomerAddress(
    BuildContext context,
    CustomerAddressList data,
    ProviderAddressBook providerAddressBook,
  ) async {
    providerAddressBook.setShowProgressBar(true);

    SharedPreferences pref = await SharedPreferences.getInstance();
    String accessToken = pref.getString(prefStr_ACCESS_TOKEN);

    showLog("accessToken :-: $accessToken");

    Response response = await RestClient.deleteData(
        context,
        ApiEndPoints.apiAddUpdateCustomerAddress +
            "/${data.id}?active=${data.active}",
        accessToken);

    if (response.statusCode == 200) {
      CommonResponce commonResponce =
          commonResponceFromJson(response.toString());
      showLog(
          "apiDeleteCustomerAddress :-: ${commonResponceToJson(commonResponce)}");

      if (commonResponce.status == ApiEndPoints.apiStatus_200) {
        showSnackBar(commonResponce.message);

        Future.delayed(Duration(seconds: 1), () {
          _scaffoldKey.currentState.hideCurrentSnackBar();

          //refresh State
          apiCustomerAddressList(context, providerAddressBook);
        });
      } else {
        providerAddressBook.setShowProgressBar(false);

        showSnackBar(commonResponce.message);
      }
    } else {
      providerAddressBook.setShowProgressBar(false);
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
          fontSize: setSp(14),
        ),
      ),
      backgroundColor: Color(clrBlack),
      duration: Duration(seconds: 1),
    ));
  }
}
