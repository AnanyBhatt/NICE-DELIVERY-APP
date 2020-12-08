
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:nice_customer_app/framework/repository/cart/model/AddCartModel.dart';

abstract class CartRepository {

  Future<Response> checkValidCartItem({@required BuildContext context,@required String  vendorId});
  Future<Response> addToCart({@required BuildContext context, @required AddCartModel addCartModel});
  Future<Response> getAllCartItems({@required BuildContext context});
  Future<Response> updateCartItemQty({@required BuildContext context,@required String  cartItemId,@required String  cartItemQty});
  Future<Response> deleteCartItem({@required BuildContext context,@required String  cartItemId});
  Future<Response> cartCheckOut({@required BuildContext context,@required String  deliveryType,@required bool  useWallet});
  Future<Response> getVendorDetails({@required BuildContext context,@required String  vendorId});
  Future<Response> moveCart({@required BuildContext context});






}
