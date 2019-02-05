import 'package:bierzaehler/objects/drink.dart';
import 'package:bierzaehler/redux/actions.dart';
import 'package:bierzaehler/redux/app_state.dart';
import 'package:bierzaehler/redux/middleware_functions.dart';
import 'package:redux/redux.dart';

Reducer<AppState> appStateReducer = combineReducers<AppState>([
  new TypedReducer<AppState, RootAction>(_rootReducer),
  new TypedReducer<AppState, WriteAction>(_writeMiddleReducer),

]);

//------------------------
//ROOT REDUCER
//------------------------

Reducer<AppState> _rootReducer = combineReducers<AppState>([
  new TypedReducer<AppState, GetDataActionSucceeded>(_getDataSucceededReducer),
  new TypedReducer<AppState, GetDataActionError>(_getDataErrorReducer),
]);

AppState _getDataSucceededReducer(AppState state, GetDataActionSucceeded action){
  return action.state;
}

AppState _getDataErrorReducer(AppState state, GetDataActionError action){
  return state.copyWith(status: DataState.ERROR);
}

AppState _writeMiddleReducer(AppState state, WriteAction action){
  AppState newState = _writeReducer(state, action);
  setData(newState);
  return newState;
}

Reducer<AppState> _writeReducer = combineReducers<AppState>([
  new TypedReducer<AppState, AddAction>(_addReducer),
  new TypedReducer<AppState, EditAction>(_editReducer),
  new TypedReducer<AppState, DeleteAction>(_deleteReducer),
]);

//------------------------
//ADD REDUCER
//------------------------

Reducer<AppState> _addReducer = combineReducers<AppState>([
  new TypedReducer<AppState, AddSizeToDrinkAction>(_addSizeToDrinkReducer),
  new TypedReducer<AppState, AddDrinkAction>(_addDrinkReducer),
  new TypedReducer<AppState, DoUseAtDrinkForSizeAction>(_doUseAtDrinkForSizeReducer),
]);

AppState _addDrinkReducer(AppState state, AddDrinkAction action){
  List<Drink> drinks = new List<Drink>.from(state.drinks);
  drinks.add(action.drink);
  return state.copyWith(drinks: drinks);
}

AppState _addSizeToDrinkReducer(AppState state, AddSizeToDrinkAction action){
  List<Drink> drinks= List<Drink>.from(state.drinks);
  drinks[action.drinkIndex].addSize(action.size);
  return state.copyWith(drinks: drinks);
}

AppState _doUseAtDrinkForSizeReducer(AppState state, DoUseAtDrinkForSizeAction action){
  List<Drink> drinks = List<Drink>.from(state.drinks);
  drinks[action.drinkIndex].doUse(action.sizeIndex);
  return state.copyWith(drinks: drinks);
}

//------------------------
//EDIT REDUCER
//------------------------

Reducer<AppState> _editReducer = combineReducers<AppState>([
  TypedReducer<AppState, EditDrinkAction>(_editDrinkReducer),
]);

AppState _editDrinkReducer(AppState state, EditDrinkAction action){
  List<Drink> drinks = state.drinks;
  drinks[action.index].name = action.name;
  drinks[action.index].alcohol = action.alcohol;

  return state.copyWith(drinks: drinks);
}

//------------------------
//DELETE REDUCER
//------------------------

Reducer<AppState> _deleteReducer = combineReducers<AppState>([
  TypedReducer<AppState, DeleteDrinkAction>(_deleteDrinkReducer),
]);

AppState _deleteDrinkReducer(AppState state, DeleteDrinkAction action){
  List<Drink> drinks = state.drinks;
  drinks.removeAt(action.index);

  return state.copyWith(drinks: drinks);
}