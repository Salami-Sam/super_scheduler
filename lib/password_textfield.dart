import 'package:flutter/material.dart';

///Defines a text field specifically for passwords.
///Allows user to toggle whether the password should
///be obscured or not using an eye icon in the suffix of
///the text field.
class PasswordFieldWidget extends StatefulWidget {
  @override
  _PasswordFieldWidgetState createState() => _PasswordFieldWidgetState();
}

class _PasswordFieldWidgetState extends State<PasswordFieldWidget> {
  bool _obscurePassword = true;
  Icon passwordEyeSuffix = Icon(Icons.visibility_off);

  ///Handler for the password's [InkWell.onTap] event.
  ///It toggles which eye is displayed, and whether the
  ///password is obscured.
  void _toggleObscurePassword() {
    setState(() {
      _obscurePassword = !_obscurePassword;

      passwordEyeSuffix = _obscurePassword
          ? Icon(Icons.visibility_off)
          : Icon(Icons.visibility);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          decoration: InputDecoration(
            suffix: InkWell(
              onTap: _toggleObscurePassword,
              child: passwordEyeSuffix,
            ),
            labelText: 'Password',
            hintText: 'e.g. Krustykrabpi22a1sthepizz@foryou@ndme',
          ),
          obscureText: _obscurePassword,
          validator: (value) {
            if (value.isNotEmpty) {
              // TODO: return a string to somewhere
            }
            return null;
          },
        ),
      ],
    );
  }
}