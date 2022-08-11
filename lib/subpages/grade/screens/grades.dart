import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:drop_shadow_image/drop_shadow_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:imagemindsapp/constants/app_fonts.dart';
import 'package:imagemindsapp/subpages/data/bloc/scrre_bloc.dart';
import 'package:imagemindsapp/subpages/data/bloc/vedioScreenBloc.dart';
import 'package:imagemindsapp/subpages/grade/data/models/gradeModel.dart';
import 'package:imagemindsapp/subpages/grade/data/repository/grade_bloc.dart';
import 'package:imagemindsapp/utils/trianglepainter.dart';
import 'package:open_file/open_file.dart';

class GradesScreen extends StatefulWidget {
  const GradesScreen({Key? key}) : super(key: key);

  @override
  _GradesScreenState createState() => _GradesScreenState();
}

class _GradesScreenState extends State<GradesScreen> {
  @override
  void initState() {
    OpenFile.open("/Classes/p.mp4");
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      VedioScreenProvider.of(context).updateSelectedScreen(grade: "", course: "");
    });
 SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    GradeBloc gradeBloc = GradeProvider.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 80.0),
      child: Container(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder<List<GradeModel>>(
                  stream: gradeBloc.gradeListStream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: Text("No grades"));
                    }
                    if (snapshot.data!.isEmpty) {
                      return Center(child: Text("No grades"));
                    }
                    return Container(
                      width:snapshot.data!.length<=2?null: MediaQuery.of(context).size.width,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: snapshot.data!.map((e) {
                              return GradeCard(
                                context: context,
                                grade: e,
                              );
                            }).toList()),
                      ),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}

class GradeCard extends StatelessWidget {
  final BuildContext context;

  GradeModel grade;

  GradeCard({
    Key? key,
    required this.context,
    required this.grade,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.002;
    double height = MediaQuery.of(context).size.height * 0.002;
    double width1 = 150 * width;
    double height1 = 250 * height;

    return Padding(
      padding: const EdgeInsets.all(28.0),
      child: GestureDetector(
        onTap: () {
          ScreenNavProvider.of(context).updateSelectedScreen(Screens.videos);
          VedioScreenProvider.of(context)
              .updateSelectedScreen(grade: grade.name, course: grade.couseName);
          GradeProvider.of(context).getVideoList(gradeId: grade.grade);
        },
        child: Container(
            width: width1,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ImageShadow(
                        height: height1,
                        width: width1,
                        image: grade.couseName,
                        showPlay: false,
                      ),
                      SizedBox(height: 8,),
                      Container(
                        // height: height1 * 0.23,
                        width: width1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: width1 - 20,
                              child: Text(
                                grade.couseName,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: AppFonts.cronusRound,
                                  color: Colors.orange,
                                  fontSize: MediaQuery.of(context).size.height > 600 ? 28 : 18,
                                ),
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
    );
  }
}

class ImageShadow extends StatefulWidget {
  double width;
  double height;
  String image;
  bool showPlay;
  ImageShadow(
      {Key? key,
      required this.height,
      required this.width,
      required this.image,
      required this.showPlay})
      : super(key: key);

  @override
  _ImageShadowState createState() => _ImageShadowState();
}

class _ImageShadowState extends State<ImageShadow> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.002;
    double height = MediaQuery.of(context).size.height * 0.002;
    return Container(
      width: widget.width,
      height: widget.height * 0.8,
      child: Stack(
        children: [
          Center(
            child: Container(
              width: 70 * width,
              height: 10 * height,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.redAccent,
                    spreadRadius: 20 * width,
                    blurRadius: 30 * width,
                    offset: Offset(0, 7), // changes position of shadow
                  ),
                ],
              ),
            ),
          ),
          Container(
              width: widget.width,
              height: widget.height * 0.8,
              decoration: BoxDecoration(),
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl:
                        "https://iminds.s3.ap-south-1.amazonaws.com/images/${widget.image}.png",
                    placeholder: (context, url) =>  Image.asset("assets/images/course-grade1.png"),
                    errorWidget: (context, url, error) =>
                        Image.asset("assets/images/course-grade1.png"),
                  ),
                  // Image.network(
                  //   'https://iminds.s3.ap-south-1.amazonaws.com/images/${widget.image}.png',
                  //   errorBuilder: (context, error, stackTrace) {
                  //     return Container(
                  //       child: Image.asset("assets/images/course-grade1.png"),
                  //     );
                  //   },
                  // ),
                  widget.showPlay
                      ? Center(
                          child: Icon(
                            Icons.play_arrow,
                            color: Colors.grey.withOpacity(0.8),
                            size: 60,
                          ),
                        )
                      : Container(),
                ],
              )),
        ],
      ),
    );
  }
}
