import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'main.dart';

/* Screens:
 * Edit Members
 * View Members
 * Invite Member
 * Edit Individual Member
 * Edit Roles
 * 
 * Writen by Mike Schommer
 * version 1.0
 * 3/16/21
 */

//todo: these should be values created when a new user is created, these are temp values
List roles = ['Cook', 'Cashier', 'Busboy'];
List groupMembers = ['Spongebob', 'Squidward', 'Patrick'];
List permissions = ['Member', 'Manager', 'Admin'];
var db = FirebaseFirestore.instance;
CollectionReference group = db.collection('groups');

/*
 * EditIndividualMember is a screen that allows an admin to change a role and 
 * permission level of a specific user and save the changes made to said user
 * 
*/
class EditIndividualMemberWidget extends StatefulWidget {
  final int index;
  EditIndividualMemberWidget({this.index});

  @override
  _EditIndividualMemberWidgetState createState() =>
      _EditIndividualMemberWidgetState(index);
}

class _EditIndividualMemberWidgetState
    extends State<EditIndividualMemberWidget> {
  int index;
  _EditIndividualMemberWidgetState(this.index);
  //these strings are used by the drop menu, will see similar strings in other widgets
  String selectedRole;
  String selectedPermission;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('${groupMembers[index]}'),
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  //back to edit member screen screen
                  Navigator.pop(context);
                })),
        drawer: getUnifiedDrawerWidget(),
        body: Column(
          children: [
            ListTile(
              title: Center(
                child: Text('Role',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0)),
              ),
            ),
            //todo: need to find way to assign whatever is chosen from dropdown to user
            //this will come once users are properly implemented
            DropdownButton(
              hint: Text('${roles[index]}'),
              value: selectedRole,
              onChanged: (newRole) {
                setState(() {
                  selectedRole = newRole;
                });
              },
              items: roles.map((role) {
                return DropdownMenuItem(child: new Text(role), value: role);
              }).toList(),
            ),
            ListTile(
              title: Center(
                child: Text('Permissions',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0)),
              ),
            ),
            DropdownButton(
              hint: Text('${permissions[0]}'),
              value: selectedPermission,
              onChanged: (newPermissions) {
                setState(() {
                  selectedPermission = newPermissions;
                });
              },
              items: permissions.map((permission) {
                return DropdownMenuItem(
                    child: new Text(permission), value: permission);
              }).toList(),
            )
          ],
        ));
  }
}
/* EditRolesWidget allows admin to create or deleted roles with a group
 * todo: implement delete roles feature
 * 
*/

class EditRolesWidget extends StatefulWidget {
  @override
  _EditRolesWidgetState createState() => _EditRolesWidgetState();
}

Future<List> getRoles() async {
  List returnList = [];
  await group.doc('PCXUSOFVGcmZ8UqK0QnX').get().then((docref) {
    if (docref.exists) {
      returnList = docref['roles'];
      print(returnList);
    } else {
      print("Error, name not found");
    }
  });
  return returnList;
}

//need to not have doc be a string, should be variable
Future<void> addRoles(var roleToAdd) async {
  await group.doc('PCXUSOFVGcmZ8UqK0QnX').update({
    'roles': FieldValue.arrayUnion([roleToAdd])
  });
}

Future<void> deleteRoles(role) async {
  await group
      .doc('PCXUSOFVGcmZ8UqK0QnX')
      .update({'roles': FieldValue.arrayRemove([role])});
}

String newRole = '';

class _EditRolesWidgetState extends State<EditRolesWidget> {
  Future<List> futureRoles;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('Current Roles'),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                //back to edit member screen
                Navigator.pop(context);
              },
            )),
        drawer: getUnifiedDrawerWidget(),
        body: Column(children: [
          Flexible(
              child: FutureBuilder<List>(
                  future: futureRoles = getRoles(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error');
                    }
                    List roles = snapshot.data ?? [];
                    return ListView.separated(
                        itemBuilder: (context, index) => ListTile(
                              leading: IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    deleteRoles(roles[index]);
                                    Navigator.pop(context);
                                  }),
                              title: Text('${roles[index]}'),
                            ),
                        separatorBuilder: (context, int) =>
                            Divider(thickness: 1.0, height: 1.0),
                        itemCount: roles.length);
                  })),
          TextField(
              decoration: InputDecoration(
                  labelText: 'New Role',
                  hintText: 'e.g. Dishwasher, Host, Prep',
                  contentPadding: EdgeInsets.all(20.0)),
              onChanged: (text) {
                newRole = text;
              }),
          ElevatedButton(
              onPressed: () {
                addRoles(newRole);
                Navigator.pop(context);
              },
              child: Text('Submit'))
        ]));
  }
}

/* InviteMemberWidget allows admins to invite new users to group
 * This is done by sending an email to potential new user that will send a unique
 * code that will allow user to group
 * todo: email functionality and code creation
 *  
 */

class InviteMemberWidget extends StatefulWidget {
  @override
  _InviteMemberWidgetState createState() => _InviteMemberWidgetState();
}

class _InviteMemberWidgetState extends State<InviteMemberWidget> {
  String newMember = '';
  String newMemberRole;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Invite Member'),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context); //back to edit member screen
              })),
      drawer: getUnifiedDrawerWidget(),
      body: Column(
        children: [
          ListTile(
            title: Center(
              child: Text('Enter Email',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0)),
            ),
          ),
          TextField(
              decoration: InputDecoration(
                  hintText: 'spongebob123@bikinimail.com',
                  contentPadding: EdgeInsets.all(20.0)),
              //will need to use email authentication here
              onChanged: (text) {
                newMember = text;
              }),
          ListTile(
            title: Center(
              child: Text('Role',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0)),
            ),
          ),
          DropdownButton(
            hint: Text('Choose role'),
            value: newMemberRole,
            onChanged: (assignedRole) {
              setState(() {
                newMemberRole = assignedRole;
              });
            },
            items: roles.map((role) {
              return DropdownMenuItem(child: new Text(role), value: role);
            }).toList(),
          ),
        ],
      ),
    );
  }
}

/* EditMemberWidget screen acts like the "main" screen for most member management 
 * screens as it acts as a jumping off point to all other member management screens
 * EditMemberWidget can also allow admins to be able to delete members from group
 * 
 * todo: delete member functionality
 * todo: Should NOT be able to be accessed by members, only admins 
*/
class EditMemberWidget extends StatefulWidget {
  @override
  _EditMemberWidgetState createState() => _EditMemberWidgetState();
}

class _EditMemberWidgetState extends State<EditMemberWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Members'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context); //back to main group screen
            },
          ),
          centerTitle: true,
        ),
        drawer: getUnifiedDrawerWidget(),
        body: Column(children: [
          Flexible(
              child: ListView.separated(
                  itemBuilder: (context, index) {
                    return ListTile(
                        leading: IconButton(
                            icon: Icon(Icons.delete), onPressed: () {}),
                        title: Text('${groupMembers[index]}'),
                        subtitle: Text('${roles[index]}'),
                        trailing: IconButton(
                            icon: Icon(Icons.more_vert),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          EditIndividualMemberWidget(
                                              index: index)));
                            }));
                  },
                  separatorBuilder: (context, int) =>
                      Divider(thickness: 1.0, height: 1.0),
                  itemCount: groupMembers.length)),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InviteMemberWidget()),
                );
              },
              child: Text('Invite Members')),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditRolesWidget()),
                );
              },
              child: Text('Edit Roles')),
        ]));
  }
}

/* ViewMembersWidget is a screen that displays members of a particular group
 * this could probably be in the groups file as ViewMembersWidget is not a screen
 * that is reachable from EditMembersWidget, doesn't fit here really
 */
class ViewMembersWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Members'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              //back to group main page
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
        ),
        drawer: getUnifiedDrawerWidget(),
        body: Center(
            child: ListView.separated(
                itemBuilder: (context, index) => ListTile(
                      title: Text('${groupMembers[index]}'),
                      subtitle: Text('${roles[index]}'),
                    ),
                separatorBuilder: (context, int) =>
                    Divider(thickness: 1.0, height: 1.0),
                itemCount: roles.length)));
  }
}

Drawer getUnifiedDrawerWidget() {
  return Drawer(
    child: Text('Drawer placeholder'),
  );
}

