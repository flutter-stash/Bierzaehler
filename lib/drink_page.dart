import 'package:bierzaehler/drink_data_page.dart';
import 'package:bierzaehler/drink_list_page.dart';
import 'package:bierzaehler/my_flutter_app_icons.dart';
import 'package:bierzaehler/objects/size.dart';
import 'package:bierzaehler/objects/viewModels/drink.dart';
import 'package:bierzaehler/redux/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class DrinkPage extends StatefulWidget {
  final int index;

  DrinkPage({@required this.index});

  @override
  DrinkPageState createState() {
    return new DrinkPageState();
  }
}

class DrinkPageState extends State<DrinkPage>
    with SingleTickerProviderStateMixin {
  TextEditingController _controller = new TextEditingController();
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  TabController _tabController;
  int pageIndex = 0;
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

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: _tabs.length);
    _tabController.addListener(() {
      setState(() {
        pageIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(() {
      setState(() {
        pageIndex = _tabController.index;
      });
    });
    _tabController.dispose();

    super.dispose();
  }

  final List<Tab> _tabs = <Tab>[
    new Tab(icon: Icon(MyFlutterApp.bier_icon), text: "Getränke"),
    Tab(
      icon: Icon(MyFlutterApp.statistics),
      text: "Statistiken",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    ThemeData t = Theme.of(context);

    return Theme(
        data: t.copyWith(
            primaryColor: colors[widget.index % colors.length],
            accentColor: colors[(widget.index + 1) % colors.length]),
        child: StoreConnector<AppState, DrinkViewModel>(
            converter: (Store<AppState> store) {
          return DrinkViewModel.create(store, widget.index);
        }, builder: (BuildContext context, DrinkViewModel viewModel) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Bierzähler"),
              bottom: TabBar(
                tabs: _tabs,
                controller: _tabController,
              ),
            ),
            body: TabBarView(
              children: <Widget>[
                DrinkListPage(
                  drinkIndex: widget.index,
                  viewModel: viewModel,
                ),
                DrinkDataPage(viewModel: viewModel),
              ],
              controller: _tabController,
            ),
            floatingActionButton: (_tabController.index == 0)
                ? FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {

                            return new Dialog(
                                child: Container(
                              padding: EdgeInsets.all(16.0),
                              child: SingleChildScrollView(
                                  child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Größe hinzufügen",
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 16.0),
                                  ),
                                  Form(
                                    key: formKey,
                                    child: TextFormField(
                                      controller: _controller,
                                      decoration: InputDecoration(
                                        hintText: "Größe in Litern",
                                        labelText: "Größe",
                                      ),
                                      autofocus: true,
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                        decimal: true,
                                      ),
                                      validator: (input) {
                                        if (input.length == 0)
                                          return 'Bitte gib hier die Größe ein!';
                                        return double.tryParse(input) == null
                                            ? 'Bitte benutze den Punkt anstatt des Kommas!'
                                            : null;
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 16.0),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      FlatButton(
                                        child: Text("ABBRECHEN"),
                                        textColor: colors[
                                            widget.index % colors.length],
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                      ),
                                      RaisedButton(
                                        child: Text("OK"),
                                        color: colors[
                                            widget.index % colors.length],
                                        textColor: Colors.white,
                                        onPressed: () {
                                          if (formKey.currentState.validate()) {
                                            viewModel.addSize(new Size(
                                                double.parse(
                                                    _controller.text)));
                                            _controller.text = "";
                                            Navigator.of(context).pop();
                                          }
                                        },
                                      ),
                                    ],
                                  )
                                ],
                              )),
                            ));
                          });
                      //viewModel.addSize(new Size(0.5));
                    })
                : null,
          );
        }));
  }
}
