import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:logger/logger.dart';
import 'package:nice_customer_app/framework/repository/cart/contract/cart_repository.dart';
import 'package:nice_customer_app/framework/repository/cart/model/AddCartModel.dart';
import 'package:nice_customer_app/framework/repository/order/contract/order_repository.dart';
import 'package:nice_customer_app/framework/repository/order/model/ReqOrder.dart';
import 'package:nice_customer_app/mixins/const.dart';
import 'package:nice_customer_app/webservices/RestClient.dart';
import 'package:nice_customer_app/webservices/apiendpointd.dart';


import 'package:shared_preferences/shared_preferences.dart';


class OrderApiRepository implements OrderRepository {


  Logger logger=Logger();
  String tag="OrderApiRepository";



  @override
  Future<Response> placeOrder({BuildContext context, ReqOrder reqOrder}) async {


    SharedPreferences prefs = await SharedPreferences.getInstance();
    Response response;
    String url;
    String token= prefs.getString("ACCESS_TOKEN");
    String data=json.encode(reqOrder.toJson());
    url=ApiEndPoints.urlPlaceOrder;
    response=await RestClient.postData(context, url, data, token);

    return response;


  }

  @override
  Future<Response> orderDetails({BuildContext context, String orderId}) async{

    SharedPreferences prefs = await SharedPreferences.getInstance();

    Response response;
    String url;
    String token= prefs.getString("ACCESS_TOKEN");

    url=ApiEndPoints.urlOrderDetails(orderId: orderId);

    print("....order....URL.....$url");

    response=await RestClient.getData(context, url, token);

    return response;


  }


}
