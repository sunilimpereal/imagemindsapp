import 'package:flutter/material.dart';
import 'package:imagemindsapp/authentication/data/repository/auth_repository.dart';

import '../../../homepage/presentation/homescreen.dart';

showloginErrorDialog(
    {required String errorMessage,
    required String email,
    required String password,
    required BuildContext context}) {
  // set up the button

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return LoginErrorAlert(
        errorMessage: errorMessage,
        email: email,
        password: password,
      );
    },
  );
}

class LoginErrorAlert extends StatelessWidget {
  final String errorMessage;
  final String email;
  final String password;
  const LoginErrorAlert({
    super.key,
    required this.password,
    required this.email,
    required this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    String errorText = "";
    if (errorMessage == "Already Logged In ") {
      errorText = "Your account is already logged in another device.";
    } else {
      errorText = errorMessage;
    }
    Widget okButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget logoutfromotherdevice = TextButton(
      child: Text("Logout from other device"),
      onPressed: () {
        AuthRepository().resetDeviceId(context: context, email: email).then((value) {
          AuthRepository().login(context: context, email: email, password: password).then((value) {
            Future.delayed(const Duration(milliseconds: 200)).then((value1) {
              if (value)
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => HomePageWrapper(),
                    ));
              // setState(() {
              //   loginFailFlag = !value;
              // });
            });
          });
        });
      },
    );
    return AlertDialog(
      title: Text("Login Failed"),
      content: Text("$errorText"),
      actions: [
        logoutfromotherdevice,
        okButton,
      ],
    );
  }
}
