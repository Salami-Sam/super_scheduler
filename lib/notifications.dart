import 'package:flutter/material.dart';

///Defines the app's notifications screen
///@author: Rudy Fisher
class NotificationsWidget extends StatefulWidget {
  @override
  _NotificationsWidgetState createState() => _NotificationsWidgetState();
}

class _NotificationsWidgetState extends State<NotificationsWidget> {
  void _deleteNotification(Widget child) {}
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: ListView.separated(
        itemCount: 20,
        itemBuilder: (BuildContext context, int index) => Notification(
          parentDeleteMeCallback: _deleteNotification,
          title: 'tmp',
          subtitle: 'tmp',
        ),
        separatorBuilder: (context, index) => Divider(
          height: 16.0,
        ),
      ),
    );
  }
}

//TODO: define a class for notifications with optional buttons

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
