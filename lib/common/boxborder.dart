import 'package:flutter/material.dart';
import 'package:nice_customer_app/utils/color_.dart';

class ContainerBox extends StatelessWidget {
  final String hintText;
  final TextInputType type;
  final TextEditingController controller;
  final Function validate;

  ContainerBox(
      {Key key,
      @required this.hintText,
      @required this.type,
      @required this.controller,
      this.validate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        child: TextFormField(
          controller: controller,
          maxLines: 1,
          keyboardType: type,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration.collapsed(
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: Theme.of(context)
                  .textTheme
                  .headline4
                  .copyWith(color: GlobalColor.black)),
        ),
      ),
      decoration: BoxDecoration(
          border: Border.all(color: GlobalColor.black),
          borderRadius: BorderRadius.circular(3)),
    );
  }
}
