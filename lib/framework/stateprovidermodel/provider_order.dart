import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nice_customer_app/api/responce/CommonResponce.dart';
import 'package:nice_customer_app/framework/repository/cart/model/AddCartModel.dart';
import 'package:nice_customer_app/framework/repository/cart/model/ResAddCart.dart';
import 'package:nice_customer_app/framework/repository/cart/model/ResCartList.dart';
import 'package:nice_customer_app/framework/repository/cart/model/ResCheckCartItem.dart';
import 'package:nice_customer_app/framework/repository/cart/model/ResCheckOut.dart';
import 'package:nice_customer_app/framework/repository/cart/model/ResUpdateCartQty.dart';
import 'package:nice_customer_app/framework/repository/cart/provider/cart_api_repository.dart';
import 'package:nice_customer_app/framework/repository/cart/provider/cart_repository_builder.dart';
import 'package:nice_customer_app/framework/repository/order/model/ReqOrder.dart';
import 'package:nice_customer_app/framework/repository/order/model/ResOrder.dart';
import 'package:nice_customer_app/framework/repository/order/model/ResOrderDetails.dart';
import 'package:nice_customer_app/framework/repository/order/provider/order_api_repository.dart';
import 'package:nice_customer_app/framework/repository/order/provider/order_repository_builder.dart';

class ProviderOrder extends ChangeNotifier {
  OrderApiRepository orderApiRepository =
      OrderApiRepositoryBuilder.repository();
  bool isLoading = false;


  String successOrderId = "";
  ResOrderDetails resOrderDetails = ResOrderDetails();
  OrderMaster orderMaster = OrderMaster();
  List<OrderItemResponseDtoList> orderItemList = List();



  //--
  bool showProgressBar = false;
  bool getShowProgressBar() => showProgressBar;
  setShowProgressBar(bool val) {
    showProgressBar = val;
    notifyListeners();
  }

  Future<ResOrder> placeOrder({BuildContext context, ReqOrder reqOrder}) async {
    ResOrder resOrder = ResOrder(message: "Something went wrong");

    isLoading = true;
    notifyListeners();

    Response response = await orderApiRepository.placeOrder(
        context: context, reqOrder: reqOrder);

    if (response.statusCode == 200) {
      resOrder = resOrderFromJson(response.toString());
      print("ResOrder ${resOrder.toJson()}");

      if (resOrder.status == 200) {
        successOrderId = resOrder.data;
        print(".......successOrderId..........$successOrderId");
      } else {
        // Server Error
        // isSuccess = false;
      }
    } else {
      // HTTP ERROR
      // isSuccess = false;
    }

    isLoading = false;
    notifyListeners();
    return resOrder;
  }

  Future<bool> orderDetails({BuildContext context, String orderId}) async {
    bool isSuccess = false;

    isLoading = true;
    notifyListeners();

    Response response = await orderApiRepository.orderDetails(context: context, orderId: orderId);
    if (response.statusCode == 200) {
      resOrderDetails = resOrderDetailsFromJson(response.toString());
      if (resOrderDetails.status == 200) {
        isSuccess = true;


        orderMaster = resOrderDetails.data;
        orderItemList = orderMaster.orderItemResponseDtoList;
        await generateDisplayData(orderItemList);

      } else {
        // Server Error
        isSuccess = false;
      }
    } else {
      // HTTP ERROR
      isSuccess = false;
    }

    isLoading = false;
    notifyListeners();
    return isSuccess;
  }

  Future<void> generateDisplayData(
      List<OrderItemResponseDtoList> orderItemList) async {
    for (int i = 0; i < orderItemList.length; i++) {
      OrderItemResponseDtoList orderItem = orderItemList[i];

      String toppingStr = "";
      String addOnStr = "";
      String attributeStr = "";
      String extraStr = "";
      String finalStr = "";

      List<OrderToppingsDtoList> orderToppingsDtoList = List();
      List<OrderAddonsDtoList> orderAddonsDtoList = List();
      List<OrderProductAttributeValueDtoList> orderAttributeValuesDtoList =
          List();
      List<OrderExtraDtoList> orderExtrasDtoList = List();

      orderToppingsDtoList = orderItem.orderToppingsDtoList;
      orderAddonsDtoList = orderItem.orderAddonsDtoList;
      orderAttributeValuesDtoList = orderItem.orderProductAttributeValueDtoList;
      orderExtrasDtoList = orderItem.orderExtraDtoList;

      if (orderToppingsDtoList.isNotEmpty) {
        List<String> tempStrList = List();
        for (OrderToppingsDtoList item in orderToppingsDtoList) {
          tempStrList.add(item.toppingsName);
        }
        if (tempStrList.isNotEmpty) {
          toppingStr = "Topping:- " + tempStrList.join(', ');
        }
      }

      if (orderAddonsDtoList.isNotEmpty) {
        List<String> tempStrList = List();
        for (OrderAddonsDtoList item in orderAddonsDtoList) {
          tempStrList.add(item.addonsName);
        }
        if (tempStrList.isNotEmpty) {
          addOnStr = "\n Add On:- " + tempStrList.join(', ');
        }
      }

      if (orderAttributeValuesDtoList.isNotEmpty) {
        List<String> tempStrList = List();
        for (OrderProductAttributeValueDtoList item
            in orderAttributeValuesDtoList) {
          String attributeName = item.attributeName;

          String attributeVal = item.attributeValue;

          tempStrList.add(attributeName + " ( $attributeVal )");
        }
        if (tempStrList.isNotEmpty) {
          attributeStr = "\n" + tempStrList.join(', ');
        }
      }

      if (orderExtrasDtoList.isNotEmpty) {
        List<String> tempStrList = List();
        for (OrderExtraDtoList item in orderExtrasDtoList) {
          tempStrList.add(item.extrasName);
        }
        if (tempStrList.isNotEmpty) {
          extraStr = "\n Extras:- " + tempStrList.join(', ');
        }
      }

      finalStr = toppingStr + addOnStr + attributeStr + extraStr;


      orderItemList[i].displayExtra = finalStr;
    }
  }
}
