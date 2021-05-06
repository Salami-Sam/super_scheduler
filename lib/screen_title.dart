import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// Author: Dylan Schulz
// Gets the title of a screen in the following format:
// screenName: currentGroupRefName
FutureBuilder<DocumentSnapshot> getScreenTitle(
    {@required DocumentReference currentGroupRef, @required String screenName}) {
  return FutureBuilder<DocumentSnapshot>(
    future: currentGroupRef.get(),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Text('$screenName');
      } else if (snapshot.connectionState == ConnectionState.waiting) {
        return Text('$screenName');
      } else {
        var currentGroup = snapshot.data;
        return Text('$screenName: ${currentGroup['name']}');
      }
    },
  );
}
