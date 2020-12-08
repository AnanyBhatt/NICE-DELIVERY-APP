import 'package:flutter/material.dart';
import 'package:nice_customer_app/api/responce/CompanyAddressResponce.dart';
import 'package:nice_customer_app/api/responce/CustomerAddressResponse.dart';

class ProviderAddressBook extends ChangeNotifier {
  bool showProgressBar = false;
  List<CustomerAddressList> arrCustomerAddressList = List();
  SelectedAddressModel modelCustomerAddressList = SelectedAddressModel();
  CustomerAddressList customerAddressList = CustomerAddressList();
  int position;
  CompanyAddress companyAddressList = CompanyAddress();

  //--
  bool getShowProgressBar() => showProgressBar;
  setShowProgressBar(bool val) {
    showProgressBar = val;
    notifyListeners();
  }

  int getPosition() => position;
  setPosition(int val) {
    position = val;
    notifyListeners();
  }

  List<CustomerAddressList> getCustomerAddressList() => arrCustomerAddressList;
  setCustomerAddressList(List<CustomerAddressList> val) {
    arrCustomerAddressList.clear();
    arrCustomerAddressList = val;
    notifyListeners();
  }

  CustomerAddressList getCustomerAddressListData() => customerAddressList;
  setCustomerAddressListData(CustomerAddressList val) {
    customerAddressList = val;
    notifyListeners();
  }

  CompanyAddress getCompanyAddress() => companyAddressList;
  seCompanyAddress(CompanyAddress val) {
    companyAddressList = val;
    notifyListeners();
  }

  SelectedAddressModel getSelectedAddressModel() => modelCustomerAddressList;
  setSelectedAddressModel(SelectedAddressModel val) {
    modelCustomerAddressList = val;
    notifyListeners();
  }

  clearCompanyAddress() {
    companyAddressList = new CompanyAddress();
    notifyListeners();
  }

  clearSelectedAddressModel() {
    modelCustomerAddressList = SelectedAddressModel();
    notifyListeners();
  }
}

class SelectedAddressModel {
  int addressID;
  String areaName;

  double latitude;
  double longitude;
  String fullAdddress;

  SelectedAddressModel(
      {this.addressID,
      this.latitude,
      this.longitude,
      this.areaName,
      this.fullAdddress});
}
