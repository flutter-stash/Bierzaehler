import 'package:bierzaehler/drink_page.dart';
import 'package:bierzaehler/home.dart';
import 'package:bierzaehler/redux/app_state.dart';
import 'package:bierzaehler/redux/middleware.dart';
import 'package:bierzaehler/redux/reducers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final Store<AppState> store = new Store<AppState>(
      appStateReducer,
      initialState: AppState.initialState(),
      middleware: middleware,
    );

    return StoreProvider<AppState>(
        store: store,
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primaryColor: const Color(0xff7b1fa2),
            accentColor: const Color(0xff0091ea),

          ),
          home: HomePage(),
        ));
  }
}
