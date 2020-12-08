import 'package:flutter/cupertino.dart';
import 'package:nice_customer_app/api/responce/OrderRatingQueListResponse.dart';
import 'package:nice_customer_app/api/responce/ReviewRatingResponse.dart';

class ProviderReviewRatings extends ChangeNotifier {
  bool showProgressBar = false;
  List<RatingReviewList> ratingReviewList = new List<RatingReviewList>();
  List<OrderRatingQueList> orderRatingQueList = new List<OrderRatingQueList>();
  List<double> orderRatings = [0, 0, 0, 0, 0];

  getShowProgressBar() => showProgressBar;
  setShowProgressBar(bool val) {
    showProgressBar = val;
    notifyListeners();
  }

  List<RatingReviewList> getRatingReviewList() => ratingReviewList;
  setRatingReviewList(List<RatingReviewList> val) {
    ratingReviewList.clear();
    ratingReviewList = val;
    notifyListeners();
  }

  List<OrderRatingQueList> getOrderRatingQueList() => orderRatingQueList;
  setOrderRatingQueList(List<OrderRatingQueList> val) {
    orderRatingQueList.clear();
    orderRatingQueList = val;
    notifyListeners();
  }

  List<double> getOrderRatings() => orderRatings;
  setOrderRatings(int i, double val) {
    orderRatings[i] = val;
    notifyListeners();
  }
}
