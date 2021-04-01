import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'entered_user_info.dart';
import 'password_textfield.dart';

///Defines the Sign In screen for the app.
///[signUpButtonOnPressedCallback] and
///[signInButtonOnPressdCallback] and
///[forgotPasswordButtonOnPressdCallback] are callbacks
///for this widget's button children's [onPressed].
///@author: Rudy Fisher
class SignInScreenWidget extends StatefulWidget {
  final Function() signUpButtonOnPressdCallback;
  final Function() signInButtonOnPressdCallback;
  final Function() forgotPasswordButtonOnPressdCallback;

  SignInScreenWidget({
    this.signUpButtonOnPressdCallback,
    this.signInButtonOnPressdCallback,
    this.forgotPasswordButtonOnPressdCallback,
  });

  @override
  _SignInScreenWidgetState createState() => _SignInScreenWidgetState();
}

///The state of the [SignInScreenWidget] widgets of this app.
///@author: Rudy Fisher
class _SignInScreenWidgetState extends State<SignInScreenWidget> {
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
          SignInWidget(
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
///@author: Rudy Fisher
class SignInWidget extends StatefulWidget {
  final Function() signInButtonOnPressdCallback;
  final StringByReference email = StringByReference();
  final StringByReference password = StringByReference();

  SignInWidget({this.signInButtonOnPressdCallback});

  @override
  _SignInWidgetState createState() => _SignInWidgetState();
}

class _SignInWidgetState extends State<SignInWidget> {
  PasswordFieldWidget passwordFieldWidget;

  void showSnackBar({String message}) {
    SnackBar snackbar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  void signIn() async {
    print('sign in');
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: widget.email.string,
        password: widget.password.string,
      );
      if (userCredential.user.emailVerified) {
        widget.signInButtonOnPressdCallback();
        showSnackBar(message: 'Welcome');
      } else {
        await FirebaseAuth.instance.currentUser.sendEmailVerification();

        showSnackBar(message: 'Please check your email for verification');
      }
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      if (e.code == 'user-not-found') {
        showSnackBar(message: 'No user found with that email');
      } else if (e.code == 'wrong-password') {
        showSnackBar(message: 'Incorrect password provided for that email');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    widget.email.string = 'mobiledevsuperscheduler@gmail.com';
    widget.password.string = '321schedule!';
    passwordFieldWidget = PasswordFieldWidget(
      password: widget.password,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          initialValue: widget.email.string,
          decoration: InputDecoration(
            labelText: 'Email',
            hintText: 'e.g. spongebob@thekrustykrab.net',
          ),
          onChanged: (value) {
            widget.email.string = value;
          },
        ),
        passwordFieldWidget,
        ElevatedButton(
          onPressed: () {
            signIn();
          },
          child: Text('Sign In'),
        ),
      ],
    );
  }
}
