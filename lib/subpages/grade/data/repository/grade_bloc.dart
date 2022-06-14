import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:imagemindsapp/main.dart';
import 'package:imagemindsapp/subpages/grade/data/models/gradeModel.dart';
import 'package:imagemindsapp/subpages/grade/data/repository/grade_repository.dart';
import 'package:imagemindsapp/subpages/grade/data/models/videoModel.dart';
import 'package:imagemindsapp/utils/bloc.dart';
import 'package:rxdart/rxdart.dart';

class GradeBloc extends Bloc {
  BuildContext context;
  GradeBloc(this.context) {
    // get grades
    getgradeList(studentId: sharedPref.id);
  }

  //grade
  final _gradeController = BehaviorSubject<List<GradeModel>>();
  Stream<List<GradeModel>> get gradeListStream => _gradeController.stream.asBroadcastStream();
  //vedio
  final _videoController = BehaviorSubject<List<VideoModel>>();
  Stream<List<VideoModel>> get videoListStream => _videoController.stream.asBroadcastStream();

  Future<bool> getgradeList({required String studentId}) async {
    GradeRepository gradeRepository = GradeRepository();
    final result = await gradeRepository.getGrades(context: context, studentId: studentId);
    _gradeController.sink.add(result);
    return result.isEmpty ? false : true;
  }

  Future<bool> getVideoList({required String gradeId}) async {
    GradeRepository gradeRepository = GradeRepository();
    final result = await gradeRepository.getVideos(context: context, gradeId: gradeId);
    _videoController.sink.add(result);
    return result.isEmpty ? false : true;
  }

  @override
  void dispose() {
    _gradeController.close();
    _videoController.close();
    // TODO: implement dispose
  }
}

class GradeProvider extends InheritedWidget {
  late GradeBloc bloc;
  BuildContext context;
  GradeProvider({Key? key, required Widget child, required this.context})
      : super(key: key, child: child) {
    bloc = GradeBloc(context);
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }

  static GradeBloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<GradeProvider>() as GradeProvider).bloc;
  }
}
