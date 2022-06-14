// To parse this JSON data, do
//
//     final gradeModel = gradeModelFromJson(jsonString);

import 'dart:convert';

List<GradeModel> gradeModelFromJson(String str) =>
    List<GradeModel>.from(json.decode(str).map((x) => GradeModel.fromJson(x)));

String gradeModelToJson(List<GradeModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GradeModel {
  GradeModel({
    required this.name,
    required this.grade,
    required this.couseName,
  });

  String name;
  String grade;
  String couseName;

  factory GradeModel.fromJson(Map<String, dynamic> json) => GradeModel(
        name: json["name"],
        grade: json["grade"],
        couseName: json["couseName"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "grade": grade,
        "couseName": couseName,
      };
}
