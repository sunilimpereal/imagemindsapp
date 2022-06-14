// To parse this JSON data, do
//
//     final videoModel = videoModelFromJson(jsonString);

import 'dart:convert';

List<VideoModel> videoModelFromJson(String str) => List<VideoModel>.from(json.decode(str).map((x) => VideoModel.fromJson(x)));

String videoModelToJson(List<VideoModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VideoModel {
    VideoModel({
      required  this.name,
      required  this.grade,
      required  this.filename,
    });

    String name;
    int grade;
    String filename;

    factory VideoModel.fromJson(Map<String, dynamic> json) => VideoModel(
        name: json["name"],
        grade: json["grade"],
        filename: json["fileName"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "grade": grade,
        "fileName": filename,
    };
}
