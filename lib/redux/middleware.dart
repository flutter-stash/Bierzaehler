import 'package:bierzaehler/redux/app_state.dart';
import 'package:redux/redux.dart';

import 'actions.dart';
import 'middleware_functions.dart';

final List<Middleware<AppState>> middleware = [
  new TypedMiddleware<AppState, GetDataAction>(loadDataMiddleware),
];

void loadDataMiddleware(
    Store<AppState> store, GetDataAction action, NextDispatcher next) {
  getData(store.state).then((newState) {
    next(new GetDataActionSucceeded(state: newState));
  }).catchError((_) => next(new GetDataActionError()));
}