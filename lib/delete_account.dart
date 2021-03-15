import 'package:flutter/material.dart';

///Defines a screen that allows the user to delete/deactivate their account
///@author: Rudy Fisher
class DeleteAccountWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Deactivate Account?'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                'Are you sure you want to Deactivate your account?',
                style: TextStyle(fontSize: 32.0),
              ),
            ),
            ElevatedButton(
              onPressed: null,
              child: Text('confirm'),
            ),
          ],
        ),
      ),
    );
  }
}
