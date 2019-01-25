import 'package:bierzaehler/objects/drink.dart';
import 'package:flutter/material.dart';

class AppState {
  final List<Drink> drinks;
  final DataState status;

  AppState({@required this.drinks, @required this.status});

  AppState.initialState()
      : drinks = new List.unmodifiable(<Drink>[]),
        status = DataState.LOADING;

  AppState copyWith({List<Drink> drinks, DataState status}) {
    return AppState(
        drinks: drinks ?? this.drinks, status: status ?? this.status);
  }
}

enum DataState { LOADING, THERE, ERROR }
