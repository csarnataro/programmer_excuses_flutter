import 'package:flutter/material.dart';
import './prefs_helper.dart';

class Settings extends StatefulWidget {
  final selectedLang;

  Settings({Key key, @required this.selectedLang}) : super(key: key);

  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  String _selectedLang;
  List<DropdownMenuItem<String>> _availableLanguagesItems;

  @override
  void initState() {
    _selectedLang = widget.selectedLang; // passed by the main screen
    
    var availableLanguages = await _loadAvailableLanguages();
    _availableLanguagesItems = availableLanguages.map((language) => DropdownMenuItem<String>(
          value: language,
          child: Text(_capitalize(language))
        ));
    super.initState();
  }

    /// Assumes the given path is a text-file-asset.
  Future<List<String>> _loadAvailableLanguages() async {
    String languages = await DefaultAssetBundle.of(context)
      .loadString('assets/translations/available_languages.txt');
    return languages.split('\n');
  }


  /// Capitalizes the `input` string.
  String _capitalize(String input) {
    if (input == null) {
      throw new ArgumentError("string: $input");
    }
    if (input.length == 0) {
      return input;
    }
    return input[0].toUpperCase() + input.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // Add 6 lines from here...
        appBar: new AppBar(
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(_selectedLang),
            ),
            title: const Text('Settings')),
        body: Center(
            child: DropdownButton<String>(
                value: _selectedLang,
                hint: new Text("Language"),
                items: _availableLanguagesItems,
                onChanged: (newValue) {
                  setState(() {
                    _selectedLang = newValue;
                  });
                  PrefsHelper.storeLang(newValue);
                })));
  }
}
