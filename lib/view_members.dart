import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'main.dart';

/* Screen:
 * View Members
 * 
 * Writen by Mike Schommer
 * version 2.0
 * 4/14/21
 */

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

/* ViewMembersWidget is a screen that displays members of a particular group
 */
class ViewMembersWidget extends StatefulWidget {
  @override
  _ViewMembersWidgetState createState() => _ViewMembersWidgetState();
}

class _ViewMembersWidgetState extends State<ViewMembersWidget> {
  Future<Map> futureMembers;

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
        body: FutureBuilder<Map>(
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
                        title: Text('${names[index]}'),
                        subtitle: Text('${roles[index]}'),
                      ),
                  separatorBuilder: (context, int) =>
                      Divider(thickness: 1.0, height: 1.0),
                  itemCount: roles.length);
            }));
  }
}

Drawer getUnifiedDrawerWidget() {
  return Drawer(
    child: Text('Drawer placeholder'),
  );
}

