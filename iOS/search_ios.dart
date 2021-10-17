import 'package:cupertino_list_tile/cupertino_list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hola/service/future_read.dart';

import '../model/data_model.dart';
import 'form_person_ios.dart';

class ListsViewSearchiOS extends StatefulWidget {
  const ListsViewSearchiOS({Key? key}) : super(key: key);

  @override
  State<ListsViewSearchiOS> createState() => ListsViewSearchiOSState();
}

class ListsViewSearchiOSState extends State<ListsViewSearchiOS> {
  late Future<List<Data>> _dataLists;

  late Future<List<Data>> _originalDataLists;

  late String title = "list";
  late String titleOri = "list";
  late String filteredValue = "";
  late final FocusNode _focusNode;
  // create state constructor
  @override
  void initState() {
    super.initState();
    // okay diamond in diamond weirdness

    _focusNode = FocusNode();
    _focusNode.requestFocus();
    setState(() {
      _dataLists = fetchPerson();
      _originalDataLists = _dataLists;
      titleOri = "list";
    });
  }

  Future<List<Data>> filtered(List<Data> data, String value) async {
    List<Data> filtered =
        data.where((element) => element.name.contains(value)).toList();
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    // wait wheres my button text?

    var sliverToBoxAdapter = SliverToBoxAdapter(
        child: CupertinoNavigationBar(
      middle: CupertinoSearchTextField(
        focusNode: _focusNode,
        onChanged: (String value) async {
          if (value.isEmpty) {
            setState(() {
              _dataLists = _originalDataLists;
              filteredValue = value;
            });
          } else {
            List<Data> dataAll = await _dataLists;
            setState(() {
              _dataLists = filtered(dataAll, value);
              filteredValue = value;
            });
          }
        },
      ),
      trailing: CupertinoButton(
        child: const Text('Cancel'),
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ));

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

          return CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: <Widget>[sliverToBoxAdapter, newsListSliver],
          );
        });

    var layout = CupertinoPageScaffold(child: futureBuilder);
    return layout;
  }
}
