import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'dart:io' show Platform;

import 'package:hola/iOS/list_person_ios.dart';
import 'package:hola/android/list_android.dart';

void main(List<String> args) {
  // we need some classes first
  if (Platform.isAndroid) {
    runApp(const MaterialApp(home: ListsViewAndroid()));
  } else {
    // runApp(const CupertinoApp(home: ListsViewiOS()));
    runApp(const CupertinoApp(home: ListsViewiOS()));
  }
}
