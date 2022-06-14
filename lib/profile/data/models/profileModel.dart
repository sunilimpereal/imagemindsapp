// To parse this JSON data, do
//
//     final studentProfileModel = studentProfileModelFromJson(jsonString);

import 'dart:convert';

List<StudentProfileModel> studentProfileModelFromJson(String str) => List<StudentProfileModel>.from(json.decode(str).map((x) => StudentProfileModel.fromJson(x)));

String studentProfileModelToJson(List<StudentProfileModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StudentProfileModel {
    StudentProfileModel({
       required this.userCode,
       required this.username,
       required this.firstName,
       required this.lastName,
       required this.dob,
       required this.gender,
       required this.schoolName,
       required this.grade,
       required this.medium,
       required this.city,
       required this.fatherName,
       required this.motherName,
       required this.email,
       required this.emailAlt,
       required this.mobile,
       required this.mobileAlt,
       required this.address,
       required this.area,
       required this.state,
       required this.country,
       required this.zipcode,
       required this.loggedIn,
       required this.otp,
    });

    String userCode;
    String username;
    String firstName;
    String lastName;
    DateTime dob;
    String gender;
    String schoolName;
    List<int> grade;
    String medium;
    String city;
    String fatherName;
    String motherName;
    String email;
    String emailAlt;
    String mobile;
    String mobileAlt;
    String address;
    String area;
    String state;
    String country;
    String zipcode;
    bool loggedIn;
    int otp;

    factory StudentProfileModel.fromJson(Map<String, dynamic> json) => StudentProfileModel(
        userCode: json["userCode"],
        username: json["username"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        dob: DateTime.parse(json["dob"]),
        gender: json["gender"],
        schoolName: json["schoolName"],
        grade: List<int>.from(json["grade"].map((x) => x)),
        medium: json["medium"],
        city: json["city"],
        fatherName: json["fatherName"],
        motherName: json["motherName"],
        email: json["email"],
        emailAlt: json["emailAlt"],
        mobile: json["mobile"],
        mobileAlt: json["mobileAlt"],
        address: json["address"],
        area: json["area"],
        state: json["state"],
        country: json["country"],
        zipcode: json["zipcode"],
        loggedIn: json["loggedIn"],
        otp: json["otp"],
    );

    Map<String, dynamic> toJson() => {
        "userCode": userCode,
        "username": username,
        "firstName": firstName,
        "lastName": lastName,
        "dob": "${dob.year.toString().padLeft(4, '0')}-${dob.month.toString().padLeft(2, '0')}-${dob.day.toString().padLeft(2, '0')}",
        "gender": gender,
        "schoolName": schoolName,
        "grade": List<dynamic>.from(grade.map((x) => x)),
        "medium": medium,
        "city": city,
        "fatherName": fatherName,
        "motherName": motherName,
        "email": email,
        "emailAlt": emailAlt,
        "mobile": mobile,
        "mobileAlt": mobileAlt,
        "address": address,
        "area": area,
        "state": state,
        "country": country,
        "zipcode": zipcode,
        "loggedIn": loggedIn,
        "otp": otp,
    };
}
