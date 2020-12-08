import 'package:flutter/cupertino.dart';
import 'package:nice_customer_app/api/responce/ProductResponce.dart';
import 'package:nice_customer_app/api/responce/VendorDetailResponce.dart';

class ProviderRestaurantDetails extends ChangeNotifier {


  List<Productlist> arrMainProductList = List();
  List<ProductResponseList> arrSelectedProduct = List();
  ProductResponseList modelSelectProduct = ProductResponseList();

  List<ProductExtrasList> arrProductExtrasList = List();
  ProductExtrasList productExtrasList = ProductExtrasList();

  int selectedProductVariant;
  ProductVariantList productVariantList = ProductVariantList();

  List<ProductToppingsDtoList> arrProductToppingsDtoList = List();
  ProductToppingsDtoList productToppingsDtoList = ProductToppingsDtoList();

  List<ProductAddonsDtoList> arrProductAddonsDtoList = List();
  ProductAddonsDtoList productAddonsDtoList = ProductAddonsDtoList();

  List<ProductAttributeValuesDtoList> arrProductAttributeValuesDtoList = List();
  List<ProductAttributeValueList> arrProductAttributeValueList = List();
  ProductAttributeValuesDtoList productAttributeValuesDtoList =
      ProductAttributeValuesDtoList();

  bool showProgressBar = true;
  bool isbottombar = false;
  VendorDetailData vendorDetailData = VendorDetailData();
  List<SingleProductCart> arrSingleProductCart = List();
  List<SingleProductCart> arrSingleProductCartExtras = List();
  double totalMainCart = 0;
  List<MainCart> arrMainCart = List();
  double totalSingleCart = 0;
  int SingleCartVariantID = 0;
  int SingleCartTotalCounts = 1;
  List<int> SingleCartAttributeValueIds = List();
  List<int> SingleCartProductToppingsIds = List();
  List<int> SingleCartProductAddonsId = List();
  List<int> SingleCartProductExtrasId = List();


  List<Productlist> getArrAddressList() => arrMainProductList;
  setArrAddressList(List<Productlist> val) {
    arrMainProductList.clear();
    arrMainProductList.addAll(val);
    notifyListeners();
  }

  List<ProductResponseList> getArrSelectedProduct() => arrSelectedProduct;
  setArrSelectedProduct(List<ProductResponseList> val) {
    arrSelectedProduct.addAll(val);
    notifyListeners();
  }

  ProductResponseList getProductResponseList() => modelSelectProduct;
  setProductResponseList(ProductResponseList val) {
    modelSelectProduct = val;
    notifyListeners();
  }

  int getSelectedProductVariant() => selectedProductVariant;
  setSelectedProductVariant(int val) {
    selectedProductVariant = val;
    notifyListeners();
  }

  ProductVariantList getProductVariantList() => productVariantList;
  setProductVariantList(ProductVariantList val) {
    productVariantList = val;
    notifyListeners();
  }

  List<ProductToppingsDtoList> getarrProductToppingsDtoList() =>
      arrProductToppingsDtoList;
  setarrProductToppingsDtoList(List<ProductToppingsDtoList> val) {
    arrProductToppingsDtoList.clear();
    arrProductToppingsDtoList.addAll(val);
    notifyListeners();
  }

  ProductToppingsDtoList getProductToppingsDtoList() => productToppingsDtoList;
  setProductToppingsDtoList(ProductToppingsDtoList val) {
    productToppingsDtoList = val;
    notifyListeners();
  }

  List<ProductAddonsDtoList> getarrProductAddonsDtoList() =>
      arrProductAddonsDtoList;
  setarrProductAddonsDtoList(List<ProductAddonsDtoList> val) {
    arrProductAddonsDtoList.clear();
    arrProductAddonsDtoList.addAll(val);
    notifyListeners();
  }

  ProductAddonsDtoList getProductAddonsDtoList() => productAddonsDtoList;
  setProductAddonsDtoList(ProductAddonsDtoList val) {
    productAddonsDtoList = val;
    notifyListeners();
  }

  List<ProductAttributeValuesDtoList> getarrProductAttributeValuesDtoList() =>
      arrProductAttributeValuesDtoList;
  setarrProductAttributeValuesDtoList(List<ProductAttributeValuesDtoList> val) {
    arrProductAttributeValuesDtoList.clear();
    arrProductAttributeValuesDtoList.addAll(val);
    notifyListeners();
  }

  List<ProductAttributeValueList> getarrProductAttributeValueList() =>
      arrProductAttributeValueList;
  setarrProductAttributeValueList(List<ProductAttributeValueList> val) {
    arrProductAttributeValueList.clear();
    arrProductAttributeValueList.addAll(val);
    notifyListeners();
  }

  ProductAttributeValuesDtoList getProductAttributeValuesDtoList() =>
      productAttributeValuesDtoList;
  setProductAttributeValuesDtoList(ProductAttributeValuesDtoList val) {
    productAttributeValuesDtoList = val;
    notifyListeners();
  }

  List<ProductExtrasList> getarrProductExtrasList() => arrProductExtrasList;
  setarrProductExtrasList(List<ProductExtrasList> val) {
    arrProductExtrasList.clear();
    arrProductExtrasList.addAll(val);
    notifyListeners();
  }

  ProductExtrasList getProductExtrasList() => productExtrasList;
  setProductExtrasList(ProductExtrasList val) {
    productExtrasList = val;
    notifyListeners();
  }

  getShowProgressBar() => showProgressBar;
  setShowProgressBar(bool val) {
    showProgressBar = val;
    notifyListeners();
  }

  VendorDetailData getVendorDetailData() => vendorDetailData;
  setVendorDetailData(VendorDetailData val) {
    vendorDetailData = val;
    notifyListeners();
  }

  List<SingleProductCart> getarrSingleProductCart() => arrSingleProductCart;
  setarrSingleProductCart(List<SingleProductCart> val) {
    arrSingleProductCart.clear();
    arrSingleProductCart.addAll(val);
    getSingleProductAmout(arrSingleProductCart);

    notifyListeners();
  }

  List<SingleProductCart> getarrSingleProductCartExtras() =>
      arrSingleProductCartExtras;
  setarrSingleProductCartExtras(List<SingleProductCart> val) {
    arrSingleProductCartExtras.clear();
    arrSingleProductCartExtras.addAll(val);

    notifyListeners();
  }

  int getSingleCartTotalCounts() => SingleCartTotalCounts;
  setSingleCartTotalCounts(int val) {
    SingleCartTotalCounts = val;
    notifyListeners();
  }

  List<MainCart> getarrMainCart() => arrMainCart;
  setarrMainCart(List<MainCart> val) {
    arrMainCart.clear();
    arrMainCart.addAll(val);

    if (arrMainCart != null && arrMainCart.length > 0) {
      isbottombar = true;
    } else {
      isbottombar = false;
    }

    getMainAmout(arrMainCart);

    notifyListeners();
  }

  String getSingleProductAmout(List<SingleProductCart> arr) {
    totalSingleCart = 0;
    SingleCartVariantID = arr[0].itemID;
    SingleCartAttributeValueIds = List();
    SingleCartProductToppingsIds = List();
    SingleCartProductAddonsId = List();
    SingleCartProductExtrasId = List();

    for (int i = 0; i < arr.length; i++) {
      if (arr[i].isChoiceOfCurst == true) {
        SingleCartAttributeValueIds.add(arr[i].itemID);
      }

      if (arr[i].isTopping == true) {
        SingleCartProductToppingsIds.add(arr[i].itemID);
      }

      if (arr[i].isAddOns == true) {
        SingleCartProductAddonsId.add(arr[i].itemID);
      }

      if (arr[i].isExtras == true) {
        SingleCartProductExtrasId.add(arr[i].itemID);
      }

      totalSingleCart = totalSingleCart + arr[i].itemAmount;
    }
  }

  String getMainAmout(List<MainCart> arr) {
    totalMainCart = 0;

    for (int i = 0; i < arr.length; i++) {
      totalMainCart = totalMainCart + arr[i].totalAmount;
    }
  }
}

class SingleProductCart {
  int itemID;
  String itemName;
  double itemAmount = 0;
  bool isChoiceOfCurst = false;
  bool isTopping = false;
  bool isAddOns = false;
  bool isExtras = false;

  SingleProductCart(
      {this.itemID,
      this.itemName,
      this.itemAmount,
      this.isChoiceOfCurst,
      this.isTopping,
      this.isAddOns,
      this.isExtras});
}

class MainCart {
  int itemID;
  double totalAmount = 0;
  List<SingleProductCart> arr;

  MainCart(this.itemID, this.totalAmount, this.arr);
}
