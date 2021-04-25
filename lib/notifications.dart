import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

///Defines the app's notifications screen
///@author: Rudy Fisher
class NotificationsWidget extends StatefulWidget {
  @override
  _NotificationsWidgetState createState() => _NotificationsWidgetState();
}

class _NotificationsWidgetState extends State<NotificationsWidget> {
  final String tmpCurrentUserID = 'pvTQ6g7u5RPOk7veFbN7pJM9poF3';

  final FirebaseFirestore db = FirebaseFirestore.instance;
  DocumentReference currentUserDocRef;

  void _deleteNotification(Widget child) {
    //TODO: -- RUDY -- remove notification of child widget from firestore
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: StreamBuilder<QuerySnapshot>(
          stream: db
              .collection('users')
              .doc(tmpCurrentUserID)
              .collection('notifications')
              .snapshots(), //TODO: -- RUDY -- Use stream builder to populate listview
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
                itemBuilder: (BuildContext context, int index) => Notification(
                  parentDeleteMeCallback: _deleteNotification,
                  title: 'tmp',
                  subtitle: 'tmp',
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

//TODO: -- RUDY -- add optional buttons for invite notifications

///Defines a widget to encapsulate a notification within the app.
///[parentDeleteMeCallback] is a [Function(Widget)] of its parent
///and takes this widget as its parameter's argument for deletion
class Notification extends StatelessWidget {
  final Function(Widget) parentDeleteMeCallback;
  final String title;
  final String subtitle;

  Notification({this.parentDeleteMeCallback, this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.notification_important_rounded),
      title: Text(
        title,
      ),
      subtitle: Text(
        subtitle,
      ),
      trailing: IconButton(
        icon: Icon(Icons.delete_forever_rounded),
        onPressed: () => parentDeleteMeCallback(this),
      ),
    );
  }
}
