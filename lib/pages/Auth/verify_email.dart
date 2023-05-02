// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:shop_manager/components/button.dart';
import 'package:shop_manager/models/AuthService.dart';
import 'package:shop_manager/models/GeneralProvider.dart';
import 'package:shop_manager/models/NotificationModel.dart';
import 'package:shop_manager/models/NotificationProvider.dart';
import 'package:shop_manager/models/ShopModel.dart';
import 'package:shop_manager/pages/dashboard.dart';
import 'package:shop_manager/pages/widgets/constants.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({
    Key? key,
  }) : super(key: key);

  @override
  _VerifyEmailScreenState createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;
  LocalStorage storage = LocalStorage('shop_mate');
  String  shopName ='';
  bool initialized = false;

  void bootUp() async {
    shopName = auth.currentUser?.displayName ?? '';
    //if (await storage.ready) {
      var data = await storage.getItem(shopName.isEmpty ? 'demo' : shopName);
      if (data == null) {
        log('empty');
        Provider.of<GeneralProvider>(context, listen: false).shop =
            ShopProducts(
                id: 0, shopname: 'demo', products: [], sales: [], expenses: [],lowStocks: []);
      } else {
        log('not empty');
        Provider.of<GeneralProvider>(context, listen: false).shop =
            shopProductsFromJson(data);
      }
      Provider.of<NotificationProvider>(context, listen: false).notiList =
          notificationModelFromJson(storage.getItem('notification') ?? '[]');
      // Provider.of<GeneralProvider>(context, listen: false).shop =
      //     shopProductsFromJson(data);
      Provider.of<GeneralProvider>(context, listen: false).shop.shopname =
          shopName;
   // }
  }

  @override
  void initState() {
    //bootUp();
    super.initState();
    //user needs to be created before!
    isEmailVerified = auth.currentUser!.emailVerified;
//  getShopProducts();
    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(Duration(seconds: 3), (_) => checkEmailVerified());
    }
  }

  Future sendVerificationEmail() async {
    try {
      final user = auth.currentUser!;
      await user.sendEmailVerification();

      setState(() => canResendEmail = false);
      await Future.delayed(Duration(seconds: 5));
      setState(() => canResendEmail = true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Color.fromARGB(255, 226, 11, 11),
            content: Text(e.toString(),
                textAlign: TextAlign.center, style: bodyText2),
            duration: const Duration(milliseconds: 1500),
            behavior: SnackBarBehavior.floating,
            shape: const StadiumBorder()),
      );
    }
  }

  Future checkEmailVerified() async {
    //call after email verification
    await auth.currentUser!.reload();
    setState(() {
      isEmailVerified = auth.currentUser!.emailVerified;
    });

    if (isEmailVerified) timer?.cancel();
  }

  @override
  void dispose() {
    timer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return FutureBuilder(
        future: storage.ready,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(
                color: primaryColorLight,
              ),
            );
          }
          if (!initialized) {
            bootUp();
            
            initialized = true;
          }

          return isEmailVerified
              ? MyHomeScreen()
              : Scaffold(
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
                      // Positioned(
                      //     top: height * 0.03,
                      //     left: 20,
                      //     child: IconButton(
                      //       onPressed: () {
                      //         Navigator.pop(context);
                      //       },
                      //       icon: Icon(Icons.arrow_back_ios,
                      //           color: Colors.white, size: 30),
                      //     )),
                      Container(
                        alignment: const Alignment(0, 0),
                        width: width,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundColor: primaryColorLight,
                                radius: width * 0.12,
                                backgroundImage:
                                    AssetImage("assets/app_icon.png"),
                              ),
                              SizedBox(height: height * 0.01),
                              Text(
                                'Shop Mate',
                                style: headline2,
                              ),
                              SizedBox(height: height * 0.05),
                              AnimatedContainer(
                                  padding:
                                      EdgeInsets.only(bottom: height * 0.03),
                                  duration: const Duration(milliseconds: 700),
                                  // height: height * 0.5,
                                  width: width * 0.9,
                                  decoration: BoxDecoration(
                                      color: primaryColorLight,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: height * 0.03,
                                        right: height * 0.03,
                                        left: height * 0.03),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 15),
                                              child: Text("Email Verification",
                                                  style: headline2.copyWith(
                                                      color: primaryColor))),
                                          Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: height * 0.02),
                                              child: Text(
                                                  "A verification email has been sent to your email.",
                                                  style: bodyText1.copyWith(
                                                      color:
                                                          primaryColorDark))),
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  top: height * 0.04,
                                                  bottom: height * 0.01),
                                              child: Button(
                                                  width: width,
                                                  color: canResendEmail
                                                      ? primaryColor
                                                      : Colors.grey,
                                                  // textColor: primaryColorLight,
                                                  buttonText: 'Resend Email',
                                                  onTap: canResendEmail
                                                      ? sendVerificationEmail
                                                      : () {})),
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  top: height * 0.01,
                                                  bottom: height * 0.01),
                                              child: Button(
                                                width: width,
                                                shadowColor: Colors.transparent,
                                                borderColor: primaryColor,
                                                textColor: primaryColor,
                                                buttonText: 'Cancel',
                                                onTap: () async {
                                                  await authService.signOut();
                                                },
                                              )),
                                        ]),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
        });
  }
}
