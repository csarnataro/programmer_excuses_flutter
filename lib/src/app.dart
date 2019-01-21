import 'package:flutter/material.dart';

import 'blocs/excuses_provider.dart';
import 'ui/excuses_screen.dart';
import 'ui/settings_screen.dart';

const EXCUSES_ROUTE = '/'; // It MUST be '/', otherwise it will generate an error
const SETTINGS_ROUTE = '/settings';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExcusesProvider(
      child: MaterialApp(
        initialRoute: EXCUSES_ROUTE,
        routes: {
          EXCUSES_ROUTE: (context) => ExcusesScreen(),
          SETTINGS_ROUTE: (context) => SettingsScreen(),
        },
        title: 'Programmer excuses',
        theme: ThemeData(
          primaryColor: Colors.blue,
        ),
      ),
    );
  }
}
