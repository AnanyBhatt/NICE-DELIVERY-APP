import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:nice_customer_app/Localization/app_translations.dart';
import 'package:nice_customer_app/api/request/OrderRatingRequest.dart';
import 'package:nice_customer_app/api/responce/CommonResponce.dart';
import 'package:nice_customer_app/api/responce/OrderRatingQueListResponse.dart';
import 'package:nice_customer_app/common/appbar.dart';
import 'package:nice_customer_app/common/flaticonbutton.dart';
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

class RatingInputPage extends StatefulWidget {
  final int orderId;
  final String deliveryType;
  RatingInputPage({@required this.orderId, @required this.deliveryType});

  @override
  _RatingInputState createState() => _RatingInputState();
}

class _RatingInputState extends State<RatingInputPage> with Constants {
  var rating = 0.0;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController _anySuggestionsController = new TextEditingController();

  @override
  void initState() {
    var providerReviewRatings =
        Provider.of<ProviderReviewRatings>(context, listen: false);

    Future.delayed(Duration(milliseconds: 10), () async {
      checkInternet().then((value) {
        if (value == true) {
          apiRatingQuestion(context, providerReviewRatings);
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
      backgroundColor: Color(clrWhite),
      appBar: CommonAppBar(
          title:
              "${AppTranslations.of(context).text("Key_rateYourExperience")}",
          appBar: AppBar()),
      body: Consumer<ProviderReviewRatings>(
          builder: (context, providerReviewRatings, child) {
        return providerReviewRatings.getShowProgressBar()
            ? ProgressBar(clrBlack)
            : SingleChildScrollView(
                child: Container(
                  padding: GlobalPadding.paddingAll_20,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: providerReviewRatings
                                .getOrderRatingQueList()
                                .length,
                            itemBuilder: (context, i) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${i + 1}. ${providerReviewRatings.getOrderRatingQueList()[i].question}",
                                    style: getTextStyle(
                                      context,
                                      type: Type.styleBody1,
                                      fontFamily: sourceSansFontFamily,
                                      fontWeight: fwRegular,
                                      txtColor: GlobalColor.grey,
                                    ),
                                  ),
                                  SizedBox(
                                    height: setHeight(9.6),
                                  ),
                                  RatingBar(
                                    initialRating: providerReviewRatings
                                        .getOrderRatings()[i],
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: false,
                                    itemCount: 5,
                                    itemSize: setSp(25),
                                    itemPadding:
                                        EdgeInsets.only(right: setWidth(38)),
                                    itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                      color: Colors.black,
                                    ),
                                    onRatingUpdate: (rating) {
                                      print(rating);
                                      providerReviewRatings.setOrderRatings(
                                          i, rating);
                                    },
                                  ),
                                  Divider(
                                    thickness: 1,
                                    height: setHeight(29.94),
                                  ),
                                ],
                              );
                            }),
                        Text(
                          "${AppTranslations.of(context).text("Key_anySuggestions")}",
                          style: getTextStyle(
                            context,
                            type: Type.styleBody1,
                            fontFamily: sourceSansFontFamily,
                            fontWeight: fwRegular,
                            txtColor: GlobalColor.black,
                          ),
                        ),
                        SizedBox(
                          height: setHeight(11),
                        ),
                        TextFormField(
                          maxLines: 3,
                          controller: _anySuggestionsController,
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
                        SizedBox(
                          height: 39,
                        ),
                        SizedBox(
                            width: infiniteSize,
                            child: FlatCustomButton(
                                onPressed: () {
                                  checkInternet().then((value) {
                                    if (value == true) {
                                      apiOrderRating(
                                          context, providerReviewRatings);
                                    } else {
                                      showSnackBar(
                                          "${AppTranslations.of(context).text("Key_errinternet")}");
                                    }
                                  });
                                },
                                title:
                                    "${AppTranslations.of(context).text("Key_submit")}")),
                      ]),
                ),
              );
      }),
    ));
  }

  apiRatingQuestion(
      BuildContext context, ProviderReviewRatings providerReviewRatings) async {
    providerReviewRatings.setShowProgressBar(true);
    SharedPreferences pref = await SharedPreferences.getInstance();
    String accessToken = pref.getString(prefStr_ACCESS_TOKEN);

    //clear list
    List<OrderRatingQueList> orderRatingList = List();
    providerReviewRatings.setOrderRatingQueList(orderRatingList);

    Response response = await RestClient.getData(
      context,
      ApiEndPoints.apiRatingQuestion + "deliveryType=${widget.deliveryType}",
      accessToken,
    );

    print("URL: ${ApiEndPoints.apiRatingQuestion}");

    if (response.statusCode == 200) {
      OrderRatingQueListResponse orderRatingQueListResponse =
          orderRatingQueListResponseFromJson(response.toString());
      showLog(
          "OrderRating :-: ${orderRatingQueListResponseToJson(orderRatingQueListResponse)}");

      if (orderRatingQueListResponse.status == ApiEndPoints.apiStatus_200) {
        if (orderRatingQueListResponse.data != null &&
            orderRatingQueListResponse.data.length > 0) {
          providerReviewRatings
              .setOrderRatingQueList(orderRatingQueListResponse.data);
          providerReviewRatings.setOrderRatings(1, 0);

          for (int i = 0;
              i < providerReviewRatings.getOrderRatingQueList().length;
              i++) {
            providerReviewRatings.setOrderRatings(i, 0);
          }
        }
      } else {
        showSnackBar(orderRatingQueListResponse.message);
      }
      providerReviewRatings.setShowProgressBar(false);
    } else {
      providerReviewRatings.setShowProgressBar(false);

      showSnackBar("${AppTranslations.of(context).text("Key_errinternet")}");
    }
  }

  apiOrderRating(
      BuildContext context, ProviderReviewRatings providerReviewRatings) async {
    providerReviewRatings.setShowProgressBar(true);
    SharedPreferences pref = await SharedPreferences.getInstance();
    String accessToken = pref.getString(prefStr_ACCESS_TOKEN);

    OrderRatingRequest orderRatingRequest = new OrderRatingRequest();
    orderRatingRequest.question1Rating =
        providerReviewRatings.getOrderRatings()[0];
    orderRatingRequest.question2Rating =
        providerReviewRatings.getOrderRatings()[1];
    orderRatingRequest.question3Rating =
        providerReviewRatings.getOrderRatings()[2];
    orderRatingRequest.question4Rating =
        providerReviewRatings.getOrderRatings()[3];
    orderRatingRequest.question5Rating =
        providerReviewRatings.getOrderRatings()[4];
    orderRatingRequest.active = Constants.static_ACTIVE;

    orderRatingRequest.review = _anySuggestionsController.text;
    orderRatingRequest.orderId = widget.orderId;

    String data = orderRatingRequestToJson(orderRatingRequest);
    showLog("orderRatingRequest data :-: $data");

    Response response = await RestClient.postData(
      context,
      ApiEndPoints.apiOrderRating,
      data,
      accessToken,
    );

    print("URL: ${ApiEndPoints.apiOrderRating}");

    if (response.statusCode == 200) {
      CommonResponce commonResponce =
          commonResponceFromJson(response.toString());
      showLog("apiRatingQuestion :-: ${commonResponceToJson(commonResponce)}");

      if (commonResponce.status == ApiEndPoints.apiStatus_200) {
        showSnackBar(commonResponce.message);

        Future.delayed(Duration(seconds: 1), () {
          // _scaffoldKey.currentState.hideCurrentSnackBar();
          Navigator.pop(context, true);
        });
      } else {
        showSnackBar(commonResponce.message);
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
