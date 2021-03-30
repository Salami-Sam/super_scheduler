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

  void _goToChangePasswordPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChangePasswordWidget()),
    );
  }

  void _goToDeleteAccountPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DeleteAccountWidget()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: RUDY -- pull user's name, email,
    // and maybe passwoard from database
    String userName = 'Spongebob Squarepants';
    String userEmail = 'spongebob@thekrustykrabs.net';
    TextStyle textStyle = TextStyle(fontSize: 24.0);
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
              initialValue: userName,
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
              initialValue: userEmail,
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
            onPressed: _goToChangePasswordPage,
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
  }
}
