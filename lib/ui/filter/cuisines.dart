import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nice_customer_app/Localization/app_translations.dart';
import 'package:nice_customer_app/api/request/CuisineVendorResponce.dart';
import 'package:nice_customer_app/common/appbar.dart';
import 'package:nice_customer_app/common/flaticonbutton.dart';
import 'package:nice_customer_app/mixins/const.dart';
import 'package:nice_customer_app/ui/vendor_details/ProviderVendorList.dart';
import 'package:nice_customer_app/utils/color_.dart';
import 'package:nice_customer_app/utils/padding_.dart';
import 'package:nice_customer_app/utils/textstyle_.dart';
import 'package:nice_customer_app/webservices/RestClient.dart';
import 'package:nice_customer_app/webservices/apiendpointd.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CuisinesPage extends StatefulWidget {
  @override
  _CuisinesPageState createState() => _CuisinesPageState();
}

class _CuisinesPageState extends State<CuisinesPage> with Constants {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void initState() {
    super.initState();

    //--
    ProviderVendorList providerVendorList =
        Provider.of<ProviderVendorList>(context, listen: false);

    //--
    Future.delayed(Duration(milliseconds: 10), () async {
      providerVendorList.setCuisineList(new List());
    });

    //--
    checkInternet().then((value) {
      if (value == true) {
        apiCuisinesVendor(context, providerVendorList);
      } else {
        showSnackBar(errInternetConnection);
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: GlobalColor.white,
        appBar: CommonAppBar(
          title: "${AppTranslations.of(context).text("Key_Cuisines")}",
          appBar: AppBar(),
          action: [],
        ),
        body: Consumer<ProviderVendorList>(
          builder: (context, providerVendorList, child) {
            return Container(
              padding: GlobalPadding.paddingSymmetricH_20,
              child: providerVendorList.getCuisineList().length == 0
                  ? Container()
                  : _cuisinesList(providerVendorList),
            );
          },
        ),
        bottomNavigationBar: Consumer<ProviderVendorList>(
          builder: (context, providerVendorList, child) {
            return Padding(
              padding: EdgeInsets.all(setWidth(10)),
              child: FlatCustomButton(
                title: "${AppTranslations.of(context).text("Key_Done")}",
                onPressed: () {
                  providerVendorList.setCuisineListSelected(new List());
                  List<CuisineList> arrTemp = List();
                  for (int i = 0;
                      i < providerVendorList.getCuisineList().length;
                      i++) {
                    if (providerVendorList.getCuisineList()[i].isSelected ==
                        true) {
                      arrTemp.add(providerVendorList.getCuisineList()[i]);
                    }
                  }
                  providerVendorList.setCuisineListSelected(arrTemp);

                  Navigator.pop(context);
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _cuisinesList(ProviderVendorList providerVendorList) {
    return ListView.separated(
        shrinkWrap: true,
        itemCount: providerVendorList.getCuisineList().length,
        separatorBuilder: (context, index) => SizedBox(
              height: setWidth(10),
            ),
        itemBuilder: (context, i) {
          return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  providerVendorList.getCuisineList()[i].name,
                  style: getTextStyle(context,
                      type: Type.styleBody1,
                      fontFamily: sourceSansFontFamily,
                      fontWeight: fwRegular,
                      txtColor: GlobalColor.black),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      if (providerVendorList.getCuisineList()[i].isSelected)
                        providerVendorList.getCuisineList()[i].isSelected =
                            false;
                      else
                        providerVendorList.getCuisineList()[i].isSelected =
                            true;
                    });
                  },
                  child: Container(
                    height: setHeight(18),
                    width: setWidth(18),
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(2)),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Image.asset(
                        icCheckDark,
                        color: providerVendorList.getCuisineList()[i].isSelected
                            ? GlobalColor.black
                            : GlobalColor.white,
                      ),
                    ),
                  ),
                ),
              ]);
        });
  }

  apiCuisinesVendor(
      BuildContext context, ProviderVendorList providerVendorList) async {
    providerVendorList.setShowProgressBar(true);

    SharedPreferences pref = await SharedPreferences.getInstance();
    String accessToken = pref.getString(prefStr_ACCESS_TOKEN);

    Response response = await RestClient.getData(
        context, ApiEndPoints.apiCuisinesVendor, accessToken);

    if (response.statusCode == 200) {
      CuisineVendorResponce cuisineVendorResponce =
          cuisineVendorResponceFromJson(response.toString());

      providerVendorList.setShowProgressBar(false);

      if (cuisineVendorResponce.status == ApiEndPoints.apiStatus_200) {
        if (cuisineVendorResponce.data != null &&
            cuisineVendorResponce.data.length > 0) {
          if (providerVendorList.getCuisineListSelected() != null &&
              providerVendorList.getCuisineListSelected().length > 0) {
            for (int i = 0; i < cuisineVendorResponce.data.length; i++) {
              for (int j = 0;
                  j < providerVendorList.getCuisineListSelected().length;
                  j++) {
                if (cuisineVendorResponce.data[i].id ==
                    providerVendorList.getCuisineListSelected()[j].id) {
                  cuisineVendorResponce.data[i].isSelected = true;
                  break;
                }
              }
            }
          }

          providerVendorList.setCuisineList(cuisineVendorResponce.data);
        } else {
          providerVendorList.setCuisineList(new List());
        }
      } else {
        showSnackBar(cuisineVendorResponce.message);
      }
    } else {
      providerVendorList.setShowProgressBar(false);
      showSnackBar(errSomethingWentWrong);
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
