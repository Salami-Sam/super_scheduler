import 'package:flutter/material.dart';

import 'password_textfield.dart';

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
