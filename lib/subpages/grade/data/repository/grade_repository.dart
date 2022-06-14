import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:imagemindsapp/repository/repositry.dart';
import 'package:imagemindsapp/subpages/grade/data/models/gradeModel.dart';
import 'package:imagemindsapp/subpages/grade/data/models/videoModel.dart';

class GradeRepository {
  Future<List<GradeModel>> getGrades(
      {required BuildContext context, required String studentId}) async {
    try {
      Map<String, String>? postheaders = {
        'Accept': 'application/json',
        // 'Authorization': 'Bearer ${sharedPref.token}',
      };
      final response =
          await API.get(url: 'grades/usergrades?userId=${studentId}', context: context);
      if (response.statusCode == 200) {
        List<GradeModel> grades = gradeModelFromJson(response.body);
        return grades;
      } else {
        return [];
      }
    } catch (e) {
      log('$e');
      return [];
    }
  }
  Future<List<VideoModel>> getVideos(
      {required BuildContext context, required String gradeId}) async {
    try {
      Map<String, String>? postheaders = {
        'Accept': 'application/json',
        // 'Authorization': 'Bearer ${sharedPref.token}',
      };
      final response =
          await API.get(url: 'grades/gradeVideos?grade=${gradeId}', context: context);
          log(response.body.toString());
      if (response.statusCode == 200) {
        List<VideoModel> videoList = videoModelFromJson(response.body);
        return videoList;
      } else {
        return [];
      }
    } catch (e) {
      log('$e');
      return [];
    }
  }
}


