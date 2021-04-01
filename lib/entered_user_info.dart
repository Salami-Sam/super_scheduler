import 'package:cloud_firestore/cloud_firestore.dart';

///Defines the necessary information a user must enter to
///sign in to an account.
///@author Rudy Fisher
class EnteredSignInInfo {
  final FirebaseFirestore database = FirebaseFirestore.instance;
  String enteredEmail = 'mobiledevsuperscheduler@gmail.com';
  String enteredPassword = '';
}
