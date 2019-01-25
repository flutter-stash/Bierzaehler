import 'dart:convert';

import 'package:bierzaehler/objects/drink.dart';
import 'package:bierzaehler/redux/app_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<AppState> getData(AppState state) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String data = prefs.getString("data");
  //  '[{"name": "Bier", "alcohol": "4.9", "sizes": [{"value": "0.33"}], "uses": [{"size": {"value": "0.33"}, "date": "2313231315451213"}]}]';
  if(data == null || data == ""){
    return  state.copyWith(status: DataState.THERE);
  }
  Iterable l = json.decode(data);
  return state.copyWith(status: DataState.THERE,drinks: l.map((model) => Drink.fromJSON(model)).toList());
}

Future<void> setData(AppState state) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String encode = jsonEncode(state.drinks);
  await prefs.setString("data", encode);
}