import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'create_group.dart';
import 'group_home.dart';
import 'group_home_ADMIN.dart';
import 'group_home_Manager.dart';
import 'join_group.dart';

/* Screens:
 * My Groups
 * Create Group
 * Join Group
 * Edit Group
 */
///@author: James Chartraw & Rudy Fisher
class MyGroupsWidget extends StatefulWidget {
  @override
  _MyGroupsWidgetState createState() => _MyGroupsWidgetState();
}

class _MyGroupsWidgetState extends State<MyGroupsWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
          Container(
              margin: EdgeInsets.all(20),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => JoinGroupWidget()));
                  },
                  child: Text('Join Group'))),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CreateGroupWidget()));
            },
            child: Text('Create Group'),
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[Text("TEST Groups:")],
            ),
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GroupHomeWidget()));
                    },
                    child: Text('Group Home (Member)')),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GroupHomeAdminWidget()));
                    },
                    child: Text('Group Home (Admin)')),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GroupHomeManagerWidget()));
                    },
                    child: Text('Group Home (Manager)')),
              ],
            ),
          ),
          Container(
            child: Column(
              children: <Widget>[Text("Your Groups:")],
            ),
          ),
          Flexible(
            child: Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black)),
                child: _getAllGroups()),
          )
        ])));
  }
}

Widget _getAllGroups() {
  return new StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("groups").snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return new Text("There are no groups");
        return new ListView(children: getGroups(snapshot));
      });
}

getGroups(AsyncSnapshot<QuerySnapshot> snapshot) {
  return snapshot.data.docs
      .map((doc) => new ListTile(title: new Text(doc["name"])))
      .toList();
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
class EditGroupWidget extends StatefulWidget {
  @override
  _EditGroupWidgetState createState() => _EditGroupWidgetState();
}

class _EditGroupWidgetState extends State<EditGroupWidget> {
  TextEditingController groupController = TextEditingController();
  String groupName = '';
  String groupDescription = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Group'),
        ),
        body: Center(
            child: Column(children: <Widget>[
          Container(
              margin: EdgeInsets.all(20),
              child: TextField(
                controller: groupController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Group Name',
                ),
                onChanged: (text) {
                  setState(() {
                    groupName = text;
                  });
                },
              )),
          Container(
              margin: EdgeInsets.all(20),
              child: TextField(
                controller: groupController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Group Description',
                ),
                onChanged: (text) {
                  setState(() {
                    groupDescription = text;
                  });
                },
              )),
          ElevatedButton(
              onPressed: () {
                //TODO: submit the form
              },
              child: Text('Save Changes')),
        ])));
  }
}
