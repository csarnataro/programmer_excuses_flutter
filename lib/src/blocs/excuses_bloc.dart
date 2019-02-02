import 'dart:async';

import 'package:flutter/services.dart' show rootBundle;
import 'package:rxdart/rxdart.dart';

import '../resources/prefs_helper.dart';

/// Used for populating a DropdownButton with the currently selected
/// language and the list of available languages to choose from.
class LanguageInfo {
  final LanguageDescription language;
  final List<LanguageDescription> availableLanguages;

  LanguageInfo(this.language, this.availableLanguages);
}

class LanguageDescription {
  final String label;
  final String value;

  LanguageDescription(this.label, this.value);
}

/// Business Logic Component for managing both the programmer excuses logic
/// and the Language selection. It could be splitted in 2
class ExcusesBloc {
  List<LanguageDescription> _availableLanguages;
  LanguageDescription _currentLanguage;
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
      _currentLanguage = _availableLanguages.firstWhere((l) => l.value == lang);
      _currentExcuses = await _getExcuses(_currentLanguage.value);
      _excusesStreamController.sink.add(_currentExcuses);
      _languageInfoController.sink
          .add(LanguageInfo(_currentLanguage, _availableLanguages));
      PrefsHelper.storeLang(lang);
    }
  }

  /// TODO: delegate the following functions to Service class
  /// Assumes the given path is a text-file-asset.
  /// WARNING: for some reason, assets with non-ascii characters (e.g. 'français')
  /// are not working here... trying to overcome this issue adding both label and value
  Future<String> _loadFileDataForLang(String lang) async {
    return rootBundle.loadString('assets/translations/$lang.txt');
  }

  /// Initializes the BLoC. Detects if a language was previously stored
  /// in the shared Preferences (if not, english is used), then
  /// loads the excuses for that language and send everything through the
  /// stream.
  void _init() async {
    // Loading available languages
    _availableLanguages = await _loadAvailableLanguages();

    /// Loading stored language (if available)
    String storedLang = await PrefsHelper.getLang();

    if (storedLang == null) {
      _currentLanguage = LanguageDescription('English', 'english');
    } else if (!_availableLang(_availableLanguages, storedLang)) {
      _currentLanguage = LanguageDescription('English', 'english');
    } else {
      _currentLanguage = _availableLanguages.firstWhere((l) => l.value == storedLang);
    }

    // putting the current language and the available language into the sink
    // for later use in the settings screen
    _languageInfoController.sink
        .add(LanguageInfo(_currentLanguage, _availableLanguages));

    // Loading the excuses in the current language and putting them
    // into the sink for creating the main screen
    _currentExcuses = await _getExcuses(_currentLanguage.value);
    _excusesStreamController.sink.add(_currentExcuses);
  }

  bool _availableLang(List<LanguageDescription> languages, String lang) {
    return (languages.firstWhere((l) => l.value == lang, orElse: null) != null);
  }

  Future<List<String>> _getExcuses(String selectedLanguage) async {
    String fileContent = await _loadFileDataForLang(selectedLanguage);
    List<String> lines = fileContent.split('\n');
    lines.shuffle();
    return lines.where((line) => line.isNotEmpty).toList();
  }

  /// Assumes the given path is a text-file-asset.
  Future<List<LanguageDescription>> _loadAvailableLanguages() async {
    String languagesAsString = await rootBundle
        .loadString('assets/translations/available_languages.txt');
    List<LanguageDescription> languages = languagesAsString
        .split('\n')
        .where((line) => line.isNotEmpty)
        .map((line) =>
            LanguageDescription(line.split('|')[0], line.split('|')[1]))
        .toList();
    return languages;
  }
}
