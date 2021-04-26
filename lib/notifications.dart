import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

///Defines the app's notifications screen
///@author: Rudy Fisher
class NotificationsWidget extends StatefulWidget {
  @override
  _NotificationsWidgetState createState() => _NotificationsWidgetState();
}

class _NotificationsWidgetState extends State<NotificationsWidget> {
  final String tmpCurrentUserID = FirebaseAuth.instance.currentUser.uid;

  final FirebaseFirestore db = FirebaseFirestore.instance;
  DocumentReference currentUserDocRef;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: StreamBuilder<QuerySnapshot>(
          stream: db
              .collection('users')
              .doc(tmpCurrentUserID)
              .collection('notifications')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Something went wrong.'),
              );
            } else if (!snapshot.hasData) {
              return Center(
                child: Text('Loading... (probably)'),
              );
            } else {
              return ListView.separated(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) => Notification(
                  doc: snapshot.data.docs.elementAt(index),
                ),
                separatorBuilder: (context, index) => Divider(
                  height: 16.0,
                ),
              );
            }
          }),
    );
  }
}

///Defines a widget to encapsulate a notification within the app.
///Handles deletion of this widget's notification document in
///[Firestore] and the user's ability to confirm invites into a group
class Notification extends StatefulWidget {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final QueryDocumentSnapshot doc;

  Notification({this.doc});

  @override
  _NotificationState createState() => _NotificationState();
}

class _NotificationState extends State<Notification> {
  bool _isInvite = false;

  String _getGroupName(String groupId) {
    //TODO: -- RUDY -- if groupId exists in usergroups, return that to display, otherwise return the id

    return groupId;
  }

  @override
  void initState() {
    super.initState();
    _isInvite = widget.doc.get('isInvite');
  }

  void showSnackBar({String message}) {
    SnackBar snackbar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 7),
      action: SnackBarAction(
        label: 'Confirm Invite',
        onPressed: () {
          //TODO -- RUDY -- Add user to group when confirmed
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.notification_important_rounded),
      title: Text(
        _getGroupName(widget.doc.get('groupId')),
      ),
      subtitle: Text(
        widget.doc.get('content'),
      ),
      trailing: IconButton(
        icon: Icon(Icons.delete_forever_rounded),
        onPressed: widget.doc.reference.delete,
      ),
      tileColor: _isInvite ? Colors.blue : null,
      onTap: () {
        if (_isInvite) {
          showSnackBar(message: '');
        }
      },
    );
  }
}
