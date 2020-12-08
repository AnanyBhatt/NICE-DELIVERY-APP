import 'package:flutter/foundation.dart';
import 'package:nice_customer_app/api/responce/OrderDetailsResponce.dart';
import 'package:nice_customer_app/framework/repository/order/model/ResOrderDetails.dart';

class ProviderOrderdetails extends ChangeNotifier {
  bool showProgressBar = true;
  bool NoDataFound = false;
  OrderDetailList orderList = new OrderDetailList();
  List<OrderItemResponseDtoList> orderItemResponseDtoList;
  OrderRating orderRating = OrderRating();

  getShowProgressBar() => showProgressBar;
  setShowProgressBar(bool val) {
    showProgressBar = val;
    notifyListeners();
  }

  void showorderdetails(orderdetails) {
    orderList = orderdetails;
    notifyListeners();
  }

  void showorderSummary(ordersummarylist) {
    orderItemResponseDtoList = ordersummarylist;
    generateDisplayData(orderItemResponseDtoList);
    notifyListeners();
  }

  void getOrderRating() => orderRating;

  void setOrderRating(val) {
    orderRating = val;

    notifyListeners();
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

      print(".......ssss....$finalStr");

      orderItemList[i].displayExtra = finalStr;
    }
  }
}
