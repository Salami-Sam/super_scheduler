import 'package:flutter/material.dart';
import 'drawer.dart';

/* Screens:
 * My Account
 * Change Name / Email / Password
 * Are You Sure? (Delete Account)
 */

class MyAccountWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Account'),
      ),
      drawer: getUnifiedDrawerWidget(),
      body: Text('Placeholder'),
    );
  }
}

class ChangeInfoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Info'),
      ),
      drawer: getUnifiedDrawerWidget(),
      body: Text('Placeholder'),
    );
  }
}

class DeleteAccountWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delete Account'),
      ),
      drawer: getUnifiedDrawerWidget(),
      body: Text('Are you sure? / Delete Account placeholder'),
    );
  }
}
