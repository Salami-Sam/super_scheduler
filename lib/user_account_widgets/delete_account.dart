import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:super_scheduler/home_widget.dart';

///Defines a screen that allows the user to delete/deactivate their account
///@author: Rudy Fisher
class DeleteAccountWidget extends StatefulWidget {
  @override
  _DeleteAccountWidgetState createState() => _DeleteAccountWidgetState();
}

class _DeleteAccountWidgetState extends State<DeleteAccountWidget> {
  void showSnackBar({String message}) {
    SnackBar snackbar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 7),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  void _deleteAccountAndReturnToSignInScreen() async {
    try {
      //TODO: -- RUDY -- remove user from users collection in Firestore
      await FirebaseAuth.instance.currentUser.delete();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => SuperSchedulerApp(),
        ),
        (route) => false,
      );
      showSnackBar(message: 'Account deleted. Sorry to see you go!');
    } on FirebaseAuthException catch (e) {
      showSnackBar(message: e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delete Account?'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                'Are you sure you want to delete your account?',
                style: TextStyle(
                  fontSize: 32.0,
                  color: Colors.redAccent,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _deleteAccountAndReturnToSignInScreen,
              child: Text('Confirm'),
            ),
          ],
        ),
      ),
    );
  }
}