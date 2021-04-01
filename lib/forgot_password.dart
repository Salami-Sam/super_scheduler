import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

///Defines a screen that allows the user to request a temporary password
///be sent to the provided email when they forgot their password
///@author: Rudy Fisher
class ForgotPasswordWidget extends StatefulWidget {
  @override
  _ForgotPasswordWidgetState createState() => _ForgotPasswordWidgetState();
}

class _ForgotPasswordWidgetState extends State<ForgotPasswordWidget> {
  String email = 'mobiledevsuperscheduler@gmail.com';

  void showSnackBar({String message}) {
    SnackBar snackbar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  void sendPasswordResetEmail() {
    try {
      FirebaseAuth emailSender = FirebaseAuth.instance;
      emailSender.sendPasswordResetEmail(email: email);
      showSnackBar(message: 'Password reset email sent to $email');
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      if (e.code == 'user-not-found') {
        showSnackBar(message: 'No user found with that email.');
      } else if (e.code == 'invalid-email') {
        showSnackBar(message: 'Email is invalid.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              initialValue: email,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'e.g. spongebob@thekrustykrab.com',
              ),
              onChanged: (value) {
                email = value;
              },
            ),
            ElevatedButton(
              onPressed: () {
                sendPasswordResetEmail();
              },
              child: Text('Send Password Reset Email'),
            ),
          ],
        ),
      ),
    );
  }
}
