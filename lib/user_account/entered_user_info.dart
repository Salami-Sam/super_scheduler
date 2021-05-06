import 'package:flutter/material.dart';

///This file contains a few small classes that are used by [SignIn] and
///[SignUp] [Widget]s to handle user input.

///Wraps a [String] into a reference type data structure. Its [string] field
///is never null.
///@author Rudy Fisher
class StringByReference extends Object {
  String string = '';
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
