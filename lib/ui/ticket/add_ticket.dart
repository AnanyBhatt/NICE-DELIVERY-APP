import 'package:flutter/material.dart';
import 'package:nice_customer_app/Localization/app_translations.dart';
import 'package:nice_customer_app/common/appbar.dart';
import 'package:nice_customer_app/common/flaticonbutton.dart';
import 'package:nice_customer_app/mixins/const.dart';
import 'package:nice_customer_app/utils/color_.dart';
import 'package:nice_customer_app/utils/padding_.dart';
import 'package:nice_customer_app/utils/textstyle_.dart';

import 'package:nice_customer_app/ui/ticket/ProviderAddTicket.dart';
import 'package:nice_customer_app/api/responce/TicketReasonResponce.dart';
import 'package:nice_customer_app/api/responce/CommonResponce.dart';
import 'package:nice_customer_app/api/request/AddTicketRequest.dart';

import 'package:dio/dio.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:nice_customer_app/webservices/RestClient.dart';
import 'package:nice_customer_app/webservices/apiendpointd.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nice_customer_app/common/progressbar.dart';

class AddTicketPage extends StatefulWidget {
  final Function refresh;
  AddTicketPage(this.refresh);

  @override
  _AddTicketPageState createState() => _AddTicketPageState();
}

class _AddTicketPageState extends State<AddTicketPage> with Constants {
  TextEditingController _descController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  // String dropdownValue = '';
  // int dropdownValueId = 0;
  List<TicketReasonList> _ticketReasonList = [];

  void initState() {
    super.initState();

    ProviderAddTicket providerAddTicket =
        Provider.of<ProviderAddTicket>(context, listen: false);

    //--
    Future.delayed(Duration(milliseconds: 10), () async {
      await providerAddTicket.setTicketReasonList(new List());

      checkInternet().then((value) async {
        if (value == true) {
          await apiTicketReasonList(context, providerAddTicket);
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
        appBar: CommonAppBar(
          appBar: AppBar(),
          title: "${AppTranslations.of(context).text("Key_AddTicket")}",
        ),
        body: Consumer<ProviderAddTicket>(
          builder: (context, providerAddTicket, child) {
            return providerAddTicket.showProgressBar
                ? ProgressBar(clrBlack)
                : Container(
                    margin: GlobalPadding.paddingSymmetricV_25,
                    padding: GlobalPadding.paddingSymmetricH_20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${AppTranslations.of(context).text("Key_EnquiryReason")}",
                          style: getTextStyle(context,
                              type: Type.styleBody1,
                              fontFamily: sourceSansFontFamily,
                              fontWeight: fwRegular,
                              txtColor: GlobalColor.darkGrey),
                        ),
                        DropdownButtonFormField(
                            value: providerAddTicket.getSelectedTicketReason(),
                            items: _ticketReasonList
                                .map((TicketReasonList reasonList) {
                              return new DropdownMenuItem<TicketReasonList>(
                                value: reasonList,
                                child: new Text(
                                  reasonList.reason,
                                  style: new TextStyle(color: Colors.black),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              providerAddTicket.setSelectedTicketReason(value);
                              // dropdownValue = value.reason;
                              // dropdownValueId = value.id;
                            },
                            icon: Image.asset(icDropDownArrow),
                            decoration: InputDecoration(
                              hintText:
                                  "${AppTranslations.of(context).text("Key_SelectEnquiryReason")}",
                            )),
                        SizedBox(
                          height: setHeight(22),
                        ),
                        Text(
                          "${AppTranslations.of(context).text("Key_Description")}",
                          style: getTextStyle(context,
                              type: Type.styleBody1,
                              fontFamily: sourceSansFontFamily,
                              fontWeight: fwRegular,
                              txtColor: GlobalColor.darkGrey),
                        ),
                        SizedBox(
                          height: setHeight(22),
                        ),
                        TextFormField(
                          maxLines: 3,
                          controller: _descController,
                          keyboardType: TextInputType.multiline,
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
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: SizedBox(
                                width: infiniteSize,
                                height: setHeight(48),
                                child: FlatCustomButton(
                                    onPressed: () {
                                      String strDesc = _descController.text;
                                      if (checkValidation(
                                          providerAddTicket
                                              .getSelectedTicketReason()
                                              .reason,
                                          strDesc)) {
                                        checkInternet().then((value) {
                                          if (value == true) {
                                            apiAddTicket(
                                                context,
                                                providerAddTicket,
                                                _descController.text);
                                          } else {
                                            showSnackBar(
                                                "${AppTranslations.of(context).text("Key_errinternet")}");
                                          }
                                        });
                                      }
                                    },
                                    title:
                                        "${AppTranslations.of(context).text("Key_submit")}")),
                          ),
                        )
                      ],
                    ),
                  );
          },
        ),
      ),
    );
  }

  bool checkValidation(String strReason, String strDescription) {
    if (strReason == null || strReason.length == 0) {
      showSnackBar(
          "${AppTranslations.of(context).text("Key_valTicketReason")}");
      return false;
    } else if (strDescription == null || strDescription.length == 0) {
      showSnackBar(
          "${AppTranslations.of(context).text("Key_valTicketDescription")}");
      return false;
    } else {
      return true;
    }
  }

  apiTicketReasonList(
      BuildContext context, ProviderAddTicket providerCancelOrder) async {
    providerCancelOrder.setShowProgressBar(true);

    SharedPreferences pref = await SharedPreferences.getInstance();
    String accessToken = pref.getString(prefStr_ACCESS_TOKEN);
    showLog("accessToken :-: $accessToken");

    Response response = await RestClient.getData(
        context, ApiEndPoints.apiTicketReasonList + "CUSTOMER", accessToken);

    if (response.statusCode == 200) {
      TicketReasonResponce ticketReasonResponce =
          ticketReasonResponceFromJson(response.toString());
      showLog(
          "apiTicketReason :-: ${ticketReasonResponceToJson(ticketReasonResponce)}");

      if (ticketReasonResponce.status == ApiEndPoints.apiStatus_200) {
        if (ticketReasonResponce.data != null &&
            ticketReasonResponce.data.length > 0) {
          _ticketReasonList = [];

          _ticketReasonList = ticketReasonResponce.data;

          providerCancelOrder.setSelectedTicketReason(_ticketReasonList[0]);
        } else {
          TicketReasonList tempselected = TicketReasonList();

          providerCancelOrder.setSelectedTicketReason(tempselected);
          providerCancelOrder.setShowProgressBar(false);
        }
        providerCancelOrder.setShowProgressBar(false);
      } else {
        providerCancelOrder.setShowProgressBar(false);

        showSnackBar(ticketReasonResponce.message);
      }
    } else {
      providerCancelOrder.setShowProgressBar(false);
      showSnackBar(errSomethingWentWrong);
    }
  }

  apiAddTicket(BuildContext context, ProviderAddTicket providerAddTicket,
      String strDescription) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String accessToken = pref.getString(prefStr_ACCESS_TOKEN);
    showLog("accessToken :-: $accessToken");

    providerAddTicket.setShowProgressBar(true);

    AddTicketRequest addTicketRequest = new AddTicketRequest();
    addTicketRequest.ticketReasonId = providerAddTicket.selectedTicketReason.id;
    addTicketRequest.description = strDescription;

    String data = addTicketRequestToJson(addTicketRequest);
    showLog("apiAddTicket data :-: $data");

    Response response = await RestClient.postData(
        context, ApiEndPoints.apiAddTicket, data, accessToken);

    if (response.statusCode == 200) {
      CommonResponce commonResponce =
          commonResponceFromJson(response.toString());
      showLog("commonResponce :-: ${commonResponceToJson(commonResponce)}");
      providerAddTicket.setShowProgressBar(false);

      if (commonResponce.status == ApiEndPoints.apiStatus_200) {
        showSnackBar(commonResponce.message);
        _descController.text = "";

        Future.delayed(Duration(seconds: 1), () {
          widget.refresh();
          Navigator.pop(context, true);
        });
      } else {
        showSnackBar(commonResponce.message);
      }
    } else {
      providerAddTicket.setShowProgressBar(false);
      showSnackBar(errSomethingWentWrong);
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
