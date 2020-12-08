import 'package:flutter/material.dart';
import 'package:nice_customer_app/Localization/app_translations.dart';
import 'package:nice_customer_app/common/drawerAppBar.dart';
import 'package:nice_customer_app/common/no_data_found.dart';
import 'package:nice_customer_app/mixins/const.dart';
import 'package:nice_customer_app/ui/drawer/drawer.dart';
import 'package:nice_customer_app/ui/ticket/add_ticket.dart';
import 'package:nice_customer_app/ui/ticket/tickets_tile.dart';
import 'package:nice_customer_app/utils/color_.dart';
import 'package:nice_customer_app/utils/padding_.dart';

import 'package:nice_customer_app/ui/ticket/ProviderTicket.dart';
import 'package:nice_customer_app/api/responce/TicketListResponce.dart';

import 'package:dio/dio.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:nice_customer_app/webservices/RestClient.dart';
import 'package:nice_customer_app/webservices/apiendpointd.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nice_customer_app/common/progressbar.dart';

class TicketListPage extends StatefulWidget {
  TicketListPage({Key key}) : super(key: key);

  @override
  _TicketListPageState createState() => _TicketListPageState();
}

class _TicketListPageState extends State<TicketListPage> with Constants {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int intCurrentPage = 1;
  ScrollController _sc = new ScrollController();

  void initState() {
    super.initState();

    refresh();
  }

  refresh() {
    ProviderTicket providerTicket =
        Provider.of<ProviderTicket>(context, listen: false);

    Future.delayed(Duration(milliseconds: 10), () async {
      await providerTicket.setTicketList(new List());
    });

    //--
    checkInternet().then((value) async {
      if (value == true) {
        await apiTicketList(context, providerTicket, true, intCurrentPage);
      } else {
        showSnackBar("${AppTranslations.of(context).text("Key_errinternet")}");
      }
    });

    //-- Pagination
    _sc.addListener(() {
      if (_sc.position.pixels == _sc.position.maxScrollExtent) {
        if (providerTicket.getTotalCount() >
            providerTicket.getTicketList().length) {
          //--
          checkInternet().then((value) {
            if (value == true) {
              intCurrentPage++;
              apiTicketList(context, providerTicket, true, intCurrentPage);
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
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: GlobalColor.white,
        appBar: DrawerAppBar(
          appBar: AppBar(),
          title: "${AppTranslations.of(context).text("Key_Ticket")}",
          action: [
            IconButton(
                icon: Icon(
                  Icons.add,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddTicketPage(refresh),
                    ),
                  );
                })
          ],
        ),
        drawer: DrawerPage(),
        body: Consumer<ProviderTicket>(
          builder: (context, providerTicket, child) {
            return Stack(
              children: <Widget>[
                SingleChildScrollView(
                  controller: _sc,
                  child: Container(
                    padding: GlobalPadding.paddingSymmetricH_20,
                    margin: GlobalPadding.paddingSymmetricV_20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        providerTicket.getShowProgressBarMain()
                            ? Container(
                                height: setHeight(350),
                                child: ProgressBar(clrBlack))
                            : providerTicket.getTicketList().length == 0
                                ? Container(child: NoDataFound())
                                : _getTicketLists(providerTicket),
                      ],
                    ),
                  ),
                ),
                providerTicket.getShowProgressBar() == false
                    ? Container()
                    : Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: ProgressBar(clrBlack)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _getTicketLists(ProviderTicket providerTicket) {
    return ListView.builder(
        itemCount: providerTicket.getTicketList().length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, i) {
          return Container(
              margin: EdgeInsets.only(bottom: setHeight(10)),
              child: TicketsTile(arrData: providerTicket.getTicketList()[i]));
        });
  }

  apiTicketList(BuildContext context, ProviderTicket providerTicket,
      bool showProgressBar, int page) async {
    if (page == 1) {
      providerTicket.setShowProgressBarMain(true);
    } else if (showProgressBar == true) {
      providerTicket.setShowProgressBar(true);
    }

    SharedPreferences pref = await SharedPreferences.getInstance();
    String accessToken = pref.getString(prefStr_ACCESS_TOKEN);
    String endpoint = ApiEndPoints.apiTicketList + "$page" + "/pageSize/10";
    showLog("accessToken :-: $accessToken");

    Response response =
        await RestClient.getData(context, endpoint, accessToken);

    if (response.statusCode == 200) {
      TicketListResponce ticketListResponce =
          ticketListResponceFromJson(response.toString());
      showLog(
          "apiTicketList :-: ${ticketListResponceToJson(ticketListResponce)}");

      if (page == 1) {
        providerTicket.setShowProgressBarMain(false);
      } else if (showProgressBar == true) {
        providerTicket.setShowProgressBar(false);
      }

      if (ticketListResponce.status == ApiEndPoints.apiStatus_200) {
        if (page == 1) {
          providerTicket.arrTicketList = new List();
          providerTicket.setTicketList(new List());
        }

        if (ticketListResponce.data != null &&
            ticketListResponce.data.length > 0) {
          providerTicket.setTotalCount(ticketListResponce.totalCount);
          providerTicket.setTicketList(ticketListResponce.data);
        } else {
          providerTicket.setTotalCount(0);
          providerTicket.setTicketList(new List());
        }
      } else {
        showSnackBar(ticketListResponce.message);
      }
    } else {
      if (page == 1) {
        providerTicket.setShowProgressBarMain(false);
      } else if (showProgressBar == true) {
        providerTicket.setShowProgressBar(false);
      }

      showSnackBar("${AppTranslations.of(context).text("Key_errinternet")}");
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
