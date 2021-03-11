import 'package:flutter/material.dart';
import 'drawer.dart';

/* Screens:
 * My Groups
 * Create Group
 * Join Group
 * Edit Group
 */

class MyGroupsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Groups'),
      ),
      drawer: getUnifiedDrawerWidget(),
      body: Text('Placeholder'),
    );
  }
}

class CreateGroupWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Group'),
      ),
      drawer: getUnifiedDrawerWidget(),
      body: Text('Placeholder'),
    );
  }
}

class JoinGroupWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Join Group'),
      ),
      drawer: getUnifiedDrawerWidget(),
      body: Text('Placeholder'),
    );
  }
}

class EditGroupWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Group: The Krusty Crew'),
      ),
      drawer: getUnifiedDrawerWidget(),
      body: Text('Placeholder'),
    );
  }
}
