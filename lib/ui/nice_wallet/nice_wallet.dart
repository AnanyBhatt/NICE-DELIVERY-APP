import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nice_customer_app/common/appbar.dart';
import 'package:nice_customer_app/common/drawerAppBar.dart';
import 'package:nice_customer_app/common/no_data_found.dart';
import 'package:nice_customer_app/Localization/app_translations.dart';
import 'package:nice_customer_app/common/progressbar.dart';
import 'package:nice_customer_app/mixins/const.dart';
import 'package:nice_customer_app/ui/drawer/drawer.dart';
import 'package:nice_customer_app/ui/nice_wallet/nice_wallet_tile.dart';

import 'package:nice_customer_app/utils/color_.dart';
import 'package:nice_customer_app/utils/padding_.dart';
import 'package:nice_customer_app/utils/textstyle_.dart';
import 'package:nice_customer_app/ui/nice_wallet/ProviderNiceWallet.dart';
import 'package:nice_customer_app/api/responce/WalletListResponse.dart';
import 'package:nice_customer_app/api/responce/WalletAmountResponse.dart';

import 'package:nice_customer_app/webservices/RestClient.dart';
import 'package:nice_customer_app/webservices/apiendpointd.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NiceWalletPage extends StatefulWidget {
  NiceWalletPage({Key key}) : super(key: key);

  @override
  _NiceWalletPageState createState() => _NiceWalletPageState();
}

class _NiceWalletPageState extends State<NiceWalletPage> with Constants {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int intCurrentPage = 1;
  ScrollController _sc = new ScrollController();

  @override
  void initState() {
    var providerNiceWallet =
        Provider.of<ProviderNiceWallet>(context, listen: false);

    Future.delayed(Duration(milliseconds: 10), () async {
      checkInternet().then((value) {
        if (value == true) {
          apiNiceWalletAmount(context, providerNiceWallet);
        } else {
          showSnackBar(
              "${AppTranslations.of(context).text("Key_errinternet")}");
        }
      });
    });

    //-- Pagination
    _sc.addListener(() {
      if (_sc.position.pixels == _sc.position.maxScrollExtent) {
        if (providerNiceWallet.getTotalAmount() >
            providerNiceWallet.getWalletList().length) {
          //--
          checkInternet().then((value) {
            if (value == true) {
              intCurrentPage++;
              apiWalletList(context, providerNiceWallet, true, intCurrentPage);
            } else {
              showSnackBar(
                  "${AppTranslations.of(context).text("Key_errinternet")}");
            }
          });
        }
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    buildSetupScreenUtils(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: GlobalColor.white,
        appBar: DrawerAppBar(
          appBar: AppBar(),
          title: "${AppTranslations.of(context).text("Key_NICEWallet")}",
        ),
        drawer: DrawerPage(),
        body: Consumer<ProviderNiceWallet>(
            builder: (context, providerNiceWallet, child) {
          return Stack(
            children: <Widget>[
              providerNiceWallet.getShowProgressBarMain()
                  ? Container(
                      height: setHeight(350), child: ProgressBar(clrBlack))
                  : providerNiceWallet.getWalletList().length == 0
                      ? Container(child: NoDataFound())
                      : SingleChildScrollView(
                          controller: _sc,
                          child: Container(
                            padding: GlobalPadding.paddingSymmetricH_20,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: setHeight(15),
                                ),
                                Center(child: Image.asset(icNiceWallet)),
                                SizedBox(
                                  height: setHeight(19.19),
                                ),
                                Text(
                                  "${AppTranslations.of(context).text("Key_NiceWalletAmount")}",
                                  style: getTextStyle(context,
                                      type: Type.styleBody2,
                                      fontFamily: sourceSansFontFamily,
                                      fontWeight: fwRegular,
                                      txtColor: GlobalColor.grey),
                                ),
                                SizedBox(
                                  height: setHeight(8),
                                ),
                                Text(
                                  "${AppTranslations.of(context).text("Key_kd")} ${providerNiceWallet.getTotalAmount().toString()}",
                                  style: getTextStyle(context,
                                      type: Type.styleLargeText,
                                      fontFamily: sourceSansFontFamily,
                                      fontWeight: fwSemiBold,
                                      txtColor: GlobalColor.black),
                                ),
                                SizedBox(
                                  height: setHeight(15),
                                ),
                                Divider(
                                  thickness: setHeight(0.5),
                                  color: GlobalColor.grey,
                                ),
                                SizedBox(
                                  height: setHeight(13),
                                ),
                                Text(
                                  "${AppTranslations.of(context).text("Key_History")}",
                                  style: getTextStyle(context,
                                      type: Type.styleDrawerText,
                                      fontFamily: sourceSansFontFamily,
                                      fontWeight: fwSemiBold,
                                      txtColor: GlobalColor.black),
                                ),
                                Padding(
                                  padding: GlobalPadding.paddingSymmetricV_10,
                                  child: Container(
                                    color: GlobalColor.black,
                                    height: setHeight(2),
                                    width: setWidth(45.42),
                                  ),
                                ),
                                SizedBox(
                                  height: setHeight(8),
                                ),
                                walletListWidget(providerNiceWallet),
                              ],
                            ),
                          ),
                        ),
              providerNiceWallet.getShowProgressBar() == false
                  ? Container()
                  : Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: ProgressBar(clrBlack)),
            ],
          );
        }),
      ),
    );
  }

  Widget walletListWidget(ProviderNiceWallet providerNiceWallet) {
    return ListView.builder(
        itemCount: providerNiceWallet.getWalletList().length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, i) {
          return Container(
              margin: EdgeInsets.only(bottom: setHeight(10)),
              child: NICEWalletTile(
                walletData: providerNiceWallet.getWalletList()[i],
              ));
        });
  }

  apiWalletList(BuildContext context, ProviderNiceWallet providerNiceWallet,
      bool showProgressBar, int page) async {
    if (page == 1) {
      providerNiceWallet.setShowProgressBarMain(true);
    } else if (showProgressBar == true) {
      providerNiceWallet.setShowProgressBar(true);
    }

    SharedPreferences pref = await SharedPreferences.getInstance();
    int customerID = pref.getInt(prefInt_ID);
    String accessToken = pref.getString(prefStr_ACCESS_TOKEN);
    String endpoint = ApiEndPoints.apiWalletTransactionList +
        "$page" +
        "/pageSize/10" +
        "?customerId=$customerID";

    showLog("accessToken :-: $accessToken");
    showLog("endpoint :-: $endpoint");

    Response response = await RestClient.getData(
      context,
      endpoint,
      accessToken,
    );

    if (response.statusCode == 200) {
      WalletResponse walletResponse =
          walletResponseFromJson(response.toString());
      showLog("apiWalletList :-: ${walletResponseToJson(walletResponse)}");

      if (page == 1) {
        providerNiceWallet.setShowProgressBarMain(false);
      } else if (showProgressBar == true) {
        providerNiceWallet.setShowProgressBar(false);
      }

      if (walletResponse.status == ApiEndPoints.apiStatus_200) {
        if (page == 1) {
          providerNiceWallet.arrWalletList = new List();
          providerNiceWallet.setWalletList(new List());
        }

        if (walletResponse.data != null && walletResponse.data.length > 0) {
          providerNiceWallet.setTotalCount(walletResponse.totalCount);
          providerNiceWallet.setWalletList(walletResponse.data);
        } else {
          providerNiceWallet.setTotalCount(0);
        }
      } else {
        showSnackBar(walletResponse.message);
      }
    } else {
      if (page == 1) {
        providerNiceWallet.setShowProgressBarMain(false);
      } else if (showProgressBar == true) {
        providerNiceWallet.setShowProgressBar(false);
      }

      showSnackBar(
          "${AppTranslations.of(context).text("Key_errSomethingWrong")}");
    }
  }

  apiNiceWalletAmount(
      BuildContext context, ProviderNiceWallet providerNiceWallet) async {
    providerNiceWallet.setShowProgressBarMain(true);
    SharedPreferences pref = await SharedPreferences.getInstance();
    String accessToken = pref.getString(prefStr_ACCESS_TOKEN);

    Response response = await RestClient.getData(
      context,
      ApiEndPoints.apiWallet,
      accessToken,
    );

    if (response.statusCode == 200) {
      WalletAmountResponse walletAmountResponse =
          walletAmountResponseFromJson(response.toString());
      showLog(
          "apiNiceWalletAmount :-: ${walletAmountToJson(walletAmountResponse)}");

      if (walletAmountResponse.status == ApiEndPoints.apiStatus_200) {
        if (walletAmountResponse.data != null) {
          providerNiceWallet.setTotalAmount(walletAmountResponse.data);
        }
      } else {
        showSnackBar(walletAmountResponse.message);
      }

      apiWalletList(context, providerNiceWallet, true, intCurrentPage);
    } else {
      providerNiceWallet.setShowProgressBarMain(false);

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
        duration: const Duration(seconds: 1)));
  }
}
