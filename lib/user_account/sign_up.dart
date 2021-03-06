import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'entered_user_info.dart';
import 'password_textfield.dart';

///Defines a screen for the user to sign up for an account with the app.
///[signUpButtonCallBack] is the function called when user tries to sign up.
///[signInButtonCallBack] is the function that should navigate the user
///back to the [SignIn] screen. Both of these functions should navigate to
///another screen.
///@author: Rudy Fisher
class SignUpScreenWidget extends StatefulWidget {
  final Function() signUpButtonCallBack;
  final Function() signInButtonCallBack;

  SignUpScreenWidget({
    @required this.signUpButtonCallBack,
    @required this.signInButtonCallBack,
  });

  @override
  _SignUpScreenWidgetState createState() => _SignUpScreenWidgetState();
}

class _SignUpScreenWidgetState extends State<SignUpScreenWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 900.0,
      margin: EdgeInsets.only(
        left: 16,
        right: 16,
      ),
      child: ListView(
        children: [
          SignUpWidget(
            signUpButtonOnPressedCallBack: widget.signUpButtonCallBack,
          ),
          ElevatedButton(
            child: Text('Back to Sign In'),
            onPressed: widget.signInButtonCallBack,
          ),
          Divider(
            height: 24,
          ),
          Text(
            'Password requirements:\n\t1. At least 6 characters long.\n' +
                '\nNote: Password requirements determined by Google.',
            style: TextStyle(fontSize: 16),
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
    boolean: true,
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

  ///Tests if the passwords match. If so, returns true, otherwise false.
  bool passwordsMatch() {
    if (widget._password1.string != widget._password2.string) {
      showSnackBar(message: 'Passwords don\'t match. Please re-enter.');
      return false;
    }
    return true;
  }

  ///Tests if the entered name is valid (basically, non-empty after trimming
  ///white space). If so, returns true, otherwise false.
  bool nameIsValid() {
    if (widget._name.string.trim().isEmpty) {
      showSnackBar(
          message: 'Please enter your name. Alphabetical characters are' +
              ' preferred, but feel free to get crazy with it ;)');
      return false;
    }
    return true;
  }

  ///Attempts to sign the user up for an account. If successful, they are taken
  ///to the [SignIn] screen and an email is sent for confirmation. If not
  ///successful, they are given an appropriate error message.
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
        showSnackBar(
            message: 'The password provided is too weak. ${e.message}');
      } else if (e.code == 'email-already-in-use') {
        showSnackBar(message: 'The account already exists for that email.');
      } else if (e.code == 'invalid-email') {
        showSnackBar(message: 'Email is invalid.');
      } else {
        showSnackBar(message: e.code + '\n' + e.message);
      }
    } catch (e) {
      showSnackBar(message: e.code + '\n' + e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => widget._obscurePasswords,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Name',
              hintText: 'e.g. Spongebob Squarepants',
            ),
            onChanged: (value) {
              widget._name.string = value;
            },
          ),
          TextFormField(
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
              password: widget._password2,
              obscurePassword: booleanByReference,
            ),
          ),
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
