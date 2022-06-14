import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:imagemindsapp/profile/data/models/profileModel.dart';

import '../../../repository/repositry.dart';

class ProfileRepository {
  Future<StudentProfileModel?> getStudentProfile(
      {required BuildContext context, required String uid}) async {
    // try {
    Map<String, String>? postheaders = {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    };

    final response = await API.get(
      url: 'user/student?uid=${uid}',
      context: context,
    );
    log(response.body.toString());
    if (response.statusCode == 200) {
      StudentProfileModel studentProfileModel = studentProfileModelFromJson(response.body)[0];
      return studentProfileModel;
    } else {
      log('filaed 2');
      return null;
    }
    // } catch (e) {
    //   log('filaed 3 $e');
    //   return false;
    // }
  }
}
