import 'package:bierzaehler/drink_list_page.dart';
import 'package:bierzaehler/objects/viewModels/drink.dart';
import 'package:bierzaehler/objects/size.dart';
import 'package:bierzaehler/redux/app_state.dart';
import 'package:flutter/material.dart';
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
  TabController _tabController;
  int pageIndex = 0;

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
    new Tab(icon: Icon(Icons.home), text: "Getränke"),
    Tab(
      icon: Icon(Icons.settings),
      text: "Einstellungen",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, DrinkViewModel>(
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
            DrinkListPage(drinkIndex: widget.index, viewModel: viewModel,),
            Center(
              child: Text(viewModel.drink.amount.toString()),
            )
          ],
          controller: _tabController,
        ),
        floatingActionButton: (_tabController.index == 0)
            ? FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () {
                  viewModel.addSize(new Size(0.5));
                })
            : null,
      );
    });
  }
}
