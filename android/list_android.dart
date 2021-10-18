import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hola/android/form_android.dart';
import 'package:hola/android/search_android.dart';
import 'package:hola/service/future_read.dart';

import '../model/data_model.dart';

class ListsViewAndroid extends StatefulWidget {
  const ListsViewAndroid({Key? key}) : super(key: key);

  @override
  State<ListsViewAndroid> createState() => ListsViewAndroidState();
}

class ListsViewAndroidState extends State<ListsViewAndroid> {
  var refreshkey = GlobalKey<RefreshIndicatorState>();

  late Future<List<Data>> _dataLists;
  late String title = "test";
  // create state constructor
  @override
  void initState() {
    super.initState();
    // okay diamond in diamond weirdness
    setState(() {
      _dataLists = fetchPerson();
      title = "test 1";
    });
  }

  @override
  Widget build(BuildContext context) {
    // wait wheres my button text?
    var appBar = AppBar(
        title: Text(title),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              // since android ux separate the search with the  so ..
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ListsViewSearchAndroid()));
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              Data data = Data(personId: 0, name: "", age: 0);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FormViewAndroid(data: data)));
            },
            icon: const Icon(Icons.add),
          ),
        ]);

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
