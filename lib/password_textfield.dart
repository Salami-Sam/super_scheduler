import 'package:flutter/material.dart';
import 'entered_user_info.dart';

///Defines a text field specifically for passwords.
///Allows user to toggle whether the password should
///be obscured or not using an eye icon in the suffix of
///the text field.
///@author: Rudy Fisher
class PasswordFieldWidget extends StatefulWidget {
  final String textLabel;
  final StringByReference password;

  PasswordFieldWidget({this.textLabel = 'Password', this.password});

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
          initialValue: widget.password.string,
          decoration: InputDecoration(
            suffix: InkWell(
              onTap: _toggleObscurePassword,
              child: passwordEyeSuffix,
            ),
            labelText: widget.textLabel,
            hintText: 'e.g. Krustykrabpi22a1sthepizz@foryou@ndme',
          ),
          obscureText: _obscurePassword,
          onChanged: (value) {
            widget.password.string = value;
          },
        ),
      ],
    );
  }
}
