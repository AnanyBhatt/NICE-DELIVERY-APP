import 'package:flutter/material.dart';
import 'package:nice_customer_app/mixins/const.dart';
import 'package:nice_customer_app/ui/address_book/ProviderAddressBook.dart';
import 'package:nice_customer_app/utils/color_.dart';
import 'package:nice_customer_app/utils/padding_.dart';
import 'package:nice_customer_app/utils/textstyle_.dart';
import 'package:provider/provider.dart';

class ViewMorePage extends StatefulWidget {
  ViewMorePage({Key key}) : super(key: key);

  @override
  _ViewMorePageState createState() => _ViewMorePageState();
}

class _ViewMorePageState extends State<ViewMorePage> with Constants {
  @override
  Widget build(BuildContext context) {
    buildSetupScreenUtils(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: GlobalColor.white,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: GlobalColor.white,
          iconTheme: IconThemeData(color: GlobalColor.black),
          title: GestureDetector(
            onTap: () {
              // ChangeLocation().showSaveAddBottomSheet(context, () {
              //   Navigator.pop(context);
              //   _updateLocation(context);
              // });
            },
            child: Consumer<ProviderAddressBook>(
                builder: (context, providerAddressBook, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                        text: TextSpan(
                            text: deliverTo,
                            style: getTextStyle(
                              context,
                              type: Type.styleBody1,
                              fontFamily: sourceSansFontFamily,
                              fontWeight: fwLight,
                              txtColor: GlobalColor.grey,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: providerAddressBook.getSelectedAddressModel().areaName != null ? "${providerAddressBook.getSelectedAddressModel().areaName}" : "",
                                style: getTextStyle(
                                  context,
                                  type: Type.styleBody1,
                                  fontFamily: sourceSansFontFamily,
                                  fontWeight: fwBold,
                                  txtColor: GlobalColor.black,
                                ),
                              ),
                            ]),
                      ),
                      Image.asset(icDownArrow),
                    ],
                  );
                }
            ),
          ),
          actions: [
            Image.asset(
              icShoppingBag,
              // height: setHeight(30),
              // width: setWidth(30),
            ),
            SizedBox(
              width: setWidth(20),
            )
          ],
        ),
        body: Container(
          child: Column(
            children: [
              _getFilterRow(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: setHeight(25),
                      ),
                      ListView.builder(
                        itemCount: 13,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: GlobalPadding.paddingSymmetricH_20,
                        itemBuilder: (context, i) {
                          return Column(
                            children: [
                              //ItemListTile(),
                              SizedBox(
                                height: setHeight(25),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getFilterRow() {
    return Material(
      elevation: 6,
      child: Container(
        color: GlobalColor.white,
        padding: EdgeInsets.only(bottom: setHeight(5)),
        child: Row(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.asset(
                    icFilter,
                    color: GlobalColor.black,
                    height: setHeight(30),
                    width: setWidth(30),
                  ),
                  Text(
                    filter,
                    textAlign: TextAlign.end,
                    style: getTextStyle(
                      context,
                      type: Type.styleBody1,
                      fontFamily: sourceSansFontFamily,
                      fontWeight: fwSemiBold,
                      txtColor: GlobalColor.black,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: setWidth(50),
            ),
            Expanded(
              child: Row(
                children: [
                  Image.asset(
                    icLocSearch,
                    color: GlobalColor.grey,
                    height: setHeight(30),
                    width: setWidth(30),
                  ),
                  Text(
                    search,
                    style: getTextStyle(
                      context,
                      type: Type.styleBody1,
                      fontFamily: sourceSansFontFamily,
                      fontWeight: fwSemiBold,
                      txtColor: GlobalColor.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
