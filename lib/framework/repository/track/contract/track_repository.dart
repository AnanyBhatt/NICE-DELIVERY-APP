
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:nice_customer_app/framework/repository/order/model/ReqOrder.dart';

abstract class TrackRepository {

  Future<Response> trackOrder({@required BuildContext context});

}
