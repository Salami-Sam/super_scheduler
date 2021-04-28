import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

/*
///Defines a screen that allows the user to change their password.
///NOTE: This class is currently not used because the app will be
///using [FirestoreAuth]'s password reset email functionality.
///@author: Rudy Fisher
class ChangePasswordWidget extends StatefulWidget {
  BooleanByReference _obscurePasswords = BooleanByReference(boolean: true);
  @override
  _ChangePasswordWidgetState createState() => _ChangePasswordWidgetState();
}

class _ChangePasswordWidgetState extends State<ChangePasswordWidget> {
  String _password = FirebaseAuth.instance.currentUser.email;

  void showSnackBar({String message}) {
    SnackBar snackbar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 7),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  void _changePassword() async {
    try {
      await FirebaseAuth.instance.currentUser.updateEmail(_password);

      Navigator.pop(context);
      showSnackBar(message: 'Email updated successfully.');
    } on FirebaseAuthException catch (e) {
      showSnackBar(message: e.code + '\n' + e.message);
    } catch (e) {
      showSnackBar(message: e.code + '\n' + e.message);
    }
  }

  final String textLabel = 'New Password';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => widget._obscurePasswords,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Change Password'),
        ),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Consumer<BooleanByReference>(
                  builder: (context, booleanByReference, child) =>
                      PasswordFieldWidget(
                    textLabel: textLabel,
                    obscurePassword: booleanByReference,
                  ),
                ),
                Consumer<BooleanByReference>(
                  builder: (context, booleanByReference, child) =>
                      PasswordFieldWidget(
                    textLabel: textLabel,
                    obscurePassword: booleanByReference,
                  ),
                ),
                ElevatedButton(
                  onPressed: null,
                  child: Text('confirm'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
*/
