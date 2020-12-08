import 'package:flutter/material.dart';
import 'package:nice_customer_app/Localization/app_translations.dart';
import 'package:nice_customer_app/common/appbar.dart';
import 'package:nice_customer_app/mixins/const.dart';
import 'package:nice_customer_app/utils/color_.dart';
import 'package:nice_customer_app/utils/padding_.dart';
import 'package:nice_customer_app/utils/textstyle_.dart';

import 'package:nice_customer_app/ui/ticket/ProviderTicketDetail.dart';
import 'package:nice_customer_app/api/responce/TicketDetailResponce.dart';

import 'package:dio/dio.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:nice_customer_app/webservices/RestClient.dart';
import 'package:nice_customer_app/webservices/apiendpointd.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nice_customer_app/common/progressbar.dart';

class TicketDetailPage extends StatefulWidget {
  final ticketId;

  TicketDetailPage({Key key, this.ticketId}) : super(key: key);

  @override
  _TicketDetailPageState createState() => _TicketDetailPageState();
}

class _TicketDetailPageState extends State<TicketDetailPage> with Constants {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String ticketDateTime;

  void initState() {
    super.initState();

    var providerTicketDetail =
        Provider.of<ProviderTicketDetail>(context, listen: false);

    Future.delayed(Duration(milliseconds: 10), () {
      try {
        checkInternet().then((value) async {
          if (value == true) {
            await apiTicketDetail(providerTicketDetail);
          } else {
            showSnackBar(
                "${AppTranslations.of(context).text("Key_errinternet")}");
          }
        });
      } catch (e) {
        print(e.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    buildSetupScreenUtils(context);

    return SafeArea(
      child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: GlobalColor.white,
          appBar: CommonAppBar(
              title: "${AppTranslations.of(context).text("Key_TicketDetails")}",
              appBar: AppBar()),
          body: Consumer<ProviderTicketDetail>(
            builder: (context, providerTicketDetail, child) {
              return providerTicketDetail.showProgressBar
                  ? ProgressBar(clrBlack)
                  : SingleChildScrollView(
                      child: Container(
                        margin: GlobalPadding.paddingSymmetricV_25,
                        padding: GlobalPadding.paddingSymmetricH_20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${AppTranslations.of(context).text("Key_TicketNo")}.: ${providerTicketDetail.ticketDetailList.id.toString()}",
                              style: getTextStyle(context,
                                  type: Type.styleHead,
                                  fontFamily: sourceSansFontFamily,
                                  fontWeight: fwBold,
                                  txtColor: GlobalColor.black),
                            ),
                            SizedBox(
                              height: setHeight(10),
                            ),
                            Row(
                              children: [
                                Text(
                                  "${AppTranslations.of(context).text("Key_TicketDate")}${widget.ticketId}",
                                  style: getTextStyle(context,
                                      type: Type.styleBody2,
                                      fontFamily: sourceSansFontFamily,
                                      fontWeight: fwRegular,
                                      txtColor: GlobalColor.grey),
                                ),
                                SizedBox(
                                  width: setWidth(10),
                                ),
                                Text(
                                  ticketDateTime ?? "-",
                                  style: getTextStyle(context,
                                      type: Type.styleBody2,
                                      fontFamily: sourceSansFontFamily,
                                      fontWeight: fwSemiBold,
                                      txtColor: GlobalColor.black),
                                ),
                                Expanded(
                                    child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    "${AppTranslations.of(context).text("Key_TicketStatus")}",
                                    style: getTextStyle(context,
                                        type: Type.styleBody2,
                                        fontFamily: sourceSansFontFamily,
                                        fontWeight: fwRegular,
                                        txtColor: GlobalColor.grey),
                                  ),
                                )),
                                SizedBox(
                                  width: setWidth(10),
                                ),
                                Text(
                                  providerTicketDetail
                                      .ticketDetailList.ticketStatus,
                                  style: getTextStyle(context,
                                      type: Type.styleBody2,
                                      fontFamily: sourceSansFontFamily,
                                      fontWeight: fwSemiBold,
                                      txtColor: providerTicketDetail
                                                  .ticketDetailList
                                                  .ticketStatus ==
                                              pending
                                          ? GlobalColor.red
                                          : providerTicketDetail
                                                      .ticketDetailList
                                                      .ticketStatus ==
                                                  acknowledged
                                              ? GlobalColor.yellow
                                              : GlobalColor.green),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: setHeight(15),
                            ),
                            Container(
                              color: GlobalColor.grey,
                              height: setHeight(0.5),
                            ),
                            SizedBox(
                              height: setHeight(13),
                            ),
                            Text(
                              "${AppTranslations.of(context).text("Key_TicketReason")}",
                              style: getTextStyle(context,
                                  type: Type.styleHead,
                                  fontFamily: sourceSansFontFamily,
                                  fontWeight: fwBold,
                                  txtColor: GlobalColor.black),
                            ),
                            SizedBox(
                              height: setHeight(13),
                            ),
                            Container(
                              color: GlobalColor.grey,
                              height: setHeight(0.5),
                            ),
                            SizedBox(
                              height: setHeight(13),
                            ),
                            Text(
                              providerTicketDetail
                                  .ticketDetailList.ticketReason,
                              style: getTextStyle(context,
                                  type: Type.styleHead,
                                  fontFamily: sourceSansFontFamily,
                                  fontWeight: fwSemiBold,
                                  txtColor: GlobalColor.grey),
                            ),
                            SizedBox(
                              height: setHeight(15.19),
                            ),
                            Text(
                              "${AppTranslations.of(context).text("Key_Description")}",
                              style: getTextStyle(context,
                                  type: Type.styleHead,
                                  fontFamily: sourceSansFontFamily,
                                  fontWeight: fwBold,
                                  txtColor: GlobalColor.black),
                            ),
                            SizedBox(
                              height: setHeight(18),
                            ),
                            TextFormField(
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                              initialValue: providerTicketDetail
                                  .ticketDetailList.description,
                              style: getTextStyle(context,
                                  type: Type.styleBody2,
                                  fontFamily: sourceSansFontFamily,
                                  fontWeight: fwRegular,
                                  txtColor: GlobalColor.grey),
                              enabled: false,
                              decoration: new InputDecoration(
                                  border: new OutlineInputBorder(
                                      borderSide: new BorderSide(
                                        color: GlobalColor.grey,
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(setSp(12))),
                                  hintText: '',
                                  contentPadding: GlobalPadding.paddingAll_14),
                            ),
                            SizedBox(
                              height: setHeight(18),
                            ),
                            (providerTicketDetail
                                        .ticketDetailList.ticketStatus ==
                                    resolved)
                                ? Text(
                                    "${AppTranslations.of(context).text("Key_TicketCommets")}",
                                    style: getTextStyle(context,
                                        type: Type.styleHead,
                                        fontFamily: sourceSansFontFamily,
                                        fontWeight: fwBold,
                                        txtColor: GlobalColor.black),
                                  )
                                : Offstage(),
                            SizedBox(
                              height: setHeight(14),
                            ),
                            (providerTicketDetail
                                        .ticketDetailList.ticketStatus ==
                                    resolved)
                                ? _getCommentsList(providerTicketDetail)
                                : Offstage(),
                          ],
                        ),
                      ),
                    );
            },
          )),
    );
  }

  Widget _getCommentsList(ProviderTicketDetail providerTicketDetail) {
    return Container(
      margin: EdgeInsets.only(bottom: setHeight(10)),
      child: Column(
        children: [
          Container(
            color: GlobalColor.grey,
            height: setHeight(0.5),
          ),
          Padding(
            padding: GlobalPadding.paddingSymmetricV_15,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "1.",
                    style: getTextStyle(context,
                        type: Type.styleHead,
                        fontFamily: sourceSansFontFamily,
                        fontWeight: fwBold,
                        txtColor: GlobalColor.black),
                  ),
                  SizedBox(
                    width: ScreenUtil().setWidth(8),
                  ),
                  Expanded(
                    child: Text(
                      providerTicketDetail.ticketDetailList.comment,
                      style: getTextStyle(context,
                          type: Type.styleBody1,
                          fontFamily: sourceSansFontFamily,
                          fontWeight: fwRegular,
                          txtColor: GlobalColor.grey),
                    ),
                  ),
                ]),
          ),
        ],
      ),
    );
  }

  apiTicketDetail(ProviderTicketDetail providerTicketDetail) async {
    providerTicketDetail.setShowProgressBar(true);

    SharedPreferences pref = await SharedPreferences.getInstance();
    String accessToken = pref.getString(prefStr_ACCESS_TOKEN);
    String apiTicketDetail =
        ApiEndPoints.apiTicketDetail + widget.ticketId.toString();
    print("-----Access Token--------$accessToken");

    Response response =
        await RestClient.getData(context, apiTicketDetail, accessToken);

    try {
      if (response.statusCode == 200) {
        providerTicketDetail.setShowProgressBar(false);

        TicketDetailResponce ticketDetailResponce =
            ticketDetailResponceFromJson(response.toString());
        showLog(
            "apiTicketDetailsList :-: ${ticketDetailResponceToJson(ticketDetailResponce)}");

        if (ticketDetailResponce.status == ApiEndPoints.apiStatus_200) {
          providerTicketDetail.showTicketDetails(ticketDetailResponce.data);
          String date =
              providerTicketDetail.ticketDetailList.createdAt.toString();
          ticketDateTime = convertDateformat(date);
        } else {
          showSnackBar(ticketDetailResponce.message);
        }
      } else {
        providerTicketDetail.setShowProgressBar(false);
        showSnackBar("${AppTranslations.of(context).text("Key_errinternet")}");
      }
    } catch (exception) {
      print("-----exception Occured-----${exception.toString()}");
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
