import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

///The group_management page acts as a home screen for the User
///On this screen there are two buttons at the top which bring you to the Join Group and Create Group screens
///Below them is a list of all the groups a user is a member, manager, or admin of.
///If a user is and Admin of a group it will give them Admin controls on that groups page.
class _MyGroupsWidgetState extends State<MyGroupsWidget> {
  String uid = FirebaseAuth.instance.currentUser.uid;

  Widget _getAllGroups() {
    return new StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("groups").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return new Text("There are no groups");

          List allGroups = snapshot.data.docs;
          Map curUsersGroups = {};

          for (QueryDocumentSnapshot group in allGroups) {
            if (group['Members'].containsKey(uid)) {
              curUsersGroups[group] = 'Member';
            }
            if (group['Managers'].containsKey(uid)) {
              curUsersGroups[group] = 'Manager';
            }
            if (group['Admins'].containsKey(uid)) {
              curUsersGroups[group] = 'Admin';
            }
          }

          return ListView.builder(
            itemCount: curUsersGroups.length,
            itemBuilder: (context, index) {
              String groupName = curUsersGroups.keys.elementAt(index)['name'];
              return ListTile(
                title: Text(groupName), trailing:  Icon(Icons.arrow_right, size: 45),
                onTap: () {
                  QueryDocumentSnapshot group = curUsersGroups.keys.elementAt(index);
                  if (curUsersGroups.values.elementAt(index) == 'Admin') {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => GroupHomeAdminWidget(group.id, groupName)));
                  } else if (curUsersGroups.values.elementAt(index) == 'Manager') {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => GroupHomeManagerWidget(group.id, groupName)));
                  } else {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => GroupHomeWidget(group.id, groupName)));
                  }
                },
              );
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
      Container(
          margin: EdgeInsets.all(20),
          child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => JoinGroupWidget()));
              },
              child: Text('Join Group'))),
      ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateGroupWidget()));
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
                          builder: (context) => GroupHomeWidget('RsTjd6INQsNa6RvSTeUX', 'Pawnee Parks Dept.')));
                },
                child: Text('Group Home (Member)')),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GroupHomeAdminWidget('RsTjd6INQsNa6RvSTeUX', 'Pawnee Parks Dept.')));
                },
                child: Text('Group Home (Admin)')),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GroupHomeManagerWidget('RsTjd6INQsNa6RvSTeUX', 'Pawnee Parks Dept.')));
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
        child: Container(decoration: BoxDecoration(border: Border.all(color: Colors.black)), child: _getAllGroups()),
      )
    ])));
  }
}

//   getGroups(AsyncSnapshot<QuerySnapshot> snapshot) {
//     return snapshot.data.docs
//         .map((doc) => new ListTile(
//             leading: IconButton(
//               icon: Icon(Icons.api),
//               onPressed: () {
//                 /* Navigator.of(context).pop(MaterialPageRoute(
//                     builder: (context) => GroupHomeAdminWidget())); */
//               },
//             ),
//             title: new Text(doc["name"])))
//         .toList();
//   }

//   Widget _getAllGroups() {
//     return new StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance.collection("groups").snapshots(),
//         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (!snapshot.hasData) return new Text("There are no groups");
//           return new ListView(children: getGroups(snapshot));
//         });
//   }
// }

class EditGroupWidget extends StatefulWidget {
  @override
  _EditGroupWidgetState createState() => _EditGroupWidgetState();
}

/// The Edit group widget is accessed through an Admin of a group clicking "Edit Group" on that groups page.
/// works essentialy the same as CreateGroup but it updates instead.
class _EditGroupWidgetState extends State<EditGroupWidget> {
  TextEditingController groupNameController = TextEditingController();
  TextEditingController groupDescriptionController = TextEditingController();
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
                controller: groupNameController,
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
                controller: groupDescriptionController,
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
                //TO DO: Editing a group such that a new group is not created
                // newGroupName = groupNameController.text;
                // newGroupDescription = groupDescriptionController.text;
                // addAGroup(newGroupName, newGroupDescription);
                Navigator.of(context).pop(MaterialPageRoute(builder: (context) => MyGroupsWidget()));
              },
              child: Text('Save Changes')),
        ])));
  }
}
