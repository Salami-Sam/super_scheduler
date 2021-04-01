import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'entered_user_info.dart';
import 'password_textfield.dart';

///Defines a screen for the user to sign up for an account with the app
///@author: Rudy Fisher
class SignUpScreenWidget extends StatefulWidget {
  final Function() signUpButtonCallBack;
  final Function() signInButtonCallBack;

  SignUpScreenWidget({
    this.signUpButtonCallBack,
    this.signInButtonCallBack,
  });

  @override
  _SignUpScreenWidgetState createState() => _SignUpScreenWidgetState();
}

class _SignUpScreenWidgetState extends State<SignUpScreenWidget> {
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
          SignUpWidget(
              signUpButtonOnPressedCallBack: widget.signUpButtonCallBack),
          ElevatedButton(
            child: Text('Back to Sign In'),
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
class SignUpWidget extends StatefulWidget {
  final Function() signUpButtonOnPressedCallBack;
  final StringByReference email = StringByReference();
  final StringByReference name = StringByReference();
  final StringByReference password1 = StringByReference();
  final StringByReference password2 = StringByReference();

  SignUpWidget({this.signUpButtonOnPressedCallBack});

  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  void showSnackBar({String message}) {
    SnackBar snackbar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  bool passwordsMatch() {
    if (widget.password1.string != widget.password2.string) {
      showSnackBar(message: 'Passwords don\'t match. Please re-enter.');
      return false;
    }
    return true;
  }

  bool nameIsValid() {
    if (widget.name.string.trim().isEmpty) {
      showSnackBar(
          message:
              'Please enter your name. Alphabet characters are preferred, but feel free to get crazy with it ;)');
      return false;
    }
    return true;
  }

  void signUp() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: widget.email.string,
        password: widget.password1.string,
      );

      await userCredential.user.sendEmailVerification();
      widget.signUpButtonOnPressedCallBack();
      showSnackBar(message: 'Please check your email to finish signing up.');
      // TODO: RUDY -- Save user's name into database and initialize a user as a document
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showSnackBar(message: 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        showSnackBar(message: 'The account already exists for that email.');
      } else if (e.code == 'invalid-email') {
        showSnackBar(message: 'Email is invalid.');
      } else {
        showSnackBar(message: e.code + '\n' + e.message);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    widget.email.string = 'fisher97@uwosh.edu';
    widget.name.string = ''; //'Spongebob Squarepants';
    widget.password1.string = 'hi@!!!';
    widget.password2.string = 'hi@!!!';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          initialValue: widget.name.string,
          decoration: InputDecoration(
            labelText: 'Name',
            hintText: 'e.g. Spongebob Squarepants',
          ),
          onChanged: (value) {
            widget.name.string = value;
          },
        ),
        TextFormField(
          initialValue: widget.email.string,
          decoration: InputDecoration(
            labelText: 'Email',
            hintText: 'e.g. spongebob@thekrustykrab.com',
          ),
          onChanged: (value) {
            widget.email.string = value;
          },
        ),
        PasswordFieldWidget(password: widget.password1),
        PasswordFieldWidget(password: widget.password2),
        ElevatedButton(
          onPressed: () {
            if (!passwordsMatch()) return;
            if (!nameIsValid()) return;
            signUp();
          },
          child: Text('Sign Up'),
        ),
      ],
    );
  }
}
