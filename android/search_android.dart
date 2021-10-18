import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hola/android/form_android.dart';
import 'package:hola/service/future_read.dart';

import '../model/data_model.dart';

class ListsViewSearchAndroid extends StatefulWidget {
  const ListsViewSearchAndroid({Key? key}) : super(key: key);

  @override
  State<ListsViewSearchAndroid> createState() => ListsViewSearchAndroidState();
}

class ListsViewSearchAndroidState extends State<ListsViewSearchAndroid> {
  var refreshkey = GlobalKey<RefreshIndicatorState>();

  late Future<List<Data>> _dataLists;

  late Future<List<Data>> _originalDataLists;

  var queryTextController = TextEditingController();

  // create state constructor
  @override
  void initState() {
    super.initState();
    // okay diamond in diamond weirdness
    setState(() {
      _dataLists = fetchPerson();
      _originalDataLists = _dataLists;
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

    var appBar = AppBar(
      title: TextField(
        controller: queryTextController,
        onChanged: (String value) async {
          if (value.isEmpty) {
            setState(() {
              _dataLists = _originalDataLists;
            });
          } else {
            List<Data> dataAll = await _dataLists;
            setState(() {
              _dataLists = filtered(dataAll, value);
            });
          }
        },
        textInputAction: TextInputAction.search,
        cursorColor: Colors.white,
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          hintText: "Search",
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          labelStyle: TextStyle(color: Colors.white),
          focusColor: Colors.white,
        ),
      ),
    );
    var futureBuilder = FutureBuilder<List<Data>>(
        future: _dataLists,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
          } else if (snapshot.hasError) {
            return const Text(
                "Error lol. check .. this seem weird give eror  ");
          } else {
            List<Data> dataLists = snapshot.data!;

            var listViewBuilder = ListView.builder(
                itemCount: dataLists.length,
                itemBuilder: (context, index) {
                  Data data = dataLists[index];
                  var listsTitle = ListTile(
                    title: Text(data.name),
                    subtitle: Text(data.age.toString()),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  FormViewAndroid(data: data)));
                    },
                  );
                  return listsTitle;
                });

            return Scrollbar(
                child: RefreshIndicator(
                    child: listViewBuilder,
                    onRefresh: () async {
                      refreshkey.currentState?.show(
                          atTop:
                              true); // change atTop to false to show progress indicator at bottom
                      await Future.delayed(const Duration(seconds: 2));

                      setState(() {
                        _dataLists = fetchPerson();
                      });
                    }));
          }
          // as flutter requested .. we just do it
          return const CircularProgressIndicator();
        });
    var layout = Scaffold(
        appBar: appBar,
        body: Center(
          child: futureBuilder,
        ));
    return layout;
  }
}
