import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:logger/logger.dart';
import 'package:nice_customer_app/framework/repository/track/contract/track_repository.dart';
import 'package:nice_customer_app/mixins/const.dart';
import 'package:nice_customer_app/webservices/RestClient.dart';
import 'package:nice_customer_app/webservices/apiendpointd.dart';


import 'package:shared_preferences/shared_preferences.dart';


class TrackApiRepository implements TrackRepository {


  Logger logger=Logger();
  String tag="TrackApiRepository";

  @override
  Future<Response> trackOrder({BuildContext context}) async {
    // TODO: implement trackOrder
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Response response;
    String url;
    String token= prefs.getString("ACCESS_TOKEN");

    url=ApiEndPoints.apiTrackOrder;

    print("....apiTrackOrder....URL.....$url");

    response=await RestClient.getData(context, url, token);

    return response;
  }





}
