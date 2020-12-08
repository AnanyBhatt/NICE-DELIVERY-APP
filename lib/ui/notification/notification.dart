import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nice_customer_app/Localization/app_translations.dart';
import 'package:nice_customer_app/api/responce/CommonResponce.dart';
import 'package:nice_customer_app/api/responce/NotificationListResponse.dart';
import 'package:nice_customer_app/common/appbar.dart';
import 'package:nice_customer_app/common/drawerAppBar.dart';
import 'package:nice_customer_app/common/no_data_found.dart';
import 'package:nice_customer_app/common/progressbar.dart';
import 'package:nice_customer_app/mixins/const.dart';
import 'package:nice_customer_app/ui/drawer/drawer.dart';
import 'package:nice_customer_app/ui/notification/ProviderNotification.dart';
import 'package:nice_customer_app/utils/color_.dart';
import 'package:nice_customer_app/utils/padding_.dart';
import 'package:nice_customer_app/utils/textstyle_.dart';
import 'package:nice_customer_app/webservices/RestClient.dart';
import 'package:nice_customer_app/webservices/apiendpointd.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationPage extends StatefulWidget {
  NotificationPage({Key key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> with Constants {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int intCurrentPage = 1;
  ScrollController _scrollControllerNoti = new ScrollController();

  @override
  void initState() {
    var providerNotification =
        Provider.of<ProviderNotification>(context, listen: false);

    Future.delayed(Duration(milliseconds: 10), () async {
      providerNotification.arrNotificationList = new List();
      providerNotification.setNotificationList(new List());
    });

    Future.delayed(Duration(milliseconds: 10), () async {
      checkInternet().then((value) {
        if (value == true) {
          apiNotificationList(context, providerNotification, intCurrentPage);
        } else {
          showSnackBar(
              "${AppTranslations.of(context).text("Key_errinternet")}");
        }
      });
    });

    //-- Pagination
    _scrollControllerNoti.addListener(() {
      if (_scrollControllerNoti.position.pixels ==
          _scrollControllerNoti.position.maxScrollExtent) {
        if (providerNotification.getTotalCount() >
            providerNotification.getNotificationList().length) {
          //--
          checkInternet().then((value) {
            if (value == true) {
              intCurrentPage++;
              apiNotificationList(
                  context, providerNotification, intCurrentPage);
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
            key: _scaffoldKey,
            backgroundColor: GlobalColor.white,
            appBar: DrawerAppBar(
              appBar: AppBar(),
              title: "${AppTranslations.of(context).text("Key_notification")}",
            ),
            drawer: DrawerPage(),
            body: Consumer<ProviderNotification>(
                builder: (context, providerNotification, child) {
              return Stack(
                children: <Widget>[
                  providerNotification.getShowProgressBar()
                      ? ProgressBar(clrBlack)
                      : providerNotification.getNotificationList().length == 0
                          ? NoDataFound()
                          : SingleChildScrollView(
                              controller: _scrollControllerNoti,
                              child: Container(
                                padding: GlobalPadding.paddingSymmetricH_20,
                                margin: GlobalPadding.paddingSymmetricV_25,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _getNotificationListWidget(
                                        providerNotification)
                                  ],
                                ),
                              ),
                            ),
                ],
              );
            })));
  }

  Widget _getNotificationListWidget(ProviderNotification providerNotification) {
    return ListView.builder(
        itemCount: providerNotification.getNotificationList().length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, i) {
          return Container(
              margin: EdgeInsets.only(bottom: setHeight(15)),
              child: notificationListTileWidget(providerNotification,
                  providerNotification.getNotificationList()[i]));
        });
  }

  Widget notificationListTileWidget(
      ProviderNotification providerNotification, NotificationList data) {
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
            Text(
              data?.message ?? "",
              style: getTextStyle(context,
                  type: Type.styleBody1,
                  fontFamily: sourceSansFontFamily,
                  fontWeight: fwRegular,
                  txtColor: GlobalColor.black),
            ),
            SizedBox(
              height: setHeight(5),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(icBell),
                    SizedBox(
                      width: setWidth(10),
                    ),
                    Text(
                      compareTwoDates(data.createdAt) == "0"
                          ? "${AppTranslations.of(context).text("Key_today")}..."
                          : compareTwoDates(data.createdAt) +
                              " ${AppTranslations.of(context).text("Key_daysAgo")}...",
                      style: getTextStyle(context,
                          type: Type.styleBody2,
                          fontFamily: sourceSansFontFamily,
                          fontWeight: fwRegular,
                          txtColor: GlobalColor.darkGrey),
                    ),
                  ],
                ),
                AbsorbPointer(
                  absorbing: providerNotification.getShowProgressBar(),
                  child: InkWell(
                    child: Icon(
                      Icons.delete,
                      color: Color(clrred),
                    ),
                    onTap: () {
                      providerNotification.setShowProgressBar(true);

                      checkInternet().then((value) {
                        if (value == true) {
                          apiDeleteNotification(
                              context, data, providerNotification);
                        } else {
                          showSnackBar(
                              "${AppTranslations.of(context).text("Key_errinternet")}");
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  apiNotificationList(BuildContext context,
      ProviderNotification providerNotification, int page) async {
    providerNotification.setShowProgressBar(true);
    SharedPreferences pref = await SharedPreferences.getInstance();

    String accessToken = pref.getString(prefStr_ACCESS_TOKEN);

    String endpoint =
        ApiEndPoints.apiGetNotificationList + "$page" + "/pageSize/10";
    showLog("apiGetNotificationList endpoint :-: $endpoint");

    Response response = await RestClient.getData(
      context,
      endpoint,
      accessToken,
    );

    if (response.statusCode == 200) {
      NotificationListResponse notificationListResponse =
          notificationListResponseFromJson(response.toString());
      showLog(
          "notificationListResponse :-: ${notificationListResponseToJson(notificationListResponse)}");

      if (notificationListResponse.status == ApiEndPoints.apiStatus_200) {
        if (page == 1) {
          providerNotification.arrNotificationList = new List();
          providerNotification.setNotificationList(new List());
        }

        if (notificationListResponse.data != null &&
            notificationListResponse.data.length > 0) {
          providerNotification
              .setTotalCount(notificationListResponse.totalCount);

          providerNotification
              .setNotificationList(notificationListResponse.data);
        } else {
          providerNotification.setTotalCount(0);
        }

        providerNotification.setShowProgressBar(false);
      } else {
        providerNotification.setShowProgressBar(false);

        showSnackBar(notificationListResponse.message);
      }
    } else {
      providerNotification.setShowProgressBar(false);

      showSnackBar(
          "${AppTranslations.of(context).text("Key_errSomethingWrong")}");
    }
  }

  apiDeleteNotification(
    BuildContext context,
    NotificationList data,
    ProviderNotification providerNotification,
  ) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String accessToken = pref.getString(prefStr_ACCESS_TOKEN);

    showLog("accessToken :-: $accessToken");

    Response response = await RestClient.deleteData(context,
        ApiEndPoints.apiDeleteNotification + "/${data.id}", accessToken);

    if (response.statusCode == 200) {
      CommonResponce commonResponce =
          commonResponceFromJson(response.toString());
      showLog(
          "apiDeleteNotification :-: ${commonResponceToJson(commonResponce)}");

      if (commonResponce.status == ApiEndPoints.apiStatus_200) {
        showSnackBar(commonResponce.message);

        intCurrentPage = 1;
        apiNotificationList(context, providerNotification, intCurrentPage);
      } else {
        providerNotification.setShowProgressBar(false);

        showSnackBar(commonResponce.message);
      }
    } else {
      providerNotification.setShowProgressBar(false);
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
