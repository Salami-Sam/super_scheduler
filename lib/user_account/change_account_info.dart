import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

///This file contains a few small [Widget]s that define screens for the user
///to change their account information.

///Defines a screen that allows the user to change their name
///@author: Rudy Fisher
class ChangeNameWidget extends StatefulWidget {
  @override
  _ChangeNameWidgetState createState() => _ChangeNameWidgetState();
}

class _ChangeNameWidgetState extends State<ChangeNameWidget> {
  String _name = FirebaseAuth.instance.currentUser.displayName;

  void showSnackBar({String message}) {
    SnackBar snackbar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 7),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  ///Attempts to change the user's [displayName].
  void _changeUserName() async {
    try {
      User user = FirebaseAuth.instance.currentUser;
      await user.updateProfile(displayName: _name);

      DocumentReference docRef = FirebaseFirestore.instance
          .collection(
            'users',
          )
          .doc(
            '${FirebaseAuth.instance.currentUser.uid}',
          );
      await docRef.update({'displayName': _name});

      Navigator.pop(context);
      showSnackBar(message: 'Name updated to \'$_name\' successfully.');
    } on FirebaseAuthException catch (e) {
      showSnackBar(message: e.code + '\n' + e.message);
    } catch (e) {
      showSnackBar(message: e.code + '\n' + e.message);
    }
  }

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
                onChanged: (value) => _name = value,
                decoration: InputDecoration(
                  labelText: 'New Name',
                ),
              ),
              ElevatedButton(
                onPressed: _changeUserName,
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
class ChangeEmailWidget extends StatefulWidget {
  @override
  _ChangeEmailWidgetState createState() => _ChangeEmailWidgetState();
}

class _ChangeEmailWidgetState extends State<ChangeEmailWidget> {
  String _email = FirebaseAuth.instance.currentUser.email;

  void showSnackBar({String message}) {
    SnackBar snackbar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 7),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  ///Attempts to change the user's [email].
  void _changeEmail() async {
    try {
      await FirebaseAuth.instance.currentUser.updateEmail(_email);

      Navigator.pop(context);
      showSnackBar(message: 'Email updated successfully.');
    } on FirebaseAuthException catch (e) {
      showSnackBar(message: e.code + '\n' + e.message);
    } catch (e) {
      showSnackBar(message: e.code + '\n' + e.message);
    }
  }

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
                onChanged: (value) => _email = value,
                decoration: InputDecoration(
                  labelText: 'New Email',
                ),
              ),
              ElevatedButton(
                onPressed: _changeEmail,
                child: Text('Confirm'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
