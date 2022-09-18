import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:imagemindsapp/homepage/Widget/maintile.dart';
import 'package:imagemindsapp/main.dart';
import 'package:imagemindsapp/subpages/grade/data/repository/grade_bloc.dart';
import 'package:imagemindsapp/subpages/main_sub_page.dart';
import 'package:imagemindsapp/subpages/data/bloc/scrre_bloc.dart';
import 'package:imagemindsapp/subpages/data/bloc/vedioScreenBloc.dart';

import '../../utils/methods.dart';

class HomePageWrapper extends StatelessWidget {
  const HomePageWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GradeProvider(
      context: context,
      child: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        checkLogin(context: context);
      print("asdas"+ sharedPref.password.toString());
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              // ignore: prefer_const_constructors
              decoration: BoxDecoration(
                  color: Colors.red,
                  image: const DecorationImage(
                    image: AssetImage(
                      'assets/images/main-bg.jpg',
                    ),
                    fit: BoxFit.fill,
                  )),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MainTile(
                        img: Image.asset('assets/images/menu-icon1.png'),
                        title: 'PROFILE',
                        onTap: () {
                          ScreenNavProvider.of(context).updateSelectedScreen(Screens.profile);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SubPage(
                                        text: 'PROFILE',
                                      )));
                        },
                      ),
                      MainTile(
                        img: Image.asset('assets/images/menu-icon2.png'),
                        title: 'PROGRAMS',
                        onTap: () {
                          ScreenNavProvider.of(context).updateSelectedScreen(Screens.programs);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SubPage(
                                        text: 'PROGRAMS',
                                      )));
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MainTile(
                        img: Image.asset('assets/images/menu-icon3.png'),
                        title: 'ASSESSMENT',
                        onTap: () {
                          ScreenNavProvider.of(context).updateSelectedScreen(Screens.assessment);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SubPage(
                                        text: 'ASSESSMENT',
                                      )));
                        },
                      ),
                      MainTile(
                        img: Image.asset('assets/images/menu-icon4.png'),
                        title: 'LIVECLASS',
                        onTap: () {
                          ScreenNavProvider.of(context).updateSelectedScreen(Screens.liveclasses);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SubPage(
                                        text: 'LIVECLASS',
                                      )));
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: -1,
              left: 20,
              child: Image.asset(
                'assets/images/logo.jpg',
                height: MediaQuery.of(context).size.width * 0.12,
                width: MediaQuery.of(context).size.width * 0.2,
              ),
            ),
            Positioned(
              bottom: 10,
              right: 20,
              child: InkWell(
                onTap: () {},
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Image.asset(
                    'assets/images/question-mark-draw.png',
                    height: MediaQuery.of(context).size.width * 0.12,
                    width: MediaQuery.of(context).size.width * 0.2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
