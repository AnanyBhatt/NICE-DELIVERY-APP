import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nice_customer_app/framework/repository/cart/model/AddCartModel.dart';
import 'package:nice_customer_app/framework/repository/cart/model/ResAddCart.dart';
import 'package:nice_customer_app/framework/repository/cart/model/ResCartList.dart';
import 'package:nice_customer_app/framework/repository/cart/model/ResCheckCartItem.dart';
import 'package:nice_customer_app/framework/repository/cart/model/ResCheckOut.dart';
import 'package:nice_customer_app/framework/repository/cart/model/ResUpdateCartQty.dart';
import 'package:nice_customer_app/framework/repository/cart/model/ResVendorDetails.dart';
import 'package:nice_customer_app/framework/repository/cart/provider/cart_api_repository.dart';
import 'package:nice_customer_app/framework/repository/cart/provider/cart_repository_builder.dart';

class ProviderCart  extends ChangeNotifier {


  CartApiRepository cartApiRepository = CartRepositoryBuilder.repository();
  bool isLoading = false;
  bool isLoadingTemp = false;

  bool useWallet=false;

  List<CartItem> cartList = List();
  CheckoutMaster checkoutMaster = CheckoutMaster();
  ResVendorDetailsData resVendorDetailsData = ResVendorDetailsData();

  String specialReq="";

  double totCartAmount = 0.0;
  int totCartCount = 0;
  bool isChecked = false;
  int radioValueDelPick=0;
  int radioPayment=0; //int radioPayment=2;
  int vendorId=0;



  //--
  ResVendorDetailsData getResVendorDetailsData() => resVendorDetailsData;
  setResVendorDetailsData(ResVendorDetailsData val) {
    resVendorDetailsData = val;
    notifyListeners();
  }


  void clearCartProvider()
  {

    cartApiRepository = CartRepositoryBuilder.repository();
     isLoading = false;
     isLoadingTemp = false;
     cartList = List();
    checkoutMaster = CheckoutMaster();

     totCartAmount = 0.0;
     totCartCount = 0;
     isChecked = false;
     radioValueDelPick=0;
     radioPayment=0;

     notifyListeners();



  }


  void displayLoader(bool val)
  {
    isLoading=val;
    notifyListeners();
  }



  void updateCheck()
  {
    isChecked=!isChecked;
    notifyListeners();
  }


  void updateRequest(String val)
  {
    specialReq=val;
    notifyListeners();
  }



  void updateValueDelPick(int val)
  {
    radioValueDelPick=val;
    notifyListeners();
  }


  void updateValuePayment(int val)
  {
    radioPayment=val;
    notifyListeners();
  }


  void updateWallet(val)
  {
    useWallet=val;
    notifyListeners();
  }







  Future<bool> checkCartItem(BuildContext context, String vendorId) async {
    bool notValidItem = false;
    isLoading = true;
    notifyListeners();

    Response response = await cartApiRepository.checkValidCartItem(
        context: context, vendorId: vendorId);
    if (response.statusCode == 200) {
      ResCheckCartItem resCheckCartItem = resCheckCartItemFromJson(
          response.toString());
      if (resCheckCartItem.status == 200) {
        notValidItem = resCheckCartItem.data;
      }
      else {
        // Server Error
      }
    }
    else {
      // HTTP ERROR
    }
    isLoading = false;
    notifyListeners();
    return notValidItem;
  }


  Future<bool> addCartItem(BuildContext context, AddCartModel cartModel) async {
    bool isSuccess = false;
    isLoading = true;
    notifyListeners();

    Response response = await cartApiRepository.addToCart(
        context: context, addCartModel: cartModel);
    if (response.statusCode == 200) {
      ResCartList resCartList = resCartListFromJson(response.toString());
      if (resCartList.status == 200) {
        isSuccess = true;
        cartList = resCartList.data;
        if (cartList.length > 0) {
          await generateDisplayData(cartList);
          await updateCartData(cartList);
        }
      }
      else {
        // Server Error
        isSuccess = false;
      }
    }
    else {
      // HTTP ERROR
      isSuccess = false;
    }


    isLoading = false;
    notifyListeners();
    return isSuccess;
  }


  Future<void> getAllCartItemList(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    Response response = await cartApiRepository.getAllCartItems(
        context: context);

    if (response.statusCode == 200) {
      ResCartList resCartList = resCartListFromJson(response.toString());
      if (resCartList.status == 200) {
        cartList = resCartList.data;
        if (cartList.length > 0) {
          vendorId=cartList[0].vendorId;
          await generateDisplayData(cartList);
          await updateCartData(cartList);
        }
        else{
          await generateDisplayData(cartList);
          await updateCartData(cartList);
          vendorId=0;
        }
      }
      else {
        // Server Error

      }
    }
    else {
      // HTTP ERROR

    }


    isLoading = false;
    notifyListeners();
  }


  Future<bool> moveCart(BuildContext context) async {
    bool isSuccess = false;

    Response response = await cartApiRepository.moveCart(context: context);

    if (response.statusCode == 200) {
      ResCartList resCartList = resCartListFromJson(response.toString());
      if (resCartList.status == 200) {

        isSuccess = true;
        cartList = resCartList.data;
        if (cartList.length > 0) {
          vendorId=cartList[0].vendorId;
          await generateDisplayData(cartList);
          await updateCartData(cartList);
        }
        else{
          await generateDisplayData(cartList);
          await updateCartData(cartList);
        }
      }
      else {}
    }
    else {
      // HTTP ERROR

    }

    notifyListeners();
    return isSuccess;
  }

  Future<bool> addCartQty(int index, CartItem itemParam,
      BuildContext context) async {
    bool isSuccess = false;

    isLoading = true;
    notifyListeners();

    CartItem item = itemParam;
    String cartItemId = item.id.toString();
    int qty = item.quantity + 1;


    Response response = await cartApiRepository.updateCartItemQty(
        context: context, cartItemId: cartItemId, cartItemQty: qty.toString());

    if (response.statusCode == 200) {
      ResCartList resCartList = resCartListFromJson(response.toString());
      if (resCartList.status == 200) {
        isSuccess = true;
        cartList = resCartList.data;
        if (cartList.length > 0) {
          await generateDisplayData(cartList);
          await updateCartData(cartList);
        }
      }
      else {}
    }
    else {
      // HTTP ERROR

    }

    isLoading = false;
    notifyListeners();
    return isSuccess;
  }

  Future<bool> addCartQtyProduct(int cartItemQty, String cartItemId,
      BuildContext context) async {
    bool isSuccess = false;

    isLoading = true;
    notifyListeners();

    Response response = await cartApiRepository.updateCartItemQty(
        context: context, cartItemId: cartItemId, cartItemQty: cartItemQty.toString());

    if (response.statusCode == 200) {
      ResCartList resCartList = resCartListFromJson(response.toString());
      if (resCartList.status == 200) {
        isSuccess = true;
        cartList = resCartList.data;
        if (cartList.length > 0) {
          await generateDisplayData(cartList);
          await updateCartData(cartList);
        }
      }
      else {}
    }
    else {
      // HTTP ERROR

    }

    isLoading = false;
    notifyListeners();
    return isSuccess;
  }


  Future<bool> removeCartQty(int index, CartItem itemParam,
      BuildContext context) async {
    bool isSuccess = false;

    isLoading = true;
    notifyListeners();

    CartItem item = itemParam;
    String cartItemId = item.id.toString();
    int qty = item.quantity - 1;

    if (qty > 0) {
      Response response = await cartApiRepository.updateCartItemQty(
          context: context,
          cartItemId: cartItemId,
          cartItemQty: qty.toString());

      if (response.statusCode == 200) {
        ResCartList resCartList = resCartListFromJson(response.toString());
        if (resCartList.status == 200) {
          isSuccess = true;
          cartList = resCartList.data;
          if (cartList.length > 0) {
            await generateDisplayData(cartList);
            await updateCartData(cartList);
          }
        }
        else {}
      }
      else {
        // HTTP ERROR

      }
    }
    else {
      isLoading = false;
    }


    isLoading = false;
    notifyListeners();
    return isSuccess;
  }

  Future<bool> removeCartQtyProduct(int cartItemQty, String cartItemId,
      BuildContext context) async {
    bool isSuccess = false;


    if (cartItemQty > 0) {


      Response response = await cartApiRepository.updateCartItemQty(
          context: context,
          cartItemId: cartItemId,
          cartItemQty: cartItemQty.toString());

      if (response.statusCode == 200) {
        ResCartList resCartList = resCartListFromJson(response.toString());
        if (resCartList.status == 200) {
          isSuccess = true;
          cartList = resCartList.data;
          if (cartList.length > 0) {
            await generateDisplayData(cartList);
            await updateCartData(cartList);
          }
        }
        else {



        }
      }
      else {

      }
    }
    else {
      isLoading = false;
    }


    notifyListeners();
    return isSuccess;
  }


  Future<bool> deleteCartQty(int index, CartItem itemParam,
      BuildContext context) async {
    bool isSuccess = false;

    isLoading = true;
    notifyListeners();

    CartItem item = itemParam;
    String cartItemId = item.id.toString();

    Response response = await cartApiRepository.deleteCartItem(
        context: context, cartItemId: cartItemId);

    if (response.statusCode == 200) {
      ResUpdateCartQty resUpdateCartQty = resUpdateCartQtyFromJson(
          response.toString());
      if (resUpdateCartQty.status == 200) {
        isSuccess = true;
        cartList.removeAt(index);
        updateCartData(cartList);
      }
      else {
        isSuccess = false;
      }
    }
    else {
      // HTTP ERROR
      isSuccess = false;
    }


    isLoading = false;
    notifyListeners();
    return isSuccess;
  }

  Future<bool> deleteCartQtyProduct(String cartItemId,
      BuildContext context) async {
    bool isSuccess = false;


    Response response = await cartApiRepository.deleteCartItem(
        context: context, cartItemId: cartItemId);

    if (response.statusCode == 200) {
      ResUpdateCartQty resUpdateCartQty = resUpdateCartQtyFromJson(
          response.toString());
      if (resUpdateCartQty.status == 200) {
        isSuccess = true;
      }
      else {
        isSuccess = false;
      }
    }
    else {
      // HTTP ERROR
      isSuccess = false;
    }

   return isSuccess;
  }


  Future<void> generateDisplayData(List<CartItem> cartList) async
  {
    for (int i = 0; i < cartList.length; i++) {
      CartItem cartItem = cartList[i];

      String toppingStr = "";
      String addOnStr = "";
      String attributeStr = "";
      String extraStr = "";
      String finalStr = "";

      var disRate =cartItem.productVariantResponseDto.discountedRate;

      double productRate ;

      if(disRate == null)
        {
          productRate = cartItem.productVariantResponseDto.rate;
        }
      else{

        productRate = cartItem.productVariantResponseDto.discountedRate;
      }



      int quantity = cartItem.quantity;
      double toppingCount = 0.0;
      double addOnCount = 0.0;
      double attributeCount = 0.0;
      double extraCount = 0.0;
      double finalCount = 0.0;


      List<ProductToppingsDtoList> productToppingsDtoList = List();
      List<ProductAddonsDtoList> productAddonsDtoList = List();
      List<ProductAttributeValuesDtoList> productAttributeValuesDtoList = List();
      List<ProductExtrasDtoList> productExtrasDtoList = List();

      productToppingsDtoList =
          cartItem.productToppingsDtoList;
      productAddonsDtoList =
          cartItem.productAddonsDtoList;
      productAttributeValuesDtoList =
          cartItem.productAttributeValuesDtoList;
      productExtrasDtoList = cartItem.productExtrasDtoList;


      if (productToppingsDtoList.isNotEmpty) {
        List<String> tempStrList = List();
        for (ProductToppingsDtoList item in productToppingsDtoList) {
          tempStrList.add(item.name);
          toppingCount = toppingCount + item.rate;
        }
        if(tempStrList.isNotEmpty)
          {
            toppingStr = "Topping:- " + tempStrList.join(', ');
          }

      }

      if (productAddonsDtoList.isNotEmpty) {
        List<String> tempStrList = List();
        for (ProductAddonsDtoList item in productAddonsDtoList) {
          tempStrList.add(item.addonsName);
          addOnCount = addOnCount + item.rate;
        }
        if(tempStrList.isNotEmpty)
        {
          addOnStr = "\n Add On:- " + tempStrList.join(', ');
        }

      }


      if (productAttributeValuesDtoList.isNotEmpty) {
        List<String> tempStrList = List();
        for (ProductAttributeValuesDtoList item in productAttributeValuesDtoList) {
          String attributeName = item.attributeName;
          List<ProductAttributeValueList> productAttributeValueList = item
              .productAttributeValueList;
          String attributeVal = productAttributeValueList[0].attributeValue;

          tempStrList.add(attributeName + " ( $attributeVal )");

          attributeCount = attributeCount + productAttributeValueList[0].rate;
        }
        if(tempStrList.isNotEmpty)
        {
          attributeStr = "\n" + tempStrList.join(', ');
        }

      }

      if (productExtrasDtoList.isNotEmpty) {
        List<String> tempStrList = List();
        for (ProductExtrasDtoList item in productExtrasDtoList) {
          tempStrList.add(item.name);
          extraCount = extraCount + item.rate;
        }
        if(tempStrList.isNotEmpty)
        {
          extraStr = "\n Extras:- " + tempStrList.join(', ');
        }

      }

      finalStr = toppingStr + addOnStr + attributeStr + extraStr;
      finalCount =
          productRate + toppingCount + addOnCount + attributeCount + extraCount;

      print(".......ssss....$finalStr");


      cartList[i].displayAmt = finalCount;
      cartList[i].displayExtraStr = finalStr;
    }
  }


  Future<void> updateCartData(List<CartItem> cartList) async
  {
    totCartAmount = 0.0;
    totCartCount = cartList.length;
    for (CartItem item in cartList) {
      double tempAmt = item.displayAmt * item.quantity;
      totCartAmount = totCartAmount + tempAmt;
    }
  }




  Future<void> checkOutCartItem({@required BuildContext context,@required String  deliveryType,@required bool  useWallet,@required bool  isFromInit}) async {

    if(isFromInit)
      {
        isLoading = true;
      }
    else
      {
        openLoadingDialog(context);
      }

    notifyListeners();

    Response response = await cartApiRepository.cartCheckOut(context: context,useWallet: useWallet,deliveryType: deliveryType);

    if (response.statusCode == 200) {
      ResCheckOut resCheckOut = resCheckOutFromJson(response.toString());

      if (resCheckOut.status == 200) {

        checkoutMaster=resCheckOut.data;
        List<CartItem> cartListCheckOut = checkoutMaster.cartItemResponseList;
        if (cartListCheckOut.length > 0) {
          await generateDisplayData(cartListCheckOut);
        }
        checkoutMaster.cartItemResponseList=cartListCheckOut;

        if(checkoutMaster.customerWalletAmount < 0)
          {
            isChecked=true;
            Response response = await cartApiRepository.cartCheckOut(context: context,useWallet: isChecked,deliveryType: deliveryType);
            if (response.statusCode == 200) {
              ResCheckOut resCheckOut = resCheckOutFromJson(response.toString());
              if (resCheckOut.status == 200) {

                checkoutMaster=resCheckOut.data;
                List<CartItem> cartListCheckOut = checkoutMaster.cartItemResponseList;
                if (cartListCheckOut.length > 0) {
                  await generateDisplayData(cartListCheckOut);
                }
                checkoutMaster.cartItemResponseList=cartListCheckOut;

              }
              }
          }

      }
      else {
        // Server Error

      }
    }
    else {
      // HTTP ERROR

    }



    if(isFromInit)
    {
      isLoading = false;
    }
    else
    {
      Navigator.pop(context);
    }
    notifyListeners();


  }




  Future<void> getVendorDetails(BuildContext context,String vendorId) async {
    isLoading = true;
    notifyListeners();

    Response response = await cartApiRepository.getVendorDetails(context: context,vendorId: vendorId);

    if (response.statusCode == 200) {
      ResVendorDetails resVendorDetails = resVendorDetailsFromJson(response.toString());
      if (resVendorDetails.status == 200) {

        setResVendorDetailsData(resVendorDetails.data);

      }
      else {
        // Server Error

      }
    }
    else {
      // HTTP ERROR

    }


    isLoading = false;
    notifyListeners();
  }





  void openLoadingDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text("Please wait .."),
        );
      },
    );
  }









}





