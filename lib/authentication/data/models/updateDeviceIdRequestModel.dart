// To parse this JSON data, do
//
//     final updateDeviceIdRequestModel = updateDeviceIdRequestModelFromJson(jsonString);

import 'dart:convert';

UpdateDeviceIdRequestModel updateDeviceIdRequestModelFromJson(String str) => UpdateDeviceIdRequestModel.fromJson(json.decode(str));

String updateDeviceIdRequestModelToJson(UpdateDeviceIdRequestModel data) => json.encode(data.toJson());

class UpdateDeviceIdRequestModel {
    UpdateDeviceIdRequestModel({
       required this.email,
       required this.deviceId,
    });

    String email;
    String deviceId;

    factory UpdateDeviceIdRequestModel.fromJson(Map<String, dynamic> json) => UpdateDeviceIdRequestModel(
        email: json["email"],
        deviceId: json["deviceId"],
    );

    Map<String, dynamic> toJson() => {
        "email": email,
        "deviceId": deviceId,
    };
}
