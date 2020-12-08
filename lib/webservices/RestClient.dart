import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:nice_customer_app/mixins/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cacheinterceptor.dart';

class RestClient{

  static var dio = new Dio();



  static Future<Response> getData(BuildContext context, String endpoint, String token) async {

    SharedPreferences preferences = await SharedPreferences.getInstance();
    var appLanguage = preferences.getString(Constants.active_app_language);

    if(appLanguage=="ar")
    {
      appLanguage=="fr";
    }


    if(token != null && token.length>0){

      var dioauth = Dio(BaseOptions(
          headers: {
            "Authorization" : "Bearer "+token,
            "content-type": "application/json",
            "Accept-Language":appLanguage,
          }
      ));

      dioauth.interceptors.clear();
      dioauth.interceptors.add(CacheInterceptor(context, dio, CacheInterceptor.apiGET));
      Response response = await dioauth.get(endpoint);
      return response;
    }else{

      Options opt2 = Options(
          headers: {
            "content-type": "application/json",
            "Accept-Language":appLanguage,
          }
      );

      Response response = await dio.get(endpoint, options: opt2);
      return response;
    }

  }



  static Future<Response> getDataQueryParameter(BuildContext context, String endpoint, String token, Map<String, dynamic> queryParameters) async {

    SharedPreferences preferences = await SharedPreferences.getInstance();
    var appLanguage = preferences.getString(Constants.active_app_language);

    if(appLanguage=="ar")
    {
      appLanguage=="fr";
    }

    if(token != null && token.length>0){
      var dioauth = Dio(BaseOptions(
          headers: {
            "Authorization" : "Bearer "+token,
            "content-type": "application/json",
            "Accept-Language":appLanguage,
          }
      ));

      dioauth.interceptors.clear();
      dioauth.interceptors.add(CacheInterceptor(context, dio, CacheInterceptor.apiGETQUERYPARAMETER));
      Response response = await dioauth.get(endpoint, queryParameters: queryParameters);
      return response;
    }else{
      Options opt2 = Options(
          headers: {
            "content-type": "application/json",
            "Accept-Language":appLanguage,
          }
      );

      Response response = await dio.get(endpoint, options: opt2, queryParameters: queryParameters);
      return response;
    }


  }




  static Future<Response> postData(BuildContext context, String endpoint, String data, String token) async {

    SharedPreferences preferences = await SharedPreferences.getInstance();
    var appLanguage = preferences.getString(Constants.active_app_language);

    if(appLanguage=="ar")
    {
      appLanguage=="fr";
    }

    if(token != null && token.length>0){
      var dioauth = Dio(BaseOptions(
          headers: {
            "Authorization" : "Bearer "+token,
            "content-type": "application/json",
            "Accept-Language":appLanguage,
          }
      ));

      dioauth.interceptors.clear();
      dioauth.interceptors.add(CacheInterceptor(context, dio, CacheInterceptor.apiPOST));
      Response response = await dioauth.post(endpoint, data: data);
      return response;
    }else{
      Options opt2 = Options(
          headers: {
            "content-type": "application/json",
            "Accept-Language":appLanguage,
          }
      );

      Response response = await dio.post(endpoint, data: data, options: opt2);
      return response;
    }

  }



  static Future<Response> putData(BuildContext context, String endpoint, String data, String token) async {

    SharedPreferences preferences = await SharedPreferences.getInstance();
    var appLanguage = preferences.getString(Constants.active_app_language);

    if(appLanguage=="ar")
    {
      appLanguage=="fr";
    }

    if(token != null && token.length>0){
      var dioauth = Dio(BaseOptions(
          headers: {
            "Authorization" : "Bearer "+token,
            "content-type": "application/json",
            "Accept-Language":appLanguage,
          }
      ));


      dioauth.interceptors.clear();
      dioauth.interceptors.add(CacheInterceptor(context, dio, CacheInterceptor.apiPUT));
      Response response = await dioauth.put(endpoint, data: data);
      return response;
    }else{
      Options opt2 = Options(
          headers: {
            "content-type": "application/json",
            "Accept-Language":appLanguage,
          }
      );

      Response response = await dio.put(endpoint, data: data, options: opt2);
      return response;
    }

  }


  static Future<Response> putDataQueryParameter(BuildContext context, String endpoint, String token, Map<String, dynamic> queryParameters) async {

    SharedPreferences preferences = await SharedPreferences.getInstance();
    var appLanguage = preferences.getString(Constants.active_app_language);

    if(appLanguage=="ar")
    {
      appLanguage=="fr";
    }

    if(token != null && token.length>0){
      var dioauth = Dio(BaseOptions(
          headers: {
            "Authorization" : "Bearer "+token,
            "content-type": "application/json",
            "Accept-Language":appLanguage,

          }
      ));

      dioauth.interceptors.clear();
      dioauth.interceptors.add(CacheInterceptor(context, dio, CacheInterceptor.apiPUTQUERYPARAMETER));
      Response response = await dioauth.put(endpoint, queryParameters: queryParameters);
      return response;
    }else{
      Options opt2 = Options(
          headers: {
            "content-type": "application/json",
            "Accept-Language":appLanguage,
          }
      );


      Response response = await dio.put(endpoint, options: opt2, queryParameters: queryParameters);
      return response;
    }

  }



  static Future<Response> deleteData(BuildContext context, String endpoint, String token) async {

    SharedPreferences preferences = await SharedPreferences.getInstance();
    var appLanguage = preferences.getString(Constants.active_app_language);

    if(appLanguage=="ar")
    {
      appLanguage=="fr";
    }

    if(token != null && token.length>0){
      var dioauth = Dio(BaseOptions(
          headers: {
            "Authorization" : "Bearer "+token,
            "content-type": "application/json",
            "Accept-Language":appLanguage,
          }
      ));

      dioauth.interceptors.clear();
      dioauth.interceptors.add(CacheInterceptor(context, dio, CacheInterceptor.apiDELETE));
      Response response = await dioauth.delete(endpoint);
      return response;
    }else{
      Options opt2 = Options(
          headers: {
            "content-type": "application/json",
            "Accept-Language":appLanguage,
          }
      );

      Response response = await dio.delete(endpoint, options: opt2);
      return response;
    }

  }




  static Future<Response> postDataAuth(String endpoint, Map<String, dynamic> queryParameters) async {

    String credential = "kody-client:kody-secret";

    Options opt = Options(
        headers: {
          "Authorization" : "Basic "+base64.encode(utf8.encode(credential)),
          "content-type": "application/x-www-form-urlencoded",
          "No-Auth": "True",
        }
    );


    Response response = await dio.post(endpoint, queryParameters: queryParameters, options: opt);
    return response;

  }



  static Future<Response> getDataGuest({@required String url}) async {

    SharedPreferences preferences = await SharedPreferences.getInstance();
    var appLanguage = preferences.getString(Constants.active_app_language);

    if(appLanguage=="ar")
    {
      appLanguage=="fr";
    }


    Options dioGuestOptions = Options(
        headers: {
          "content-type": "application/json",
          "Accept-Language":appLanguage,
        }
    );

    Response response;
    try {
      response = await dio.get(url,options: dioGuestOptions);
      return response;
    } catch (e) {
      if (e is DioError) {
        response = e.response;
      }
      return response;
    }

  }



  static Future<Response> PostDataGuest({ @required String endpoint, @required String data}) async {

    SharedPreferences preferences = await SharedPreferences.getInstance();
    var appLanguage = preferences.getString(Constants.active_app_language);

    if(appLanguage=="ar")
    {
      appLanguage=="fr";
    }


    Options dioGuestOptions = Options(
        headers: {
          "content-type": "application/json",
          "Accept-Language":appLanguage,
        }
    );

    Response response;
    try {
      response = await dio.post(endpoint, data: data, options: dioGuestOptions);
      return response;
    } catch (e) {
      if (e is DioError) {
        response = e.response;
      }
      return response;
    }

  }




  static Future<Response> PutDataGuest({ @required String endpoint, @required String data}) async {

    SharedPreferences preferences = await SharedPreferences.getInstance();
    var appLanguage = preferences.getString(Constants.active_app_language);

    if(appLanguage=="ar")
    {
      appLanguage=="fr";
    }


    Options dioGuestOptions = Options(
        headers: {
          "content-type": "application/json",
          "Accept-Language":appLanguage,
        }
    );

    Response response;
    try {
      response = await dio.put(endpoint, data: data, options: dioGuestOptions);
      return response;
    } catch (e) {
      if (e is DioError) {
        response = e.response;
      }
      return response;
    }

  }




  static Future<Response> deleteDataGuest({@required String url}) async {

    SharedPreferences preferences = await SharedPreferences.getInstance();
    var appLanguage = preferences.getString(Constants.active_app_language);

    if(appLanguage=="ar")
    {
      appLanguage=="fr";
    }


    Options dioGuestOptions = Options(
        headers: {
          "content-type": "application/json",
          "Accept-Language":appLanguage,
        }
    );

    Response response;
    try {
      response = await dio.delete(url,options: dioGuestOptions);
      return response;
    } catch (e) {
      if (e is DioError) {
        response = e.response;
      }
      return response;
    }

  }


}