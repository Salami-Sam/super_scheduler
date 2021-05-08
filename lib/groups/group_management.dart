import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../screen_title.dart';
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

          // An alternative way to display the groups:

          // return ListView.builder(
          //   itemCount: curUsersGroups.length,
          //   itemBuilder: (context, index) {
          //     String groupName = curUsersGroups.keys.elementAt(index)['name'];
          //     return Container(
          //       margin: EdgeInsets.only(top: 4, bottom: 4),
          //       child: ElevatedButton(
          //         child: Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: [
          //             Expanded(child: Text(groupName)),
          //             Icon(Icons.arrow_right, size: 45),
          //           ],
          //         ),
          //         onPressed: () {
          //           QueryDocumentSnapshot group = curUsersGroups.keys.elementAt(index);
          //           if (curUsersGroups.values.elementAt(index) == 'Admin') {
          //             Navigator.push(
          //                 context, MaterialPageRoute(builder: (context) => GroupHomeAdminWidget(group.id, groupName)));
          //           } else if (curUsersGroups.values.elementAt(index) == 'Manager') {
          //             Navigator.push(context,
          //                 MaterialPageRoute(builder: (context) => GroupHomeManagerWidget(group.id, groupName)));
          //           } else {
          //             Navigator.push(
          //                 context, MaterialPageRoute(builder: (context) => GroupHomeWidget(group.id, groupName)));
          //           }
          //         },
          //       ),
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
                    QueryDocumentSnapshot group =
                        curUsersGroups.keys.elementAt(index);
                    if (curUsersGroups.values.elementAt(index) == 'Admin') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  GroupHomeAdminWidget(group.id, groupName)));
                    } else if (curUsersGroups.values.elementAt(index) ==
                        'Manager') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  GroupHomeManagerWidget(group.id, groupName)));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  GroupHomeWidget(group.id, groupName)));
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

        // An alternative way to display the list of groups

        // body: Container(
        //     margin: EdgeInsets.all(8),
        //     child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
        //       ElevatedButton(
        //           onPressed: () {
        //             Navigator.push(context, MaterialPageRoute(builder: (context) => JoinGroupWidget()));
        //           },
        //           child: Text('Join Group')),
        //       ElevatedButton(
        //         onPressed: () {
        //           Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateGroupWidget()));
        //         },
        //         child: Text('Create Group'),
        //       ),
        //       Container(
        //         margin: EdgeInsets.only(top: 8),
        //         child: Divider(
        //           color: Colors.black,
        //           thickness: 1.0,
        //           height: 1.0,
        //         ),
        //       ),
        //       Center(
        //         child: ListTile(
        //           title: Text(
        //             'Your Groups',
        //             textAlign: TextAlign.center,
        //             style: TextStyle(
        //               fontWeight: FontWeight.bold,
        //             ),
        //           ),
        //         ),
        //       ),
        //       Container(
        //         margin: EdgeInsets.only(bottom: 8),
        //         child: Divider(
        //           color: Colors.black,
        //           thickness: 1.0,
        //           height: 1.0,
        //         ),
        //       ),
        //       Expanded(
        //         child: _getAllGroups(),
        //       ),
        //     ])));
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

/* The test groups:

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
                              builder: (context) => GroupHomeWidget(
                                  'RsTjd6INQsNa6RvSTeUX',
                                  'Pawnee Parks Dept.')));
                    },
                    child: Text('Group Home (Member)')),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GroupHomeAdminWidget(
                                  'RsTjd6INQsNa6RvSTeUX',
                                  'Pawnee Parks Dept.')));
                    },
                    child: Text('Group Home (Admin)')),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GroupHomeManagerWidget(
                                  'RsTjd6INQsNa6RvSTeUX',
                                  'Pawnee Parks Dept.')));
                    },
                    child: Text('Group Home (Manager)')),
              ],
            ),
          ),
*/

class EditGroupWidget extends StatefulWidget {
  final String currentGroupId;
  EditGroupWidget({this.currentGroupId});

  @override
  _EditGroupWidgetState createState() => _EditGroupWidgetState(currentGroupId);
}

/// The Edit group widget is accessed through an Admin of a group clicking "Edit Group" on that groups page.
/// works essentialy the same as CreateGroup but it updates instead.
class _EditGroupWidgetState extends State<EditGroupWidget> {
  TextEditingController groupNameController = TextEditingController();
  TextEditingController groupDescriptionController = TextEditingController();
  String groupName = '';
  String groupDescription = '';

  String currentGroupId;
  _EditGroupWidgetState(this.currentGroupId);

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
        body: Container(
            margin: EdgeInsets.all(20),
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
                      onChanged: (text) {
                        setState(() {
                          groupName = text;
                        });
                      },
                    )),
                Container(
                    margin: EdgeInsets.only(top: 10, bottom: 20),
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
                      Navigator.of(context).pop(MaterialPageRoute(
                          builder: (context) => MyGroupsWidget()));
                    },
                    child: Text('Save Changes')),
              ],
            )));
  }
}
