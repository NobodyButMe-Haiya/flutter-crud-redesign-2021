import 'package:hola/model/data_model.dart';

class ReadModel {
  late bool success;
  late String message;
  late List<Data> data;
  ReadModel({required this.success, required this.message, required this.data});

  ReadModel.fromJson(Map<String, dynamic> json) {
    success = json["success"];
    message = json["message"];
    if (json["data"] != null) {
      data = <Data>[];
      // sometimes we don't know foreacch of ForEach for forEach .. each language kinda same
      json["data"].forEach((value) {
        data.add(Data.fromJson(value));
      });
    }
  }
}
