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
]);

//------------------------
//ADD REDUCER
//------------------------

Reducer<AppState> _addReducer = combineReducers<AppState>([
  new TypedReducer<AppState, AddSizeToDrinkAction>(_addSizeToDrinkReducer),
  new TypedReducer<AppState, AddDrinkAction>(_addDrinkReducer),
]);

AppState _addDrinkReducer(AppState state, AddDrinkAction action){
  List<Drink> drinks = new List<Drink>.from(state.drinks);
  drinks.add(action.drink);
  return state.copyWith(drinks: drinks);
}

AppState _addSizeToDrinkReducer(AppState state, AddSizeToDrinkAction action){
  List<Drink> drinks= state.drinks;
  drinks[action.drinkIndex].addSize(action.size);
  return state.copyWith(drinks: drinks);
}
