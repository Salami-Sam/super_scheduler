import 'package:flutter/material.dart';

import 'password_textfield.dart';

///TODO: Coordinates between both password fields' obscurity toggling
class MultiPasswordWidget extends StatefulWidget {
  final String textLabel;
  final List<PasswordFieldWidget> passwordFields;

  MultiPasswordWidget({this.textLabel, this.passwordFields});

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
