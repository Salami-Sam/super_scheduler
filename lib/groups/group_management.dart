import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../screen_title.dart';
import 'create_group.dart';
import 'delete_group.dart';
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
///@author: James Chartraw, Rudy Fisher, Dylan Schulz, Mike Schommer
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
          if (snapshot.hasError) {
            return Center(
                child:
                    Text('There was an error in loading the list of groups.'));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          List allGroups = snapshot.data.docs;
          Map curUsersGroups = {};

          //searches through all groups of the app
          //if the group contains the members uid, if it does
          //find if they are a member, manager or admin and save it in 
          //curUsersGroups
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

          if (curUsersGroups.isEmpty) {
            return Center(
              child: Text(
                'You do not have any groups. Go to Join Group or Create Group to get started!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.separated(
            itemCount: curUsersGroups.length,
            itemBuilder: (context, index) {
              String groupName = curUsersGroups.keys.elementAt(index)['name'];
              return ListTile(
                  tileColor: Colors.blue,
                  title: Text(groupName, style: TextStyle(color: Colors.white)),
                  trailing: Icon(
                    Icons.arrow_right,
                    size: 45,
                    color: Colors.white,
                  ),
                  onTap: () {
                    //if curUsersGroups value is an admin, then they are an admin
                    QueryDocumentSnapshot group =
                        curUsersGroups.keys.elementAt(index);
                    if (curUsersGroups.values.elementAt(index) == 'Admin') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  GroupHomeAdminWidget(group.id)));
                                  //if curUsersGroups value is a manager, then they are a manager
                    } else if (curUsersGroups.values.elementAt(index) ==
                        'Manager') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  GroupHomeManagerWidget(group.id)));
                                  //if not either, they are a member
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GroupHomeWidget(group.id)));
                    }
                  });
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: 10,
              );
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
          SizedBox(
            height: 10,
          ),
          ListTile(
            tileColor: Colors.blue,
            trailing: Icon(
              Icons.arrow_right,
              size: 45,
              color: Colors.white,
            ),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => JoinGroupWidget()));
            },
            title: Text('Join Group', style: TextStyle(color: Colors.white)),
          ),
          SizedBox(
            height: 10,
          ),
          ListTile(
            tileColor: Colors.blue,
            trailing: Icon(
              Icons.arrow_right,
              size: 45,
              color: Colors.white,
            ),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CreateGroupWidget()));
            },
            title: Text('Create Group', style: TextStyle(color: Colors.white)),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: Column(
              children: <Widget>[
                Text("Your Groups:", style: TextStyle(fontSize: 20)),
                SizedBox(
                  height: 10,
                )
              ],
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

class EditGroupWidget extends StatefulWidget {
  final String currentGroupId;
  EditGroupWidget({this.currentGroupId});

  @override
  _EditGroupWidgetState createState() => _EditGroupWidgetState(currentGroupId);
}

/// The Edit group widget is accessed through an Admin of a group clicking "Edit Group" on that groups page.
/// works essentialy the same as CreateGroup but it updates instead.
/// Authors: Dylan Schulz and James Chartraw
class _EditGroupWidgetState extends State<EditGroupWidget> {
  TextEditingController groupNameController;
  TextEditingController groupDescriptionController;
  String groupName = '';
  String groupDescription = '';

  String currentGroupId;
  _EditGroupWidgetState(this.currentGroupId);

  // Gets the name and description for the current group
  // and places them in the fields
  // Author: Dylan Schulz
  Future<void> getNameAndDescription() {
    return FirebaseFirestore.instance
        .collection('groups')
        .doc('$currentGroupId')
        .get()
        .then((docref) {
      if (docref.exists) {
        groupName = docref['name'];
        groupDescription = docref['description'];
      }
    });
  }

  // Updates the current group's name and description
  // in the database to be groupName and groupDescription
  // Author: Dylan Schulz
  void updateGroup() {
    FirebaseFirestore.instance
        .collection('groups')
        .doc('$currentGroupId')
        .update({
      'name': groupName,
      'description': groupDescription,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: getScreenTitle(
            currentGroupRef: FirebaseFirestore.instance
                .collection("groups")
                .doc(currentGroupId),
            screenName: 'Edit Group'),
      ),
      body: FutureBuilder(
          // Wait while the name and description of the current group are retrieved,
          // then continue building
          future: getNameAndDescription(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text(
                  'There was an error in retrieving the group\'s current info.');
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              groupNameController = new TextEditingController(text: groupName);
              groupDescriptionController =
                  new TextEditingController(text: groupDescription);

              return Container(
                margin: EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 20, bottom: 10),
                        child: TextField(
                          controller: groupNameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Group Name',
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10, bottom: 20),
                        child: TextField(
                          maxLines: null,
                          controller: groupDescriptionController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Group Description',
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          groupName = groupNameController.text;
                          groupDescription = groupDescriptionController.text;
                          updateGroup();
                          // The argument to pop will be retrieved in a future by
                          // the Navigator.push call that opened this screen
                          Navigator.of(context).pop<String>(groupName);
                        },
                        child: Text('Save Changes'),
                      ),
                      Padding(padding: EdgeInsets.all(16)),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DeleteGroupWidget(
                                      currentGroupId: currentGroupId)));
                        },
                        child: Text('Delete Group'),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.redAccent),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }
}
