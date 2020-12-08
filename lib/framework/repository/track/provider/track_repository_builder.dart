
import 'package:nice_customer_app/framework/repository/order/contract/order_repository.dart';
import 'package:nice_customer_app/framework/repository/order/provider/order_api_repository.dart';
import 'package:nice_customer_app/framework/repository/track/contract/track_repository.dart';
import 'package:nice_customer_app/framework/repository/track/provider/track_api_repository.dart';

class TrackApiRepositoryBuilder {
  static TrackRepository repository() {
    return TrackApiRepository();
  }
}
