import 'dart:io' show Platform;

import 'package:bierzaehler/home.dart';
import 'package:bierzaehler/objects/drink.dart';
import 'package:bierzaehler/objects/size.dart';
import 'package:bierzaehler/objects/use.dart';
import 'package:bierzaehler/redux/app_state.dart';
import 'package:bierzaehler/redux/middleware.dart';
import 'package:bierzaehler/redux/middleware_functions.dart';
import 'package:bierzaehler/redux/reducers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:path/path.dart';
import 'package:redux/redux.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  if (Platform.isAndroid) {
    getDatabaseData().then((_) => runApp(MyApp()));
  } else {
    runApp(MyApp());
  }
}

Future<void> getDatabaseData() async {
  var dbDir = await getDatabasesPath();
  var dbPath = join(dbDir, "Bierzaehler.db");
  Database db;
  try {
    db = await openDatabase(dbPath);
  } catch (e) {
    return;
  }
  if(db == null){
    return;
  }
  List<Map<String, dynamic>> drinks;
  try{
    String query = "SELECT * FROM Beverages;";
    drinks = await db.rawQuery(query);
  }catch (e) {
    return;
  }
  List<Drink> drinkObjects = new List<Drink>();
  for(Map<String, dynamic> drink in drinks){
    String drinkName = drink['Beverage'];
    double alcohol = 0.0;
    
    String query = "SELECT * FROM Sizes;";
    List<Map<String, dynamic>> sizes = await db.rawQuery(query);
    Map<int, Size> sizesObjects = new Map<int, Size>();
    for(Map<String, dynamic> size in sizes){
      String sizeDouble = size['Size'];
      sizesObjects[size['SizesID']] = new Size(double.parse(sizeDouble));
    }
    
    List<Size> finalDrinkSizesObjects = new List<Size>();
    List<Use> finalDrinkSizeUsesObjects = new List<Use>();
    Map<int, Size> drinkSizesObjects = new Map<int, Size>();
    query = "SELECT * FROM BeverageSizes WHERE BevaragesID = '${drink['BevaragesID']}';";
    List<Map<String, dynamic>> drinkSizes = await db.rawQuery(query);
    for(Map<String, dynamic> drinkSize in drinkSizes){
      drinkSizesObjects[drinkSize['BevarageSizesID']] = sizesObjects[drinkSize['SizesID']];
      finalDrinkSizesObjects.add(sizesObjects[drinkSize['SizesID']]);


      query = "SELECT * FROM BeverageSizeUses WHERE BeverageSizesID = '${drinkSize['BevarageSizesID']}';";
      List<Map<String, dynamic>> drinkSizeUses = await db.rawQuery(query);
      for(Map<String, dynamic> drinkSizeUse in drinkSizeUses){
        int date = drinkSizeUse['Date'];
        int day = date % 100;
        date = date ~/ 100;
        int month = date % 100;
        date = date ~/ 100;
        DateTime dateObject = DateTime(date, month, day);
        finalDrinkSizeUsesObjects.add(new Use(drinkSizesObjects[drinkSizeUse['BeverageSizesID']], microsecondsSinceEpoch: dateObject.microsecondsSinceEpoch));
      }
    }



    drinkObjects.add(new Drink(drinkName, alcohol, finalDrinkSizesObjects, finalDrinkSizeUsesObjects));
  }
  AppState state = AppState.initialState();
  state = state.copyWith(drinks: drinkObjects);
  await setData(state);
  deleteDatabase(dbPath);
}

class MyApp extends StatelessWidget {
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
