import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:super_scheduler/home_widget.dart';
import 'package:super_scheduler/screen_title.dart';

///Defines a screen that allows the user to delete a group
///@author: Dylan Schulz, based on delete_account.dart by Rudy Fisher
class DeleteGroupWidget extends StatefulWidget {
  final String currentGroupId;

  DeleteGroupWidget({@required this.currentGroupId});

  @override
  _DeleteGroupWidgetState createState() => _DeleteGroupWidgetState();
}

class _DeleteGroupWidgetState extends State<DeleteGroupWidget> {
  void showSnackBar({String message}) {
    SnackBar snackbar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 7),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  ///Removes all information about the group from Firestore
  ///by setting its document to contain only filler data
  ///Does not technically delete the group because it's document reference
  ///could still be in use by other users
  Future<void> _deleteGroupDocFromFirestore() {
    return FirebaseFirestore.instance
        .collection('groups')
        .doc(widget.currentGroupId)
        .set({
      'Admins': {},
      'Managers': {},
      'Members': {},
      'description': '[This group has been deleted]',
      'group_code': '',
      'name': '[Deleted]',
      'roles': [],
    });
  }

  ///Deletes the group and pops back to the MyGroups screen
  ///by going back to the top level app home screen
  void _deleteGroupAndReturnToMyGroupsScreen() async {
    try {
      await _deleteGroupDocFromFirestore();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => SuperSchedulerApp(),
        ),
        (route) => false,
      );
      showSnackBar(message: 'Your group was deleted.');
    } on FirebaseAuthException catch (e) {
      showSnackBar(message: e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: getScreenTitle(
              currentGroupRef: FirebaseFirestore.instance
                  .collection('groups')
                  .doc(widget.currentGroupId),
              screenName: 'Delete Group')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Are you sure you want to delete this group?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32.0,
                color: Colors.redAccent,
              ),
            ),
            Divider(
                height: 20, color: Theme.of(context).scaffoldBackgroundColor),
            ElevatedButton(
              onPressed: _deleteGroupAndReturnToMyGroupsScreen,
              child: Text('Confirm'),
            ),
          ],
        ),
      ),
    );
  }
}
