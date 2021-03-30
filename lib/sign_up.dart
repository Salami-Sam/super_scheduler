import 'package:flutter/material.dart';
import 'password_textfield.dart';

///Defines a screen for the user to sign up for an account with the app
///@author: Rudy Fisher
class SignUpWidget extends StatefulWidget {
  final Function() signUpButtonCallBack;
  final Function() signInButtonCallBack;

  SignUpWidget({
    this.signUpButtonCallBack,
    this.signInButtonCallBack,
  });

  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
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
          SignUpFormWidget(
              signUpButtonOnPressedCallBack: widget.signUpButtonCallBack),
          ElevatedButton(
            child: Text('Sign In'),
            onPressed: widget.signInButtonCallBack,
          ),
        ],
      ),
    );
  }
}

///Defines a form for the user to sign up/make an account
///with the app.
///@author: Rudy Fisher
class SignUpFormWidget extends StatefulWidget {
  final _formKey = GlobalKey<FormState>();
  final Function() signUpButtonOnPressedCallBack;

  SignUpFormWidget({this.signUpButtonOnPressedCallBack});

  @override
  _SignUpFormWidgetState createState() => _SignUpFormWidgetState();
}

class _SignUpFormWidgetState extends State<SignUpFormWidget> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget._formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Name',
              hintText: 'e.g. Spongebob Squarepants',
            ),
            validator: (value) {
              if (value.isNotEmpty) {
                // TODO: RUDY -- return a string to somewhere
              }
              return null;
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Email',
              hintText: 'e.g. spongebob@thekrustykrab.com',
            ),
            validator: (value) {
              if (value.isNotEmpty) {
                // TODO: RUDY -- return a string to somewhere
              }
              return null;
            },
          ),
          PasswordFieldWidget(),
          PasswordFieldWidget(),
          ElevatedButton(
            onPressed: widget.signUpButtonOnPressedCallBack,
            child: Text('Sign Up'),
          ),
        ],
      ),
    );
  }
}
