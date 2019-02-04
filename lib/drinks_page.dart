import 'package:bierzaehler/drink_page.dart';
import 'package:bierzaehler/objects/viewModels/home.dart';
import 'package:bierzaehler/redux/app_state.dart';
import 'package:flutter/material.dart';

class DrinksPage extends StatelessWidget {
  final HomeViewModel viewModel;
  static const List<Color> colors = [
    const Color(0xff7b1fa2),
    const Color(0xff0091ea),
    const Color(0xfff50057),
    const Color(0xff388e3c),
    const Color(0xffff6f00),
    const Color(0xff6d4c41),
    const Color(0xff00838f),
    const Color(0xff1a237e),
    const Color(0xff558b2f),
  ];

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
            child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text("Keine Getränke vohanden!"),
                Text("Füge jetzt dein erstes Getränk hinzu!")
              ],
            ),
          );
        } else {
          return ListView.builder(
            itemCount: viewModel.drinks.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: RawMaterialButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    DrinkPage(index: index)));
                      },
                      fillColor: colors[index % 9],
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(48.0),
                      child: Text(
                        viewModel.drinks[index].name,
                        style: TextStyle(color: Color(0xffffffff)),
                      ),
                    ),
                  ));
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
