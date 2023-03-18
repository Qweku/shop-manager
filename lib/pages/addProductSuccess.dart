import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shop_manager/pages/dashboard.dart';
import 'package:shop_manager/pages/widgets/constants.dart';

class AddProductSuccess extends StatefulWidget {
  final String? tag;
  const AddProductSuccess({Key? key, this.tag}) : super(key: key);

  @override
  State<AddProductSuccess> createState() => _AddProductSuccessState();
}

class _AddProductSuccessState extends State<AddProductSuccess> {
  @override
  void initState() {
    super.initState();
    startTime();
  }

  startTime() async {
    var _duration = const Duration(seconds: 3);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const MyHomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        height: height,
        width: width,
        child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/confetti-gif-2.gif"),
                  fit: BoxFit.cover)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: primaryColor,
                child: const Icon(Icons.check, color: Colors.white, size: 50),
              ),
              SizedBox(height: height * 0.05),
              SizedBox(
                  width: width * 0.6,
                  child: Text(
                    widget.tag == 'order'
                        ? "Order processed successfully"
                        : 'Product added successfully',
                    textAlign: TextAlign.center,
                    style:headline1
                        .copyWith(color: primaryColor),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
