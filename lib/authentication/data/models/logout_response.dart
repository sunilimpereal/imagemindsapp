// To parse this JSON data, do
//
//     final LogoutResponse = LogoutResponseFromJson(jsonString);

import 'dart:convert';

LogoutResponse LogoutResponseFromJson(String str) => LogoutResponse.fromJson(json.decode(str));

String LogoutResponseToJson(LogoutResponse data) => json.encode(data.toJson());

class LogoutResponse {
    LogoutResponse({
        required this.email,
        required this.message,
    });

    String email;
    String message;

    factory LogoutResponse.fromJson(Map<String, dynamic> json) => LogoutResponse(
        email: json["email"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "email": email,
        "message": message,
    };
}
