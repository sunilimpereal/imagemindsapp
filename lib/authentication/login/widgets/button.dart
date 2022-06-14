import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:imagemindsapp/authentication/login/widgets/text_field.dart';
import 'package:imagemindsapp/constants/app_fonts.dart';

class IMStreamButton extends StatefulWidget {
  Stream<List<String>> formValidationStream;
  Function submit;
  String text;
  String errrorText;
  bool errorFlag;

  //width
  double? width;
  IMStreamButton({
    Key? key,
    required this.formValidationStream,
    required this.submit,
    required this.text,
    this.width,
    required this.errrorText,
    required this.errorFlag,
  });

  @override
  _IMStreamButtonState createState() => _IMStreamButtonState();
}

class _IMStreamButtonState extends State<IMStreamButton> {
  String error = "";

  @override
  Widget build(BuildContext context) {
    log(" flag ${widget.errorFlag}");
    return Container(
      width: widget.width,
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0),
          child: Column(
            children: [
              StreamBuilder<List<String>>(
                  stream: widget.formValidationStream,
                  builder: (context, snapshot) {
                    log(' snapshot ${snapshot.hasData.toString()}');

                    return Column(
                      children: [
                        SizedBox(
                          width: widget.width,
                          child: SizedBox(
                            child: ClipPath(
                              clipper: ButtonCustomClipper(),
                              child: Material(
                                color: Colors.transparent,
                                child: Container(
                                  height: MediaQuery.of(context).size.height > 550
                                      ? MediaQuery.of(context).size.height * 0.09
                                      : MediaQuery.of(context).size.height * 0.14,
                                  child: ElevatedButton(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(top:4.0),
                                          child: Text(
                                            widget.text,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 18,
                                                fontFamily: AppFonts.kidsFont),
                                          ),
                                        ),
                                      ],
                                    ),
                                    style: OutlinedButton.styleFrom(
                                        onSurface: Theme.of(context).colorScheme.onPrimary,
                                        elevation: snapshot.hasError || !snapshot.hasData ? 0 : 5),
                                    onPressed: snapshot.hasError || !snapshot.hasData
                                        ? () {
                                            setState(() {
                                              error = 'Fill all Fields to Login';
                                            });
                                          }
                                        : () {
                                            setState(() {
                                              error = '';
                                            });
                                            widget.submit();
                                          },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        error != ""
                            ? Row(
                                children: [
                                  Icon(
                                    Icons.error,
                                    color: Theme.of(context).errorColor,
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    error,
                                    style: TextStyle(
                                        color: Colors.white, fontFamily: AppFonts.kidsFont),
                                  ),
                                ],
                              )
                            : Container(),
                        widget.errorFlag && error == ""
                            ? Row(
                                children: [
                                  Icon(
                                    Icons.error,
                                    color: Theme.of(context).errorColor,
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    widget.errrorText,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              )
                            : Container(),
                      ],
                    );
                  }),
            ],
          )),
    );
  }
}

class ButtonCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var controlPoint = Offset(size.width / 2, size.height / 2);
    var endPoint = Offset(size.width, size.height);
    double radius = 15;
    Path path = Path()
      ..moveTo(radius, 10)
      ..lineTo(size.width - radius, 0)
      ..arcToPoint(Offset(size.width, radius), radius: Radius.circular(radius))
      ..lineTo(size.width, size.height - radius)
      ..arcToPoint(Offset(size.width - radius, size.height), radius: Radius.circular(radius))
      ..lineTo(radius, size.height)
      ..arcToPoint(
        Offset(0, size.height - radius),
        radius: Radius.circular(radius),
      )
      ..lineTo(5, radius + 2)
      ..arcToPoint(Offset(radius, 10), radius: Radius.circular(20))
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
