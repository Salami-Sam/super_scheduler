import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:super_scheduler/about.dart';
import 'package:super_scheduler/user_account_widgets/my_account.dart';
import 'package:super_scheduler/notifications.dart';

import 'drawer.dart';
import 'forgot_password.dart';
import 'group_management.dart';
import 'user_account/sign_in.dart';
import 'user_account/sign_up.dart';

///The app's main/home widget, placed just under the app's root in the tree
///@author: Rudy Fisher
class SuperSchedulerApp extends StatefulWidget {
  @override
  _SuperSchedulerAppState createState() {
    return _SuperSchedulerAppState();
  }
}

///This is where the most top-level screens will transition.
class _SuperSchedulerAppState extends State<SuperSchedulerApp> {
  Widget currentBodyWidget;
  String title = 'Sign In';

  ///Sets the initial screen of the app based on whether
  ///the user is signed in or not. If [userIsSignedIn]
  ///then the screen will be the [MyGroupsWidget],
  ///otherwise it will show [SignInScreenWidget].
  ///(This is a constructor.)
  _SuperSchedulerAppState() {
    if (FirebaseAuth.instance.currentUser != null) {
      currentBodyWidget = MyGroupsWidget();
      title = 'My Groups';
    } else {
      currentBodyWidget = SignInScreenWidget(
        signUpButtonOnPressdCallback: _goToSignUpScreen,
        signInButtonOnPressdCallback: _goToMyGroupsScreen,
        forgotPasswordButtonOnPressdCallback: _goToForgotPasswordScreen,
      );
    }
  }

  ///Rebuilds this state's widget tree with a [SignUpScreenWidget] assigned to its
  ///[Scaffold]'s body.
  //////This method can be given to children widgets as
  ///callbacks to navigate to the Sign Up page without having push/pop
  ///capabilities, when it makes sense to do so.
  void _goToSignUpScreen() {
    setState(() {
      currentBodyWidget = SignUpScreenWidget(
        signInButtonCallBack: _goToSignInScreen,
        signUpButtonCallBack: _goToSignInScreen,
      );
      title = 'Sign Up';
    });
  }

  ///Rebuilds this state's widget tree with a [SignInScreenWidget] assigned to its
  ///[Scaffold]'s body. This also sets [userIsSignedIn] to true.
  ///This method can be given to children widgets as
  ///callbacks to navigate to the Sign In page without having push/pop
  ///capabilities, when it makes sense to do so.
  void _goToSignInScreen() {
    // Sign out the user if they are signed in
    if (FirebaseAuth.instance.currentUser != null) {
      FirebaseAuth.instance.signOut();
    }

    setState(() {
      currentBodyWidget = SignInScreenWidget(
        signInButtonOnPressdCallback: _goToMyGroupsScreen,
        signUpButtonOnPressdCallback: _goToSignUpScreen,
        forgotPasswordButtonOnPressdCallback: _goToForgotPasswordScreen,
      );
      title = 'Sign In';
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
        userIsSignedIn: FirebaseAuth.instance.currentUser != null,
        // Pass in whether a signed in user exists.
      ),
    );
  }
}
