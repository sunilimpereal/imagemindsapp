import 'package:flutter/material.dart';
import 'package:imagemindsapp/authentication/login/login_screen.dart';
import 'package:imagemindsapp/homepage/presentation/homescreen.dart';
import 'package:imagemindsapp/main.dart';
import 'package:imagemindsapp/utils/shared_pref.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 3)).then((value) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => sharedPref.loggedIn ? HomePageWrapper() : LoginScreen(),
        ),
      );
    });
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      setState(() {
        size = end;
      });
    });
    super.initState();
  }

  static int start = 100;
  static int end = 250;
  int size = start;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        image: DecorationImage(image: AssetImage('assets/images/main-bg.jpg'), fit: BoxFit.cover),
      ),
      child: Center(
        child: AnimatedContainer(
          width: size.toDouble(),
          height: size.toDouble(),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(1000),
              image: DecorationImage(
                image: AssetImage("assets/images/logo.jpg"),
                fit: BoxFit.contain,
              )),
          duration: Duration(seconds: 2),
        ),
      ),
    );
  }
}
