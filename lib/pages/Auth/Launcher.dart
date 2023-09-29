// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
// import 'package:hive/hive.dart';
import 'package:shop_manager/components/responsive.dart';
import 'package:shop_manager/pages/widgets/constants.dart';
import 'package:shop_manager/pages/wrapper.dart';

class Launcher extends StatefulWidget {
  const Launcher({Key? key}) : super(key: key);
  // static const String routeName = '/';

  @override
  _LauncherState createState() => _LauncherState();
}

class _LauncherState extends State<Launcher> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<double> _animation2;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.bounceOut);
    _animation2 = Tween<double>(begin: 0.0, end: 1.2).animate(_controller);
    _controller.forward();
   // startTime();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  startTime() async {
    var _duration = Duration(seconds: 3);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Wrapper()));
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: primaryColor,
        body: Stack(
          children: [
            Positioned(
                top: -height * 0.15,
                right: -width * 0.5,
                child: CircleAvatar(
                    radius: width * 0.6,
                    backgroundColor: Colors.black.withOpacity(0.4))),
            Positioned(
                bottom: -height * 0.1,
                left: -width * 0.1,
                child: CircleAvatar(
                    radius: width * 0.4,
                    backgroundColor: Colors.black.withOpacity(0.4))),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularPercentIndicator(
                    backgroundColor: Colors.transparent,
                    animationDuration: 5000,
                    animation: true,
                  radius:width * 0.15,
                  lineWidth: 5.0,
                  percent: 1.0,
                  center:  
                  CircleAvatar(
                    backgroundColor: primaryColorLight,
                    radius:
                        Responsive.isMobile() ? width * 0.12 : width * 0.05,
                    backgroundImage: AssetImage("assets/app_icon.png"),
                  ),
                  progressColor: Colors.white,
                ),
                  SizedBox(height: height * 0.01),
                  FadeTransition(
                      opacity: _animation2,
                      child: Text(
                        'Shop Mate',
                        style: headline2,
                      )),
                ],
              ),
            ),
            Container(
              alignment: Alignment(0, 0.9),
              // child: Text('@ c r e a t e d b y Q w e k u & Y - F l i c k r',
              //     style: TextStyle(color: Colors.white, fontSize: 12)),
            )
          ],
        ));
  }
}
