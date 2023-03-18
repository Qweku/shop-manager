// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:shop_manager/components/button.dart';
import 'package:shop_manager/components/responsive.dart';
import 'package:shop_manager/components/textFields.dart';
import 'package:shop_manager/models/AuthService.dart';
import 'package:shop_manager/models/FirebaseApplicationState.dart';
import 'package:shop_manager/models/ShopModel.dart';
import 'package:shop_manager/pages/TabletScreens/Dashboard.dart';
import 'package:shop_manager/pages/dashboard.dart';
import 'package:shop_manager/pages/widgets/constants.dart';

import '../../main.dart';

class SignUp extends StatefulWidget {
  final Function? toggleScreen;
  const SignUp({
    Key? key,
    this.toggleScreen,
  }) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  LocalStorage storage = LocalStorage('shop_mate');

  bool obsure = true;
  IconData visibility = Icons.visibility_off;

  int count = 0;
  void _loginError(
    Exception e,
  ) {
    showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              "LOGIN ERROR",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            content: Text(
                "An error happened while trying to login: ${(e as dynamic).message}"),
            actions: [
              TextButton(
                  onPressed: (() => Navigator.of(context).pop()),
                  child: const Text("OK"))
            ],
          );
        });
  }

  final TextEditingController shopController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
   
    final authService = Provider.of<AuthService>(context);
    List<Widget> signUpList = [
      SignUpNameEmail(
          height: height,
          
          emailController: _emailController,
          nameController: shopController),
      SignUpPassword(
          passwordController: _passwordController,
          confirmPasswordController: _confirmPasswordController)
    ];

    return AnimatedContainer(
        padding: EdgeInsets.only(bottom: height * 0.03),
        duration: const Duration(milliseconds: 700),
        //height: height * 0.6,
        width: width * 0.9,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: primaryColorLight),
        child: Padding(
          padding: EdgeInsets.only(
              left: height * 0.03, right: height * 0.03, top: height * 0.03),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Row(
                    children: [
                      count > 0
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  count--;
                                });
                              },
                              icon: Icon(Icons.arrow_back, color: primaryColor))
                          : Container(),
                      count > 0
                          ? SizedBox(
                              width: 20,
                            )
                          : Container(),
                      Text(
                        "Create an account",
                        style: headline1.copyWith(color: primaryColor),
                      ),
                    ],
                  ),
                ),
                AnimatedSwitcher(
                    duration: Duration(milliseconds: 600),
                    child: signUpList[count]),
                Padding(
                    padding: EdgeInsets.only(
                        top: height * 0.04, bottom: height * 0.01),
                    child: Button(
                      onTap: () async {
                        if (count == 0 &&
                            (shopController.text.isEmpty ||
                                shopController.text.length < 4)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                backgroundColor:
                                    const Color.fromARGB(255, 255, 17, 1),
                                content: Text('Shop Name is Empty!',
                                    textAlign: TextAlign.center,
                                    style: bodyText2),
                                duration: const Duration(milliseconds: 1500),
                                behavior: SnackBarBehavior.floating,
                                shape: const StadiumBorder()),
                          );

                          return;
                        }
                        if (count == 0 &&
                            (_emailController.text.isEmpty ||
                                _emailController.text.length < 4)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                backgroundColor:
                                    const Color.fromARGB(255, 255, 17, 1),
                                content: Text('Invalid email',
                                    textAlign: TextAlign.center,
                                    style: bodyText2),
                                duration: const Duration(milliseconds: 1500),
                                behavior: SnackBarBehavior.floating,
                                shape: const StadiumBorder()),
                          );

                          return;
                        }
                        if (count == 1 &&
                            (_passwordController.text.isEmpty ||
                                _passwordController.text.length < 4)) {
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
                        if (count == 1 &&
                            (_passwordController.text !=
                                _confirmPasswordController.text)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                backgroundColor:
                                    const Color.fromARGB(255, 255, 17, 1),
                                content: Text("Password does not match",
                                    textAlign: TextAlign.center,
                                    style: bodyText2),
                                duration: const Duration(milliseconds: 1500),
                                behavior: SnackBarBehavior.floating,
                                shape: const StadiumBorder()),
                          );

                          return;
                        }
                        if (count < signUpList.length - 1) {
                          setState(() {
                            count++;
                          });
                        }

                        if (count == 1) {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => Center(
                                      child: CircularProgressIndicator(
                                    color: primaryColorLight,
                                  )));

                          ShopProducts shop = ShopProducts(
                              id: 0,
                              shopname: shopController.text,
                              products: []);

                          storage.setItem(
                              shopController.text, shopProductsToJson(shop));

                          await authService.createUserWithEmailAndPassword(
                              shopController.text,
                              _emailController.text,
                              _passwordController.text);

                          // await ApplicationState()
                          //     .registerAccount(
                          //         _emailController.text.trim(),
                          //         shopController.text.trim(),
                          //         _passwordController.text.trim(),
                          //         (e) => _loginError(e))
                          //     .onError((error, stackTrace) =>
                          //         Navigator.pushAndRemoveUntil(
                          //             context,
                          //             MaterialPageRoute(
                          //                 builder: (context) =>
                          //                     Responsive.isMobile()
                          //                         ? MyHomeScreen()
                          //                         : TabletDashboard()),
                          //             (route) => false));
                          navigatorKey.currentState!.pop((route) => route);
                        }
                      },
                      color: primaryColor,
                      buttonText:
                          count == signUpList.length - 1 ? "Signup" : "Next",
                      width: width,
                    )),
                Row(children: [
                  Text("Already have an account? ", style: bodyText1),
                  TextButton(
                      child: Text("Login",
                          style: bodyText2.copyWith(color: primaryColor)),
                      onPressed: () => widget.toggleScreen!())
                ]),
              ],
            ),
          ),
        ));
  }
}

class SignUpNameEmail extends StatelessWidget {
  const SignUpNameEmail({
    Key? key,
    required this.height,
    required TextEditingController emailController,
    
    required TextEditingController nameController,
  })  : _emailController = emailController,
        _nameController = nameController,
        super(key: key);

  final double height;
  final TextEditingController _emailController, _nameController;
  

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: height * 0.02),
          child: CustomTextField(
            controller: _nameController,
            borderColor: Colors.grey,
            hintText: "Name of shop",
            hintColor: Colors.grey,
            style: bodyText1,
            prefixIcon: Icon(Icons.shopify, color: primaryColor),
          ),
        ),
        Padding(
            padding: EdgeInsets.symmetric(vertical: height * 0.02),
            child: CustomPhoneTextField(
              borderColor: Colors.grey,
              textStyle: bodyText1,
            )),
        Padding(
          padding: EdgeInsets.symmetric(vertical: height * 0.02),
          child: CustomTextField(
            controller: _emailController,
            borderColor: Colors.grey,
            hintText: "Email",
            hintColor: Colors.grey,
            style: bodyText1,
            prefixIcon: Icon(Icons.person, color: primaryColor),
          ),
        ),
      ],
    );
  }
}

class SignUpPassword extends StatefulWidget {
  final TextEditingController _passwordController;
  final TextEditingController _confirmPasswordController;
  const SignUpPassword(
      {Key? key,
      required TextEditingController passwordController,
      required TextEditingController confirmPasswordController})
      : _passwordController = passwordController,
        _confirmPasswordController = confirmPasswordController,
        super(key: key);

  @override
  State<SignUpPassword> createState() => _SignUpPasswordState();
}

class _SignUpPasswordState extends State<SignUpPassword> {
  bool obscure = true;
  bool isMatch = false;
  IconData visibility = Icons.visibility_off;

  @override
  Widget build(BuildContext context) {
   
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: height * 0.02),
          child: CustomTextField(
            controller: widget._passwordController,
            maxLines: 1,
            obscure: obscure,
            borderColor: Colors.grey,
            style: bodyText1,
            prefixIcon: Icon(Icons.lock, color: primaryColor),
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  obscure = !obscure;
                  if (!obscure) {
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
            hintColor: Colors.grey,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: height * 0.02),
          child: CustomTextField(
            controller: widget._confirmPasswordController,
            maxLines: 1,
            obscure: obscure,
            borderColor: Colors.grey,
            style: bodyText1,
            onChanged: (text) {
              if (text == widget._passwordController.text) {
                setState(() {
                  isMatch = !isMatch;
                });
              }
            },
            prefixIcon: Icon(Icons.lock, color: primaryColor),
            suffixIcon: isMatch
                ? Icon(Icons.check_circle, color: Colors.green)
                : Icon(Icons.cancel, color: Colors.red),
            hintText: "Confirm Password",
            hintColor: Colors.grey,
          ),
        ),
      ],
    );
  }
}
