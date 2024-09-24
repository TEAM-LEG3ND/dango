import 'package:flutter/material.dart';

class LanguageService with ChangeNotifier {
  Locale _locale = const Locale('en', '');

  Locale get locale => _locale;

  void toggleLanguage() {
    _locale = _locale.languageCode == 'en'
        ? const Locale('ko', '')
        : const Locale('en', '');
    notifyListeners();
  }
}
