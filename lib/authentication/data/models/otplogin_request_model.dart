// To parse this JSON data, do
//
//     final otpLoginRequestModel = otpLoginRequestModelFromJson(jsonString);

import 'dart:convert';

OtpLoginRequestModel otpLoginRequestModelFromJson(String str) =>
    OtpLoginRequestModel.fromJson(json.decode(str));

String otpLoginRequestModelToJson(OtpLoginRequestModel data) => json.encode(data.toJson());

class OtpLoginRequestModel {
  OtpLoginRequestModel({
    required this.mobile,
    required this.otp,
  });

  String mobile;
  int otp;

  factory OtpLoginRequestModel.fromJson(Map<String, dynamic> json) => OtpLoginRequestModel(
        mobile: json["mobile"],
        otp: json["otp"],
      );

  Map<String, dynamic> toJson() => {
        "mobile": mobile,
        "otp": otp,
      };
}
