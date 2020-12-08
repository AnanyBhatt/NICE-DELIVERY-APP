
import 'package:nice_customer_app/framework/repository/order/contract/order_repository.dart';
import 'package:nice_customer_app/framework/repository/order/provider/order_api_repository.dart';

class OrderApiRepositoryBuilder {
  static OrderRepository repository() {
    return OrderApiRepository();
  }
}
