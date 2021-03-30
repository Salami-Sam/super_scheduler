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
                Navigator.push(context,
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
      Container(
        child: Column(
          children: <Widget>[Text("Your Groups:")],
        ),
      ),
      Flexible(
        child: Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.black)),
          child: _showGroupList(),
        ),
      )
    ])));
  }
}

Widget _showGroupList() {
  return ListView.builder(
      itemCount: 1,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          child: Column(
            children: <Widget>[
              ElevatedButton(
                  onPressed: () {
                    //TODO: Go to a group home page
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GroupHomeWidget()));
                  },
                  child: Text('Group Home (Member)')),
              ElevatedButton(
                  onPressed: () {
                    //TODO: Go to a group home (Admin) page
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
              ElevatedButton(onPressed: () {}, child: Text('Group 4')),
              ElevatedButton(onPressed: () {}, child: Text('Group 5')),
              ElevatedButton(onPressed: () {}, child: Text('Group 6')),
              ElevatedButton(onPressed: () {}, child: Text('Group 7')),
              ElevatedButton(onPressed: () {}, child: Text('Group 8')),
              ElevatedButton(onPressed: () {}, child: Text('Group 9')),
              ElevatedButton(onPressed: () {}, child: Text('Group 10')),
              ElevatedButton(onPressed: () {}, child: Text('Group 11')),
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
