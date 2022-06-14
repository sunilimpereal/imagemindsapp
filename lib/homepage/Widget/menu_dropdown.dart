import 'package:flutter/material.dart';
import 'package:imagemindsapp/authentication/data/repository/auth_repository.dart';
import 'package:imagemindsapp/constants/app_fonts.dart';
import 'package:imagemindsapp/constants/colors.dart';
import 'package:imagemindsapp/subpages/data/bloc/scrre_bloc.dart';
import 'package:imagemindsapp/subpages/data/bloc/vedioScreenBloc.dart';

import '../../authentication/login/login_screen.dart';
import '../../main.dart';

class MenuDropDown extends StatefulWidget {
  const MenuDropDown({Key? key}) : super(key: key);

  @override
  _MenuDropDownState createState() => _MenuDropDownState();
}

class _MenuDropDownState extends State<MenuDropDown> {
  String selected = "";

  bool opened = false;
  OverlayEntry? entry;
  final layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
  }

  showOverlay() {
    double width = MediaQuery.of(context).size.width * 0.002;
    double height = MediaQuery.of(context).size.height * 0.002;

    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    entry = OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          setState(() {
            opened = !opened;
          });

          hideOverlay();
        },
        child: Container(
          color: Colors.transparent,
          child: Stack(
            children: [
              Positioned(
                width: 180 * width,
                child: CompositedTransformFollower(
                    link: layerLink,
                    offset: Offset(-180, size.height * height),
                    showWhenUnlinked: false,
                    child: buildOverlay()),
              ),
            ],
          ),
        ),
      ),
    );
    overlay?.insert(entry!);
  }

  void hideOverlay() {
    entry?.remove();
    entry = null;
  }

  Widget buildOverlay() {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Material(
        elevation: 8,
        shadowColor: Colors.white,
        child: Container(
          width: 100,
          color: Colors.red,
          child: Menulist(
            exitontap: () {
              setState(() {
                hideOverlay();
                opened = !opened;
              });
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
        link: layerLink,
        child: Container(
            width: 48,
            height: 48,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                1100,
              ),
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(0), primary: AppColors.menuButtonColor),
              child: Icon(
                !opened ? Icons.menu : Icons.close,
                size: 32,
              ),
              onPressed: () {
                setState(() {
                  opened = !opened;

                  showOverlay();
                });
              },
            )));
  }
}

class Menulist extends StatefulWidget {
  Function exitontap;
  Menulist({Key? key, required this.exitontap}) : super(key: key);

  @override
  State<Menulist> createState() => _MenulistState();
}

class _MenulistState extends State<Menulist> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          menuItem(name: 'Profile', screen: Screens.profile),
          menuItem(name: 'Programs', screen: Screens.programs),
          menuItem(name: 'Assessment', screen: Screens.assessment),
          menuItem(name: 'Live Classes', screen: Screens.liveclasses),
          menuItem(name: 'Support/help', screen: Screens.support_help),
          menuItem(
              name: 'Logout',
              screen: Screens.support_help,
              function: () {
               
                AuthRepository authRepository = AuthRepository();
                authRepository
                    .logout(
                  email: sharedPref.email,
                  context: context,
                )
                    .then(
                  (value) {
                     widget.exitontap();
                    sharedPref.setLoggedOut();
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                        (Route<dynamic> route) => false);
                  },
                );
              }),
        ],
      ),
    );
  }

  Widget menuItem({required String name, required Screens screen, Function? function}) {
    double width = MediaQuery.of(context).size.width * 0.002;
    double height = MediaQuery.of(context).size.height * 0.002;
    return Material(
      color: AppColors.menuBackgroundColor,
      child: Column(
        children: [
          InkWell(
            splashColor: Colors.red,
            highlightColor: AppColors.menuBackgroundColor.withOpacity(0.2),
            onTap: () {
              if (function == null) {
                widget.exitontap();
                ScreenNavProvider.of(context).updateSelectedScreen(screen);
                VedioScreenProvider.of(context).updateSelectedScreen(grade: "", course: "");
              } else {
                function();
              }
            },
            child: Padding(
              padding: EdgeInsets.all(16.0 * height),
              child: Row(
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontFamily: AppFonts.cronusRound,
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            height: 1,
            color: Colors.white,
          )
        ],
      ),
    );
  }
}
