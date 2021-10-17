import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:hola/service/future_create.dart';
import 'package:hola/service/future_delete.dart';
import 'package:hola/service/future_update.dart';

import '../model/data_model.dart';

// now we complete those dart /flutter crud .  a little basic here will help you to understand yourself
// and master it . subscribe ? like ? e aa  source code will be share.
class FormViewAndroid extends StatefulWidget {
  // here is the paramater from previous View/Page/Screen ?  unsure what's can be call
  final Data data;

  const FormViewAndroid({Key? key, required this.data}) : super(key: key);

  @override
  State<FormViewAndroid> createState() => FormViewAndroidState();
}

class FormViewAndroidState extends State<FormViewAndroid> {
  // this is for form
  final _formKey = GlobalKey<FormState>();

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

    // as lazy don't want nested separated it
    var appBar = AppBar(title: const Text("Form"), actions: [
      TextButton(
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
          child: const Text("Save", style: TextStyle(color: Colors.white)))
    ]);

    // form field
    var nameTextField = TextField(
        decoration:
            const InputDecoration(labelText: "Name", hintText: "Your name la"),
        controller: nameController);
    var ageTextField = TextField(
        decoration:
            const InputDecoration(labelText: "Age", hintText: "Shh shh .. "),
        controller: ageController,
        keyboardType: TextInputType.number);

    var deleteButton = ElevatedButton(
        onPressed: (widget.data.personId > 0)
            ? () => deletePerson(context, widget.data)
            : null,
        child: const Text("delete"));
    // end form field

    var form = Form(
        key: _formKey,
        child: Column(children: [
          nameTextField,
          ageTextField,
          const SizedBox(height: 10),
          deleteButton
        ]));

    var layout = Scaffold(
        appBar: appBar,
        body: Padding(padding: const EdgeInsets.all(10), child: form));
    return layout;
  }
}
