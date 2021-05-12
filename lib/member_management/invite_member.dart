import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:email_validator/email_validator.dart';

import '../screen_title.dart';

/* Screen:
 * Invite Members
 * 
 * @author Mike Schommer
 * @version 4.0
 * 5/12/21
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
  _InviteMemberWidgetState createState() =>
      _InviteMemberWidgetState(currentGroupId);
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
        groupCode = docref['group_code'];
        groupName = docref['name'];
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
    } catch (error) {
      print('Error, something went wrong!');
    }
  }

  //finds unique join code from database
  Future<String> getJoinCode(String currentGroupId) {
    return group.doc('$currentGroupId').get().then((docref) {
      if (docref.exists) {
        return docref['group_code'];
      } else {
        print("Error, name not found");
        return '[Error]';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: getScreenTitle(
                currentGroupRef: group.doc(currentGroupId),
                screenName: 'Invite Member'),
            centerTitle: true,
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(
                      context); //back to either member_managementMANAGER or member_managerADMIN
                })),
        body: Container(
            margin: EdgeInsets.all(8),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ListTile(
                    title: Center(
                      child: Text('Join Code',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25.0)),
                    ),
                  ),
                  Container(
                    child: Text(
                        'Your group\'s join code is below. Share it with others so they can join your group!',
                        style: TextStyle(fontSize: 16.0)),
                    //group code is displayed on the screen too just incase someone already has the app
                    //and doesn't need an email
                  ),
                  ListTile(
                    title: Center(
                      child: FutureBuilder(
                        future: getJoinCode(currentGroupId),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text('[Error]',
                                style: TextStyle(fontSize: 16.0));
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else {
                            return Text('${snapshot.data}',
                                style: TextStyle(fontSize: 16.0));
                          }
                        },
                      ),
                    ),
                  ),
                  ListTile(
                    title: Center(
                      child: Text('Email Invite',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25.0)),
                    ),
                  ),
                  Container(
                    child: Text(
                        'Enter someone\'s email address and we will prepare an invite email to send using your default email app.',
                        style: TextStyle(fontSize: 16.0)),
                    //just lets the user know that the app uses their email and not thru the app
                    //makes it less jaring when app changes screen
                  ),
                  Padding(padding: EdgeInsets.all(8.0)),
                  TextField(
                      decoration: InputDecoration(
                          hintText: 'spongebob123@bikinimail.com',
                          contentPadding: EdgeInsets.all(10.0)),
                      onChanged: (text) {
                        newMember = text;
                      }),
                  Padding(padding: EdgeInsets.all(16.0)),
                  Container(
                      width: 125.0,
                      height: 60.0,
                      child: ElevatedButton(
                          onPressed: () {
                            if (EmailValidator.validate(newMember)) {
                              print(currentGroupId);
                              send(newMember, currentGroupId);
                            } else {
                              var snackBar = SnackBar(
                                  content: Text(
                                      'Invalid email')); //don't want to send to invaild email
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          },
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                    ' Send  ', //kinda ugly like this but it works nice enough
                                    style: TextStyle(fontSize: 20.0),
                                    textAlign: TextAlign.center),
                                Icon(Icons.mail_outline_rounded,
                                    color: Colors.white)
                              ])))
                ],
              ),
            )));
  }
}
