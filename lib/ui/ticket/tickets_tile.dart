import 'package:flutter/material.dart';
import 'package:nice_customer_app/Localization/app_translations.dart';
import 'package:nice_customer_app/mixins/const.dart';
import 'package:nice_customer_app/ui/drawer/drawer.dart';
import 'package:nice_customer_app/ui/ticket/ticket_detail.dart';
import 'package:nice_customer_app/utils/color_.dart';
import 'package:nice_customer_app/utils/padding_.dart';
import 'package:nice_customer_app/utils/textstyle_.dart';
import 'package:nice_customer_app/api/responce/TicketListResponce.dart';

class TicketsTile extends StatefulWidget {

  final TicketList arrData;
  TicketsTile({Key key, this.arrData}) : super(key: key);

  @override
  _TicketsTileState createState() => _TicketsTileState();
}

class _TicketsTileState extends State<TicketsTile> with Constants {

  String ticketDateTime;

  void initState(){
    super.initState();

    ticketDateTime = convertDateformat(widget.arrData.createdAt.toString());
  }

  @override
  Widget build(BuildContext context) {
    buildSetupScreenUtils(context);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
              transitionDuration: Duration(milliseconds: pageDuration),
              pageBuilder: (_, __, ___) => TicketDetailPage(
                ticketId: widget.arrData.id,
                  )),
        );
      },
      child: Card(
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
                "${AppTranslations.of(context).text("Key_TicketNo")}.: ${widget.arrData.id.toString()}",
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
                    "${AppTranslations.of(context).text("Key_TicketDate")}",
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
                    ticketDateTime,
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
                      ticketStatus,
                      style: getTextStyle(context,
                          type: Type.styleBody2,
                          fontFamily: sourceSansFontFamily,
                          fontWeight: fwRegular,
                          txtColor: GlobalColor.grey),
                    ),
                  )),
                ],
              ),
              SizedBox(
                height: setHeight(10),
              ),
              Row(
                children: [
                  Text(
                    "${AppTranslations.of(context).text("Key_TicketReason")}",
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
                    widget.arrData.ticketReason,
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
                      widget.arrData.ticketStatus,
                      style: getTextStyle(context,
                          type: Type.styleBody2,
                          fontFamily: sourceSansFontFamily,
                          fontWeight: fwSemiBold,
                          txtColor: widget.arrData.ticketStatus == pending
                              ? GlobalColor.red
                              : widget.arrData.ticketStatus == acknowledged
                                  ? GlobalColor.yellow
                                  : GlobalColor.green),
                    ),
                  )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
