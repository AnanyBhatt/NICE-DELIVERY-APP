import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:nice_customer_app/api/request/RefreshRequest.dart';
import 'package:nice_customer_app/api/responce/RefreshResponce.dart';
import 'package:nice_customer_app/mixins/const.dart';
import 'package:nice_customer_app/webservices/apiendpointd.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CacheInterceptor extends InterceptorsWrapper with Constants {
  var dio = new Dio();

  String apiType;
  Dio previous;
  BuildContext context;

  CacheInterceptor(this.context, this.previous, this.apiType);

  static String apiPOST = "POST";
  static String apiGET = "GET";
  static String apiGETQUERYPARAMETER = "GETQUERYPARAMETER";
  static String apiPUT = "PUT";
  static String apiPUTQUERYPARAMETER = "PUTQUERYPARAMETER";
  static String apiDELETE = "DELETE";

  @override
  onRequest(RequestOptions options) async {
    return options;
  }

  @override
  onResponse(Response response) async {
    return response;
  }

  @override
  onError(DioError error) async {
    if (error.response?.statusCode == 401) {
      RequestOptions options = error.request;

      previous.lock();
      previous.interceptors.responseLock.lock();
      previous.interceptors.errorLock.lock();

      try {
        await apiRefreshToken();

        previous.unlock();
        previous.interceptors.responseLock.unlock();
        previous.interceptors.errorLock.unlock();


        SharedPreferences pref = await SharedPreferences.getInstance();
        String accessToken = pref.getString(prefStr_ACCESS_TOKEN);

        var dioauth = Dio(BaseOptions(headers: {
          "Authorization": "Bearer " + accessToken,
          "content-type": "application/json",
        }));


        Response response;

        if (apiType == apiGET) {
          response = await dioauth.get(options.path);
        } else if (apiType == apiGETQUERYPARAMETER) {
          response = await dioauth.get(options.path,
              queryParameters: options.queryParameters);
        } else if (apiType == apiPOST) {
          response = await dioauth.post(options.path, data: options.data);
        } else if (apiType == apiPUT) {
          response = await dioauth.put(options.path, data: options.data);
        } else if (apiType == apiPUTQUERYPARAMETER) {
          response = await dioauth.put(options.path,
              queryParameters: options.queryParameters);
        } else if (apiType == apiDELETE) {
          response = await dioauth.delete(options.path);
        }

        return response;
      } catch (e) {
        logoutFromApp(context);
      }
    }
    return error;
  }

  Future apiRefreshToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String refresh_token = pref.getString(prefStr_REFRESH_TOKEN);

    RefreshRequest refreshRequest = RefreshRequest();
    refreshRequest.refreshToken = refresh_token;
    refreshRequest.grantType = ApiEndPoints.static_GRANTTYPE;

    String data = refreshRequestToJson(refreshRequest);

    try {
      String credential = "kody-client:kody-secret";

      Options opt = Options(headers: {
        "Authorization": "Basic " + base64.encode(utf8.encode(credential)),
        "content-type": "application/x-www-form-urlencoded",
        "No-Auth": "True",
      });

      Response response = await dio.post(ApiEndPoints.apiRefreshToken,
          queryParameters: refreshRequest.toJson(), options: opt);

      if (response.statusCode == 200) {
        RefreshResponce refreshResponce =
            refreshResponceFromJson(response.toString());

        sharePref_saveString(prefStr_SCOPE, refreshResponce.scope);
        sharePref_saveString(prefStr_ACCESS_TOKEN, refreshResponce.accessToken);
        sharePref_saveString(prefStr_TOKEN_TYPE, refreshResponce.tokenType);
        sharePref_saveString(
            prefStr_REFRESH_TOKEN, refreshResponce.refreshToken);
        sharePref_saveInt(prefInt_EXPIRES_IN, refreshResponce.expiresIn);

        return;
      } else {

        logoutFromApp(context);
      }
    } on DioError catch (e) {
      logoutFromApp(context);
    }
  }
}
