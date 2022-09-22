import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:imagemindsapp/constants/app_fonts.dart';
import 'package:imagemindsapp/homepage/Widget/menu_dropdown.dart';
import 'package:imagemindsapp/profile/profile_screen.dart';
import 'package:imagemindsapp/subpages/grade/data/repository/grade_bloc.dart';
import 'package:imagemindsapp/subpages/grade/screens/grades.dart';
import 'package:imagemindsapp/subpages/grade/screens/videos_screen.dart';
import 'package:imagemindsapp/subpages/data/bloc/scrre_bloc.dart';
import 'package:imagemindsapp/subpages/data/bloc/vedioScreenBloc.dart';
import 'package:permission_handler/permission_handler.dart';
import '../main.dart';
import '../utils/methods.dart';

class SubPage extends StatefulWidget {
  final String text;
  const SubPage({Key? key, required this.text}) : super(key: key);

  @override
  _SubPageState createState() => _SubPageState();
}

class _SubPageState extends State<SubPage> {
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      checkLogin(context: context);
      print("asdas" + sharedPref.password.toString());
      var status = await Permission.storage.status;
                  if (!status.isGranted) {
                    await Permission.storage.request();
                  }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.002;
    double height = MediaQuery.of(context).size.height * 0.002;
    return GradeProvider(
      context: context,
      child: Scaffold(
        body: StreamBuilder<Screens>(
            stream: ScreenNavProvider.of(context).selectedScreenStream,
            builder: (context, snapshot) {
              return Container(
                child: Stack(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width * width,
                        child: screen(snapshot.data ?? Screens.home)),
                    snapshot.data == Screens.profile
                        ? Container()
                        : Positioned(
                            top: -10,
                            left: 0,
                            right: 0,
                            child: Image.asset(
                              'assets/images/head-strip.png',
                              height: MediaQuery.of(context).size.width *
                                  (snapshot.data == Screens.profile ? 0.24 : 0.12),
                              width: MediaQuery.of(context).size.width * 0.2,
                              fit: BoxFit.cover,
                            ),
                          ),
                    snapshot.data == Screens.profile
                        ? Container()
                        : Positioned(
                            top: -10,
                            left: 10,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/logo.jpg',
                                  height: MediaQuery.of(context).size.width * 0.10,
                                  width: MediaQuery.of(context).size.width * 0.15,
                                ),
                                snapshot.data == Screens.programs
                                    ? Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Row(children: [
                                          SizedBox(
                                            width: 16,
                                          ),
                                          Text(
                                            "PROGRAMS ",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: AppFonts.roboto,
                                                color: Colors.white),
                                          )
                                        ]),
                                      )
                                    : Container(),
                                StreamBuilder<List<String>>(
                                    stream: VedioScreenProvider.of(context).selectedCourseStream,
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) return Container();
                                      if (snapshot.data!.isEmpty) return Container();
                                      return Padding(
                                        // padding:  EdgeInsets.only(bottom:MediaQuery.of(context).size.height * 0.13,left: 8),
                                        padding: EdgeInsets.all(4),

                                        child: Row(
                                          children: [
                                            Text(
                                              "${snapshot.data![0]} - ",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: AppFonts.roboto,
                                                  color: Color(0xffffdd6e)),
                                            ),
                                            Text(
                                              "${snapshot.data![1]}",
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: AppFonts.roboto,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    })
                              ],
                            ),
                          ),
                    snapshot.data == Screens.profile
                        ? Container()
                        : Positioned(
                            top: MediaQuery.of(context).size.height * 0.06,
                            right: 30,
                            child: MenuDropDown()),
                  ],
                ),
              );
            }),
      ),
    );
  }

  Widget screen(Screens screen) {
    switch (screen) {
      case Screens.programs:
        return GradesScreen();
      case Screens.profile:
        return ProfileScreen();
      case Screens.videos:
        return VideosScreen();

      default:
        return Center(
          child: Text(
            "${getScreenName(screen)}",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
    }
  }
}
