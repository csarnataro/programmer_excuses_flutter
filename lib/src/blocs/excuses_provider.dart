import 'package:flutter/widgets.dart';
import './excuses_bloc.dart';

/// Provider for the BLoC.
/// See https://github.com/filiph/state_experiments/blob/master/shared/lib/src/bloc/cart_provider.dart
class ExcusesProvider extends InheritedWidget {
  final ExcusesBloc excusesBloc;

  ExcusesProvider({
    Key key,
    ExcusesBloc bloc,
    Widget child,
  })  : excusesBloc = bloc ?? ExcusesBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static ExcusesBloc of(BuildContext context) {
      return (context.inheritFromWidgetOfExactType(ExcusesProvider) as ExcusesProvider)
          .excusesBloc;
  }
}