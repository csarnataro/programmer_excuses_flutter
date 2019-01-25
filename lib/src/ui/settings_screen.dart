import 'package:flutter/material.dart';

import '../blocs/excuses_provider.dart';
import '../blocs/excuses_bloc.dart';

class SettingsScreen extends StatefulWidget {

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

/// Since I'm using a single BLoC for 2 screen, the disposal of the
/// streams in the bloc are in charge of the main screen (i.e. ExcusesScreen)
class SettingsScreenState extends State<SettingsScreen> {
  ExcusesBloc _excusesBloc;

  List<DropdownMenuItem<String>> _getAvailableLanguagesItems(data) {
    return (data as List<String>)
        .map((value) => DropdownMenuItem<String>(
            value: value, child: Text(_capitalize(value))))
        .toList();
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
    _excusesBloc = ExcusesProvider.of(context);

    return Scaffold(
      appBar: new AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Settings'),
      ),
      body: Center(
        child: StreamBuilder(
          stream: _excusesBloc.languageInfo,
          builder: (context, AsyncSnapshot<LanguageInfo> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(child: Text('loading...'));
              default:
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: Text(
                          'Language: ',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      DropdownButton<String>(
                        value: snapshot.data.language,
                        hint: new Text("Language"),
                        items: _getAvailableLanguagesItems(
                            snapshot.data.availableLanguages),
                        onChanged: (newValue) {
                          _excusesBloc.languageSwitcher.add(newValue);
                        },
                      )
                    ],
                  );
                }
            }
          },
        ),
      ),
    );
  }
}
