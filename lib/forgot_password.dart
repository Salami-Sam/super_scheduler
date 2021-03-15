import 'package:flutter/material.dart';

///Defines a screen that allows the user to request a temporary password
///be sent to the provided email when they forgot their password
///@author: Rudy Fisher
class ForgotPasswordWidget extends StatefulWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  _ForgotPasswordWidgetState createState() => _ForgotPasswordWidgetState();
}

class _ForgotPasswordWidgetState extends State<ForgotPasswordWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: widget._formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'e.g. spongebob@thekrustykrab.com',
                ),
                validator: (value) {
                  if (value.isNotEmpty) {
                    // TODO: return a string to somewhere
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  //TODO: submit the form
                },
                child: Text('Send Temperary Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
