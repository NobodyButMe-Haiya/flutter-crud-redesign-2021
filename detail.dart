import 'package:flutter/material.dart';

class Detail extends StatelessWidget {
  const Detail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // so we want click from home to dart but how ?
    // weird change a bit const weird error
    var layout = Scaffold(
        appBar: AppBar(title: const Text("Detail")),
        body: const Center(
            child: Text(
                "I'm detail.. yes basic navigation.. but i need some bar above")));
    return layout;
  }
}
