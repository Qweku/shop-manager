// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
// import 'package:hive_flutter/hive_flutter.dart';
import 'package:shop_manager/components/button.dart';
import 'package:shop_manager/components/textFields.dart';
import 'package:shop_manager/main.dart';
import 'package:shop_manager/models/AuthService.dart';
import 'package:shop_manager/models/GeneralProvider.dart';
import 'package:shop_manager/models/ShopModel.dart';
import 'package:shop_manager/pages/Auth/forgotten_password.dart';
import 'package:shop_manager/pages/widgets/constants.dart';
// import 'package:hive_flutter/hive_flutter.dart';

class LoginScreen extends StatefulWidget {
  final Function? toggleScreen;
  const LoginScreen({Key? key, this.toggleScreen}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LocalStorage storage = LocalStorage('shop_mate');

  bool obsure = true;
  bool isShown = true;
  bool isNot = false;
  double num = 0.4;
  IconData visibility = Icons.visibility_off;
  FirebaseAuth auth = FirebaseAuth.instance;

  void loginError(
    Exception e,
  ) {
    showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Icon(Icons.cancel,
                color: Color.fromARGB(255, 216, 30, 17), size: 50),

            // Text(
            //   "LOGIN ERROR",textAlign: TextAlign.center,
            //   style: TextStyle(fontWeight: FontWeight.bold,color:Color.fromARGB(255, 233, 22, 7), fontSize: 18),
            // ),
            content: Text("${(e as dynamic).message}"),
            actions: [
              TextButton(
                  onPressed: (() => Navigator.of(context).pop()),
                  child: Text("OK"))
            ],
          );
        });
  }

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController shopController = TextEditingController();
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    shopController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return AnimatedContainer(
        padding: EdgeInsets.only(bottom: height * 0.03),
        duration: const Duration(milliseconds: 700),
        // height: height * 0.5,
        width: width * 0.9,
        decoration: BoxDecoration(
            color: primaryColorLight, borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: EdgeInsets.only(
              top: height * 0.03, right: height * 0.03, left: height * 0.03),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Text("Welcome back",
                    style: headline2.copyWith(color: primaryColor))),
            // Padding(
            //   padding: EdgeInsets.symmetric(vertical: height * 0.02),
            //   child: CustomTextField(
            //     borderColor: Colors.grey,
            //     hintText: "Shop Name",
            //     //hintColor: primaryColor,
            //     controller: shopController,
            //     style:bodyText1,
            //     prefixIcon: Icon(Icons.shopify, color: primaryColor),
            //   ),
            // ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: height * 0.02),
              child: CustomTextField(
                borderColor: Colors.grey,
                hintText: "Username or email",
                // hintColor: primaryColor,
                controller: _emailController,
                style: bodyText1,
                prefixIcon: Icon(Icons.person, color: primaryColor),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: height * 0.02),
              child: CustomTextField(
                maxLines: 1,
                obscure: obsure,
                borderColor: Colors.grey,
                style: bodyText1,
                prefixIcon: Icon(Icons.lock, color: primaryColor),
                controller: _passwordController,
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      obsure = !obsure;
                      if (!obsure) {
                        visibility = Icons.visibility;
                      } else {
                        visibility = Icons.visibility_off;
                      }
                    });
                  },
                  child: Container(
                    // alignment: Alignment(1.0,50.0),
                    padding: const EdgeInsets.only(right: 10),
                    child: Icon(visibility, size: 25, color: primaryColor),
                  ),
                ),
                hintText: "Password",
                // hintColor: primaryColor,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ForgottenPassword()));
                  },
                  child: Text('Forgotten Password',
                      style: bodyText1.copyWith(color: actionColor))),
            ),
            Padding(
                padding:
                    EdgeInsets.only(top: height * 0.04, bottom: height * 0.01),
                child: Button(
                  width: width,
                  color: primaryColor,
                  // textColor: primaryColorLight,
                  buttonText: 'Login',
                  onTap: () async {
                    if (_emailController.text.isEmpty ||
                        _emailController.text.length < 4) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            backgroundColor:
                                const Color.fromARGB(255, 255, 17, 1),
                            content: Text('Invalid email',
                                textAlign: TextAlign.center, style: bodyText2),
                            duration: const Duration(milliseconds: 1500),
                            behavior: SnackBarBehavior.floating,
                            shape: const StadiumBorder()),
                      );

                      return;
                    }
                    if (_passwordController.text.isEmpty ||
                        _passwordController.text.length < 4) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            backgroundColor:
                                const Color.fromARGB(255, 255, 17, 1),
                            content: Text(
                                'Password must be at least 4 characters',
                                textAlign: TextAlign.center,
                                style: bodyText2),
                            duration: const Duration(milliseconds: 1500),
                            behavior: SnackBarBehavior.floating,
                            shape: const StadiumBorder()),
                      );

                      return;
                    }

                    // try {
                    var data = await storage.getItem(shopController.text.isEmpty
                        ? 'demo'
                        : shopController.text);

                    if (data == null) {
                      log('empty');
                      Provider.of<GeneralProvider>(context, listen: false)
                              .shop =
                          ShopProducts(id: 0, shopname: 'demo', products: [], sales:[], expenses: []);
                    } else {
                      log('not empty');
                      Provider.of<GeneralProvider>(context, listen: false)
                          .shop = shopProductsFromJson(data);
                    }

                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => Center(
                                child: CircularProgressIndicator(
                              color: primaryColorLight,
                            )));

                    await authService
                        .signInWithEmailAndPassword(
                            _emailController.text, _passwordController.text)
                        .then((user) {
                      navigatorKey.currentState!.pop((route) => route);
                    }).catchError((e) {
                      navigatorKey.currentState!.pop((route) => route);
                      loginError(e);
                    });

                    // await ApplicationState()
                    //     .signInWithEmailAndPassword(
                    //         _emailController.text.trim(),
                    //         _passwordController.text.trim(),
                    //         (e) => loginError(e))
                    //     .onError((error, stackTrace) =>
                    //         Navigator.pushReplacement(
                    //             context,
                    //             MaterialPageRoute(
                    //                 builder: (context) => Responsive.isMobile()
                    //                     ? MyHomeScreen()
                    //                     : TabletDashboard())));
                    // navigatorKey.currentState!.pop((route) => route);

                    // Navigator.pushReplacement(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => Responsive.isMobile()
                    //             ? MyHomeScreen()
                    //             : TabletDashboard()));

                    // log('1');
                    // log(shopController.text.isEmpty.toString());
                    // log("2");
                    // Provider.of<GeneralProvider>(context, listen: false).shop =
                    //     shopProductsFromJson();
                    // } on Exception catch (e) {
                    //   Provider.of<GeneralProvider>(context, listen: false)
                    //           .shop =
                    //       ShopProducts(id: 0, shopname: 'demo', products: []);
                    //   // log("HEERREE");
                    // }
                  },
                )),
            Row(children: [
              Text("Don't have an account? ", style: bodyText1),
              TextButton(
                  child: Text("Register",
                      style: bodyText2.copyWith(color: primaryColor)),
                  onPressed: () => widget.toggleScreen!())
            ]),
          ]),
        ));
  }
}
