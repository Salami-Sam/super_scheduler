import 'package:flutter/material.dart';

///Defines the Sign In screen for the app.
///[signUpButtonOnPressedCallback] and
///[signInButtonOnPressdCallback] and
///[forgotPasswordButtonOnPressdCallback] are callbacks
///for this widget's button children's [onPressed].
class SignInWidget extends StatefulWidget {
  final Function() signUpButtonOnPressdCallback;
  final Function() signInButtonOnPressdCallback;
  final Function() forgotPasswordButtonOnPressdCallback;

  SignInWidget({
    this.signUpButtonOnPressdCallback,
    this.signInButtonOnPressdCallback,
    this.forgotPasswordButtonOnPressdCallback,
  });

  @override
  _SignInWidgetState createState() => _SignInWidgetState();
}

///The state of the [SignInWidget] widgets of this app.
class _SignInWidgetState extends State<SignInWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: 16,
        right: 16,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SignInFormWidget(
            signInButtonOnPressdCallback: widget.signInButtonOnPressdCallback,
          ),
          ElevatedButton(
            child: Text('Sign Up'),
            onPressed: widget.signUpButtonOnPressdCallback,
          ),
          ElevatedButton(
            child: Text('Forgot Password'),
            onPressed: widget.forgotPasswordButtonOnPressdCallback,
          ),
        ],
      ),
    );
  }
}

///Defines a form for the user to sign in to their account.
class SignInFormWidget extends StatefulWidget {
  final _formKey = GlobalKey<FormState>();
  // ignore: non_constant_identifier_names
  final Function() signInButtonOnPressdCallback;

  SignInFormWidget({this.signInButtonOnPressdCallback});

  @override
  _SignInFormWidgetState createState() => _SignInFormWidgetState();
}

class _SignInFormWidgetState extends State<SignInFormWidget> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget._formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Email',
              hintText: 'e.g. spongebob@thekrustykrab.com',
            ),
            validator: (value) {
              if (value.isNotEmpty) {
                // TODO: return a string to somewhere
              }
              return null;
            },
          ),
          PasswordFieldWidget(),
          ElevatedButton(
            onPressed: widget.signInButtonOnPressdCallback,
            child: Text('Sign In'),
          ),
        ],
      ),
    );
  }
}

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
