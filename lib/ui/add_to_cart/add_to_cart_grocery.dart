import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nice_customer_app/common/addTocartButton.dart';
import 'package:nice_customer_app/mixins/const.dart';
import 'package:nice_customer_app/provider/viewCart.dart';
import 'package:nice_customer_app/ui/add_to_cart/variantCart.dart';
import 'package:nice_customer_app/ui/vendor_detail_category/add_on.dart';
import 'package:nice_customer_app/ui/vendor_detail_category/choice_crust.dart';
import 'package:nice_customer_app/ui/vendor_detail_category/extras.dart';
import 'package:nice_customer_app/ui/vendor_detail_category/toppings.dart';
import 'package:nice_customer_app/ui/vendor_detail_category/variants.dart';
import 'package:nice_customer_app/utils/color_.dart';
import 'package:nice_customer_app/utils/padding_.dart';
import 'package:nice_customer_app/utils/textstyle_.dart';
import 'package:nice_customer_app/model/foodItem.dart';

import 'package:provider/provider.dart';

class AddToCartGroceryPage extends StatefulWidget {
  final int index;
  final FoodItem itemData;
  int cartCount;
  AddToCartGroceryPage({Key key, this.index, this.itemData, this.cartCount})
      : super(key: key);

  @override
  _AddToCartGroceryPageState createState() => _AddToCartGroceryPageState();
}

class _AddToCartGroceryPageState extends State<AddToCartGroceryPage>
    with Constants {
  String foos = 'One';

  bool isExpanded = false;
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    var viewCartPro = Provider.of<ViewCart>(context);

    buildSetupScreenUtils(context);

    return SafeArea(
        child: Scaffold(
            backgroundColor: GlobalColor.white,
            body: Container(
              padding: GlobalPadding.paddingSymmetricH_20,
              height: infiniteSize,
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: setHeight(20),
                        ),
                        InkWell(
                          child: Image.asset(icArrowRound),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                        Center(
                            child: Hero(
                          tag: "itemPicTag${widget.index}",
                          child: Material(
                            type: MaterialType.transparency,
                            child: Image.asset(
                              widget.itemData.image,
                            ),
                          ),
                        )),
                        SizedBox(
                          height: setHeight(28.67),
                        ),
                        Text(
                          widget.itemData.name,
                          style: getTextStyle(context,
                              type: Type.styleDrawerText,
                              fontFamily: sourceSansFontFamily,
                              fontWeight: fwBold,
                              txtColor: GlobalColor.black),
                        ),
                        SizedBox(
                          height: setHeight(10),
                        ),
                        Hero(
                          tag: "categoryTag${widget.index}",
                          child: Material(
                            type: MaterialType.transparency,
                            child: Text(
                              widget.itemData.desc,
                              style: getTextStyle(context,
                                  type: Type.styleBody1,
                                  fontFamily: sourceSansFontFamily,
                                  fontWeight: fwRegular,
                                  txtColor: GlobalColor.black),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: setHeight(10),
                        ),
                        Hero(
                            tag: "amountTag${widget.index}",
                            child: Material(
                              type: MaterialType.transparency,
                              child: Text(
                                widget.itemData.orginalPrice,
                                style: getTextStyle(context,
                                    type: Type.styleDrawerText,
                                    fontFamily: sourceSansFontFamily,
                                    fontWeight: fwBold,
                                    txtColor: GlobalColor.black),
                              ),
                            )),
                        SizedBox(
                          height: setHeight(35),
                        ),
                        VariantsCart(
                          category: "grocery",
                        ),
                        RichText(
                          text: TextSpan(
                              text: "Special Request?",
                              style: getTextStyle(
                                context,
                                type: Type.styleBody1,
                                fontFamily: sourceSansFontFamily,
                                fontWeight: fwBold,
                                txtColor: GlobalColor.black,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                    text: " (Optional)",
                                    style: getTextStyle(
                                      context,
                                      type: Type.styleBody1,
                                      fontFamily: sourceSansFontFamily,
                                      fontWeight: fwRegular,
                                      txtColor: GlobalColor.grey,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => Navigator.pushNamed(
                                          context, signupRoute)),
                              ]),
                        ),
                        TextField(
                          decoration:
                              InputDecoration(hintText: "Tap to enter request"),
                          style: getTextStyle(
                            context,
                            type: Type.styleBody1,
                            fontFamily: sourceSansFontFamily,
                            fontWeight: fwRegular,
                            txtColor: GlobalColor.grey,
                          ),
                        ),
                        SizedBox(
                          height: setHeight(35),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              icMinus,
                              scale: 0.7,
                            ),
                            SizedBox(
                              width: setWidth(54),
                            ),
                            Text(
                              "1",
                              style: getTextStyle(
                                context,
                                type: Type.styleSubTitle,
                                fontFamily: sourceSansFontFamily,
                                fontWeight: fwSemiBold,
                                txtColor: GlobalColor.black,
                              ),
                            ),
                            SizedBox(
                              width: setWidth(54),
                            ),
                            Image.asset(
                              icPlus,
                              scale: 0.7,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: setHeight(100),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 30,
                    child: SizedBox(
                      width: setWidth(335),
                      child: AddToCartButton(
                        onPressed: () {
                          widget.itemData.qty += 1;

                          print("QTYYYYY ${widget.itemData.qty}");

                          widget.cartCount += 1;

                          Navigator.pop(context, widget.cartCount);
                        },
                        title: "Add to cart",
                        trailing: "KD 4.00",
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }
}
