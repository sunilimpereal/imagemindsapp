// To parse this JSON data, do
//
//     final LoginRequest = LoginRequestFromJson(jsonString);

import 'dart:convert';

LoginRequest LoginRequestFromJson(String str) => LoginRequest.fromJson(json.decode(str));

String LoginRequestToJson(LoginRequest data) => json.encode(data.toJson());

class LoginRequest {
    LoginRequest({
        required this.email,
        required this.password,
    });

    String email;
    String password;

    factory LoginRequest.fromJson(Map<String, dynamic> json) => LoginRequest(
        email: json["email"],
        password: json["password"],
    );

    Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
    };
}
