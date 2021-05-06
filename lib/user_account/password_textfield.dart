import 'package:flutter/material.dart';
import 'entered_user_info.dart';

///Defines a text field specifically for passwords.
///Allows user to toggle whether the password should
///be obscured or not using an eye icon in the suffix of
///the text field. [textLabel] is the label for this widget's [TextFormField],
///it's default is 'Password'. [password] must be of type [StringByReference],
///so that another [Widget] can have access to it for validation.
///[obscurePassword] specifies if the [password] should be obscured, and is type
///[BooleanByReference], so that another [PasswordFieldWidget] can share this
///value.
///@author: Rudy Fisher
class PasswordFieldWidget extends StatefulWidget {
  final String textLabel;
  final StringByReference password;
  final BooleanByReference obscurePassword;

  PasswordFieldWidget({
    this.textLabel = 'Password',
    @required this.password,
    @required this.obscurePassword,
  });

  @override
  _PasswordFieldWidgetState createState() => _PasswordFieldWidgetState();
}

class _PasswordFieldWidgetState extends State<PasswordFieldWidget> {
  ///Handler for the password's [InkWell.onTap] event.
  ///It toggles which eye is displayed, and whether the
  ///password is obscured.
  void _toggleObscurePassword() {
    setState(() {
      widget.obscurePassword.setBoolean(!widget.obscurePassword.boolean);

      getEyeSuffix();
    });
  }

  ///Sets the current suffix for this [Widget]. If [widget.obscurePassword] is
  ///true, then it will be set to [Icons.visibility_off], otherwise, it will be
  ///set to [Icons.visibility].
  Icon getEyeSuffix() {
    Icon passwordEyeSuffix = Icon(Icons.visibility_off);
    passwordEyeSuffix = widget.obscurePassword.boolean
        ? Icon(Icons.visibility_off)
        : Icon(Icons.visibility);

    return passwordEyeSuffix;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          decoration: InputDecoration(
            suffix: InkWell(
              onTap: _toggleObscurePassword,
              child: getEyeSuffix(),
            ),
            labelText: widget.textLabel,
            hintText: 'e.g. Krustykrabpi22a1sthepizz@foryou@ndme!',
          ),
          obscureText: widget.obscurePassword.boolean,
          onChanged: (value) {
            widget.password.string = value;
          },
        ),
      ],
    );
  }
}
