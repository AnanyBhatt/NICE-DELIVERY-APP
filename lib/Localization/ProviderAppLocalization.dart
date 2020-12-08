import 'package:flutter/cupertino.dart';
import 'package:nice_customer_app/Localization/app_translations.dart';
import 'package:nice_customer_app/mixins/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'application.dart';

class ProviderAppLocalization with ChangeNotifier,Constants {

  static List<String> languagesList = application.supportedLanguages;
  static List<String> languageCodesList =
      application.supportedLanguagesCodes;

   Map<dynamic, dynamic> languagesMap = {
    languagesList[0]: languageCodesList[0],
    languagesList[1]: languageCodesList[1],
  };
  String label = languagesList[0];

  Locale _appLocale = Locale('en');
  Locale get appLocal => _appLocale ?? Locale("en");

  void initState() {
    application.onLocaleChanged = onLocaleChange;
    //onLocaleChange(Locale(languagesMap["Arabic"]));
  }

  void onLocaleChange(Locale locale) async {
    AppTranslations.load(locale);
    notifyListeners();
  }
  void selectevent(String language) {
    print("Selected Language $language");
    _appLocale = Locale(language);
    onLocaleChange(Locale(language, ""));
    notifyListeners();

  }



}