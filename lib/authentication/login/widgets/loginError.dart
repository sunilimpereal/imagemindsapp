import 'package:flutter/material.dart';

showloginErrorDialog({required String errorMessage, required BuildContext context}) {
  // set up the button

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return LoginErrorAlert(
        errorMessage: errorMessage,
      );
    },
  );
}

class LoginErrorAlert extends StatelessWidget {
  final String errorMessage;
  const LoginErrorAlert({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    String errorText = "";
    if(errorMessage == "Already Logged In "){
      errorText = "Your account is already logged in another device.";
    }else{
      errorText = errorMessage;
    }
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    return AlertDialog(
      title: Text("Login Failed"),
      content: Text("$errorText"),
      actions: [
        okButton,
      ],
    );
  }
}
