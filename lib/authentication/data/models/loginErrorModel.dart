// To parse this JSON data, do
//
//     final loginErrorModel = loginErrorModelFromJson(jsonString);

import 'dart:convert';

LoginErrorModel loginErrorModelFromJson(String str) => LoginErrorModel.fromJson(json.decode(str));

String loginErrorModelToJson(LoginErrorModel data) => json.encode(data.toJson());

class LoginErrorModel {
    LoginErrorModel({
       required this.detail,
    });

    String detail;

    factory LoginErrorModel.fromJson(Map<String, dynamic> json) => LoginErrorModel(
        detail: json["detail"],
    );

    Map<String, dynamic> toJson() => {
        "detail": detail,
    };
}
