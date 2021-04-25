import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'edit_individual.dart';
import 'edit_roles.dart';
import 'invite_member.dart';
import 'main.dart';

/* Screen:
 * Edit Members
 * 
 * Writen by Mike Schommer
 * version 2.0
 * 4/14/21
 */

List permissions = ['Member', 'Manager', 'Admin'];
var db = FirebaseFirestore.instance;
CollectionReference group = db.collection('groups');

Future<Map> getMembers() async {
  Map returnMap;
  await group.doc('PCXUSOFVGcmZ8UqK0QnX').get().then((docref) {
    if (docref.exists) {
      returnMap = docref['Members'];
      print(returnMap);
    } else {
      print("Error, name not found");
    }
  });
  return returnMap;
}

Future<void> deleteMember(var memberToRemove) async {
  print(memberToRemove);
  await group
      .doc('PCXUSOFVGcmZ8UqK0QnX')
      .update({'Members.${memberToRemove}': FieldValue.delete()});
}

/* EditMemberWidget screen acts like the "main" screen for most member management 
 * screens as it acts as a jumping off point to all other member management screens
 * EditMemberWidget can also allow admins to be able to delete members from group
 * 
 * todo: Should NOT be able to be accessed by members, only admins 
*/
class EditMemberWidget extends StatefulWidget {
  @override
  _EditMemberWidgetState createState() => _EditMemberWidgetState();
}

class _EditMemberWidgetState extends State<EditMemberWidget> {
  Future<Map> futureMembers;
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
              child: FutureBuilder<Map>(
                  future: futureMembers = getMembers(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error');
                    }
                    Map members = snapshot.data;
                    List names = members.keys.toList();
                    List roles = members.values.toList();
                    return ListView.separated(
                        itemBuilder: (context, index) => ListTile(
                            leading: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  deleteMember(names[index]);
                                  setState(() {
                                    names.length;
                                  });
                                }),
                            title: Text('${names[index]}'),
                            subtitle: Text('${roles[index]}'),
                            trailing: IconButton(
                                icon: Icon(Icons.more_vert),
                                onPressed: () {
                                  Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EditIndividualMemberWidget(
                                                      index: index,
                                                      members: members)))
                                      .then((value) {
                                    setState(() {});
                                  });
                                })),
                        separatorBuilder: (context, int) =>
                            Divider(thickness: 1.0, height: 1.0),
                        itemCount: names.length);
                  })),
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

Drawer getUnifiedDrawerWidget() {
  return Drawer(
    child: Text('Drawer placeholder'),
  );
}
