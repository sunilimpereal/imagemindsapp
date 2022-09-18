import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:imagemindsapp/authentication/data/repository/auth_repository.dart';
import 'package:imagemindsapp/main.dart';

import '../authentication/login/login_screen.dart';

Future<String?> getDeviceId() async {
  var deviceInfo = DeviceInfoPlugin();
  if (Platform.isIOS) {
    // import 'dart:io'
    var iosDeviceInfo = await deviceInfo.iosInfo;
    return iosDeviceInfo.identifierForVendor; // unique ID on iOS
  } else if (Platform.isAndroid) {
    var androidDeviceInfo = await deviceInfo.androidInfo;
    return androidDeviceInfo.androidId; // unique ID on Android
  }
}

checkLogin({required BuildContext context}) {
  AuthRepository()
      .login(context: context, email: sharedPref.email, password: sharedPref.password.toString())
      .then((value) {
    if (value) {
    } else {
      sharedPref.setLoggedOut();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginScreen()), (Route<dynamic> route) => false);
    }
  });
}
