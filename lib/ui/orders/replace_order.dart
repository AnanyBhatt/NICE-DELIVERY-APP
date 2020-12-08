import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nice_customer_app/Localization/app_translations.dart';
import 'package:nice_customer_app/api/request/CancelRequest.dart';
import 'package:nice_customer_app/api/responce/CommonResponce.dart';
import 'package:nice_customer_app/api/responce/TicketReasonResponce.dart';
import 'package:nice_customer_app/common/appbar.dart';
import 'package:nice_customer_app/common/flaticonbutton.dart';
import 'package:nice_customer_app/common/progressbar.dart';
import 'package:nice_customer_app/mixins/const.dart';
import 'package:nice_customer_app/ui/orders/ProviderCancelOrder.dart';
import 'package:nice_customer_app/utils/color_.dart';
import 'package:nice_customer_app/utils/padding_.dart';
import 'package:nice_customer_app/utils/textstyle_.dart';
import 'package:nice_customer_app/webservices/RestClient.dart';
import 'package:nice_customer_app/webservices/apiendpointd.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReplaceOrderPage extends StatefulWidget {
  final int orderId;
  ReplaceOrderPage({Key key, @required this.orderId}) : super(key: key);

  @override
  _ReplaceOrderPageState createState() => _ReplaceOrderPageState();
}

class _ReplaceOrderPageState extends State<ReplaceOrderPage> with Constants {
  TextEditingController _descController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<TicketReasonList> _ticketReasonList = [];

  ProviderCancelOrder providerCancelOrder;

  @override
  void initState() {
    providerCancelOrder =
        Provider.of<ProviderCancelOrder>(context, listen: false);

    Future.delayed(Duration(milliseconds: 10), () async {
      checkInternet().then((value) async {
        if (value == true) {
          await apiReasonList(context, providerCancelOrder);
        } else {
          showSnackBar(
              "${AppTranslations.of(context).text("Key_errinternet")}");
        }
      });
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
            appBar: CommonAppBar(
              appBar: AppBar(),
              title: "${AppTranslations.of(context).text("Key_ReplaceOrder")}",
            ),
            body: Consumer<ProviderCancelOrder>(
                builder: (context, providerCancelOrder, child) {
              return providerCancelOrder.showProgressBar
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
                              value:
                                  providerCancelOrder.getSelectedReasonList(),
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
                              onChanged: (newValue) {
                                providerCancelOrder
                                    .setSelectedReasonList(newValue);
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
                            height: setHeight(12),
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
                                        if (_descController.text.isEmpty) {
                                          _scaffoldKey.currentState
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                                "${AppTranslations.of(context).text("Key_DescriptionRequired")}"),
                                          ));
                                        } else {
                                          apiReplaceOrder(
                                              context, providerCancelOrder);
                                        }
                                      },
                                      title:
                                          "${AppTranslations.of(context).text("Key_submit")}")),
                            ),
                          )
                        ],
                      ),
                    );
            })));
  }

  apiReasonList(
      BuildContext context, ProviderCancelOrder providerCancelOrder) async {
    providerCancelOrder.setShowProgressBar(true);

    SharedPreferences pref = await SharedPreferences.getInstance();
    String accessToken = pref.getString(prefStr_ACCESS_TOKEN);
    showLog("accessToken :-: $accessToken");

    Response response = await RestClient.getData(
        context, ApiEndPoints.apiTicketReasonList + "REPLACE", accessToken);

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

          providerCancelOrder.setSelectedReasonList(_ticketReasonList[0]);
        } else {
          TicketReasonList tempselected = TicketReasonList();

          providerCancelOrder.setSelectedReasonList(tempselected);
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

  apiReplaceOrder(
      BuildContext context, ProviderCancelOrder providerCancelOrder) async {
    providerCancelOrder.setShowProgressBar(true);

    SharedPreferences pref = await SharedPreferences.getInstance();
    String accessToken = pref.getString(prefStr_ACCESS_TOKEN);
    showLog("accessToken :-: $accessToken");

    CancelRequest cancelRequest = new CancelRequest();
    cancelRequest.orderId = widget.orderId;
    cancelRequest.reasonId = providerCancelOrder.getSelectedReasonList().id;
    cancelRequest.description = _descController.text;

    String data = cancelRequestToJson(cancelRequest);
    showLog("replaceRequest data :-: $data");

    Response response = await RestClient.postData(
        context, ApiEndPoints.apiReplaceOrder, data, accessToken);

    if (response.statusCode == 200) {
      CommonResponce commonResponce =
          commonResponceFromJson(response.toString());
      showLog("commonResponce :-: ${commonResponceToJson(commonResponce)}");

      providerCancelOrder.setShowProgressBar(false);

      if (commonResponce.status == ApiEndPoints.apiStatus_200) {
        showSnackBar(commonResponce.message);
        _descController.text = "";

        Future.delayed(Duration(seconds: 1), () {
          Navigator.pop(context);
          Navigator.pop(context, true);
        });
      } else {
        showSnackBar(commonResponce.message);
      }
    } else {
      providerCancelOrder.setShowProgressBar(false);
      showSnackBar("${AppTranslations.of(context).text("Key_errinternet")}");
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
