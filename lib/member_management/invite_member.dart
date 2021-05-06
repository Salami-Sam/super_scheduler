import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
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

/* InviteMemberWidget allows admins to invite new users to group
 * This is done by sending an email to potential new user that will send a unique
 * code that will allow user to group
 */
class InviteMemberWidget extends StatefulWidget {
  final String currentGroupId;
  InviteMemberWidget({this.currentGroupId});

  @override
  _InviteMemberWidgetState createState() => _InviteMemberWidgetState(currentGroupId);
}

class _InviteMemberWidgetState extends State<InviteMemberWidget> {
  String newMember = '';
  String selectedRole, currentGroupId;
  bool roleChosen = false;
  Future<List> futureRoles;
  _InviteMemberWidgetState(this.currentGroupId);

  String groupName, groupCode;

//pretty basic email sender, uses default email from users phone, works
//just fine for our purposes
  Future<void> send(String recipient, String currentGroupId) async {
    List<String> recipientList = [recipient];
    await group.doc('$currentGroupId').get().then((docref) {
      if (docref.exists) {
        groupName = docref['name'];
        groupCode = docref['group_code'];
        print("in send() " + "$groupCode");
      } else {
        print("Error, name not found");
      }
    });
    Email email = Email(
        subject: 'Invitation to join group $groupName on Super Scheduler',
        body: 'Here is your access code: $groupCode\n',
        recipients: recipientList);
    try {
      await FlutterEmailSender.send(email);
      print('Success');
    } catch (error) {
      print('Error, something went wrong!');
    }
  }

  Drawer getUnifiedDrawerWidget() {
    return Drawer(
      child: Text('Drawer placeholder'),
    );
  }

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
              child: Text('Enter An Email', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0)),
            ),
          ),
          TextField(
              decoration:
                  InputDecoration(hintText: 'spongebob123@bikinimail.com', contentPadding: EdgeInsets.all(10.0)),
              onChanged: (text) {
                newMember = text; //will need to use email authentication here
              }),
          Padding(padding: EdgeInsets.all(16.0)),
          Container(
              width: 125.0,
              height: 60.0,
              child: ElevatedButton(
                  onPressed: () {
                    if (EmailValidator.validate(newMember)) {
                      send(newMember, currentGroupId);
                    } else {
                      var snackBar = SnackBar(content: Text('Invalid email')); //don't want to send to invaild email
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  child: Row(children: [
                    Text(' Send  ', //kinda ugly like this but it works nice enough
                        style: TextStyle(fontSize: 20.0),
                        textAlign: TextAlign.center),
                    Icon(Icons.mail_outline_rounded, color: Colors.white)
                  ])))
        ],
      ),
    );
  }
}
