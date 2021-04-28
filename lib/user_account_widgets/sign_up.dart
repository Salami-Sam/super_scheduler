import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'entered_user_info.dart';
import '../password_textfield.dart';

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
  final StringByReference _email = StringByReference();
  final StringByReference _name = StringByReference();
  final StringByReference _password1 = StringByReference();
  final StringByReference _password2 = StringByReference();
  final BooleanByReference _obscurePasswords = BooleanByReference(
    boolean: false,
  );

  SignUpWidget({this.signUpButtonOnPressedCallBack});

  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  void showSnackBar({String message}) {
    SnackBar snackbar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 7),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  bool passwordsMatch() {
    if (widget._password1.string != widget._password2.string) {
      showSnackBar(message: 'Passwords don\'t match. Please re-enter.');
      return false;
    }
    return true;
  }

  bool nameIsValid() {
    if (widget._name.string.trim().isEmpty) {
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
        email: widget._email.string,
        password: widget._password1.string,
      );

      await FirebaseAuth.instance.currentUser.updateProfile(
        displayName: widget._name.string,
      );

      await userCredential.user.sendEmailVerification();
      widget.signUpButtonOnPressedCallBack();
      showSnackBar(message: 'Please check your email to finish signing up.');
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
    widget._email.string = 'fisher97@uwosh.edu';
    widget._name.string = ''; //'Spongebob Squarepants';
    widget._password1.string = 'hi@!!!';
    widget._password2.string = 'hi@!!!';

    return ChangeNotifierProvider(
      create: (context) => widget._obscurePasswords,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            initialValue: widget._name.string,
            decoration: InputDecoration(
              labelText: 'Name',
              hintText: 'e.g. Spongebob Squarepants',
            ),
            onChanged: (value) {
              widget._name.string = value;
            },
          ),
          TextFormField(
            initialValue: widget._email.string,
            decoration: InputDecoration(
              labelText: 'Email',
              hintText: 'e.g. spongebob@thekrustykrab.com',
            ),
            onChanged: (value) {
              widget._email.string = value;
            },
          ),
          Consumer<BooleanByReference>(
            builder: (context, booleanByReference, child) =>
                PasswordFieldWidget(
              password: widget._password1,
              obscurePassword: booleanByReference,
            ),
          ),
          Consumer<BooleanByReference>(
            builder: (context, booleanByReference, child) =>
                PasswordFieldWidget(
              password: widget._password1,
              obscurePassword: booleanByReference,
            ),
          ),

          /*
          PasswordFieldWidget(
            password: widget._password2,
            obscurePassword: widget._obscurePasswords,
          ),*/
          ElevatedButton(
            onPressed: () {
              if (!passwordsMatch()) return;
              if (!nameIsValid()) return;
              signUp();
            },
            child: Text('Sign Up'),
          ),
        ],
      ),
    );
  }
}