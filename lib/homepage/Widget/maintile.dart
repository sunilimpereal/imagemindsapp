import 'package:flutter/material.dart';
import 'package:imagemindsapp/constants/app_fonts.dart';

class MainTile extends StatefulWidget {
  Image img;
  String title;
  void Function() onTap;
  MainTile({Key? key, required this.img, required this.onTap, required this.title})
      : super(key: key);

  @override
  _MainTileState createState() => _MainTileState();
}

class _MainTileState extends State<MainTile> {
  @override
  Widget build(BuildContext context) {
    // double padding = MediaQuery.of(context).size.width * 0.03;
    double width  = MediaQuery.of(context).size.width*0.002;
    double height  = MediaQuery.of(context).size.height*0.002;
    return Padding(
      padding: EdgeInsets.all(width * 8),
      child: Container(
        height: 200 * height,
        child: Stack(
          children: [
            Container(
               height: 163 * height,
              // height: MediaQuery.of(context).size.width*0.16,
              
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: widget.img,
            ),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      ClipPath(
                        clipper: ButtonCustomClipper(),
                        child: Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          child: InkWell(
                            onTap: widget.onTap,
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.purple.shade300,
                                    Colors.purple.shade400,
                                    Colors.purple.shade600
                                  ],
                                ),
                              ),
                              //  width: 140*width ,
                              // height: 75*height,
                              width: MediaQuery.of(context).size.width*0.20,
                              height: MediaQuery.of(context).size.height*0.14,
                              child: Center(
                                child: Text(
                                  widget.title,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontFamily: AppFonts.cronusRound,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

brekpointValue(BuildContext context){
  double width = MediaQuery.of(context).size.width;
  double height = MediaQuery.of(context).size.height;
  if(width > 750){
    return 1;
  }
}

class ButtonCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var controlPoint = Offset(size.width / 2, size.height / 2);
    var endPoint = Offset(size.width, size.height);
    double radius = 18;
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
