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
List groupMembers = ['Spongebob', 'Squidward', 'Patrick'];  //these are placeholders
List permissions = ['Member', 'Manager', 'Admin'];

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

Drawer getUnifiedDrawerWidget() {
  return Drawer(
    child: Text('Drawer placeholder'),
  );
}

