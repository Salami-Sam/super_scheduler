import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import '../main.dart';
import 'member_management.dart';
import 'package:email_validator/email_validator.dart';

/* Screen:
 * Invite Members
 * 
 * @author Mike Schommer
 * @version 3.0
 * 4/28/21
 */


var db = FirebaseFirestore.instance;
CollectionReference group = db.collection('groups');
String groupName;
String accessCode = 'abc123'; //should be passed in from group creation

//pretty basic email sender, uses default email from users phone, works
//just fine for our purposes
Future<void> send(String recipient, String role) async {
  List<String> recipientList = [recipient];
  Email email = Email(
      subject: 'Invitaion to join group $groupName',
      body:
          'You have been invited to join: $groupName on Super Scheduler! \n Here is your access code: \n $accessCode\n\n',
      recipients: recipientList);

  try {
    await FlutterEmailSender.send(email);
    print('Success');
  } catch (error) {
    print('Error, something went wrong!');
  }
}

//standard function to return roles from database
Future<List> getRoles() async {
  List returnList = [];
  await group.doc('PCXUSOFVGcmZ8UqK0QnX').get().then((docref) {
    if (docref.exists) {
      returnList = docref['roles'];
      groupName = docref['name'];
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
 */
class InviteMemberWidget extends StatefulWidget {
  @override
  _InviteMemberWidgetState createState() => _InviteMemberWidgetState();
}

class _InviteMemberWidgetState extends State<InviteMemberWidget> {
  String newMember = '';
  String selectedRole;
  bool roleChosen = false;
  Future<List> futureRoles;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Group Invitation'),
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
              child: Text('Enter An Email',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0)),
            ),
          ),
          TextField(
              decoration: InputDecoration(
                  hintText: 'spongebob123@bikinimail.com',
                  contentPadding: EdgeInsets.all(20.0)),
              onChanged: (text) {
                newMember = text; //will need to use email authentication here
              }),
          ListTile(
            title: Center(
              child: Text('Select A Role',
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
                      roleChosen =
                          true; //I don't want user to send an email without a role being assigned
                    });
                  },
                  items: roles.map((role) {
                    return DropdownMenuItem(child: new Text(role), value: role);
                  }).toList(),
                );
              }),
          Container(
              width: 120.0,
              height: 50.0,
              child: ElevatedButton(
                  onPressed: () {
                    if (roleChosen) {
                      if (EmailValidator.validate(newMember)) {
                        send(newMember, selectedRole);
                      } else {
                        var snackBar = SnackBar(content: Text('Invalid Email'));  //don't want to send to invaild email
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    } else {
                      var snackBar =
                          SnackBar(content: Text('You Must Choose a Role'));     
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  child: Row(children: [
                    Text('Send',
                        style: TextStyle(fontSize: 20.0),
                        textAlign: TextAlign.center),
                    Icon(Icons.mail_outline_rounded, color: Colors.white)
                  ])))
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
