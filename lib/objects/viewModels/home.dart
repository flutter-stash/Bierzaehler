import 'package:bierzaehler/objects/drink.dart';
import 'package:bierzaehler/redux/actions.dart';
import 'package:bierzaehler/redux/app_state.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

class HomeViewModel {
  final List<Drink> drinks;
  final DataState state;

  final Function(Drink) addDrink;
  final Function(int) deleteDrink;
  final Function(int, String, double) editDrink;
  final Function() getData;


  HomeViewModel(
      {@required this.drinks,
      @required this.state,
      @required this.addDrink,
      @required this.deleteDrink,
      @required this.editDrink,
      @required this.getData});

  factory HomeViewModel.create(Store<AppState> store) {
    _addDrink(Drink drink) {
      store.dispatch(new AddDrinkAction(drink: drink));
    }

    _deleteDrink(int index) {
      store.dispatch(new DeleteDrinkAction(index: index));
    }

    _editDrink(int index, String name, double alcohol) {
      store.dispatch(new EditDrinkAction(index: index, name: name,alcohol: alcohol));
    }

    _getData() {
      store.dispatch(new GetDataAction());
    }

    return HomeViewModel(
      addDrink: _addDrink,
      deleteDrink: _deleteDrink,
      drinks: store.state.drinks,
      editDrink: _editDrink,
      state: store.state.status,
      getData: _getData,
    );
  }
}
