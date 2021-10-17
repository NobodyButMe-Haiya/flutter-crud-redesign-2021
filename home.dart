import 'package:flutter/material.dart';
import 'package:hola/detail.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // okay the next video would be the list as usuall ..  subscribe  and like ? ohh my
    var layout = Scaffold(
        appBar: AppBar(title: const Text("Home")),
        body: Center(
            child: TextButton(
                child: const Text("Click me to detail"),
                onPressed: () {
                  // they just give error but .....
                  // yeah our nest getting weirdo .. just for simple hello world
                  // we continue again..  and we will create new file for list , 2 new folder model and service .
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => const Detail(),
                    ),
                  );
                })));
    return layout;
  }
}
