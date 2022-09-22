import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:imagemindsapp/authentication/bloc/login_bloc.dart';
import 'package:imagemindsapp/authentication/data/repository/auth_repository.dart';
import 'package:imagemindsapp/authentication/login/login_screen.dart';
import 'package:imagemindsapp/main.dart';
import 'package:imagemindsapp/profile/data/models/profileModel.dart';
import 'package:imagemindsapp/profile/data/repository/profileRepository.dart';
import 'package:imagemindsapp/subpages/data/bloc/scrre_bloc.dart';
import 'package:imagemindsapp/subpages/data/bloc/vedioScreenBloc.dart';
import 'package:intl/intl.dart';

import '../constants/app_fonts.dart';
import '../homepage/Widget/menu_dropdown.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {});
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      VedioScreenProvider.of(context).updateSelectedScreen(grade: "", course: "");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<StudentProfileModel?>(
          future: ProfileRepository().getStudentProfile(context: context, uid: sharedPref.id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              StudentProfileModel student = snapshot.data!;
              return Container(
                color: Color(0xffFAF1F2),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: [
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.15,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.9,
                        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.12,
                                  ),
                                  personalInformation(student),
                                  parentsInformation(student),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.12,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.width * 0.21,
                      color: Colors.transparent,
                      child: Stack(
                        children: [
                          Positioned(
                            top: -10,
                            left: 0,
                            right: 0,
                            child: Image.asset(
                              'assets/images/head-strip.png',
                              height: MediaQuery.of(context).size.height * 0.3,
                              width: MediaQuery.of(context).size.width * 0.2,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                              top: MediaQuery.of(context).size.height * 0.10,
                              left: MediaQuery.of(context).size.width * 0.2,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height * 0.2,
                                    width: MediaQuery.of(context).size.height * 0.2,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(100),
                                        image: DecorationImage(
                                          image: AssetImage(
                                            'assets/images/profile.png',
                                          ),
                                        )),
                                    clipBehavior: Clip.hardEdge,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      student.firstName + " " + student.lastName,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontFamily: AppFonts.boogaloo),
                                    ),
                                  ),
                                ],
                              )),
                          Positioned(
                            top: -MediaQuery.of(context).size.height * 0.05,
                            left: 10,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/logo.jpg',
                                  height: MediaQuery.of(context).size.height * 0.30,
                                  width: MediaQuery.of(context).size.width * 0.16,
                                ),
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
                                              "${snapshot.data![0]} -",
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
                          Positioned(top: 50, right: 30, child: MenuDropDown()),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
            return Container();
          }),
    );
  }

  Widget personalInformation(StudentProfileModel student) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title("Personal Information"),
          Row(
            children: [
              fieldCard(name: "First Name", data: student.firstName),
              fieldCard(name: "Last Name", data: student.lastName),
            ],
          ),
          Row(
            children: [
              fieldCard(name: "D.O.B", data: DateFormat('dd-MM-yyyy').format(student.dob)),
              fieldCard(name: "Gender", data: student.gender),
            ],
          ),
          Row(
            children: [
              fieldCard(name: "School Name", data: student.schoolName),
              fieldCard(name: "Grade", data: student.grade[0].toString()),
            ],
          ),
          Row(
            children: [
              fieldCard(name: "Medium", data: student.medium),
              fieldCard(name: "City", data: student.city),
            ],
          )
        ],
      ),
    );
  }

  Widget parentsInformation(StudentProfileModel student) {
    List dropdownItemList = [
      {'label': 'SD Card', 'value': 'sdcard'}, // label is required and unique
      {'label': 'Cloud', 'value': 'cloud'},
  
    ];
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title("Parent Information"),
          Row(
            children: [
              fieldCard(name: "Father Name", data: student.fatherName),
              fieldCard(name: "Mother Name", data: student.motherName),
            ],
          ),
          Row(
            children: [
              fieldCard(name: "Email Id", data: student.email),
              fieldCard(name: "Alt. Email Id", data: student.emailAlt),
            ],
          ),
          Row(
            children: [
              fieldCard(name: "Mobile No.", data: student.mobile),
              fieldCard(name: "Alt. Mobile No.", data: student.mobileAlt),
            ],
          ),
          Row(
            children: [
              fieldCard(name: "Address", data: student.address),
              fieldCard(name: "Area", data: student.area),
            ],
          ),
          Row(
            children: [
              fieldCard(name: "City", data: student.city),
              fieldCard(name: "State", data: student.state),
            ],
          ),
          Row(
            children: [
              fieldCard(name: "Country", data: student.country),
              fieldCard(name: "Pincode", data: student.zipcode),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Text(
                  "Video Source",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                SizedBox(width: 16,),
                CoolDropdown(
                dropdownList: dropdownItemList,
                onChange: (source) {
                print("player1"+source['value']);
                  sharedPref.setVideoSourceType(source: source['value']);
          
                },
                dropdownHeight: 140,
                defaultValue: dropdownItemList[0],
                // placeholder: 'insert...',
              )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget title(String text) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 24,
          fontFamily: AppFonts.boogaloo,
        ),
      ),
    );
  }

  Widget fieldCard({required String name, required String data}) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
            child: Text(
              name,
              style: TextStyle(fontSize: 16, fontFamily: AppFonts.robotoReg),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.35,
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.white,
              ),
              child: Text(
                data,
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: AppFonts.kidsFont,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
// Padding(
//           padding: const EdgeInsets.only(top: 151.0),
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Container(
//               child: ElevatedButton(
//                   child: Text("Log out"),
//                   onPressed: () async {
//                     AuthRepository authRepository = AuthRepository();
//                     authRepository
//                         .logout(
//                       email: sharedPref.email,
//                       context: context,
//                     )
//                         .then(
//                       (value) {
//                         sharedPref.setLoggedOut();
//                         Navigator.of(context).pushAndRemoveUntil(
//                             MaterialPageRoute(builder: (context) => LoginScreen()),
//                             (Route<dynamic> route) => false);
//                       },
//                     );
//                   }),
//             ),
//           ),
//         ),