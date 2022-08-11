// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shop_manager/components/button.dart';
import 'package:shop_manager/components/textFields.dart';
import 'package:shop_manager/main.dart';
import 'package:shop_manager/models/FirebaseApplicationState.dart';
import 'package:shop_manager/models/GeneralProvider.dart';
import 'package:shop_manager/models/ShopModel.dart';
import 'package:shop_manager/pages/dashboard.dart';

class LoginScreen extends StatefulWidget {
  final Function? toggleScreen;
  const LoginScreen({Key? key, this.toggleScreen}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool obsure = true;
  bool isShown = true;
  bool isNot = false;
  double num = 0.4;
  //double maxH = MediaQuery.of(context).size.height;
  IconData visibility = Icons.visibility_off;
  late Box shopBox;
  void launchHive() async {
    shopBox = await Hive.openBox<String>("shop");
  }

  @override
  void initState() {
    launchHive();
    super.initState();
  }

  void _loginError(Exception e, ) {
    showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "LOGIN ERROR",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            content: Text("An error happened while trying to login: ${(e as dynamic).message}"),
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
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);
    return AnimatedContainer(
            duration: const Duration(milliseconds: 700),
            height: height * 0.5,
            width: width*0.9,
            decoration: BoxDecoration(
                color: theme.primaryColorLight,
                borderRadius: BorderRadius.circular(width * 0.05)),
            child: Padding(
              padding: EdgeInsets.only(
                  top: height * 0.05,
                  right: height * 0.03,
                  left: height * 0.03),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Padding(
                       padding: const EdgeInsets.only(bottom: 30),
                       child: Text(
                         "WELCOME",
                         style: TextStyle(
                             fontWeight: FontWeight.bold,
                             fontSize: 25,
                             color: theme.primaryColor),
                       ),
                     ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: height * 0.02),
                      child: CustomTextField(
                        borderColor: theme.primaryColor,
                        hintText: "Username or email",
                        hintColor: theme.primaryColor,
                        controller: _emailController,
                        style: theme.textTheme.bodyText1,
                        prefixIcon: Icon(Icons.person,
                            color: theme.primaryColor),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: height * 0.02),
                      child: CustomTextField(
                        maxLines: 1,
                        obscure: obsure,
                        borderColor: theme.primaryColor,
                        style: theme.textTheme.bodyText1,
                        prefixIcon: Icon(Icons.lock,
                            color: theme.primaryColor),
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
                            child: Icon(visibility,
                                size: 25,
                                color: theme.primaryColor),
                          ),
                        ),
                        hintText: "Password",
                        hintColor: theme.primaryColor,
                      ),
                    ),
                    Padding(
                        padding:
                            EdgeInsets.only(top: height * 0.04,bottom: height*0.01),
                        child: Button(
                          width: width,
                          color: theme.primaryColor,
                          textColor: theme.primaryColorLight,
                          buttonText: 'Login',
                          onTap: () async {
                            ApplicationState().startLoginFlow();
                            

                            String shopJson = shopBox.get("shopDetail",
                                defaultValue: "{}");

                            Provider.of<GeneralProvider>(context,
                                    listen: false)
                                .shop = Shop.fromJson(shopJson);

                            Provider.of<GeneralProvider>(context,
                                        listen: false)
                                    .categories =
                                Shop.fromJson(shopJson).productCategory ??
                                    [];
                                    if (_emailController.text.isEmpty ||
                                      _emailController.text.length < 4) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                       SnackBar(
                                          backgroundColor:
                                              Color.fromARGB(255, 255, 17, 1),
                                          content: Text('Invalid email',textAlign:TextAlign.center,
                                              style: theme.textTheme.bodyText2),
                                          duration:
                                              Duration(milliseconds: 1500),
                                               behavior:SnackBarBehavior.floating,
                                              shape: StadiumBorder()),
                                    );
            
                                    return null;
                                  }else
                                  if (_passwordController.text.isEmpty ||
                                      _passwordController.text.length < 4) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      SnackBar(
                                          backgroundColor:
                                             Color.fromARGB(255, 255, 17, 1),
                                          content: Text(
                                              'Password must be at least 4 characters',
                                              textAlign:TextAlign.center,
                                              style:
                                                  theme.textTheme.bodyText2),
                                          duration:
                                              Duration(milliseconds: 1500),
                                               behavior:SnackBarBehavior.floating,
                                              shape: StadiumBorder()),
                                    );
            
                                    return null;
                                  }else{
                                    showDialog(context: context, 
                                    barrierDismissible: false,
                                    builder: (context)=>Center(child:CircularProgressIndicator(color: theme.primaryColorLight,)));
                                    await ApplicationState()
                                .verifyEmail(_emailController.text,
                                    (e) => _loginError(e))
                                .onError((error, stackTrace) => null);
                            await ApplicationState()
                                .signInWithEmailAndPassword(
                                    _emailController.text,
                                    _passwordController.text,
                                    (e) => _loginError(e))
                                .onError((error, stackTrace) => null);
                              navigatorKey.currentState!.pop((route)=>route);
                                  }
                            
                          },
                        )),
                         Row(children: [
                          Text("Don't have an account? ",
                              style: theme.textTheme.bodyText1),
                          TextButton(
                              child: Text("Register",
                                  style: theme.textTheme.bodyText2!
                                      .copyWith(color: theme.primaryColor)),
                              onPressed: () => widget.toggleScreen!())
                        ]),
                  ]),
            ))
          ;
  }

 }
