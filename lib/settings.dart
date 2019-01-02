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

  @override
  void initState() {
    _selectedLang = widget.selectedLang; // passed by the main screen
    super.initState();
  }

  List<DropdownMenuItem<String>> _getAvailableLanguagesItems(data) {
    print('In _getAvailableLanguagesItems: $data');
    return (data as List<String>).map(
      (value) => 
        DropdownMenuItem<String>(value: value, child: Text(_capitalize(value)))
    ).toList();
  }

  /// Assumes the given path is a text-file-asset.
  Future<List<String>> _loadAvailableLanguages() async {
    String languages = await DefaultAssetBundle.of(context)
        .loadString('assets/translations/available_languages.txt');
    print('Languages: $languages');
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
            child: FutureBuilder(
                future: _loadAvailableLanguages(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return Text('loading...');
                    default:
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return DropdownButton<String>(
                            value: _selectedLang,
                            hint: new Text("Lang"),
                            items: _getAvailableLanguagesItems(snapshot.data),
                            onChanged: (newValue) {
                              setState(() {
                                _selectedLang = newValue;
                              });
                              PrefsHelper.storeLang(newValue);
                            });
                      }
                  }
                })));
  }
}
