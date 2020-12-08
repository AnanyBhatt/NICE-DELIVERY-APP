
import 'package:nice_customer_app/framework/repository/cart/contract/cart_repository.dart';
import 'package:nice_customer_app/framework/repository/cart/provider/cart_api_repository.dart';

class CartRepositoryBuilder {
  static CartRepository repository() {
    return CartApiRepository();
  }
}
