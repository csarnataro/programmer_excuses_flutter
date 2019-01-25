import 'package:flutter/material.dart';

import '../blocs/excuses_bloc.dart';
import '../blocs/excuses_provider.dart';

/// Please read https://iirokrankka.com/2018/12/11/splitting-widgets-to-methods-performance-antipattern/
/// for an explanation why I have replaced some functions with `StatelessWidget`s

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
    _excusesBloc = ExcusesProvider.of(context);

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
      body: _ExcusesContainer(_excusesBloc),
    );
  }
}

class _ExcusesPageView extends StatelessWidget {
  final List<String> excuses;
  const _ExcusesPageView(this.excuses);

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: excuses.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: EdgeInsets.all(10.0),
          child: Center(child: _ExcuseText(excuses, index)),
        );
      },
    );
  }
}

class _ExcuseText extends StatelessWidget {
  final List<String> excuses;
  final int index;

  _ExcuseText(this.excuses, this.index);

  @override
  Widget build(BuildContext context) {
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
}

class _ExcusesContainer extends StatelessWidget {
  final ExcusesBloc bloc;

  const _ExcusesContainer(this.bloc);

  @override
  Widget build(BuildContext context) {

    return Center(
      child: StreamBuilder(
        stream: bloc.excuses,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Text('loading...');
            default:
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return _ExcusesPageView(snapshot.data);
              }
          }
        },
      ),
    );
  }
}

