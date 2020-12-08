import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nice_customer_app/Localization/app_translations.dart';
import 'package:nice_customer_app/api/responce/CustomerAddressResponse.dart';
import 'package:nice_customer_app/common/no_data_found.dart';
import 'package:nice_customer_app/common/progressbar.dart';
import 'package:nice_customer_app/mixins/const.dart';
import 'package:nice_customer_app/ui/address_book/ProviderAddressBook.dart';
import 'package:nice_customer_app/ui/address_book/add_address.dart';
import 'package:nice_customer_app/utils/color_.dart';
import 'package:nice_customer_app/utils/padding_.dart';
import 'package:nice_customer_app/utils/textstyle_.dart';
import 'package:nice_customer_app/webservices/RestClient.dart';
import 'package:nice_customer_app/webservices/apiendpointd.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectAddressPage extends StatefulWidget {
  SelectAddressPage({Key key}) : super(key: key);

  @override
  _SelectAddressPageState createState() => _SelectAddressPageState();
}

class _SelectAddressPageState extends State<SelectAddressPage> with Constants {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<CustomerAddressList> customerAddList = List();
  @override
  void initState() {
    super.initState();

    var providerAddressBook =
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
            backgroundColor: GlobalColor.white,
            body: Consumer<ProviderAddressBook>(
                builder: (context, providerAddressBook, child) {
              return Column(
                children: [
                  AppBar(
                    centerTitle: true,
                    backgroundColor: Colors.white,
                    iconTheme: IconThemeData(color: GlobalColor.black),
                    title: Text(
                      "${AppTranslations.of(context).text("Key_selectAddress")}",
                      style: getTextStyle(context,
                          type: Type.styleBody1,
                          fontFamily: sourceSansFontFamily,
                          fontWeight: fwBold,
                          txtColor: GlobalColor.black),
                    ),
                    elevation: 0,
                    actions: [
                      IconButton(
                        icon: Icon(
                          Icons.add,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              PageRouteBuilder(
                                  transitionDuration:
                                      Duration(milliseconds: pageDuration),
                                  pageBuilder: (_, __, ___) =>
                                      AddAddressPage())).then((value) {
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
                      )
                    ],
                  ),
                  Expanded(
                    child: providerAddressBook.showProgressBar
                        ? ProgressBar(clrBlack)
                        : SingleChildScrollView(
                            child: Container(
                              padding: GlobalPadding.paddingSymmetricH_20,
                              margin: GlobalPadding.paddingSymmetricV_25,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _getAddressListWidget(providerAddressBook),
                                ],
                              ),
                            ),
                          ),
                  ),
                ],
              );
            })));
  }

  Widget _getAddressListWidget(ProviderAddressBook providerAddressBook) {
    return providerAddressBook.getCustomerAddressList().length > 0
        ? ListView.builder(
            itemCount: providerAddressBook.getCustomerAddressList().length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, i) {
              return Container(
                  margin: EdgeInsets.only(bottom: setHeight(10)),
                  child: _addressTileWidget(
                      i,
                      providerAddressBook.getCustomerAddressList()[i],
                      providerAddressBook));
            })
        : NoDataFound();
  }

  Widget _addressTileWidget(int value, CustomerAddressList data,
      ProviderAddressBook providerAddressBook) {
    return Card(
      elevation: 4,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(setSp(8)),
      ),
      child: Container(
        padding: GlobalPadding.paddingAll_15,
        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data?.addressOf ?? "",
                    style: getTextStyle(context,
                        type: Type.styleBody1,
                        fontFamily: sourceSansFontFamily,
                        fontWeight: fwSemiBold,
                        txtColor: GlobalColor.black),
                  ),
                  SizedBox(
                    height: setHeight(10),
                  ),
                  Container(
                    width: setWidth(178),
                    child: Text(
                      data.buildingName +
                          ", " +
                          data.block +
                          ", " +
                          data.streetNo +
                          ", " +
                          data.areaName,
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
              Radio(
                value: value,
                groupValue: providerAddressBook.getPosition(),
                onChanged: (int value) {
                  {
                    providerAddressBook.setPosition(value);
                    Navigator.pop(context, data);
                  }
                },
              ),
            ],
          ),
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
