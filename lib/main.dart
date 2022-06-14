import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:imagemindsapp/authentication/bloc/login_bloc.dart';
import 'package:imagemindsapp/splash.dart';
import 'package:imagemindsapp/subpages/data/bloc/scrre_bloc.dart';
import 'package:imagemindsapp/subpages/data/bloc/vedioScreenBloc.dart';
import 'package:imagemindsapp/utils/shared_pref.dart';

import 'homepage/presentation/homescreen.dart';
import 'package:page_transition/page_transition.dart';

void main() async{
  
  WidgetsFlutterBinding.ensureInitialized();
  await sharedPref.init();
  runApp(const AppProvoder());
}
//config values 
double percen = 0.002;
SharedPref sharedPref = SharedPref();
class AppProvoder extends StatelessWidget {
  const AppProvoder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VedioScreenProvider(
        context: context, child: ScreenNavProvider(context: context, child: LoginProvider(child: MyApp(),)));
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Image Minds',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Splash()

        // AnimatedSplashScreen(
        //   splash: Container(

        //     width: 130,
        //     decoration: BoxDecoration(
        //       color: Colors.white,
        //       borderRadius: BorderRadius.circular(100),
        //     ),
        //     child: Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: Container(
        //         // height: 250,
        //         // width: 100,
        //         decoration: BoxDecoration(

        //             borderRadius: BorderRadius.circular(100),
        //             image: DecorationImage(
        //                 image: AssetImage("assets/images/logo.jpg"), fit: BoxFit.contain)),
        //       ),
        //     ),
        //   ),
        //   nextScreen: HomePage(),
        //   splashTransition: SplashTransition.scaleTransition,
        //   duration: 8,
        //   pageTransitionType: PageTransitionType.bottomToTop,
        //   backgroundColor: Colors.blue,
        // )
        //  HomePage(),
        );
  }
}
