import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import './settings.dart';
import './prefs_helper.dart';

// this will be implemented as a PageView
class Excuses extends StatefulWidget {
  @override
  ExcusesState createState() => ExcusesState();
}

class ExcusesState extends State<Excuses> {
  List<String> _excuses;
  String _lang;

  final _controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Programmer excuses'),
          actions: [
            // Add 3 lines from here...
            IconButton(
                icon: const Icon(Icons.settings), onPressed: _openSettings),
          ],
        ),
        body: _buildExcuse()); // _buildSuggestions());
  }

  void _openSettings() async {
    var selectedLanguage = await Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) {
        return Settings(selectedLang: _lang);
      },
    ));
    if (selectedLanguage != null && selectedLanguage != this._lang) {
      setState(() {
        this._lang = selectedLanguage;
      });
      _getExcuses(context, selectedLanguage);
    }
  }

  Future<List<String>> _getExcuses(BuildContext context,
      [String selectedLanguage]) async {
    
    if (selectedLanguage != null) {
      var lines = await _loadFileDataForLang(selectedLanguage);
      _excuses = lines.split('\n');
      return _excuses;
    }
    if (_excuses == null) {
      var lines = await _loadFileData(context);
      _excuses = lines.split('\n');
      return _excuses;
    } else {
      return new Future.value(_excuses);
    }
  }

  /// Assumes the given path is a text-file-asset.
  Future<String> _loadFileDataForLang(String lang) async {
    return DefaultAssetBundle.of(context).loadString('assets/translations/$lang.txt');
  }

  /// Assumes the given path is a text-file-asset.
  Future<String> _loadFileData(BuildContext context) async {
    _lang = await PrefsHelper.getLang() ?? 'english';
    return _loadFileDataForLang(_lang);
  }

  Widget createPageView(context, snapshot) {
    return PageView.builder(
        // physics: new BouncingScrollPhysics(),
        controller: _controller,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
              padding: EdgeInsets.all(10.0),
              child:
                  Center(child: Text(_getRandomExcuse(snapshot.data) ?? '', textAlign: TextAlign.center))
          );
        });
  }

  String _getRandomExcuse(List<String> excuses) {
    return excuses[Random().nextInt(excuses.length)];
  }

  Widget _buildExcuse() {
    return Center(
        child: FutureBuilder(
            future: _getExcuses(context),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Text('loading...');
                default:
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return createPageView(context, snapshot);
                  }
              }
            }));
  }
}
