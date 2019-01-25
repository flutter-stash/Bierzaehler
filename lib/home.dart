import 'package:bierzaehler/drinks_page.dart';
import 'package:bierzaehler/objects/drink.dart';
import 'package:bierzaehler/objects/size.dart';
import 'package:bierzaehler/objects/use.dart';
import 'package:bierzaehler/objects/viewModels/home.dart';
import 'package:bierzaehler/redux/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, HomeViewModel>(
        converter: (Store<AppState> store) {
      return HomeViewModel.create(store);
    }, builder: (BuildContext context, HomeViewModel viewModel) {
      if (viewModel.state == DataState.LOADING) {
        viewModel.getData();
      }
      return Scaffold(
          appBar: AppBar(
            title: Text("Bierzähler"),
          ),
          body: DrinksPage(viewModel),
          floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                List<Use> uses = new List<Use>();
                uses.add(new Use(new Size(0.33), microsecondsSinceEpoch: 0));
                List<Size> sizes = new List<Size>();
                sizes.add(new Size(0.33));
                viewModel.addDrink(new Drink("Bier", 4.9, sizes, uses));
              }));
    });
  }
}
