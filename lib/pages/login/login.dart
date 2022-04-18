import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shop_manager/components/button.dart';
import 'package:shop_manager/components/textFields.dart';
import 'package:shop_manager/config/colors.dart';
import 'package:shop_manager/models/GeneralProvider.dart';
import 'package:shop_manager/models/ShopModel.dart';
 import 'package:shop_manager/pages/dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

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
  
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);
    return WillPopScope(
       onWillPop: ()=>_backButton(),
      child: Scaffold(
        //resizeToAvoidBottomInset:false,
          backgroundColor: theme.primaryColor,
          body: Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 800),
                top: 0,
                right: 0,
                left: 0,
                child: AnimatedContainer(
                   duration: const Duration(milliseconds: 800),
                  height: height * 0.65,
                  decoration: BoxDecoration(
                      color: ShopColors.secondaryColor,
                      borderRadius: BorderRadius.only(
                          // bottomLeft: Radius.circular(width),
                          bottomRight: Radius.circular(width * 0.5))),
                  child: Padding(
                    padding:  EdgeInsets.only(top: height*0.1, right: height*0.03, left: height*0.03),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Visibility(
                            visible: isNot,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Text(
                                "Existing user?",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                    color: ShopColors.primaryColor),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: isShown,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 30),
                              child: Text(
                                "WELCOME",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                    color: ShopColors.primaryColor),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: isShown,
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: height*0.02),
                              child: CustomTextField(
                                borderColor: theme.primaryColorLight,
                                hintText: "Username or email",
                                hintColor: theme.primaryColorLight,
                                style:theme.textTheme.bodyText2,
                                prefixIcon: Icon(Icons.person,color:theme.primaryColorLight),
                              ),
                            )
                            
                          )
                          ,
                          Visibility(
                            visible: isShown,
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: height*0.02),
                              child: CustomTextField(
                                maxLines: 1,
                                obscure: true,
                                borderColor: theme.primaryColorLight,
                                style:theme.textTheme.bodyText2,
                                 prefixIcon: Icon(Icons.lock,
                                          color: theme.primaryColorLight),
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
                                              color: ShopColors.primaryColor),
                                        ),
                                      ),
                                      hintText: "Password",
                                      hintColor: theme.primaryColorLight,
                              ),
                            )
                           
                          ),
                          Padding(
                              padding: EdgeInsets.symmetric(vertical: height*0.04),
                              child: Button(
                                width: width,
                                color:theme.primaryColorLight,
                                textColor: theme.primaryColor,
                                buttonText: 'Login',
                                onTap: () async {
                                    String shopJson = shopBox.get("shopDetail",
                                        defaultValue: "{}");
    
                                    Provider.of<GeneralProvider>(context,
                                            listen: false)
                                        .shop = Shop.fromJson(shopJson);
    
                                    Provider.of<GeneralProvider>(context,
                                                listen: false)
                                            .categories = Shop.fromJson(shopJson).productCategory ?? [];
    
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Dashboard()));
                                  },
                              )
                              
                        )    ]),
                  ),
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 800),
                bottom: 0,
                right: 0,
                left: 0,
                child: AnimatedContainer(
                   duration: const Duration(milliseconds: 800),
                    height: height * num,
                    decoration: BoxDecoration(
                        color: ShopColors.secondaryColor,
                        borderRadius: BorderRadius.only(
                            // bottomLeft: Radius.circular(width),
                            bottomRight: Radius.circular(width * 0.5))),
                    child: Padding(
                      padding:  EdgeInsets.only(top: height*0.1, right: height*0.03, left: height*0.03),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Visibility(
                              visible: isNot,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Text(
                                  "Existing user?",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                      color: ShopColors.primaryColor),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: isShown,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 30),
                                child: Text(
                                  "WELCOME",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                      color: ShopColors.primaryColor),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: isShown,
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: height*0.02),
                                child: CustomTextField(
                                  borderColor: theme.primaryColorLight,
                                  hintText: "Username or email",
                                  hintColor: theme.primaryColorLight,
                                  style:theme.textTheme.bodyText2,
                                  prefixIcon: Icon(Icons.person,color:theme.primaryColorLight),
                                ),
                              )
                              
                            )
                            ,
                            Visibility(
                              visible: isShown,
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: height*0.02),
                                child: CustomTextField(
                                  maxLines: 1,
                                  obscure: true,
                                  borderColor: theme.primaryColorLight,
                                  style:theme.textTheme.bodyText2,
                                   prefixIcon: Icon(Icons.lock,
                                            color: theme.primaryColorLight),
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
                                                color: ShopColors.primaryColor),
                                          ),
                                        ),
                                        hintText: "Password",
                                        hintColor: theme.primaryColorLight,
                                ),
                              )
                             
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: height*0.04),
                                child: Button(
                                  width: width,
                                  color:theme.primaryColorLight,
                                  textColor: theme.primaryColor,
                                  buttonText: 'Login',
                                   onTap: () {
      
                                      if (isShown == false) {
                                        // isShown = true;
                                        // num = 0.35;
                                        // isNot = false;
                                        // return null;
                                        setState(() {
                                          isShown = true;
                                          num = 0.4;
                                          isNot = false;
                                        });
                                      } else {
                                        
                                        Navigator.push(
                                            context, MaterialPageRoute(builder: (context) => const Dashboard()));
                                      }
                                    },
                                )
                                
                          )    ]),
                    ),
                  ),
                ),
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 800),
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: AnimatedContainer(
                     duration: const Duration(milliseconds: 800),
                      height: height * num,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              // bottomLeft: Radius.circular(width),
                              topRight: Radius.circular(width * 0.4)),
                          color: ShopColors.primaryColor),
                      child: Padding(
                        padding:  EdgeInsets.only(left:height*0.03, 
                            right: height*0.03, top: height*0.05),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Visibility(
                                visible: isShown,
                                child: Text(
                                  "OR",
                                  style: TextStyle(
                                      color: ShopColors.secondaryColor, fontSize: 25),
                                ),
                              ),
                              Visibility(
                                visible: isNot,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 30),
                                  child: Text(
                                    "Create an Account",
                                    style: TextStyle(
                                        color: ShopColors.secondaryColor,
                                        fontSize: 25),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: isNot,
                                child: Padding(
                                  padding:  EdgeInsets.symmetric(vertical: height*0.02),
                                  child: CustomTextField(
                                    borderColor: theme.primaryColor,
                                    hintText: "Username or email",
                                    hintColor: theme.primaryColor,
                                    style:theme.textTheme.bodyText2!.copyWith(color:theme.primaryColor),
                                    prefixIcon: Icon(Icons.person,color:theme.primaryColor),
                                  ), ),
                              ),
                              Visibility(
                                visible: isNot,
                                child: Padding(
                                 padding: EdgeInsets.symmetric(vertical: height*0.02),
                                  child: CustomTextField(
                                    maxLines: 1,
                                    obscure: true,
                                    borderColor: theme.primaryColor,
                                    style:theme.textTheme.bodyText2!.copyWith(color:theme.primaryColor),
                                     prefixIcon: Icon(Icons.lock,
                                              color: theme.primaryColor),
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
                              ),
                              Visibility(
                                visible: isNot,
                                child: Padding(
                                padding: EdgeInsets.symmetric(vertical: height*0.02),
                                  child: CustomTextField(
                                    maxLines: 1,
                                    obscure: true,
                                    borderColor: theme.primaryColor,
                                    style:theme.textTheme.bodyText2!.copyWith(color:theme.primaryColor),
                                     prefixIcon: Icon(Icons.lock,
                                              color: theme.primaryColor),
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
                                          hintText: "Confirm Password",
                                          hintColor: theme.primaryColor,
                                  ),
                               ),
                              ),
                              Padding(
                                  padding: const EdgeInsets.only(top: 50),
                                  child: 
                                  Button(
                                     onTap: () {
                                        setState(() {
                                          isShown = false;
                                          num = 0.6;
                                          isNot = true;
                                        });
                        
                                        // Navigator.push(
                                        //     context, MaterialPageRoute(builder: (context) => ActivatePage()));
                                      },
                                      color: theme.primaryColor,
                                      buttonText: "Signup",
                                      width: width,
                                  )
                                
                                      ),
                            ],
                          ),
                        ),
                      )),
                ),
              ],
            )),
    )
    ;
  }
  _backButton(){
    return showDialog<bool>(
            context: context,
            builder: (c) => AlertDialog(
                  title: const Text("Warning"),
                  content: const Text("Do you really want to exit?"),
                  actions: [
                    TextButton(
                        onPressed: () async {
                          if (Platform.isIOS) {
                            exit(0);
                          }
                          if (Platform.isAndroid) {
                            return await SystemChannels.platform
                                .invokeMethod<void>('SystemNavigator.pop');
                          }
                        },
                        child: const Text("Yes")),
                    TextButton(
                        onPressed: () => Navigator.pop(c, false),
                        child: const Text("No"))
                  ],
                ));
  }
}
