import 'package:bierzaehler/objects/drink.dart';
import 'package:bierzaehler/redux/actions.dart';
import 'package:bierzaehler/redux/app_state.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

class DrinkViewModel {
  final Drink drink;

  final Function(Size) addSize;
  final Function(int) deleteSize;
  final Function(int, Size) renameSize;

  DrinkViewModel(
      {@required this.drink,
        @required this.addSize,
        @required this.deleteSize,
        @required this.renameSize,
      });

  factory DrinkViewModel.create(Store<AppState> store, index) {
    _addSize(Size size) {
      store.dispatch(new AddSizeToDrinkAction(size: size, drinkIndex: index));
    }

    _deleteSize(int sizeIndex) {
      store.dispatch(new DeleteSizeFromDrinkAction(drinkIndex: index, sizeIndex: sizeIndex));
    }

    _renameSize(int sizeIndex, Size newSize) {
      store.dispatch(new RenameSizeAtDrinkAction(drinkIndex: index, sizeIndex: sizeIndex, size: newSize));
    }

    return DrinkViewModel(
      addSize: _addSize,
      deleteSize: _deleteSize,
      drink: store.state.drinks[index],
      renameSize: _renameSize
    );
  }
}
