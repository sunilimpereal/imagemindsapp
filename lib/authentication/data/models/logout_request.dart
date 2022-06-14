// To parse this JSON data, do
//
//     final LogoutRequest] = LogoutRequestFromJson(jsonString);

import 'dart:convert';

LogoutRequest LogoutRequestFromJson(String str) => LogoutRequest.fromJson(json.decode(str));

String LogoutRequestToJson(LogoutRequest data) => json.encode(data.toJson());

class LogoutRequest {
    LogoutRequest({
        required this.email,
    });

    String email;

    factory LogoutRequest.fromJson(Map<String, dynamic> json) => LogoutRequest(
        email: json["email"],
    );

    Map<String, dynamic> toJson() => {
        "email": email,
    };
}
