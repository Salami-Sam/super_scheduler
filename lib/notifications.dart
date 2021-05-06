import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

///Defines the app's notifications screen. It updates in real time with the
///[Firestore]'s notifications collection for [FirebaseAuth]'s current user.
///@author: Rudy Fisher
class NotificationsWidget extends StatefulWidget {
  final String currentUserID = FirebaseAuth.instance.currentUser.uid;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  @override
  _NotificationsWidgetState createState() => _NotificationsWidgetState();
}

class _NotificationsWidgetState extends State<NotificationsWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: StreamBuilder<QuerySnapshot>(
          stream: widget.db
              .collection('users')
              .doc(widget.currentUserID)
              .collection('notifications')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Something went wrong. ${snapshot.error}'),
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

///Defines a [Widget] to encapsulate a notification within the app.
///Handles deletion of this [Widget]'s notification document in
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
  String _groupName = '';

  ///Sets the group's name for display in this widget's notification.
  ///If the group's name doesn't exist in the groups collection, set it
  ///to the group's ID.
  void _setGroupName(String groupId) async {
    DocumentSnapshot doc =
        await widget.db.collection('groups').doc(groupId).get();

    ///For some reason, even though this is call in [initState], and this
    ///function awaits the information retrieval, the information would not
    ///display properly unless [setState] is called.
    setState(() {
      if (doc.exists) {
        _groupName = doc['name'];
      } else {
        _groupName = groupId;
      }
    });
  }

  ///Joins the user to the group of this [Widget]'s invite notification,
  ///if it has one, by adding the [groupId] to the user's [userGroup] list.
  void _joinGroup() async {
    DocumentSnapshot doc = await widget.db
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get();

    List<String> groupsIds =
        doc['userGroups']; // Seems inefficient to get the whole list...
    groupsIds.add(widget.doc['groupId']);
    Map<String, List<String>> data = {'userGroups': groupsIds};
    await doc.reference.update(data);
  }

  ///Initializes the state for this [Widget]. Specifically, retrieves the
  ///information of the [Notification] this [Widget] is to represent.
  @override
  void initState() {
    _isInvite = widget.doc.get('isInvite');
    _setGroupName(widget.doc.get('groupId'));
    super.initState();
  }

  ///Shows the [message] in the [Snackbar].
  void showSnackBar({String message}) {
    SnackBar snackbar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 7),
      action: SnackBarAction(
        label: 'Confirm Invite',
        onPressed: _joinGroup,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.notification_important_rounded),
      title: Text(
        _groupName,
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
