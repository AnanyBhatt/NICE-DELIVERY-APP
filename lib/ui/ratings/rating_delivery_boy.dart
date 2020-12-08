import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nice_customer_app/Localization/app_translations.dart';
import 'package:nice_customer_app/api/responce/ReviewRatingResponse.dart';
import 'package:nice_customer_app/common/appbar.dart';
import 'package:nice_customer_app/common/no_data_found.dart';
import 'package:nice_customer_app/common/progressbar.dart';
import 'package:nice_customer_app/mixins/const.dart';
import 'package:nice_customer_app/ui/ratings/ProviderReviewRatings.dart';
import 'package:nice_customer_app/utils/color_.dart';
import 'package:nice_customer_app/utils/padding_.dart';
import 'package:nice_customer_app/utils/textstyle_.dart';
import 'package:nice_customer_app/webservices/RestClient.dart';
import 'package:nice_customer_app/webservices/apiendpointd.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReviewRatingsPage extends StatefulWidget {
  int intVendorID;
  ReviewRatingsPage({this.intVendorID});

  @override
  _ReviewRatingsPageState createState() => _ReviewRatingsPageState();
}

class _ReviewRatingsPageState extends State<ReviewRatingsPage> with Constants {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    var providerReviewRatings =
        Provider.of<ProviderReviewRatings>(context, listen: false);

    Future.delayed(Duration(milliseconds: 10), () async {
      checkInternet().then((value) {
        if (value == true) {
          apiOrderRatingList(context, providerReviewRatings);
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
    return SafeArea(
        child: Scaffold(
      key: _scaffoldKey,
      backgroundColor: GlobalColor.white,
      appBar: CommonAppBar(
          title: "${AppTranslations.of(context).text("Key_ReviewRatings")}",
          appBar: AppBar()),
      body: Consumer<ProviderReviewRatings>(
          builder: (context, providerReviewRatings, child) {
        return Container(
            padding: GlobalPadding.paddingAll_20,
            child: providerReviewRatings.getShowProgressBar()
                ? ProgressBar(clrBlack)
                : providerReviewRatings.getRatingReviewList().length > 0
                    ? ListView.builder(
                        itemCount:
                            providerReviewRatings.getRatingReviewList().length,
                        itemBuilder: (context, i) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                      providerReviewRatings
                                              .getRatingReviewList()[i]
                                              ?.customerName ??
                                          "",
                                      style: getTextStyle(
                                        context,
                                        type: Type.styleBody1,
                                        fontFamily: sourceSansFontFamily,
                                        fontWeight: fwBold,
                                        txtColor: GlobalColor.black,
                                      )),
                                  SizedBox(
                                    width: setWidth(45),
                                  ),
                                  Icon(
                                    Icons.star,
                                    size: setSp(13.5),
                                  ),
                                  SizedBox(
                                    width: setWidth(2),
                                  ),
                                  Text(
                                      providerReviewRatings
                                              .getRatingReviewList()[i]
                                              ?.vendorRating
                                              .toString() ??
                                          "",
                                      style: getTextStyle(
                                        context,
                                        type: Type.styleBody1,
                                        fontFamily: sourceSansFontFamily,
                                        fontWeight: fwExtraBold,
                                        txtColor: GlobalColor.black,
                                      )),
                                ],
                              ),
                              SizedBox(
                                height: setHeight(6),
                              ),
                              Text(
                                providerReviewRatings
                                        .getRatingReviewList()[i]
                                        ?.review ??
                                    "",
                                style: getTextStyle(
                                  context,
                                  type: Type.styleBody2,
                                  fontFamily: sourceSansFontFamily,
                                  fontWeight: fwRegular,
                                  txtColor: GlobalColor.grey,
                                ),
                              ),
                              Container(
                                margin: GlobalPadding.paddingSymmetricV_13,
                                color: GlobalColor.darkGrey,
                                height: 0.5,
                              )
                            ],
                          );
                        },
                      )
                    : NoDataFound());
      }),
    ));
  }

  apiOrderRatingList(
      BuildContext context, ProviderReviewRatings providerReviewRatings) async {
    providerReviewRatings.setShowProgressBar(true);
    SharedPreferences pref = await SharedPreferences.getInstance();
    String accessToken = pref.getString(prefStr_ACCESS_TOKEN);

    //clear list
    List<RatingReviewList> arrCustomerAddressList = List();
    providerReviewRatings.setRatingReviewList(arrCustomerAddressList);

    String apiendpoint = ApiEndPoints.apiOrderRatingList +
        "${widget.intVendorID}" +
        "/pageNumber/1/pageSize/100";
    Response response = await RestClient.getData(
      context,
      apiendpoint,
      accessToken,
    );

    if (response.statusCode == 200) {
      RatingReviewResponse ratingReviewResponse =
          ratingReviewResponseFromJson(response.toString());
      showLog(
          "apiOrderRatingList :-: ${ratingReviewResponseToJson(ratingReviewResponse)}");

      if (ratingReviewResponse.status == ApiEndPoints.apiStatus_200) {
        if (ratingReviewResponse.data != null &&
            ratingReviewResponse.data.length > 0) {
          providerReviewRatings.setRatingReviewList(ratingReviewResponse.data);
        }
      } else {
        showSnackBar(ratingReviewResponse.message);
      }
      providerReviewRatings.setShowProgressBar(false);
    } else {
      providerReviewRatings.setShowProgressBar(false);

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
