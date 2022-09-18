import 'dart:developer';

import 'package:imagemindsapp/authentication/data/models/login_response.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static SharedPreferences? _sharedPref;
  init() async {
    if (_sharedPref == null) {
      _sharedPref = await SharedPreferences.getInstance();
    }
  }

  //gettter
  bool get loggedIn => _sharedPref!.getBool('loggedIn') ?? false;
  String get id => _sharedPref!.getString('id') ?? "";
  String get email => _sharedPref!.getString('email') ?? "";
  String get firstName => _sharedPref!.getString('firstName') ?? "";
  String get lastName => _sharedPref!.getString('lastName') ?? "";
  String get medium => _sharedPref!.getString('medium') ?? "";
  String? get token => _sharedPref!.getString('authToken');
  String? get password => _sharedPref!.getString('password');
  String? get source => _sharedPref!.getString('source');

  ///Set as logged in
  setLoggedIn() {
    _sharedPref!.setBool('loggedIn', true);
  }

  /// Set as logged out
  setLoggedOut() {
    _sharedPref!.setBool('loggedIn', false);
    setAuthToken(token: "");
    // _sharedPref!.remove('authToken');
  }

  /// Set  user details
  setUserDetails({
    required LoginResponseModel loginResponseModel,
  }) {
    _sharedPref!.setString('id', loginResponseModel.userCode);
    _sharedPref!.setString('email', loginResponseModel.email);
    _sharedPref!.setString('firstName', loginResponseModel.firstName);
    _sharedPref!.setString('lastName', loginResponseModel.lastName);
    _sharedPref!.setString('medium', loginResponseModel.medium);
    _sharedPref!.setString('password', loginResponseModel.password);
  }

  ///set Auth token for the app
  setAuthToken({required String token}) {
    _sharedPref!.setString('authToken', token);
  }
  setVideoSourceType({required String source}) {
    _sharedPref!.setString('source', source);
  }
  
}

final sharedPrefs = SharedPref();
