import 'package:flutter/material.dart';
import 'package:super_scheduler/about.dart';
import 'package:super_scheduler/my_account.dart';
import 'package:super_scheduler/notifications.dart';

import 'drawer.dart';
import 'forgot_password.dart';
import 'group_management.dart';
import 'sign_in.dart';
import 'sign_up.dart';

class SuperSchedulerApp extends StatefulWidget {
  @override
  _SuperSchedulerAppState createState() {
    //TODO: Check if user is signed in when app is opened.
    //  if so, skip the login screen and go to My Groups screen
    //  this only assigns the initial app screen
    return _SuperSchedulerAppState(userIsSignedIn: false);
  }
}

///This is where the most top-level screens will transition.
class _SuperSchedulerAppState extends State<SuperSchedulerApp> {
  Widget currentBodyWidget;
  bool userIsSignedIn = false;
  String title = 'Sign In';

  ///Rebuilds this state's widget tree with a [SignUpWidget] assigned to its
  ///[Scaffold]'s body.
  //////This method can be given to children widgets as
  ///callbacks to navigate to the Sign Up page without having push/pop
  ///capabilities, when it makes sense to do so.
  void _goToSignUpScreen() {
    setState(() {
      currentBodyWidget = SignUpWidget(
        signInButtonCallBack: _goToSignInScreen,
        signUpButtonCallBack: _goToMyGroupsScreen,
      );
      title = 'Sign Up';
    });
  }

  ///Rebuilds this state's widget tree with a [SignInWidget] assigned to its
  ///[Scaffold]'s body. This also sets [userIsSignedIn] to true.
  ///This method can be given to children widgets as
  ///callbacks to navigate to the Sign In page without having push/pop
  ///capabilities, when it makes sense to do so.
  void _goToSignInScreen() {
    setState(() {
      currentBodyWidget = SignInWidget(
        signInButtonOnPressdCallback: _goToMyGroupsScreen,
        signUpButtonOnPressdCallback: _goToSignUpScreen,
        forgotPasswordButtonOnPressdCallback: _goToForgotPasswordScreen,
      );
      title = 'Sign In';
      userIsSignedIn = false;
    });
  }

  void _goToForgotPasswordScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ForgotPasswordWidget(),
      ),
    );
  }

  ///Rebuilds this state's widget tree with a [MyGroupsWidget] assigned to its
  ///[Scaffold]'s body. This also sets [userIsSignedIn] to true.
  ///This method can be given to children widgets as
  ///callbacks to navigate to the My Groups page without having push/pop
  ///capabilities, when it makes sense to do so.
  void _goToMyGroupsScreen() {
    setState(() {
      currentBodyWidget = MyGroupsWidget();
      title = 'My Groups';
      userIsSignedIn = true;
    });
  }

  void _goToMyAccountScreen() {
    setState(() {
      currentBodyWidget = MyAccountWidget();
      title = 'My Account';
    });
  }

  void _goToNotificationScreen() {
    setState(() {
      currentBodyWidget = NotificationsWidget();
      title = 'Notifications';
    });
  }

  ///Sets the initial screen of the app based on whether
  ///the user is signed in or not. If [userIsSignedIn]
  ///then the screen will be the [MyGroupsWidget],
  ///otherwise it will show [SignInWidget].
  ///(This is a constructor.)
  _SuperSchedulerAppState({this.userIsSignedIn}) {
    if (userIsSignedIn) {
      currentBodyWidget = MyGroupsWidget();
    } else {
      currentBodyWidget = SignInWidget(
        signUpButtonOnPressdCallback: _goToSignUpScreen,
        signInButtonOnPressdCallback: _goToMyGroupsScreen,
        forgotPasswordButtonOnPressdCallback: _goToForgotPasswordScreen,
      );
    }
  }

  ///Defines this app's drawer menu used for easy navigation.
  ///This drawer will be available from most screens in the app.
  ///If [userIsSignedIn] is true, the full menu will display,
  ///otherwise, only a button to the app's "About" screen
  ///will be available. For now, default is true.
  Drawer _getUnifiedDrawerWidget({bool userIsSignedIn = true}) {
    List<DrawerButtonWidget> drawerButtons;

    if (userIsSignedIn != null && userIsSignedIn) {
      drawerButtons = [
        DrawerButtonWidget(
          buttonLabel: 'My Groups',
          navigationCallBack: _goToMyGroupsScreen,
        ),
        DrawerButtonWidget(
          buttonLabel: 'Notifications',
          pushToWidget: null,
          navigationCallBack: _goToNotificationScreen,
        ),
        DrawerButtonWidget(
          buttonLabel: 'My Account',
          pushToWidget: null,
          navigationCallBack: _goToMyAccountScreen,
        ),
        DrawerButtonWidget(
          buttonLabel: 'About',
          pushToWidget: AboutWidget(),
        ),
        DrawerButtonWidget(
          buttonLabel: 'Logout',
          navigationCallBack: _goToSignInScreen,
        ),
      ];
    } else {
      drawerButtons = [
        DrawerButtonWidget(
          buttonLabel: 'About',
          pushToWidget: AboutWidget(),
          navigationCallBack: null,
        ),
      ];
    }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: currentBodyWidget,
      drawer: _getUnifiedDrawerWidget(
        userIsSignedIn: userIsSignedIn,
      ),
    );
  }
}
