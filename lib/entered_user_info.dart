import 'package:flutter/material.dart';

///Wraps a [String] into a reference type data structure.
///@author Rudy Fisher
class StringByReference {
  String string = '321schedule!';
}

///Wraps a [bool] into a reference type data structure. Its default
///is [false].
///@author Rudy Fisher
class BooleanByReference extends ChangeNotifier {
  bool boolean;

  BooleanByReference({this.boolean = false});

  ///Use this method to set this class's [boolean] field
  ///if widgets are listening.
  void setBoolean(bool value) {
    boolean = value;
    notifyListeners();
  }
}
