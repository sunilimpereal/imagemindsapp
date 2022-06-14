import 'package:flutter/material.dart';
import 'package:imagemindsapp/authentication/bloc/login_bloc.dart';
import 'package:imagemindsapp/authentication/data/repository/auth_repository.dart';
import 'package:imagemindsapp/authentication/login/login_screen_otp.dart';
import 'package:imagemindsapp/authentication/login/widgets/button.dart';
import 'package:imagemindsapp/authentication/login/widgets/text_field.dart';
import 'package:imagemindsapp/constants/app_fonts.dart';
import 'package:imagemindsapp/homepage/presentation/homescreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  bool loginFailFlag = false;
  ontap() {
    setState(() {});
  }

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
                      SizedBox(
                        height: 0,
                      ),
                      Column(children: [
                        Column(
                          children: [
                            // email id
                            IMTextField(
                              width: 300,
                              controller: emailController,
                              focusNode: emailFocus,
                              icon: Icons.email,
                              labelText: 'Email',
                              onChanged: loginBloc!.changeEmail,
                              onfocus: emailFocus.hasFocus,
                              onTap: ontap,
                              stream: loginBloc.email,
                              heading: 'Email',
                            ),
                            // password
                            IMTextField(
                              width: 300,
                              controller: passwordController,
                              focusNode: passwordFocus,
                              icon: Icons.email,
                              labelText: 'Password',
                              onChanged: loginBloc.changePassword,
                              onfocus: passwordFocus.hasFocus,
                              onTap: ontap,
                              stream: loginBloc.password,
                              obscureText: true,
                              heading: 'Password',
                            ),
                          ],
                        ),

                        //button
                        IMStreamButton(
                          width: MediaQuery.of(context).size.width > 700
                              ? MediaQuery.of(context).size.width * 0.15
                              : MediaQuery.of(context).size.width * 0.235,
                          formValidationStream: loginBloc.validateFormStream,
                          submit: () async {
                            AuthRepository authRepository = AuthRepository();
                            authRepository
                                .login(
                              email: emailController.text,
                              password: passwordController.text,
                              context: context,
                            )
                                .then((value) {
                              Future.delayed(const Duration(milliseconds: 200)).then((value1) {
                                if (value)
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) => HomePageWrapper()));
                                setState(() {
                                  loginFailFlag = !value;
                                });
                              });
                            });
                          },
                          text: 'Enter',
                          errrorText: 'Sign In Failed',
                          errorFlag: loginFailFlag,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  height: 1,
                                  width: MediaQuery.of(context).size.width / 7,
                                  color: Colors.white),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Or",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              Container(
                                height: 1,
                                width: MediaQuery.of(context).size.width / 7,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) => LoginScreenOTP()));
                          },
                          child: Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(32),
                                border: Border.all(width: 1, color: Colors.white)),
                            child: Text(
                              "Login with Mobile Number",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: AppFonts.kidsFont,
                              ),
                            ),
                          ),
                        )
                      ]),
                    ],
                  )),
            ),
          ],
        ),
      ),
    ));
  }
}
