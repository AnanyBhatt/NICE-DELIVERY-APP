import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:nice_customer_app/framework/repository/cart/contract/cart_repository.dart';
import 'package:nice_customer_app/framework/repository/cart/model/AddCartModel.dart';
import 'package:nice_customer_app/mixins/const.dart';
import 'package:nice_customer_app/webservices/RestClient.dart';
import 'package:nice_customer_app/webservices/apiendpointd.dart';


import 'package:shared_preferences/shared_preferences.dart';


class CartApiRepository implements CartRepository {


  Logger logger=Logger();
  String tag="CartApiRepository";


  @override
  Future<Response> checkValidCartItem({BuildContext context, String vendorId})  async{

    SharedPreferences prefs = await SharedPreferences.getInstance();

    Response response;

    String url;
    bool isLogin= prefs.getBool("ISLOGIN");
    String uuid= prefs.getString("UUID");
    String token= prefs.getString("ACCESS_TOKEN");

    //isLogin=false;

    if(isLogin == true)
      {
        url=ApiEndPoints.urlCheckValidCartItem(vendorId: vendorId);
        logger.e("...$tag......url....$url");
        response = await RestClient.getData(context, url, token);
      }
    else{

       url=ApiEndPoints.urlCheckValidCartItemGuest(uuid: uuid, vendorId: vendorId);
       logger.e("...$tag......url....$url");
       response = await RestClient.getDataGuest( url: url);
    }





   return response;
  }

  @override
  Future<Response> addToCart({@required BuildContext context, @required AddCartModel addCartModel}) async{

    SharedPreferences prefs = await SharedPreferences.getInstance();

    Response response;

    String url;
    bool isLogin= prefs.getBool("ISLOGIN");
    String uuid= prefs.getString("UUID");
    String token= prefs.getString("ACCESS_TOKEN");

    addCartModel.uuid=uuid;
    String data=json.encode(addCartModel.toJson());


    if(isLogin == true)
    {
      url=ApiEndPoints.urlAddTOCart;

      print("--------isLogin $isLogin --------");
      print("url : $url");
      print("token : $token");
      print("data : $data");

      response=await RestClient.postData(context, url, data, token);
    }
    else{

      url=ApiEndPoints.urlAddTOCartGuest;

      print("--------isLogin $isLogin --------");
      print("url : $url");
      print("token : $token");
      print("data : $data");

      response= await RestClient.PostDataGuest(endpoint: url, data: data);

    }

    return response;

  }

  @override
  Future<Response> getAllCartItems({BuildContext context}) async{

    SharedPreferences prefs = await SharedPreferences.getInstance();

    Response response;

    String url;
    bool isLogin= prefs.getBool("ISLOGIN");
    String uuid= prefs.getString("UUID");
    String token= prefs.getString("ACCESS_TOKEN");

    if(isLogin == true)
    {

      url=ApiEndPoints.urlGetAllCartItems;
      response=await RestClient.getData(context, url, token);
    }
    else{
      //   print(".....$tag.....$url");
      url=ApiEndPoints.urlGetAllCartItemsGuest+"?uuid="+uuid;
      response= await RestClient.getDataGuest(url: url);

    }

    return response;


  }

  @override
  Future<Response> updateCartItemQty({BuildContext context, String cartItemId, String cartItemQty}) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    Response response;

    String url;
    bool isLogin= prefs.getBool("ISLOGIN");
    String token= prefs.getString("ACCESS_TOKEN");

    if(isLogin == true)
    {

      url=ApiEndPoints.urlUpdateCartQty(cartItemId: cartItemId, cartItemQty: cartItemQty);
      response=await RestClient.putData(context,url,"{}",token);
    }
    else{
      //   print(".....$tag.....$url");
      url=ApiEndPoints.urlUpdateCartQtyGuest(cartItemId: cartItemId, cartItemQty: cartItemQty);
      response= await RestClient.PutDataGuest(endpoint: url, data: "{}");

    }

    print("..updateCartItemQty.url....$url");

    return response;


  }

  @override
  Future<Response> deleteCartItem({BuildContext context, String cartItemId}) async{

    SharedPreferences prefs = await SharedPreferences.getInstance();

    Response response;

    String url;
    bool isLogin= prefs.getBool("ISLOGIN");
    String token= prefs.getString("ACCESS_TOKEN");

    if(isLogin == true)
    {

      url=ApiEndPoints.urlDeleteCartItem(cartItemId: cartItemId);
      print("...delete....url....$url");
      response=await RestClient.deleteData(context, url, token);
    }
    else{
      url=ApiEndPoints.urlDeleteCartItemGuest(cartItemId: cartItemId);
      response= await RestClient.deleteDataGuest(url: url);

    }

    return response;


  }

  @override
  Future<Response> cartCheckOut({BuildContext context, String deliveryType, bool useWallet}) async{

    SharedPreferences prefs = await SharedPreferences.getInstance();

    Response response;
    String url;
    String token= prefs.getString("ACCESS_TOKEN");

    url=ApiEndPoints.urlCheckout(deliveryType: deliveryType, useWallet: useWallet);

    print(".....$tag.....cartCheckOut...........$url");

    response=await RestClient.getData(context, url, token);

    return response;
  }

  @override
  Future<Response> getVendorDetails({BuildContext context, String vendorId}) async{

    SharedPreferences prefs = await SharedPreferences.getInstance();

    Response response;
    String url;
    String token= prefs.getString("ACCESS_TOKEN");

    url=ApiEndPoints.urlGetVendorDetails(vendorId: vendorId);
    response=await RestClient.getData(context, url, token);

    return response;


  }

  @override
  Future<Response> moveCart({BuildContext context}) async{

    SharedPreferences prefs = await SharedPreferences.getInstance();

    Response response;

    String url;
    String uuid= prefs.getString("UUID");
    String token= prefs.getString("ACCESS_TOKEN");

      url=ApiEndPoints.urlMoveCart(uuid:uuid );
      response=await RestClient.putData(context,url,"{}",token);

    return response;


  }



}
