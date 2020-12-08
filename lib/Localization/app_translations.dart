import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:nice_customer_app/mixins/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppTranslations  {
  Locale locale;
  static Map<dynamic, dynamic> _localisedValues;

  AppTranslations(Locale locale) {
    this.locale = locale;
  }

  static AppTranslations of(BuildContext context) {
    return Localizations.of<AppTranslations>(context, AppTranslations);
  }

  static Future<AppTranslations> load(Locale locale) async {
    AppTranslations appTranslations = AppTranslations(locale);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var appLanguage = preferences.getString(Constants.active_app_language);
    if(appLanguage==null || appLanguage=="")
      {
        appLanguage="en";
      }
    String jsonContent =
    await rootBundle.loadString("lang/localization_${appLanguage}.json");
    _localisedValues = json.decode(jsonContent);
    print("Localization File Name - lang/localization_${appLanguage}.json");
    return appTranslations;
  }

  get currentLanguage => locale.languageCode;

  String text(String key) {
    return _localisedValues[key] ?? "$key not found";
  }
}