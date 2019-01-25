import 'package:bierzaehler/objects/viewModels/drink.dart';
import 'package:flutter/material.dart';

class DrinkListPage extends StatelessWidget {
  final DrinkViewModel viewModel;
  final int drinkIndex;

  DrinkListPage({@required this.viewModel, @required this.drinkIndex});

  @override
  Widget build(BuildContext context) {
    if (viewModel.drink.sizes.length == 0) {
      return Center(
        child: Text("Keine Gläser vohanden!"),
      );
    } else {
      return ListView.builder(
        padding: EdgeInsets.all(8.0),
        itemCount: viewModel.drink.sizes.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            child: Center(
              child: RaisedButton(
                onPressed: () {
                  viewModel.doUseForSize(index);
                },
                child: Text(
                    viewModel.drink.sizes[index].value.toString()),
              ),
            ),
          );
        },
      );
    }
  }
}
