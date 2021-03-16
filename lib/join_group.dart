import 'package:flutter/material.dart';

///A screen where a user can enter a code to join a group
///@author: James Chartraw
class JoinGroupWidget extends StatefulWidget {
  @override
  _JoinGroupWidgetState createState() => _JoinGroupWidgetState();
}

class _JoinGroupWidgetState extends State<JoinGroupWidget> {
  TextEditingController codeController = TextEditingController();
  String groupCode = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Join Group'),
        ),
        body: Center(
            child: Column(children: <Widget>[
          Container(
              margin: EdgeInsets.all(20),
              child: TextField(
                controller: codeController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Group Code',
                ),
                onChanged: (text) {
                  setState(() {
                    groupCode = text;
                  });
                },
              )),
          ElevatedButton(
              onPressed: () {
                //TODO: submit the form
              },
              child: Text('Join Group')),
        ])));
  }
}
