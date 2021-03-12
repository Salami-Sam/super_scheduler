import 'package:flutter/material.dart';

import 'password_textfield.dart';

///TODO: Coordinates between both password fields' obscurity toggling
class DoublePasswordWidget extends StatefulWidget {
  final List<PasswordFieldWidget> passwordFields = [
    PasswordFieldWidget(),
    PasswordFieldWidget(),
  ];

  @override
  _DoublePasswordWidgetState createState() => _DoublePasswordWidgetState();
}

class _DoublePasswordWidgetState extends State<DoublePasswordWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.passwordFields,
    );
  }
}
