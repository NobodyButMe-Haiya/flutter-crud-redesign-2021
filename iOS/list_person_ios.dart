import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hola/iOS/form_person_ios.dart';
import 'package:hola/iOS/list_search_ios.dart';
import 'package:hola/service/future_read.dart';

import '../model/data_model.dart';

class ListsViewiOS extends StatefulWidget {
  const ListsViewiOS({Key? key}) : super(key: key);

  @override
  State<ListsViewiOS> createState() => ListsViewiOSState();
}

class ListsViewiOSState extends State<ListsViewiOS> {
  late Future<List<Data>> _dataLists;

  late String title = "list";
  late String titleOri = "list";
  late String filteredValue = "";
  late final FocusNode _focusNode;

  // create state constructor
  @override
  void initState() {
    super.initState();
    // okay diamond in diamond weirdness
    setState(() {
      _dataLists = fetchPerson();
    });
    _focusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    // wait wheres my button text?

    var cupertinoSliverNavigationBar2 = CupertinoSliverNavigationBar(
        largeTitle: Text(title.toString()),
        trailing: Material(
            child: IconButton(
                onPressed: () {
                  Data data = Data(personId: 0, name: "", age: 0);
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => FormViewiOS(data: data)));
                },
                icon: const Icon(Icons.add))));

    var sliverToBoxAdapter2 = SliverToBoxAdapter(
        child: CupertinoNavigationBar(
            heroTag: 'listPersoniOS',
            transitionBetweenRoutes: false,
            middle: CupertinoSearchTextField(
                focusNode: _focusNode,
                onTap: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => const ListsViewSearchiOS()));
                })));

    var futureBuilder = FutureBuilder<List<Data>>(
        future: _dataLists,
        builder: (context, snapshot) {
          RenderObjectWidget newsListSliver;
          if (snapshot.hasData) {
            List<Data> dataLists = snapshot.data!;

            newsListSliver = SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  Data data = dataLists[index];

                  var container = Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 8.0),
                      child: Text(data.name),
                    ),
                  );
                  return container;
                },
                childCount: dataLists.length,
              ),
            );
          } else {
            newsListSliver = const SliverToBoxAdapter(
              child: CircularProgressIndicator(),
            );
          }

          return CustomScrollView(
            slivers: <Widget>[
              cupertinoSliverNavigationBar2,
              sliverToBoxAdapter2,
              newsListSliver
            ],
          );
        });

    var layout = CupertinoPageScaffold(child: futureBuilder);
    return layout;
  }
}
