import 'package:flutter/material.dart';

///Defines this app's drawer menu used for easy navigation.
///This drawer will be available from most screens in the app.
///If [userIsSignedIn] is true, the full menu will display,
///otherwise, only a button to the app's "About" screen
///will be available. For now, default is true.
Drawer getUnifiedDrawerWidget() {
  List<DrawerButtonWidget> drawerButtons;
  drawerButtons = [
    DrawerButtonWidget(
      buttonLabel: 'My Groups',
      navigationCallBack: null,
    ),
    DrawerButtonWidget(
      buttonLabel: 'Notifications',
      pushToWidget: null,
      navigationCallBack: null,
    ),
    DrawerButtonWidget(
      buttonLabel: 'Account',
      pushToWidget: null,
      navigationCallBack: null,
    ),
    DrawerButtonWidget(
      buttonLabel: 'About',
      pushToWidget: null,
      navigationCallBack: null,
    ),
    DrawerButtonWidget(
      buttonLabel: 'Logout',
      navigationCallBack: null,
    ),
  ];

  return Drawer(
    child: Container(
      margin: EdgeInsets.only(
        top: 32,
        bottom: 32,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: drawerButtons,
      ),
    ),
  );
}

///Defines the buttons used in this app's drawer menu.
///When one of these are pressed, and [pushToWidget]
///is valid and not null, it will navigate to
///[pushToWidget].
///The [buttonLabel] should be the name of the
///[pushToWidget] that the user would understand.
class DrawerButtonWidget extends StatelessWidget {
  final String buttonLabel;
  final Function() navigationCallBack;
  final Widget pushToWidget;

  DrawerButtonWidget({
    this.buttonLabel = 'replace me',
    this.pushToWidget,
    this.navigationCallBack,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (navigationCallBack != null) {
          navigationCallBack();
        } else if (pushToWidget != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => pushToWidget),
          );
        }
      },
      child: Text(
        buttonLabel,
        style: TextStyle(
          fontSize: 18.0,
        ),
      ),
    );
  }
}
