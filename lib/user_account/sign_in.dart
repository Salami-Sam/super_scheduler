import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'entered_user_info.dart';
import 'password_textfield.dart';

///Defines the Sign In screen for the app.
///[signUpButtonOnPressedCallback] and
///[signInButtonOnPressedCallback] and
///[forgotPasswordButtonOnPressdCallback] are callbacks
///for this widget's buttons. They should navigate somewhere
///@author: Rudy Fisher
class SignInScreenWidget extends StatefulWidget {
  final Function() signUpButtonOnPressedCallback;
  final Function() signInButtonOnPressedCallback;
  final Function() forgotPasswordButtonOnPressdCallback;

  SignInScreenWidget({
    @required this.signUpButtonOnPressedCallback,
    @required this.signInButtonOnPressedCallback,
    @required this.forgotPasswordButtonOnPressdCallback,
  });

  @override
  _SignInScreenWidgetState createState() => _SignInScreenWidgetState();
}

///The state of the [SignInScreenWidget] widgets of this app.
///@author: Rudy Fisher
class _SignInScreenWidgetState extends State<SignInScreenWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: 16,
        right: 16,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SignInWidget(
            signInButtonOnPressedCallback: widget.signInButtonOnPressedCallback,
          ),
          ElevatedButton(
            child: Text('Sign Up'),
            onPressed: widget.signUpButtonOnPressedCallback,
          ),
          ElevatedButton(
            child: Text('Forgot Password'),
            onPressed: widget.forgotPasswordButtonOnPressdCallback,
          ),
        ],
      ),
    );
  }
}

///Defines a form for the user to sign in to their account.
///[signInButtonOnPressedCallback] is the function called when the user tries
///to sign in. It should navigate to the desired screen.
///@author: Rudy Fisher
class SignInWidget extends StatefulWidget {
  final Function() signInButtonOnPressedCallback;
  final StringByReference email = StringByReference();
  final StringByReference password = StringByReference();
  final FirebaseFirestore db = FirebaseFirestore.instance;

  SignInWidget({@required this.signInButtonOnPressedCallback});

  @override
  _SignInWidgetState createState() => _SignInWidgetState();
}

class _SignInWidgetState extends State<SignInWidget> {
  PasswordFieldWidget passwordFieldWidget;

  ///Shows the [message] in the [SnackBar].
  void showSnackBar({String message}) {
    SnackBar snackbar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 7),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  ///Adds the current user to the Firestore's users collection.
  ///Also see [signIn].
  void addUserToFirestore(DocumentReference docRef) async {
    // Add user to users Firestore collection.
    Map<String, dynamic> data = {
      'userGroups': [],
      'displayName': FirebaseAuth.instance.currentUser.displayName,
    };
    await docRef.set(data);

    // Add sub-collection of notifications to user's document in Firestore
    // with a welcome notification.
    data = {
      'groupId': 'Welcome to Super Scheduler!',
      'content': 'Now you can join and create groups! It\'s a good day!',
      'isInvite': false,
    };

    widget.db
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('notifications')
        .add(data);

    // Add tips and tricks notifications
    data = {
      'groupId': 'Tips & Tricks',
      'content':
          'Long press on the \'For the week\' selector on any schedule screen to return to the current week!',
      'isInvite': false,
    };

    widget.db
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('notifications')
        .add(data);
  }

  ///Signs in the user, making sure they have a document in the users
  ///Firestore collection. If they don't , they are added.
  void signIn() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: widget.email.string,
        password: widget.password.string,
      );
      if (userCredential.user.emailVerified) {
        // Check if user is also in the Firestore.
        DocumentReference docRef = widget.db
            .collection(
              'users',
            )
            .doc(
              '${FirebaseAuth.instance.currentUser.uid}',
            );
        DocumentSnapshot doc = await docRef.get();

        // If user not in Firestore, add them.
        if (!doc.exists) {
          addUserToFirestore(docRef);
        }

        widget.signInButtonOnPressedCallback();
      } else {
        await FirebaseAuth.instance.currentUser.sendEmailVerification();

        showSnackBar(message: 'Please check your email for verification.');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showSnackBar(message: 'No user found with that email.');
      } else if (e.code == 'wrong-password') {
        showSnackBar(message: 'Incorrect password provided for that email');
      } else {
        showSnackBar(
            message: 'Something went wrong. Please make sure' +
                ' your password and email are valid.');
      }
    }
  }

  ///Sets the [passwordFieldWidget] before [build] is called.
  @override
  void initState() {
    super.initState();
    passwordFieldWidget = PasswordFieldWidget(
      password: widget.password,
      obscurePassword: BooleanByReference(boolean: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Email',
            hintText: 'e.g. spongebob@thekrustykrab.net',
          ),
          onChanged: (value) {
            widget.email.string = value;
          },
        ),
        passwordFieldWidget,
        ElevatedButton(
          onPressed: () {
            signIn();
          },
          child: Text('Sign In'),
        ),
      ],
    );
  }
}
