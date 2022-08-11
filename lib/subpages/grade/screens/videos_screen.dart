import 'dart:developer';

import 'package:aes_crypt_null_safe/aes_crypt_null_safe.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:imagemindsapp/constants/app_fonts.dart';
import 'package:imagemindsapp/subpages/grade/data/models/videoModel.dart';
import 'package:imagemindsapp/subpages/grade/data/repository/grade_bloc.dart';
import 'package:imagemindsapp/subpages/grade/screens/grades.dart';
import 'package:imagemindsapp/subpages/data/bloc/scrre_bloc.dart';
import 'package:imagemindsapp/utils/trianglepainter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'landscape_player.dart';

class VideosScreen extends StatefulWidget {
  VideosScreen({
    Key? key,
  }) : super(key: key);

  @override
  _VideosScreenState createState() => _VideosScreenState();
}

class _VideosScreenState extends State<VideosScreen> {
  ScrollController _scrollController = ScrollController();
  int value = 1;
  int i = 1;
  int split = 3;

  @override
  void initState() {
    _scrollController.addListener(() {
      double part = _scrollController.position.maxScrollExtent / 3;
      int pos = (part / _scrollController.offset).ceil();
    });
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    GradeBloc gradeBloc = GradeProvider.of(context);
    double width = MediaQuery.of(context).size.width * 0.002;
    double height = MediaQuery.of(context).size.height * 0.002;
    return StreamBuilder<List<VideoModel>>(
        stream: gradeBloc.videoListStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData && snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              color: Colors.red,
            ));
          }
          if (!snapshot.hasData) {
            return Center(child: Text("Error Fetching Videos"));
          }
          if (snapshot.data!.isEmpty) {
            return Center(child: Text("No Videos in the grade!"));
          }
          return Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 80 * height,
                ),
                Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        controller: _scrollController,
                        child: Row(
                          children: snapshot.data!.map((e) {
                            if (snapshot.data?.indexOf(e) == split) {
                              split = split + 3;
                              i = i++;
                            }

                            return card(
                                courseName: e.name, image: e.name, vedioName: e.filename, i: i);
                          }).toList(),
                        ),
                      ),
                    ),
                    Container(
                      // width: MediaQuery.of(context).size.width - (10*width),
                      height: 250 * height,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Arrows(
                            left: true,
                            ontap: () {
                              setState(() {
                                _scrollController.animateTo(
                                    _scrollController.position.pixels -
                                        _scrollController.position.maxScrollExtent / snapshot.data!.length,
                                    curve: Curves.ease,
                                    duration: Duration(milliseconds: 100));
                              });
                            },
                          ),
                          Arrows(
                            left: false,
                            ontap: () {
                              setState(() {
                                _scrollController.animateTo(
                                    _scrollController.position.pixels +
                                        _scrollController.position.maxScrollExtent / snapshot.data!.length,
                                    curve: Curves.easeIn,
                                    duration: Duration(milliseconds: 100));
                              });
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Container(
                      //   child: ball(gradeBloc),
                      // )
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  Widget ball(GradeBloc gradeBloc) {
    Widget circle({required int i, required int value}) {
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: GestureDetector(
          onTap: () {},
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: i == value ? Color(0xff428bca) : Colors.grey,
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        ),
      );
    }

    return StreamBuilder<List<VideoModel>>(
        stream: gradeBloc.videoListStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            int length = (snapshot.data!.length / 3).ceil();
            List<Widget> circle_list = [];
            for (int i = 1; i <= length; i++) {
              circle_list.add(circle(i: i, value: value));
            }
            return Row(children: circle_list);
          } else {
            return Container();
          }
        });
  }

  Widget card({
    required String courseName,
    required String image,
    required String vedioName,
    required int i,
  }) {
    double width1 = MediaQuery.of(context).size.width * 0.002;
    double height1 = MediaQuery.of(context).size.height * 0.002;
    double width = 150 * width1;
    double height = 260 * height1;

    return VisibilityDetector(
        key: Key('$image'),
        onVisibilityChanged: (visibilityInfo) {
          var visiblePercentage = visibilityInfo.visibleFraction * 100;
          setState(() {
            if (visiblePercentage == 100) {
              value = i;
            }
          });
        },
        child: Padding(
          padding: EdgeInsets.all(14.0 * width1),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LandscapeVedioPlayer(
                    vedioName: vedioName,
                    title: courseName,
                  ),
                ),
              );
            },
            child: Container(
                width: width,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ImageShadow(
                            height: height,
                            width: width,
                            image: image,
                            showPlay: true,
                          ),
                          SizedBox(height: 8),
                          Container(
                            // height: height * 0.16,
                            width: width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: width - (20 * width1),
                                  child: Text(
                                    courseName,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: AppFonts.cronusRound,
                                        color: Colors.blue,
                                        fontSize: 18),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                )),
          ),
        ));
  }
}

class Arrows extends StatelessWidget {
  Function ontap;
  bool left;
  Arrows({
    Key? key,
    required this.ontap,
    required this.left,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ontap();
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(1000),
          ),
          color: Colors.white.withOpacity(0.5),
        ),
        child: Icon(
          left ? Icons.keyboard_arrow_left : Icons.keyboard_arrow_right,
          size: 40,
          color: Colors.orange,
        ),
      ),
    );
  }
}
