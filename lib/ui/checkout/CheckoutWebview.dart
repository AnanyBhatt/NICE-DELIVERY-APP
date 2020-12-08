import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:nice_customer_app/common/progressbar.dart';
import 'package:nice_customer_app/framework/stateprovidermodel/provider_cart.dart';
import 'package:nice_customer_app/framework/stateprovidermodel/provider_order.dart';
import 'package:nice_customer_app/framework/stateprovidermodel/provider_track.dart';
import 'package:nice_customer_app/mixins/const.dart';
import 'package:nice_customer_app/ui/orders/order_confirm.dart';
import 'package:nice_customer_app/webservices/apiendpointd.dart';
import 'package:provider/provider.dart';

class CheckoutWebview extends StatefulWidget {

  String strURL = "";
  String strOrderId = "";
  CheckoutWebview({this.strURL, this.strOrderId});

  @override
  _CheckoutWebviewState createState() => _CheckoutWebviewState();
}


class _CheckoutWebviewState extends State<CheckoutWebview> with Constants{


  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ProviderOrder orderread;
  ProviderTrack providerTrackRead;

  final flutterWebViewPlugin = FlutterWebviewPlugin();
  StreamSubscription<String> _onUrlChanged;


  @override
  void initState() {
    super.initState();

    orderread=context.read<ProviderOrder>();

    providerTrackRead = context.read<ProviderTrack>();
    flutterWebViewPlugin.close();

    _onUrlChanged = flutterWebViewPlugin.onUrlChanged.listen((String url) async{
      if (mounted) {
        //showLog("--> url : $url");
        if(url == ApiEndPoints.port + "success/"){

          orderread.setShowProgressBar(true);
          //showLog("--> url : match success............$url");

          String successOrderId = widget.strOrderId;
          //showLog("successOrderId : $successOrderId");


          await providerTrackRead.trackOrder(context: context);
          bool isDone = await orderread.orderDetails(context: context, orderId: providerTrackRead.orderIdTrack.toString());
          //showLog("isDone : $isDone");

          orderread.setShowProgressBar(false);

          if (isDone) {

            Navigator.pushAndRemoveUntil(
                context,
                PageRouteBuilder(
                    transitionDuration: Duration(
                        milliseconds: pageDuration),
                    pageBuilder: (_, __, ___) =>
                        OrderConfirmPage()),
                    (Route<dynamic> route) => false);
          }

        }
        else if(url == ApiEndPoints.port + "error/"){

          //showLog("--> url : match error............$url");

          Future.delayed(Duration(seconds: 1),(){
            Navigator.pop(context);
          });


        }
        /*
          http://nice.kodyinfotech.com:8602/privacy-policy/
          http://nice.kodyinfotech.com:8602/success/
          http://nice.kodyinfotech.com:8602/error/
        */
      }
    });


  }

  @override
  void dispose() {
    _onUrlChanged.cancel();
    flutterWebViewPlugin.dispose();

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    buildSetupScreenUtils(context);

    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: <Widget>[


          WebviewScaffold(
            url: widget.strURL,
            mediaPlaybackRequiresUserGesture: false,
            withZoom: true,
            withLocalStorage: true,
            hidden: true,
          ),

          orderread.showProgressBar == true ? Container(
            color: Color(clrWhite),
            child: Center(
              child:ProgressBar(clrBlack),
            ),
          ): Container(),

        ],
      ),
    );



  }





  void showSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
        value,
        style: TextStyle(
          color: Color(clrWhite),
          fontSize: setSp(14),
        ),
      ),
      backgroundColor: Color(clrBlack),
      duration: Duration(seconds: 1),
    ));
  }


}
