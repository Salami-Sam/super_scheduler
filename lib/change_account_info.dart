import 'package:flutter/material.dart';
import 'package:super_scheduler/multipasswordfield.dart';
import 'package:super_scheduler/password_textfield.dart';

///Defines a screen that allows the user to change their name
///@author: Rudy Fisher
class ChangeNameWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Name'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'New Name',
                ),
              ),
              ElevatedButton(
                onPressed: null,
                child: Text('Confirm'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

///Defines a screen that allows the user to change their email
///@author: Rudy Fisher
class ChangeEmailWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Email'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'New Email',
                ),
              ),
              ElevatedButton(
                onPressed: null,
                child: Text('Confirm'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

///Defines a screen that allows the user to change their password
///@author: Rudy Fisher
class ChangePasswordWidget extends StatelessWidget {
  final String textLabel = 'New Password';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MultiPasswordWidget(
                passwordFields: [
                  PasswordFieldWidget(textLabel: textLabel),
                  PasswordFieldWidget(textLabel: textLabel),
                ],
              ),
              ElevatedButton(
                onPressed: null,
                child: Text('confirm'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
