class OrderHistorydata {
  String name;
  String orderid;
  String orderdate;
  String status;

  OrderHistorydata({this.name, this.orderid, this.orderdate, this.status});
}

class OrderHistoryListt {
  static List<OrderHistorydata> getOrderHistoryList() {
    return [
      OrderHistorydata(
        name: "The American Pizza",
        orderid: "Order ID: 2658746",
        orderdate: "Today 11:45",
        status: "Placed",
      ),
      OrderHistorydata(
        name: "Fresh & Fresh",
        orderid: "2658746",
        orderdate: "03-06-2020 14:15",
        status: "Return",
      ),
      OrderHistorydata(
        name: "Super Grocery",
        orderid: "Order ID: 2563958",
        orderdate: "31-05-2020 08:00",
        status: "Replaced",
      ),
      OrderHistorydata(
        name: "Delight Cafe",
        orderid: "Order ID: 2658746",
        orderdate: "Today 11:45",
        status: "Delivered",
      ),
    ];
  }
}
