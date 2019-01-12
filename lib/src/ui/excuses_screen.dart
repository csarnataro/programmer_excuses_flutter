import 'package:flutter/material.dart';

import '../blocs/excuses_bloc.dart';
import '../blocs/excuses_provider.dart';

// this will be implemented as a PageView
class ExcusesScreen extends StatefulWidget {
  @override
  ExcusesScreenState createState() => ExcusesScreenState();
}

class ExcusesScreenState extends State<ExcusesScreen> {
  ExcusesBloc _excusesBloc;

  @override
  void dispose() {
    _excusesBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Programmer excuses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).pushNamed('/settings');
            },
          ),
        ],
      ),
      body: _buildExcuse(),
    );
  }

  Widget _buildExcuse() {
    _excusesBloc = ExcusesProvider.of(context);

    return Center(
      child: StreamBuilder(
        stream: _excusesBloc.excuses,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Text('loading...');
            default:
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return _createPageView(context, snapshot.data);
              }
          }
        },
      ),
    );
  }

  Widget _getText(excuses, index) {
    if (index == 0) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 80),
            child: Text(
              excuses[index],
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Opacity(
              opacity: 0.5,
              child: Image.asset(
                'assets/swipe_left.png',
                fit: BoxFit.fill,
                height: 60,
                alignment: Alignment(-1.0, -1.0),
              ),
            ),
          ),
        ],
      );
    } else {
      return Text(
        excuses[index],
        textAlign: TextAlign.center,
      );
    }
  }

  Widget _createPageView(BuildContext context, List<String> excuses) {
    return PageView.builder(
      itemCount: excuses.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: EdgeInsets.all(10.0),
          child: Center(child: _getText(excuses, index)),
        );
      },
    );
  }
}
