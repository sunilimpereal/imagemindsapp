import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:imagemindsapp/authentication/bloc/login_bloc.dart';
import 'package:imagemindsapp/authentication/data/models/login_response.dart';
import 'package:imagemindsapp/authentication/data/repository/auth_repository.dart';
import 'package:imagemindsapp/authentication/login/login_screen.dart';
import 'package:imagemindsapp/authentication/login/widgets/button.dart';
import 'package:imagemindsapp/authentication/login/widgets/text_field.dart';
import 'package:imagemindsapp/constants/app_fonts.dart';
import 'package:imagemindsapp/homepage/presentation/homescreen.dart';

enum LoginOtpStates { mobileNo, otp }

class LoginScreenOTP extends StatefulWidget {
  const LoginScreenOTP({Key? key}) : super(key: key);

  @override
  State<LoginScreenOTP> createState() => _LoginScreenOTPState();
}

class _LoginScreenOTPState extends State<LoginScreenOTP> {
  TextEditingController mobileNoController = TextEditingController();
  FocusNode mobileNoFocus = FocusNode();
  TextEditingController otpController = TextEditingController();
  FocusNode otpFocus = FocusNode();
  bool loginFailFlag = false;
  bool sendotpFailFalg = false;
  ontap() {
    setState(() {});
  }

  LoginOtpStates loginOtpState = LoginOtpStates.mobileNo;
  int otp = 0;
  @override
  Widget build(BuildContext context) {
    LoginBloc? loginBloc = LoginProvider.of(context);
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(image: AssetImage('assets/images/main-bg.jpg'), fit: BoxFit.cover),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 10,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.height * 0.25,
                decoration: BoxDecoration(
                    color: Colors.red,
                    image: const DecorationImage(
                      image: AssetImage(
                        'assets/images/logo.jpg',
                      ),
                      fit: BoxFit.fill,
                    )),
              ),
            ),
            Center(
              child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),
                      Text(
                        "Sign In",
                        textScaleFactor: 1,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: AppFonts.kidsFont,
                        ),
                      ),
                      loginOtpState == LoginOtpStates.mobileNo
                          ? mobileNo(loginBloc)
                          : verifyOtp(loginBloc)
                    ],
                  )),
            ),
          ],
        ),
      ),
    ));
  }

  Widget mobileNo(LoginBloc? loginBloc) {
    return Column(children: [
      Column(
        children: [
          // email id
          IMTextField(
            width: 300,
            controller: mobileNoController,
            focusNode: mobileNoFocus,
            icon: Icons.phone,
            labelText: 'Phone Number',
            onChanged: loginBloc!.changeMobNo,
            onfocus: mobileNoFocus.hasFocus,
            onTap: ontap,
            stream: loginBloc.mobileNo,
            heading: 'Phone Number',
            keyboardType: TextInputType.number,
          ),
        ],
      ),

      //button
      IMStreamButton(
        width: MediaQuery.of(context).size.width > 700
            ? MediaQuery.of(context).size.width * 0.15
            : MediaQuery.of(context).size.width * 0.235,
        formValidationStream: loginBloc.validateFormMobStream,
        submit: () async {
          // send otp
          AuthRepository authRepository = AuthRepository();
          authRepository
              .sendloginOTP(context: context, mobileNo: mobileNoController.text)
              .then((value) {
            if (value != null) {
              LoginResponseModel loginOtpResponseModel = value;
              setState(() {
                loginOtpState = LoginOtpStates.otp;
                otp = loginOtpResponseModel.otp;
              });
            } else {
              log("asdasd");
              setState(() {
                sendotpFailFalg = !sendotpFailFalg;
              });
            }
          });
        },
        text: 'Send OTP',
        errrorText: 'Failed to Send OTP',
        errorFlag: sendotpFailFalg,
      ),
      SizedBox(
        height: 16,
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(height: 1, width: MediaQuery.of(context).size.width / 7, color: Colors.white),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Or",
                style: TextStyle(color: Colors.white),
              ),
            ),
            Container(height: 1, width: MediaQuery.of(context).size.width / 7, color: Colors.white)
          ],
        ),
      ),
      GestureDetector(
        onTap: () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
        },
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              border: Border.all(width: 1, color: Colors.white)),
          child: Text(
            "Login with Email",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: AppFonts.kidsFont,
            ),
          ),
        ),
      ),
    ]);
  }

  Widget verifyOtp(LoginBloc? loginBloc) {
    return Column(children: [
      Column(
        children: [
          // email id
          IMTextField(
            width: 300,
            controller: otpController,
            focusNode: otpFocus,
            icon: Icons.phone,
            labelText: 'OTP',
            onChanged: loginBloc!.changeOtp,
            onfocus: otpFocus.hasFocus,
            onTap: ontap,
            stream: loginBloc.otp,
            heading: 'OTP',
            keyboardType: TextInputType.number,
          ),
        ],
      ),

      //button
      IMStreamButton(
        width: MediaQuery.of(context).size.width > 700
            ? MediaQuery.of(context).size.width * 0.15
            : MediaQuery.of(context).size.width * 0.235,
        formValidationStream: loginBloc.validateFormMobStream,
        submit: () async {
          // send otp
          AuthRepository authRepository = AuthRepository();
          authRepository
              .otpLogin(
            mobile: mobileNoController.text.toString(),
            otp: int.parse(otpController.text),
            context: context,
          )
              .then((value) {
            Future.delayed(const Duration(milliseconds: 200)).then((value1) {
              if (value) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (BuildContext context) => HomePageWrapper()));
              } else {
                setState(() {
                  loginFailFlag = !value;
                });
              }
            });
          });
        },
        text: 'LOGIN',
        errrorText: 'OTP Verification Failed',
        errorFlag: loginFailFlag,
      ),
      GestureDetector(
        onTap: () {
          // resend otp
          AuthRepository authRepository = AuthRepository();
          authRepository
              .sendloginOTP(context: context, mobileNo: mobileNoController.text)
              .then((value) {
            if (value != null) {
              LoginResponseModel loginOtpResponseModel = value;
              setState(() {
                loginOtpState = LoginOtpStates.otp;
                otp = loginOtpResponseModel.otp;
              });
            } else {
              log("asdasd");
              setState(() {
                sendotpFailFalg = !sendotpFailFalg;
              });
            }
          });
        },
        child: Text(
          "Resend OTP",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: AppFonts.kidsFont,
          ),
        ),
      )
    ]);
  }
}
