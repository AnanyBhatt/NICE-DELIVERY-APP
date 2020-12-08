import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nice_customer_app/Localization/app_translations.dart';
import 'package:nice_customer_app/api/request/AddCustomerAddressRequest.dart';
import 'package:nice_customer_app/api/request/AreaListRequest.dart';

import 'package:nice_customer_app/api/responce/AreaListResponce.dart';
import 'package:nice_customer_app/api/responce/CommonResponce.dart';
import 'package:nice_customer_app/api/responce/CustomerAddressResponse.dart';
import 'package:nice_customer_app/common/appbar.dart';

import 'package:nice_customer_app/common/flaticonbutton.dart';
import 'package:nice_customer_app/common/progressbar.dart';
import 'package:nice_customer_app/mixins/const.dart';
import 'package:nice_customer_app/ui/address_book/ProviderAddAddress.dart';
import 'package:nice_customer_app/utils/color_.dart';
import 'package:nice_customer_app/utils/padding_.dart';
import 'package:nice_customer_app/utils/textstyle_.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:nice_customer_app/webservices/RestClient.dart';
import 'package:nice_customer_app/webservices/apiendpointd.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geocoding/geocoding.dart';

class AddAddressPage extends StatefulWidget {
  final int index;
  final CustomerAddressList model;

  AddAddressPage({Key key, this.index, this.model}) : super(key: key);

  @override
  _AddAddressPageState createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> with Constants {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<AreaList> _areaList = [];
  StreamSubscription _locationSubscription;
  ProviderAddAddress providerAddAddress;

  static LatLng _initialPosition;
  LatLng _lastPosition = _initialPosition;
  LatLng get initialPosition => _initialPosition;
  LatLng get lastPosition => _lastPosition;

  bool locationServiceActive = true;
  String country;
  String locality;
  String subLocality;
  String administrativeArea;
  String postalCode;
  String streetName;
  String isoCountryCode;

  TextEditingController _phoneController = TextEditingController();

  TextEditingController _buildingController = TextEditingController();
  TextEditingController _blockController = TextEditingController();
  TextEditingController _streetController = TextEditingController();
  TextEditingController _areaController = TextEditingController();

  @override
  void initState() {
    providerAddAddress =
        Provider.of<ProviderAddAddress>(context, listen: false);

    Future.delayed(Duration(milliseconds: 10), () async {
      providerAddAddress.clearData();

      setUserData(widget.model, providerAddAddress);

      checkInternet().then((value) async {
        if (value == true) {
          await apiAreaList(context, providerAddAddress);
        } else {
          showSnackBar(
              "${AppTranslations.of(context).text("Key_errinternet")}");
        }
      });
    });
    super.initState();
  }

  setUserData(
      CustomerAddressList model, ProviderAddAddress providerAddAddress) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    if (model != null &&
        model.firstName != null &&
        model.firstName.toString().length > 0) {
      providerAddAddress.setFName(model.firstName);
    } else {
      providerAddAddress.setFName(pref.getString(prefStr_FNAME));
    }

    if (model != null &&
        model.lastName != null &&
        model.lastName.toString().length > 0) {
      providerAddAddress.setLName(model.lastName);
    } else {
      providerAddAddress.setLName(pref.getString(prefStr_LNAME));
    }

    if (model != null &&
        model.phoneNumber != null &&
        model.phoneNumber.toString().length > 0) {
      providerAddAddress.setPhone(model.phoneNumber);
      _phoneController.text = model.phoneNumber;
    } else {}

    if (model != null &&
        model.customerId != null &&
        model.customerId.toString().length > 0) {
      providerAddAddress.setCustomerId(model.customerId);
    } else {
      providerAddAddress.setCustomerId(pref.getInt(prefInt_ID));
    }
    if (model != null &&
        model.buildingName != null &&
        model.buildingName.toString().length > 0) {
      providerAddAddress.setBuilding(model.buildingName);
      _buildingController.text = model.buildingName;
    }
    if (model != null &&
        model.block != null &&
        model.block.toString().length > 0) {
      providerAddAddress.setBlock(model.block);
      _blockController.text = model.block;
    }
    if (model != null &&
        model.streetNo != null &&
        model.streetNo.toString().length > 0) {
      providerAddAddress.setStreet(model.streetNo);
      _streetController.text = model.streetNo;
    }

    if (model != null &&
        model.areaName != null &&
        model.areaName.toString().length > 0) {
      providerAddAddress.setArea(model.areaName);
      _areaController.text = model.areaName;
    }

    if (model != null &&
        model.addressOf != null &&
        model.addressOf.toString().length > 0) {
      providerAddAddress.setAddressOf(model.addressOf);
      providerAddAddress
          .setAddressOfInt(model.addressOf.contains("Home") ? 0 : 1);
    }

    if (model != null &&
        model.latitude != null &&
        model.latitude.toString().length > 0) {
      providerAddAddress.setLat(model.latitude);
    }

    if (model != null &&
        model.longitude != null &&
        model.longitude.toString().length > 0) {
      providerAddAddress.setLng(model.longitude);
    }
  }

  Future<Uint8List> getMarker() async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load(icMapPinSolid);
    return byteData.buffer.asUint8List();
  }

  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    buildSetupScreenUtils(context);

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: GlobalColor.white,
        appBar: CommonAppBar(
          appBar: AppBar(),
          title: "${AppTranslations.of(context).text("Key_addAddress")}",
        ),
        body: Consumer<ProviderAddAddress>(
          builder: (context, providerAddAddress, child) {
            return Stack(
              children: [
                providerAddAddress.getShowProgressBar()
                    ? ProgressBar(clrBlack)
                    : SingleChildScrollView(
                        child: Container(
                          padding: GlobalPadding.paddingSymmetricH_20,
                          margin: GlobalPadding.paddingSymmetricV_25,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _textField(
                                  "${AppTranslations.of(context).text("Key_building")}",
                                  "${AppTranslations.of(context).text("Key_enter_building")}",
                                  _buildingController),
                              _textField(
                                  "${AppTranslations.of(context).text("Key_block")}",
                                  "${AppTranslations.of(context).text("Key_enter_block")}",
                                  _blockController),
                              _textField(
                                  "${AppTranslations.of(context).text("Key_street")}",
                                  "${AppTranslations.of(context).text("Key_enter_street")}",
                                  _streetController),
                              _areaDropDown(
                                "${AppTranslations.of(context).text("Key_area")}",
                                "${AppTranslations.of(context).text("Key_area")}",
                              ),
                              _textField(
                                  "${AppTranslations.of(context).text("Key_phone")}",
                                  "${AppTranslations.of(context).text("Key_errValidPhoneNo")}",
                                  _phoneController),
                              Row(
                                children: [
                                  _radioButton(
                                    0,
                                    "${AppTranslations.of(context).text("Key_home")}",
                                    "$home${widget.index}",
                                  ),
                                  SizedBox(
                                    width: setWidth(15),
                                  ),
                                  _radioButton(
                                      1,
                                      "${AppTranslations.of(context).text("Key_work")}",
                                      ""),
                                ],
                              ),
                              SizedBox(
                                height: setHeight(25),
                              ),
                              SizedBox(
                                width: infiniteSize,
                                height: setHeight(48),
                                child: FlatCustomButton(
                                  title:
                                      "${AppTranslations.of(context).text("Key_saveAddresses")}",
                                  onPressed: () async {
                                    hideKeyboard(context);

                                    if (providerAddAddress
                                        .getBuilding()
                                        .isEmpty) {
                                      _scaffoldKey.currentState
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            "${AppTranslations.of(context).text("Key_enter_building")}"),
                                      ));
                                    } else if (providerAddAddress
                                        .getBlock()
                                        .isEmpty) {
                                      _scaffoldKey.currentState
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            "${AppTranslations.of(context).text("Key_enter_block")}"),
                                      ));
                                    } else if (providerAddAddress
                                        .getStreet()
                                        .isEmpty) {
                                      _scaffoldKey.currentState
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            "${AppTranslations.of(context).text("Key_enter_street")}"),
                                      ));
                                    } else if (providerAddAddress.getPhone() ==
                                            null ||
                                        providerAddAddress.getPhone().isEmpty ||
                                        isPhoneNumberlValid(providerAddAddress
                                                .getPhone()) ==
                                            false) {
                                      _scaffoldKey.currentState
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            "${AppTranslations.of(context).text("Key_errValidPhoneNo")}"),
                                      ));
                                    } else {
                                      if (widget.model != null &&
                                          widget.model.id != null &&
                                          widget.model.id.toString().length >
                                              0) {
                                        providerAddAddress
                                            .setShowProgressBar(true);

                                        if (await getLocCoordinatesFromAddress()) {
                                          checkInternet().then((value) {
                                            if (value == true) {
                                              apiUpdateCustomerAddress(
                                                  context,
                                                  providerAddAddress,
                                                  widget.model.id);
                                            } else {
                                              providerAddAddress
                                                  .setShowProgressBar(false);
                                              showSnackBar(
                                                  "${AppTranslations.of(context).text("Key_errinternet")}");
                                            }
                                          });
                                        } else {
                                          providerAddAddress
                                              .setShowProgressBar(false);
                                        }
                                      } else {
                                        if (await getLocCoordinatesFromAddress()) {
                                          checkInternet().then((value) {
                                            if (value == true) {
                                              apiAddCustomerAddress(
                                                  context, providerAddAddress);
                                            } else {
                                              providerAddAddress
                                                  .setShowProgressBar(false);
                                              showSnackBar(
                                                  "${AppTranslations.of(context).text("Key_errinternet")}");
                                            }
                                          });
                                        } else {
                                          providerAddAddress
                                              .setShowProgressBar(false);
                                        }
                                      }
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                providerAddAddress.getShowProgressBar() == true
                    ? ProgressBar(clrBlack)
                    : Container()
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _textField(
      String _text, String _hintTxt, TextEditingController _txtController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _text,
          style: getTextStyle(context,
              type: Type.styleBody1,
              fontFamily: sourceSansFontFamily,
              fontWeight: fwRegular,
              txtColor: GlobalColor.darkGrey),
        ),
        TextField(
          controller: _txtController,
          cursorColor: GlobalColor.black,
          keyboardType: _text.contains("Phone")
              ? TextInputType.phone
              : TextInputType.text,
          onChanged: (val) {
            switch (_text) {
              case "Building":
                providerAddAddress.setBuilding(val);
                break;
              case "Block":
                providerAddAddress.setBlock(val);
                break;
              case "Street":
                providerAddAddress.setStreet(val);
                break;
              case "Area":
                providerAddAddress.setArea(val);
                break;

              case "Phone":
                providerAddAddress.setPhone(val);
                break;
              default:
            }
          },
          style: getTextStyle(
            context,
            type: Type.styleHead,
            fontFamily: sourceSansFontFamily,
            fontWeight: fwRegular,
            txtColor: GlobalColor.black,
          ),
          decoration: InputDecoration(
            hintText: _hintTxt,
            hintStyle: getTextStyle(
              context,
              type: Type.styleBody1,
              fontFamily: sourceSansFontFamily,
              fontWeight: fwRegular,
              txtColor: GlobalColor.grey,
            ),
          ),
        ),
        SizedBox(
          height: setHeight(20),
        ),
      ],
    );
  }

  Widget _areaDropDown(
    String _text,
    String _hintTxt,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _text,
          style: getTextStyle(context,
              type: Type.styleBody1,
              fontFamily: sourceSansFontFamily,
              fontWeight: fwRegular,
              txtColor: GlobalColor.darkGrey),
        ),
        DropdownButtonFormField<AreaList>(
            value: providerAddAddress.getSelectedArea(),
            items: _areaList.map((AreaList areaList) {
              return new DropdownMenuItem<AreaList>(
                value: areaList,
                child: new Text(
                  areaList.name,
                  style: new TextStyle(color: Colors.black),
                ),
              );
            }).toList(),
            isExpanded: true,
            decoration: InputDecoration(
              hintText: _hintTxt,
            ),
            icon: Image.asset(icDropDownArrow),
            onChanged: (AreaList value) {
              checkInternet().then((internet) async {
                if (internet == true) {
                  providerAddAddress.setSelectedArea(value);
                } else {
                  showSnackBar(
                      "${AppTranslations.of(context).text("Key_errinternet")}");
                }
              });
            }),
        SizedBox(
          height: setHeight(20),
        ),
      ],
    );
  }

  Widget _radioButton(int _value, String _title, String tag) {
    return Row(
      children: <Widget>[
        SizedBox(
          height: setHeight(30),
          width: setWidth(30),
          child: Radio(
            value: _value,
            groupValue: providerAddAddress.getAddressOfInt(),
            onChanged: (val) {
              val == 0
                  ? providerAddAddress.setAddressOf("Home")
                  : providerAddAddress.setAddressOf("Work");
              providerAddAddress.setAddressOfInt(val);
            },
          ),
        ),
        tag.isNotEmpty
            ? Hero(
                tag: tag,
                child: Material(
                  type: MaterialType.transparency,
                  child: Text(
                    _title,
                    style: getTextStyle(context,
                        type: Type.styleBody1,
                        txtColor: GlobalColor.black,
                        fontFamily: sourceSansFontFamily,
                        fontWeight: fwSemiBold),
                  ),
                ))
            : Text(
                _title,
                style: getTextStyle(context,
                    type: Type.styleBody1,
                    txtColor: GlobalColor.black,
                    fontFamily: sourceSansFontFamily,
                    fontWeight: fwSemiBold),
              ),
      ],
    );
  }

  Future<bool> getLocCoordinatesFromAddress() async {
    final query =
        "${providerAddAddress.getBuilding()}, ${providerAddAddress.getStreet()}, ${providerAddAddress.getSelectedArea().name}, Kuwait";

    List<Location> locations;

    try {
      locations = await locationFromAddress(query);
    } catch (e) {
      // showSnackBar(e.toString());
      print("--> error : ${e.toString()}");
    }

    if (locations != null &&
        locations.first.latitude != null &&
        locations.first.longitude != null) {
      await providerAddAddress.setLat(locations.first.latitude);
      await providerAddAddress.setLng(locations.first.longitude);

      print("${locations.first.latitude} ${locations.first.longitude} ");

      return true;
    } else {
      showSnackBar("Could not find your location, try another address");
      return false;
    }
  }

  apiAreaList(
      BuildContext context, ProviderAddAddress providerAddAddress) async {
    providerAddAddress.setShowProgressBar(true);

    SharedPreferences pref = await SharedPreferences.getInstance();

    String accessToken = pref.getString(prefStr_ACCESS_TOKEN);

    AreaListRequest areaListRequest = AreaListRequest();
    areaListRequest.activeRecords = "true";
    showLog("accessToken :-: $accessToken");

    Response response = await RestClient.getDataQueryParameter(context,
        ApiEndPoints.apiAreaList, accessToken, areaListRequest.toJson());

    if (response.statusCode == 200) {
      AreaListResponce areaListResponce =
          areaListResponceFromJson(response.toString());
      showLog("apiAreaList :-: ${areaListResponceToJson(areaListResponce)}");
      providerAddAddress.setShowProgressBar(false);

      if (areaListResponce.status == ApiEndPoints.apiStatus_200) {
        if (areaListResponce.data != null && areaListResponce.data.length > 0) {
          _areaList = [];

          _areaList = areaListResponce.data;

          if (widget.model != null &&
              widget.model.id != null &&
              widget.model.id.toString().length > 0) {
            for (int i = 0; i < areaListResponce.data.length; i++) {
              if (widget.model.areaId == areaListResponce.data[i].id) {
                print(_areaList[i].toString());
                providerAddAddress.setSelectedArea(_areaList[i]);
                break;
              } else {
                providerAddAddress.setSelectedArea(_areaList[0]);
              }
            }
          } else {
            providerAddAddress.setSelectedArea(_areaList[0]);
          }
        } else {
          providerAddAddress.setSelectedArea(new AreaList());
        }
      } else {
        showSnackBar(areaListResponce.message);
      }
    } else {
      providerAddAddress.setShowProgressBar(false);
      showSnackBar(
          "${AppTranslations.of(context).text("Key_errSomethingWrong")}");
    }
  }

  apiAddCustomerAddress(
    BuildContext context,
    ProviderAddAddress providerAddAddress,
  ) async {
    providerAddAddress.setShowProgressBar(true);

    SharedPreferences pref = await SharedPreferences.getInstance();
    String accessToken = pref.getString(prefStr_ACCESS_TOKEN);

    AreaList area = providerAddAddress.getSelectedArea();

    AddCustomerAddressRequest addCustomerAddressRequest =
        new AddCustomerAddressRequest();
    addCustomerAddressRequest.customerId = pref.getInt(prefInt_ID);
    addCustomerAddressRequest.firstName = pref.getString(prefStr_FNAME);
    addCustomerAddressRequest.lastName = pref.getString(prefStr_LNAME);

    addCustomerAddressRequest.phoneNumber = providerAddAddress.getPhone();

    addCustomerAddressRequest.streetNo = providerAddAddress.getStreet();
    addCustomerAddressRequest.buildingName = providerAddAddress.getBuilding();
    addCustomerAddressRequest.block = providerAddAddress.getBlock();
    addCustomerAddressRequest.areaId = area.id;

    addCustomerAddressRequest.active = Constants.static_ACTIVE;

    addCustomerAddressRequest.latitude = providerAddAddress.getLat();
    addCustomerAddressRequest.longitude = providerAddAddress.getLng();
    addCustomerAddressRequest.addressOf = providerAddAddress.getAddressOf();

    String data = addCustomerAddressRequestToJson(addCustomerAddressRequest);
    showLog("apiAddCustomerAddress data :-: $data");
    showLog("accessToken :-: $accessToken");

    Response response = await RestClient.postData(
        context, ApiEndPoints.apiAddUpdateCustomerAddress, data, accessToken);

    if (response.statusCode == 200) {
      CommonResponce commonResponce =
          commonResponceFromJson(response.toString());
      showLog(
          "apiAddCustomerAddress :-: ${commonResponceToJson(commonResponce)}");
      providerAddAddress.setShowProgressBar(false);

      if (commonResponce.status == ApiEndPoints.apiStatus_200) {
        showSnackBar(commonResponce.message);

        Future.delayed(Duration(seconds: 1), () {
          _scaffoldKey.currentState.hideCurrentSnackBar();
          Navigator.pop(context, true);
        });
      } else {
        showSnackBar(commonResponce.message);
      }
    } else {
      providerAddAddress.setShowProgressBar(false);
      showSnackBar(
          "${AppTranslations.of(context).text("Key_errSomethingWrong")}");
    }
  }

  apiUpdateCustomerAddress(BuildContext context,
      ProviderAddAddress providerAddAddress, int id) async {
    providerAddAddress.setShowProgressBar(true);

    SharedPreferences pref = await SharedPreferences.getInstance();
    int customerID = pref.getInt(prefInt_ID);
    String accessToken = pref.getString(prefStr_ACCESS_TOKEN);

    AreaList area = providerAddAddress.getSelectedArea();

    AddCustomerAddressRequest addCustomerAddressRequest =
        AddCustomerAddressRequest();
    addCustomerAddressRequest.id = widget.model.id;
    addCustomerAddressRequest.customerId = customerID;
    addCustomerAddressRequest.firstName = providerAddAddress.getFName();
    addCustomerAddressRequest.lastName = providerAddAddress.getLName();
    addCustomerAddressRequest.phoneNumber = providerAddAddress.getPhone();

    addCustomerAddressRequest.streetNo = providerAddAddress.getStreet();
    addCustomerAddressRequest.buildingName = providerAddAddress.getBuilding();
    addCustomerAddressRequest.block = providerAddAddress.getBlock();
    addCustomerAddressRequest.areaId = area.id;
    addCustomerAddressRequest.addressOf = providerAddAddress.getAddressOf();

    addCustomerAddressRequest.active = Constants.static_ACTIVE;

    addCustomerAddressRequest.latitude = providerAddAddress.getLat();
    addCustomerAddressRequest.longitude = providerAddAddress.getLng();

    String data = addCustomerAddressRequestToJson(addCustomerAddressRequest);
    showLog("apiUpdateAddress :-: $data");
    showLog("accessToken :-: $accessToken");

    Response response = await RestClient.postData(
        context, ApiEndPoints.apiAddUpdateCustomerAddress, data, accessToken);

    if (response.statusCode == 200) {
      CommonResponce commonResponce =
          commonResponceFromJson(response.toString());
      showLog("apiUpdateAddress :-: ${commonResponceToJson(commonResponce)}");
      providerAddAddress.setShowProgressBar(false);

      if (commonResponce.status == ApiEndPoints.apiStatus_200) {
        showSnackBar(commonResponce.message);
        Future.delayed(Duration(seconds: 1), () {
          Navigator.pop(context, true);
        });
      } else {
        showSnackBar(commonResponce.message);
      }
    } else {
      providerAddAddress.setShowProgressBar(false);
      showSnackBar(
          "${AppTranslations.of(context).text("Key_errSomethingWrong")}");
    }
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
