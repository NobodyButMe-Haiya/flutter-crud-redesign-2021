import 'package:cupertino_list_tile/cupertino_list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hola/iOS/form_person_ios.dart';
import 'package:hola/iOS/list_search_ios.dart';
import 'package:hola/service/future_read.dart';

import '../model/data_model.dart';
import 'dart:developer' as logger;

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

  // create state constructor
  @override
  void initState() {
    super.initState();
    // okay diamond in diamond weirdness
    setState(() {
      _dataLists = fetchPerson();
    });
  }

  @override
  Widget build(BuildContext context) {
    // wait wheres my button text?

    var cupertinoSliverNavigationBar = CupertinoSliverNavigationBar(
        largeTitle: Text(title.toString()),
        trailing: Row(mainAxisSize: MainAxisSize.min, children: [
          CupertinoButton(
              onPressed: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => const ListsViewSearchiOS()));
              },
              child: const Icon(CupertinoIcons.search)),
          CupertinoButton(
              onPressed: () {
                Data data = Data(personId: 0, name: "", age: 0);
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => FormViewiOS(data: data)));
              },
              child: const Icon(CupertinoIcons.add))
        ]));

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

                  var cupertinoListTile = CupertinoListTile(
                    title: Text(data.name),
                    subtitle: Text(data.age.toString()),
                    onTap: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => FormViewiOS(data: data)));
                    },
                  );

                  return cupertinoListTile;
                },
                childCount: dataLists.length,
              ),
            );
          } else {
            newsListSliver = const SliverToBoxAdapter(
              child: CircularProgressIndicator(),
            );
          }
          var cupertinoSliverRefreshControl = CupertinoSliverRefreshControl(
            refreshTriggerPullDistance: 100.0,
            refreshIndicatorExtent: 60.0,
            onRefresh: () {
              return Future<void>.delayed(const Duration(seconds: 1))
                ..then<void>((_) {
                  // check mounted or not
                  if (mounted) {
                    logger.log("mounted");
                  } else {
                    logger.log("unmounted");
                  }
                  setState(() {
                    _dataLists = fetchPerson();
                  });
                  logger.log("should be refresh");
                });
            },
          );

          return CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: <Widget>[
              cupertinoSliverNavigationBar,
              cupertinoSliverRefreshControl,
              newsListSliver
            ],
          );
        });

    var layout = CupertinoPageScaffold(child: futureBuilder);
    return layout;
  }
}
