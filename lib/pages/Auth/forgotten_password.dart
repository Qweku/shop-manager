// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:hive_flutter/hive_flutter.dart';
import 'package:shop_manager/components/button.dart';
import 'package:shop_manager/components/textFields.dart';
import 'package:shop_manager/main.dart';
import 'package:shop_manager/models/AuthService.dart';
import 'package:shop_manager/pages/widgets/constants.dart';
// import 'package:hive_flutter/hive_flutter.dart';

class ForgottenPassword extends StatefulWidget {
  final Function? toggleScreen;
  const ForgottenPassword({Key? key, this.toggleScreen}) : super(key: key);

  @override
  _ForgottenPasswordState createState() => _ForgottenPasswordState();
}

class _ForgottenPasswordState extends State<ForgottenPassword> {
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

  @override
  void dispose() {
    _emailController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
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
          Positioned(
              top: height * 0.03,
              left: 20,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 30),
              )),
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
                    backgroundImage: AssetImage("assets/app_icon.png"),
                  ),
                  SizedBox(height: height * 0.01),
                  Text(
                    'Shop Mate',
                    style: headline2,
                  ),
                  SizedBox(height: height * 0.05),
                  AnimatedContainer(
                      padding: EdgeInsets.only(bottom: height * 0.03),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                  padding: const EdgeInsets.only(bottom: 15),
                                  child: Text("Forgotten Password",
                                      style: headline2.copyWith(
                                          color: primaryColor))),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: height * 0.02),
                                child: CustomTextField(
                                  borderColor: Colors.grey,
                                  hintText: "Email",
                                  // hintColor: primaryColor,
                                  controller: _emailController,
                                  style: bodyText1,
                                  prefixIcon:
                                      Icon(Icons.email, color: primaryColor),
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(
                                      top: height * 0.04,
                                      bottom: height * 0.01),
                                  child: Button(
                                    width: width,
                                    color: primaryColor,
                                    // textColor: primaryColorLight,
                                    buttonText: 'Done',
                                    onTap: () async {
                                      if (_emailController.text.isEmpty ||
                                          _emailController.text.length < 4) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 255, 17, 1),
                                              content: Text('Invalid email',
                                                  textAlign: TextAlign.center,
                                                  style: bodyText2),
                                              duration: const Duration(
                                                  milliseconds: 1500),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              shape: const StadiumBorder()),
                                        );

                                        return;
                                      }

                                      showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (context) => Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                color: primaryColorLight,
                                              )));

                                      await authService
                                          .forgottenPassword(
                                              _emailController.text)
                                          .then((user) {
                                        navigatorKey.currentState!
                                            .pop((route) => route);
                                      }).catchError((e) {
                                        navigatorKey.currentState!
                                            .pop((route) => route);
                                        loginError(e);
                                      });

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            backgroundColor: Color.fromARGB(
                                                255, 38, 170, 26),
                                            content: Text(
                                                'Check your mail for reset link',
                                                textAlign: TextAlign.center,
                                                style: bodyText2),
                                            duration: const Duration(
                                                milliseconds: 1500),
                                            behavior: SnackBarBehavior.floating,
                                            shape: const StadiumBorder()),
                                      );

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
                                Text("Don't have an account? ",
                                    style: bodyText1),
                                TextButton(
                                    child: Text("Register",
                                        style: bodyText2.copyWith(
                                            color: primaryColor)),
                                    onPressed: () => widget.toggleScreen!())
                              ]),
                            ]),
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
