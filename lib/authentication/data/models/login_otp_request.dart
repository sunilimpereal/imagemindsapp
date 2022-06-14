// To parse this JSON data, do
//
//     final loginOtpRequestModel = loginOtpRequestModelFromJson(jsonString);

import 'dart:convert';

LoginOtpRequestModel loginOtpRequestModelFromJson(String str) =>
    LoginOtpRequestModel.fromJson(json.decode(str));

String loginOtpRequestModelToJson(LoginOtpRequestModel data) => json.encode(data.toJson());

class LoginOtpRequestModel {
  LoginOtpRequestModel({
    required this.mobile,
  });

  String mobile;

  factory LoginOtpRequestModel.fromJson(Map<String, dynamic> json) => LoginOtpRequestModel(
        mobile: json["mobile"],
      );

  Map<String, dynamic> toJson() => {
        "mobile": mobile,
      };
}
