import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:super_scheduler/change_account_info.dart';
import 'package:super_scheduler/delete_account.dart';

///Defines a screen that displays the user's account info
///@author: Rudy Fisher
class MyAccountWidget extends StatefulWidget {
  final padding = 16.0;
  @override
  _MyAccountWidgetState createState() => _MyAccountWidgetState();
}

class _MyAccountWidgetState extends State<MyAccountWidget> {
  void showSnackBar({String message}) {
    SnackBar snackbar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 7),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  void _goToChangeNamePage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChangeNameWidget()),
    );
  }

  void _goToChangeEmailPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChangeEmailWidget()),
    );
  }

  void _sendChangePasswordEmail() async {
    try {
      FirebaseAuth emailSender = FirebaseAuth.instance;
      await emailSender.sendPasswordResetEmail(
        email: FirebaseAuth.instance.currentUser.email,
      );
      showSnackBar(message: 'Password reset email sent.');
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      if (e.code == 'user-not-found') {
        showSnackBar(message: 'No user found with that email.');
      } else if (e.code == 'invalid-email') {
        showSnackBar(message: 'Email is invalid.');
      }
    }
  }

  void _goToDeleteAccountPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DeleteAccountWidget()),
    );
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = TextStyle(fontSize: 24.0);
    return StreamBuilder<User>(
        stream: FirebaseAuth.instance.userChanges(),
        builder: (context, snapshot) {
          return Container(
            padding: EdgeInsets.only(
              left: widget.padding,
              right: widget.padding,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: TextFormField(
                    readOnly: true,
                    initialValue: snapshot.data
                        .displayName, // TODO: - RUDY - make this update in real time
                    decoration: InputDecoration(
                      labelText: 'Name',
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _goToChangeNamePage,
                  child: Text('Change Name'),
                ),
                Divider(),
                Center(
                  child: TextFormField(
                    readOnly: true,
                    initialValue: snapshot.data
                        .email, // TODO: - RUDY - make this update in real time
                    decoration: InputDecoration(
                      labelText: 'Email',
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _goToChangeEmailPage,
                  child: Text('Change Email'),
                ),
                Divider(),
                ElevatedButton(
                  onPressed: _sendChangePasswordEmail,
                  child: Text('Change Password'),
                ),
                Divider(),
                ElevatedButton(
                  //style: ButtonStyle(), //TODO: RUDY -- make background red
                  onPressed: _goToDeleteAccountPage,
                  child: Text('Deactivate Account'),
                ),
              ],
            ),
          );
        });
  }
}
