// we will use dio because formdata not support by default
//  dart pub add dio

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:hola/model/data_model.dart';
import 'package:hola/model/read_model.dart';
// but we don't want to see those annoyance underline,
import 'dart:developer' as logger;

Future<List<Data>> fetchPerson() async {
  List<Data> dataLists = <Data>[];
  try {
    // don't forget to use ip  not localhost
    var url = "http://192.168.0.154/php_tutorial/api.php";
    // the more proper and cleaner separete it all
    var formData = FormData.fromMap({'mode': 'read'});
    var options = Options(contentType: Headers.formUrlEncodedContentType);
    var response = await Dio().post(url, data: formData, options: options);
    if (response.statusCode == 200) {
      // okay no error
      var body = response.data;
      // wee need to check the respond what is it
      logger.log(body);

      if (body.contains("false")) {
        logger.log("something wrong.. ");
      } else {
        // okay we continue
        // but are we sure got data ?
        // seem cannot null check
        var data = ReadModel.fromJson(jsonDecode(body)).data;
        if (data.isNotEmpty) {
          dataLists = data.toList();
        }
      }
    } else {
      logger.log("something wrong network connection");
    }
  } catch (e) {
    logger.log(e.toString());
  }
  return dataLists;
}
