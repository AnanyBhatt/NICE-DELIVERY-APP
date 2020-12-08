
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:nice_customer_app/framework/repository/order/model/ReqOrder.dart';

abstract class OrderRepository {

  Future<Response> placeOrder({@required BuildContext context, @required ReqOrder reqOrder});
  Future<Response> orderDetails({@required BuildContext context, @required String orderId});





}
