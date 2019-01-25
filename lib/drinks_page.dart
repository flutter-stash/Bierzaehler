import 'package:bierzaehler/drink_page.dart';
import 'package:bierzaehler/objects/viewModels/home.dart';
import 'package:bierzaehler/redux/app_state.dart';
import 'package:flutter/material.dart';

class DrinksPage extends StatelessWidget {
  final HomeViewModel viewModel;

  DrinksPage(this.viewModel);

  @override
  Widget build(BuildContext context) {
    switch (viewModel.state) {
      case DataState.LOADING:
        return Center(
          child: CircularProgressIndicator(),
        );
      case DataState.ERROR:
        return Center(
          child: Text("Es ist ein Fehler Aufgetreten!"),
        );
      case DataState.THERE:
        if (viewModel.drinks.length == 0) {
          return Center(
            child: Text("Keine Gertänke vohanden!"),
          );
        } else {
          return ListView.builder(
            padding: EdgeInsets.all(8.0),
            itemCount: viewModel.drinks.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                child: Center(
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  DrinkPage(index: index)));
                    },
                    child: Text(viewModel.drinks[index].name.toString()),
                  ),
                ),
              );
            },
          );
        }
        break;
      default:
        return Center(
          child: Text("Es ist ein Fehler Aufgetreten!"),
        );
    }
  }
}
