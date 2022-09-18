// To parse this JSON data, do
//
//     final otpLoginRequestModel = otpLoginRequestModelFromJson(jsonString);

import 'dart:convert';

OtpLoginRequestModel otpLoginRequestModelFromJson(String str) => OtpLoginRequestModel.fromJson(json.decode(str));

String otpLoginRequestModelToJson(OtpLoginRequestModel data) => json.encode(data.toJson());

class OtpLoginRequestModel {
    OtpLoginRequestModel({
       required this.mobile,
       required this.otp,
       required this.deviceId,
    });

    String mobile;
    int otp;
    String deviceId;

    factory OtpLoginRequestModel.fromJson(Map<String, dynamic> json) => OtpLoginRequestModel(
        mobile: json["mobile"],
        otp: json["otp"],
        deviceId: json["deviceId"],
    );

    Map<String, dynamic> toJson() => {
        "mobile": mobile,
        "otp": otp,
        "deviceId": deviceId,
    };
}
