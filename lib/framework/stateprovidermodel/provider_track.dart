import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nice_customer_app/api/responce/OrderDetailsResponce.dart';
import 'package:nice_customer_app/framework/repository/track/model/ResOrderTrack.dart';
import 'package:nice_customer_app/framework/repository/track/provider/track_api_repository.dart';
import 'package:nice_customer_app/framework/repository/track/provider/track_repository_builder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nice_customer_app/webservices/RestClient.dart';
import 'package:nice_customer_app/webservices/apiendpointd.dart';


class ProviderTrack extends ChangeNotifier {


  TrackApiRepository trackApiRepository = TrackApiRepositoryBuilder.repository();
  bool isLoading = false;
  ResOrderTrack resOrderTrack=ResOrderTrack();
  OrderDetailsResponce orderDetailsResponce=OrderDetailsResponce();
  bool isSuccess = false;
  int orderIdTrack;
  String orderFinalStatus="";
  String deliveryBoyName="";
  String deliveryBoyPhoneNumber="";
  String deliveryType="";



  LatLng destLatLng;
  LatLng vendorLatLng;
  String orderStatus;


  String vendorName;


  void clearValue()
 {
    isSuccess = false;
    isLoading = false;
    resOrderTrack=ResOrderTrack();
 }


 void updateHomeOrderButton(bool val)
  {
    isSuccess=val;
    notifyListeners();
  }

  Future<void> trackOrder({BuildContext context, String orderId}) async {


    isLoading = true;
    notifyListeners();

    Response response = await trackApiRepository.trackOrder(context: context);
    if (response.statusCode == 200) {
       resOrderTrack = resOrderTrackFromJson(response.toString());

       //print("....trackOrder..............${resOrderTrack.message}.......order...id...${resOrderTrack.data.id}");
       //print("....XXXXXXXXXXXXXXXXXXXXXXXXXXXXx.........resOrderTrack.data.deliveryType......${resOrderTrack.data.deliveryType}");

      if (resOrderTrack.status == 200) {
        isSuccess = true;
        orderIdTrack=resOrderTrack.data.id;
        vendorName=resOrderTrack.data.vendorName;

        print("....yes i am tracked..............${resOrderTrack.message}");

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

  }


  Future<void> getOrderDetails({BuildContext context, String orderId,String accessToken}) async {


    isLoading = true;
    notifyListeners();

    String apiOrderDetail =
        ApiEndPoints.apiGetOrderDetail + "/" + orderId;

    Response response =
    await RestClient.getData(context, apiOrderDetail, accessToken);


    try {
      if (response.statusCode == 200) {

         orderDetailsResponce = orderDetailsResponceFromJson(response.toString());


        if (orderDetailsResponce.status == ApiEndPoints.apiStatus_200) {
          orderFinalStatus=orderDetailsResponce.data.orderStatus;
          deliveryType=orderDetailsResponce.data.deliveryType;



          if(deliveryType == "Delivery" )
         {

            destLatLng = LatLng(orderDetailsResponce.data.latitude,
              orderDetailsResponce.data.longitude);
          vendorLatLng = LatLng(orderDetailsResponce.data.vendorLatitude,
              orderDetailsResponce.data.vendorLongitude);
          orderStatus = orderDetailsResponce.data.orderStatus;

          deliveryBoyPhoneNumber=orderDetailsResponce.data.deliveryBoyPhoneNumber;
          deliveryBoyName=orderDetailsResponce.data.deliveryBoyName;

          vendorName=orderDetailsResponce.data.vendorName;


          }






        } else {
        }
      } else {
       }
    } catch (exception) {
    }

    isLoading = false;
    notifyListeners();


  }






}





