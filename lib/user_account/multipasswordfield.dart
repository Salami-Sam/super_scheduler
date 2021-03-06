import 'package:flutter/material.dart';
import 'password_textfield.dart';

///Defines a widget that encapsulates multiple password fields
///Note: this [Widget] is currently not used.
///@author: Rudy Fisher
class MultiPasswordWidget extends StatefulWidget {
  final List<PasswordFieldWidget> passwordFields;

  MultiPasswordWidget({this.passwordFields});

  @override
  _MultiPasswordWidgetState createState() => _MultiPasswordWidgetState();
}

class _MultiPasswordWidgetState extends State<MultiPasswordWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.passwordFields,
    );
  }
}
