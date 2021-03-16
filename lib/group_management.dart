import 'package:flutter/material.dart';
import 'create_group.dart';
import 'drawer.dart';
import 'join_group.dart';

/* Screens:
 * My Groups
 * Create Group
 * Join Group
 * Edit Group
 */
///@author: James Chartraw & Rudy Fisher
class MyGroupsWidget extends StatelessWidget {
  //_MyGroupsWidgetState createState() => _MyGroupsWidgetState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(children: <Widget>[
      Container(
          margin: EdgeInsets.all(20),
          child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => JoinGroupWidget()));
              },
              child: Text('Join Group'))),
      ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => CreateGroupWidget()));
        },
        child: Text('Create Group'),
      ),
      Flexible(
        child: Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.black)),
          margin: EdgeInsets.all(20),
          child: _showGroupList(),
        ),
      )
    ])));
  }
}

Widget _showGroupList() {
  return ListView.builder(
      itemCount: 15,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 15,
              ),
              Text("Group 1"),
              SizedBox(
                height: 15,
              ),
              Text("Group 2"),
              SizedBox(
                height: 15,
              ),
              Text("Group 3"),
            ],
          ),
        );
      });
}

/* class CreateGroupWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Group'),
      ),
      drawer: getUnifiedDrawerWidget(),
      body: Text('Placeholder'),
    );
  }
} */

/* class JoinGroupWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Join Group'),
      ),
      drawer: getUnifiedDrawerWidget(),
      body: Text('Placeholder'),
    );
  }
}  */

/* class EditGroupWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Group: The Krusty Crew'),
      ),
      drawer: getUnifiedDrawerWidget(),
      body: Text('Placeholder'),
    );
  }
} */
