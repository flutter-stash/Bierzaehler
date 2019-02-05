import 'package:bierzaehler/objects/drink.dart';
import 'package:bierzaehler/objects/size.dart';
import 'package:bierzaehler/redux/app_state.dart';
import 'package:flutter/material.dart';

//------------------------------
//Root Actions
//------------------------------
abstract class WriteAction{}

abstract class RootAction{}

class GetDataAction extends RootAction{}

class GetDataActionSucceeded extends RootAction{
  final AppState state;
  GetDataActionSucceeded({@required this.state});
}

class GetDataActionError extends RootAction{}

class SetDataAction extends RootAction{
  final AppState state;
  SetDataAction({@required this.state});
}

class ChangeHomePageIndexAction extends RootAction{}

//------------------------------
//Add Actions
//------------------------------

abstract class AddAction extends WriteAction{}

class AddDrinkAction implements AddAction{
  final Drink drink;

  AddDrinkAction({@required this.drink});
}

class AddSizeToDrinkAction implements AddAction{
  final int drinkIndex;
  final Size size;

  AddSizeToDrinkAction({@required this.size, @required this.drinkIndex});
}

class DoUseAtDrinkForSizeAction extends AddAction{
  final int sizeIndex;
  final int drinkIndex;

  DoUseAtDrinkForSizeAction({@required this.sizeIndex, @required this.drinkIndex});
}

//----------------------------
//Delete Actions
//----------------------------

abstract class DeleteAction extends WriteAction{}

class DeleteDrinkAction extends DeleteAction{
  final int index;
  DeleteDrinkAction({@required this.index});
}

class DeleteSizeFromDrinkAction extends DeleteAction{
  final int drinkIndex;
  final int sizeIndex;
  DeleteSizeFromDrinkAction({@required this.drinkIndex, @required this.sizeIndex});
}

//----------------------------
//Rename Actions
//----------------------------

abstract class EditAction extends WriteAction{}

class EditDrinkAction extends EditAction{
  final int index;
  final String name;
  final double alcohol;

  EditDrinkAction({@required this.index, @required this.name, @required this.alcohol});
}

class RenameSizeAtDrinkAction extends EditAction{
  final int drinkIndex;
  final int sizeIndex;
  final Size size;

  RenameSizeAtDrinkAction({@required this.sizeIndex, @required this.drinkIndex, @required this.size});
}



















