import 'package:flutter/material.dart';
import 'package:imagemindsapp/constants/app_fonts.dart';

import '../../../main.dart';

class IMTextField extends StatefulWidget {
  Function onTap;
  FocusNode focusNode;
  Stream<Object> stream;
  Function(String) onChanged;
  String labelText;
  IconData icon;
  TextEditingController controller;

  /// text field
  /// errror from stream
  final String? error;

  /// if has focus to highlight with border and elevation
  /// example :
  ///  onfocus: focusNode.hasfocus
  final bool onfocus;

  ///width of the text field
  final double width;

  ///heding on the textfield
  String heading;

  bool obscureText;
  TextInputType? keyboardType;

  IMTextField({
    Key? key,
    required this.onfocus,
    this.error,
    required this.controller,
    required this.focusNode,
    required this.onTap,
    required this.labelText,
    required this.onChanged,
    required this.icon,
    required this.stream,
    required this.width,
    required this.heading,
    this.keyboardType,
    this.obscureText = false,
  }) : super(key: key);

  @override
  _IMTextFieldState createState() => _IMTextFieldState();
}

class _IMTextFieldState extends State<IMTextField> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: widget.stream,
        builder: (context, snapshot) {
          return Padding(
              padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 0),
              child: SizedBox(
                width: widget.width,
                child: Column(
                  children: [
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Row(
                    //     children: [
                    //       Text(
                    //         widget.heading,
                    //         style: Theme.of(context).textTheme.headline5,
                    //       )
                    //     ],
                    //   ),
                    // ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(5)),
                        border: Border.all(width: 2, color: Colors.transparent),
                      ),
                      child: ClipPath(
                        clipper: TextFieldCustomClipper(),
                        child: Material(
                          elevation: widget.onfocus ? 0 : 0,
                          color: Colors.white,
                          // shape: appStyles.shapeBorder(5),
                          shadowColor: Colors.grey[100],
                          child: Container(
                            // width: MediaQuery.of(context).size.width * 0.7,
                            alignment: Alignment.center,
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            child: TextFormField(
                              controller: widget.controller,
                              focusNode: widget.focusNode,
                              textAlign: TextAlign.left,
                              obscureText: widget.obscureText,
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).textTheme.headline1!.color,
                                // AppConfig(context).width<1000?16: 18,
                                // fontFamily: appFonts.notoSans,//TODO: fonts
                                fontWeight: FontWeight.w600,
                                fontFamily: AppFonts.kidsFont,
                              ),
                              onTap: () {
                                widget.onTap();
                              },
                              onChanged: widget.onChanged,
                              keyboardType: widget.keyboardType,
                              decoration: InputDecoration(
                                // errorText: "${snapshot.error}",
                                border: InputBorder.none,
                                contentPadding:
                                    const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 0),
                                hintText: widget.labelText,
                                prefixIconConstraints:
                                    const BoxConstraints(minWidth: 23, maxHeight: 20),

                                isDense: false,
                                hintStyle: TextStyle(
                                    color: Theme.of(context).textTheme.headline1!.color,
                                    fontSize: 16),
                                labelStyle: TextStyle(
                                  height: 0.6,
                                  fontSize: 16,
                                  color: Theme.of(context).textTheme.headline1!.color,
                                  fontFamily: AppFonts.kidsFont,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            snapshot.error != null
                                ? Text(
                                    snapshot.error.toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: AppFonts.kidsFont,
                                        fontSize: 12),
                                  )
                                : Container(),
                          ],
                        ))
                  ],
                ),
              ));
        });
  }
}

class TextFieldCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var controlPoint = Offset(size.width / 2, size.height / 2);
    var endPoint = Offset(size.width, size.height);
    double radius = 12;
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
