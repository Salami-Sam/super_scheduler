import 'package:flutter/material.dart';

class MyAccountWidget extends StatefulWidget {
  final padding = 16.0;
  @override
  _MyAccountWidgetState createState() => _MyAccountWidgetState();
}

class _MyAccountWidgetState extends State<MyAccountWidget> {
  @override
  Widget build(BuildContext context) {
    // TODO: pull user's name, email,
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
            onPressed: null,
            child: Text('Change Name'),
          ),
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
            onPressed: null,
            child: Text('Change Email'),
          ),
          Divider(),
          ElevatedButton(
            onPressed: null,
            child: Text('Change Password'),
          ),
          ElevatedButton(
            //style: ButtonStyle(), //TODO: make background red
            onPressed: null,
            child: Text('Deactivate Account'),
          ),
        ],
      ),
    );
  }
}
