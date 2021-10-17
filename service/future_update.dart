import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hola/model/data_model.dart';
import 'dart:developer' as logger;

Future<List<Data>> updatePerson(BuildContext context, Data data) async {
  List<Data> dataLists = <Data>[];
  try {
    // don't forget to use ip  not localhost
    var url = "http://192.168.0.154/php_tutorial/api.php";
    // the more proper and cleaner separete it all
    var formData = FormData.fromMap({
      'mode': 'update',
      'name': data.name,
      'age': data.age,
      'personId': data.personId
    });
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
        // send back to the page
        Navigator.pop(context);
      }
    } else {
      logger.log("something wrong network connection");
    }
  } catch (e) {
    logger.log(e.toString());
  }
  return dataLists;
}
