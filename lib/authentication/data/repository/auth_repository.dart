import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:imagemindsapp/authentication/bloc/login_stream.dart';
import 'package:imagemindsapp/authentication/data/models/loginErrorModel.dart';
import 'package:imagemindsapp/authentication/data/models/login_otp_request.dart';
import 'package:imagemindsapp/authentication/data/models/login_request.dart';
import 'package:imagemindsapp/authentication/data/models/login_response.dart';
import 'package:imagemindsapp/authentication/data/models/logout_request.dart';
import 'package:imagemindsapp/authentication/data/models/logout_response.dart';
import 'package:imagemindsapp/authentication/data/models/otplogin_request_model.dart';
import 'package:imagemindsapp/authentication/login/widgets/loginError.dart';
import 'package:imagemindsapp/main.dart';
import 'package:imagemindsapp/repository/repositry.dart';
import 'package:imagemindsapp/utils/shared_pref.dart';

class AuthRepository {
  Future<bool> login(
      {required BuildContext context, required String email, required String password}) async {
    try {
      Map<String, String>? postheaders = {
        'Accept': 'application/json',
        // 'Authorization': 'Bearer ${sharedPref.token}',
      };
      LoginRequest loginRequest = LoginRequest(email: email, password: password);
      final response = await API.post(
          url: 'user/login', body: loginRequest.toJson(), context: context, headers: postheaders);
      log(response.body.toString());
      if (response.statusCode == 200) {
        LoginResponseModel loginResponse = loginResponseModelFromJson(response.body);
        sharedPrefs.setUserDetails(loginResponseModel: loginResponse);
        sharedPref.setLoggedIn();
        sharedPref.setAuthToken(token: "");
        return true;
      } else {
        LoginErrorModel loginError = loginErrorModelFromJson(response.body);
        showloginErrorDialog(context: context, errorMessage: loginError.detail);
        log('filaed 2');
        return false;
      }
    } catch (e) {
      log('filaed 3 $e');
      return false;
    }
  }

//send login otp
  Future<LoginResponseModel?> sendloginOTP(
      {required BuildContext context, required String mobileNo}) async {
    try {
      Map<String, String>? postheaders = {
        'Accept': 'application/json',
        // 'Authorization': 'Bearer ${sharedPref.token}',
      };
      LoginOtpRequestModel loginOtpRequestModel = LoginOtpRequestModel(mobile: mobileNo);
      final response = await API.post(
          url: 'user/login_send_otp',
          body: loginOtpRequestModel.toJson(),
          context: context,
          headers: postheaders);
      log(response.body.toString());
      if (response.statusCode == 200) {
        LoginResponseModel loginOtpResponseModel = loginResponseModelFromJson(response.body);
        return loginOtpResponseModel;
      } else {
        LoginErrorModel loginError = loginErrorModelFromJson(response.body);
        showloginErrorDialog(context: context, errorMessage: loginError.detail);
        log('filaed 2');
        log('filaed 2');
        return null;
      }
    } catch (e) {
      log('filaed 3 $e');
      return null;
    }
  }

  //otp login
  Future<bool> otpLogin(
      {required BuildContext context, required String mobile, required int otp}) async {
    // try {
    Map<String, String>? postheaders = {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
      // 'Authorization': 'Bearer ${sharedPref.token}',
    };
    OtpLoginRequestModel otpLoginRequestModel =
        OtpLoginRequestModel(mobile: mobile.toString(), otp: otp);
    log(otpLoginRequestModelToJson(otpLoginRequestModel));
    final response = await API.post(
        url: 'user/login_otp_verify',
        body: otpLoginRequestModelToJson(otpLoginRequestModel),
        context: context,
        headers: postheaders);
    log(response.body.toString());
    if (response.statusCode == 200) {
      LoginResponseModel loginResponse = loginResponseModelFromJson(response.body);
      sharedPrefs.setUserDetails(loginResponseModel: loginResponse);
      sharedPref.setLoggedIn();
      sharedPref.setAuthToken(token: "");
      return true;
    } else {
      log('filaed 2');
      return false;
    }
    // } catch (e) {
    //   log('filaed 3 $e');
    //   return false;
    // }
  }

  Future<bool> logout({required BuildContext context, required String email}) async {
    try {
      Map<String, String>? postheaders = {
        'Accept': 'application/json',
        // 'Authorization': 'Bearer ${sharedPref.token}',
      };
      LogoutRequest logoutRequest = LogoutRequest(email: email);
      final response = await API.post(
          url: 'user/logout', body: logoutRequest.toJson(), context: context, headers: postheaders);
      log(response.toString());
      if (response.statusCode == 200) {
        LogoutResponse loginResponse = LogoutResponseFromJson(response.body);
        sharedPref.setLoggedOut();
        return true;
      } else {
        log('filaed 2');
        return false;
      }
    } catch (e) {
      log('filaed 3 $e');
      return false;
    }
  }
}
