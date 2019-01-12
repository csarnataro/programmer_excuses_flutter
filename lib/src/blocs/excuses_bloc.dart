import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'package:rxdart/rxdart.dart';

import '../resources/prefs_helper.dart';

/// Used for populating a DropdownButton with the currently selected
/// language and the list of available languages to choose from.
class LanguageInfo {
  final String language;
  final List<String> availableLanguages;

  LanguageInfo(this.language, this.availableLanguages);
}

/// Business Logic Component for managing both the programmer excuses logic
/// and the Language selection. It could be splitted in 2
class ExcusesBloc {
  // TODO: read available languages from file
  final List<String> _availableLanguages =
      ['english', 'français', 'italiano'].toList();
  String _currentLanguage;
  List<String> _currentExcuses;

  StreamController<String> _languageSwitcherController =
      StreamController<String>();
  BehaviorSubject<LanguageInfo> _languageInfoController =
      BehaviorSubject<LanguageInfo>();
  BehaviorSubject<List<String>> _excusesStreamController =
      BehaviorSubject<List<String>>();

  ExcusesBloc() {
    _init();
    _languageSwitcherController.stream.listen(languageSwitcherListener);
  }

  Sink<String> get languageSwitcher => _languageSwitcherController.sink;
  ValueObservable<List<String>> get excuses => _excusesStreamController.stream;
  ValueObservable<LanguageInfo> get languageInfo {
    return _languageInfoController.stream;
  }

  /// Closes streams. It must be invoked explicitly from a screen.
  void dispose() {
    _languageSwitcherController.close();
    _languageInfoController.close();
    _excusesStreamController.close();
  }

  void languageSwitcherListener(lang) async {
    if (_currentLanguage != lang) {
      _currentLanguage = lang;
      _currentExcuses = await _getExcuses(_currentLanguage);
      _excusesStreamController.sink.add(_currentExcuses);
      _languageInfoController.sink
          .add(LanguageInfo(_currentLanguage, _availableLanguages));
      PrefsHelper.storeLang(lang);
    }
  }

  /// TODO: delegate the following functions to Service class
  /// Assumes the given path is a text-file-asset.
  Future<String> _loadFileDataForLang(String lang) async {
    return rootBundle.loadString('assets/translations/$lang.txt');
  }

  /// Initializes the BLoC. Detects if a language was previously stored
  /// in the shared Preferences (if not, english is used), then
  /// loads the excuses for that language and send everything through the 
  /// stream.
  void _init() {
    PrefsHelper.getLang().then((storedLang) {
      _currentLanguage = storedLang ?? 'english';
      _languageInfoController.sink
          .add(LanguageInfo(_currentLanguage, _availableLanguages));
      _getExcuses(_currentLanguage).then((excuses) {
        _currentExcuses = excuses;
        _excusesStreamController.sink.add(_currentExcuses);
      });
    });
  }

  Future<List<String>> _getExcuses(String selectedLanguage) async {
    String fileContent = await _loadFileDataForLang(selectedLanguage);
    List<String> lines = fileContent.split('\n');
    lines.shuffle();
    return lines.where((line) => line.isNotEmpty).toList();
  }
}
