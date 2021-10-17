import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:hola/service/future_create.dart';
import 'package:hola/service/future_delete.dart';
import 'package:hola/service/future_update.dart';

import '../model/data_model.dart';

// now we complete those dart /flutter crud .  a little basic here will help you to understand yourself
// and master it . subscribe ? like ? e aa  source code will be share.
class FormViewiOS extends StatefulWidget {
  // here is the paramater from previous View/Page/Screen ?  unsure what's can be call
  final Data data;

  const FormViewiOS({Key? key, required this.data}) : super(key: key);

  @override
  State<FormViewiOS> createState() => FormViewiOSState();
}

class FormViewiOSState extends State<FormViewiOS> {
  // this is for form

  // i do wish   as lazy    nameController,ageController = TextEditingController .. Why we need to type  again2 same thing ?
  final nameController = TextEditingController();
  final ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // some checking value initiliz ?
    if (widget.data.name.isNotEmpty) {
      nameController.text = widget.data.name;
    }
    ageController.text =
        (widget.data.age == 0) ? "" : widget.data.age.toString();

    // form field
    var nameTextField = CupertinoTextFormFieldRow(
      controller: nameController,
      placeholder: "Your name : John ",
    );
    var ageTextField = CupertinoTextFormFieldRow(
        controller: ageController,
        placeholder: "Shh shh .. 18  ",
        keyboardType: TextInputType.number);

    var deleteButton = CupertinoButton(
        color: Colors.red,
        onPressed: (widget.data.personId > 0)
            ? () => deletePerson(context, widget.data)
            : null,
        child: const Text("DELETE", style: TextStyle(color: Colors.black)));
    // end form field

    var cupertinoNavigationBar = CupertinoNavigationBar(
        middle: const Text("Form"),
        trailing: CupertinoButton(
            onPressed: () {
              // only assign if not the same
              if (widget.data.name != nameController.text) {
                widget.data.name = nameController.text;
              }
              // if you don't have calculation  you don't need int .. it's just data all string
              if (widget.data.age != int.parse(ageController.text)) {
                widget.data.age = int.parse(ageController.text);
              }
              if (widget.data.personId > 0) {
                updatePerson(context, widget.data);
              } else {
                createPerson(context, widget.data);
              }
            },
            child: const Icon(Icons.save)));

    var cupertinoFormSection = CupertinoFormSection.insetGrouped(
        header: const Text('Form Entry'),
        children: [nameTextField, ageTextField]);

    var layout = CupertinoPageScaffold(
        navigationBar: cupertinoNavigationBar,
        child: SafeArea(
            child: Column(children: [
          cupertinoFormSection,
          const SizedBox(height: 10),
          deleteButton
        ])));
    return layout;
  }
}
