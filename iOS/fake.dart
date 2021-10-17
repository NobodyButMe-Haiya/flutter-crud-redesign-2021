import 'package:flutter/cupertino.dart';

class Fake extends StatefulWidget {
  const Fake({Key? key}) : super(key: key);

  @override
  State<Fake> createState() => FakeState();
}

class FakeState extends State<Fake> {
  @override
  Widget build(BuildContext context) {
    var layout = const CupertinoPageScaffold(child: Text("idiot"));
    return layout;
  }
}
