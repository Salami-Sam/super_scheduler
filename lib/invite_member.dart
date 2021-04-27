import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'member_management.dart';

/* Screen:
 * Invite Members
 * 
 * Writen by Mike Schommer
 * version 2.0
 * 4/14/21
 */

var db = FirebaseFirestore.instance;
CollectionReference group = db.collection('groups');
List roles = ['Cook', 'Cashier', 'Busboy'];
List groupMembers = [
  'Spongebob',
  'Squidward',
  'Patrick'
]; //these are placeholders
List permissions = ['Member', 'Manager', 'Admin'];

Future<List> getRoles() async {
  List returnList = [];
  await group.doc('PCXUSOFVGcmZ8UqK0QnX').get().then((docref) {
    if (docref.exists) {
      returnList = docref['roles'];
      print("in getRoles() " + "$returnList");
    } else {
      print("Error, name not found");
    }
  });
  return returnList;
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
  String selectedRole;
  Future<List> futureRoles;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Invite Member'),
          centerTitle: true,
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
              child: Text('Select a Role',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0)),
            ),
          ),
          FutureBuilder<List>(
              future: futureRoles = getRoles(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('Error');
                }
                List roles = snapshot.data;
                print(roles);
                return DropdownButton(
                  hint: Text('N\A'),
                  value: selectedRole,
                  onChanged: (newRole) {
                    setState(() {
                      selectedRole = newRole;
                    });
                  },
                  items: roles.map((role) {
                    return DropdownMenuItem(child: new Text(role), value: role);
                  }).toList(),
                );
              }),
        ],
      ),
    );
  }
}

Drawer getUnifiedDrawerWidget() {
  return Drawer(
    child: Text('Drawer placeholder'),
  );
}
