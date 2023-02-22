// ignore_for_file: prefer_const_constructors



import 'package:flutter/material.dart';
import 'package:shop_manager/components/button.dart';
import 'package:shop_manager/components/responsive.dart';
import 'package:shop_manager/components/textFields.dart';
import 'package:shop_manager/pages/TabletScreens/Dashboard.dart';
import 'package:shop_manager/pages/dashboard.dart';
import 'package:shop_manager/pages/widgets/constants.dart';
// import 'package:hive_flutter/hive_flutter.dart';

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
  IconData visibility = Icons.visibility_off;

  void _loginError(
    Exception e,
  ) {
    showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "LOGIN ERROR",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            content: Text(
                "An error happened while trying to login: ${(e as dynamic).message}"),
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
    
    final theme = Theme.of(context);
    return AnimatedContainer(
        padding: EdgeInsets.only(bottom: height * 0.03),
        duration: const Duration(milliseconds: 700),
        // height: height * 0.5,
        width: width * 0.9,
        decoration: BoxDecoration(
            color: primaryColorLight,
            borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: EdgeInsets.only(
              top: height * 0.03, right: height * 0.03, left: height * 0.03),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Text("Welcome back",
                    style: theme.textTheme.headline2!
                        .copyWith(color: primaryColor))),
            Padding(
              padding: EdgeInsets.symmetric(vertical: height * 0.02),
              child: CustomTextField(
                borderColor: Colors.grey,
                hintText: "Shop Name",
                //hintColor: theme.primaryColor,
                controller: shopController,
                style: theme.textTheme.bodyText1,
                prefixIcon: Icon(Icons.shopify, color: primaryColor),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: height * 0.02),
              child: CustomTextField(
                borderColor: Colors.grey,
                hintText: "Username or email",
                // hintColor: theme.primaryColor,
                controller: _emailController,
                style: theme.textTheme.bodyText1,
                prefixIcon: Icon(Icons.person, color: primaryColor),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: height * 0.02),
              child: CustomTextField(
                maxLines: 1,
                obscure: obsure,
                borderColor: Colors.grey,
                style: theme.textTheme.bodyText1,
                prefixIcon: Icon(Icons.lock, color:primaryColor),
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
                    child:
                        Icon(visibility, size: 25, color: primaryColor),
                  ),
                ),
                hintText: "Password",
                // hintColor: theme.primaryColor,
              ),
            ),
            Padding(
                padding:
                    EdgeInsets.only(top: height * 0.04, bottom: height * 0.01),
                child: Button(
                  width: width,
                  color: primaryColor,
                  // textColor: theme.primaryColorLight,
                  buttonText: 'Login',
                  onTap: () async {
                  
                  

                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Responsive.isMobile()
                                ? MyHomeScreen()
                                : TabletDashboard()));
                 
                  },
                )),
            Row(children: [
              Text("Don't have an account? ", style: theme.textTheme.bodyText1),
              TextButton(
                  child: Text("Register",
                      style: theme.textTheme.bodyText2!
                          .copyWith(color: primaryColor)),
                  onPressed: () => widget.toggleScreen!())
            ]),
          ]),
        ));
  }
}
