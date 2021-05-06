import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:super_scheduler/user_account/change_account_info.dart';
import 'package:super_scheduler/user_account/delete_account.dart';

///Defines a screen that displays the user's account info
///@author: Rudy Fisher
class MyAccountWidget extends StatefulWidget {
  final padding = 16.0;
  final User user = FirebaseAuth.instance.currentUser;
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

  ///Navigates to the [ChangeNameWidget] screen.
  void _goToChangeNamePage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChangeNameWidget()),
    );
  }

  ///Navigates to the [ChangeEmailWidget] screen.
  void _goToChangeEmailPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChangeEmailWidget()),
    );
  }

  ///Sends a password reset email.
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

  ///Navigates to the [DeleteAccountWidget] screen.
  void _goToDeleteAccountPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DeleteAccountWidget()),
    );
  }

  ///A helper function for [build] that defines this [Widget]'s default
  ///structure.
  Widget _accountInfoPage(snapshot) {
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
              controller:
                  TextEditingController(text: snapshot.data.displayName),
              readOnly: true,
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
              controller: TextEditingController(text: snapshot.data.email),
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
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.redAccent),
            ),
            onPressed: _goToDeleteAccountPage,
            child: Text('Delete Account'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
        stream: FirebaseAuth.instance.userChanges(),
        builder: (context, snapshot) {
          print('I have been rebuilt and snapshot is $snapshot');
          if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          } else if (snapshot.hasData) {
            return _accountInfoPage(snapshot);
          } else {
            return Center(
              child:
                  Text('${snapshot.connectionState} ${snapshot.data} $context'),
            );
          }
        });
  }
}
