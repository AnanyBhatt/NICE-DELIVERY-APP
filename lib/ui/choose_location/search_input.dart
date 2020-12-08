import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nice_customer_app/mixins/const.dart';
import 'package:nice_customer_app/ui/choose_location/i18n.dart';
import 'package:nice_customer_app/utils/color_.dart';
import 'package:nice_customer_app/utils/textstyle_.dart';

/// Custom Search input field, showing the search and clear icons.
class SearchInput extends StatefulWidget {
  SearchInput(
    this.onSearchInput, {
    Key key,
    this.searchInputKey,
    this.boxDecoration,
    this.hintText,
  }) : super(key: key);

  final ValueChanged<String> onSearchInput;
  final Key searchInputKey;
  final BoxDecoration boxDecoration;
  final String hintText;

  @override
  State<StatefulWidget> createState() => SearchInputState();
}

class SearchInputState extends State<SearchInput> with Constants {
  TextEditingController editController = TextEditingController();

  Timer debouncer;

  bool hasSearchEntry = false;

  @override
  void initState() {
    super.initState();
    editController.addListener(onSearchInputChange);
  }

  @override
  void dispose() {
    editController.removeListener(onSearchInputChange);
    editController.dispose();

    super.dispose();
  }

  void onSearchInputChange() {
    if (editController.text.isEmpty) {
      debouncer?.cancel();
      widget.onSearchInput(editController.text);
      return;
    }

    if (debouncer?.isActive ?? false) {
      debouncer.cancel();
    }

    debouncer = Timer(Duration(milliseconds: 500), () {
      widget.onSearchInput(editController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    buildSetupScreenUtils(context);

    return Container(
      decoration: widget.boxDecoration ??
          BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.black54
                : Colors.white,
          ),
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: editController,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                  hintText: widget.hintText ??
                      S.of(context)?.search_place ??
                      'Search place',
                  border: InputBorder.none,
                  prefixIcon: Image.asset(icLocSearch),
                  hintStyle: getTextStyle(
                    context,
                    type: Type.styleBody1,
                    fontFamily: sourceSansFontFamily,
                    fontWeight: fwRegular,
                    txtColor: GlobalColor.grey,
                  )),
              onChanged: (value) {
                setState(() {
                  hasSearchEntry = value.isNotEmpty;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
