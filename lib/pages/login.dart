import 'package:flutter/material.dart';
import 'package:shop_manager/config/colors.dart';
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
  double num = 0.35;
  //double maxH = MediaQuery.of(context).size.height;
  IconData visibility = Icons.visibility_off;
  Widget _loginButton() {
    return InkWell(
        onTap: () {
          // setState(() {
          //     isShown = true;
          //   });
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => ActivatePage()));
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 13),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              //border: Border.all(color: BaseColors.secondaryColor, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(20)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.black45,
                    offset: Offset(1, 3),
                    blurRadius: 5,
                    spreadRadius: 1)
              ],
              color: ShopColors.primaryColor),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.vpn_key, color: ShopColors.secondaryColor),
              SizedBox(width: 10),
              Text(
                'Login',
                style:
                    TextStyle(fontSize: 20, color: ShopColors.secondaryColor),
              ),
            ],
          ),
        ));
  }

  Widget _signupButton() {
    return InkWell(
        onTap: () {
          // setState(() {
          //   isShown = false;
          // });

          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => ActivatePage()));
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 13),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              //border: Border.all(color: BaseColors.secondaryColor, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(20)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.black45,
                    offset: Offset(1, 3),
                    blurRadius: 5,
                    spreadRadius: 1)
              ],
              color: ShopColors.secondaryColor),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.vpn_key, color: ShopColors.primaryColor),
              SizedBox(width: 10),
              Text(
                'Signup',
                style: TextStyle(
                    fontSize: 20,
                    color: ShopColors.primaryColor,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: ShopColors.primaryColor,
        body: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: Container(
                height: height * 0.65,
                decoration: BoxDecoration(
                    color: ShopColors.secondaryColor,
                    borderRadius: BorderRadius.only(
                        // bottomLeft: Radius.circular(width),
                        bottomRight: Radius.circular(width * 0.5))),
                child: Padding(
                  padding: const EdgeInsets.only(top: 100, right: 20, left: 20),
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
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: ShopColors.primaryColor, width: 2),
                                  borderRadius: BorderRadius.circular(20)),
                              child: TextFormField(
                                //controller: _usernameController,
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  color: ShopColors.primaryColor,
                                  fontSize: 17,
                                ),
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.person,
                                      color: ShopColors.primaryColor, size: 20),
                                  hintText: "Username or email",
                                  hintStyle:
                                      TextStyle(color: ShopColors.primaryColor),
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorStyle: TextStyle(fontSize: 15),
                                  disabledBorder: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 15.0),
                                ),
                                // validator: MultiValidator([
                                //   RequiredValidator(
                                //       errorText: "*field cannot be empty"),
                                // ]),
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: isShown,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: ShopColors.primaryColor, width: 2),
                                  borderRadius: BorderRadius.circular(20)),
                              child: TextFormField(
                                obscureText: obsure,
                                //controller: _passwordController,
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                ),
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.lock,
                                      color: ShopColors.primaryColor),
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
                                      padding: EdgeInsets.only(right: 10),
                                      child: Icon(visibility,
                                          size: 25,
                                          color: ShopColors.primaryColor),
                                    ),
                                  ),
                                  hintText: "Password",
                                  hintStyle:
                                      TextStyle(color: ShopColors.primaryColor),
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 15.0),
                                ),
                                // validator: MultiValidator([
                                //   RequiredValidator(
                                //       errorText: "*field cannot be empty"),
                                // ]),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: InkWell(
                                onTap: () {

                                  if (isShown == false) {
                                    // isShown = true;
                                    // num = 0.35;
                                    // isNot = false;
                                    // return null;
                                    setState(() {
                                      isShown = true;
                                      num = 0.35;
                                      isNot = false;
                                    });
                                  } else {
                                    
                                    Navigator.push(
                                        context, MaterialPageRoute(builder: (context) => Dashboard()));
                                  }
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.symmetric(vertical: 13),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      //border: Border.all(color: BaseColors.secondaryColor, width: 1),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                            color: Colors.black45,
                                            offset: Offset(1, 3),
                                            blurRadius: 5,
                                            spreadRadius: 1)
                                      ],
                                      color: ShopColors.primaryColor),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.vpn_key,
                                          color: ShopColors.secondaryColor),
                                      SizedBox(width: 10),
                                      Text(
                                        'Login',
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: ShopColors.secondaryColor),
                                      ),
                                    ],
                                  ),
                                ))),
                      ]),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Container(
                  height: height * num,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          // bottomLeft: Radius.circular(width),
                          topRight: Radius.circular(width * 0.4)),
                      color: ShopColors.primaryColor),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 50),
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
                              "SIGNUP",
                              style: TextStyle(
                                  color: ShopColors.secondaryColor,
                                  fontSize: 25),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: isNot,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: ShopColors.secondaryColor!,
                                      width: 2),
                                  borderRadius: BorderRadius.circular(20)),
                              child: TextFormField(
                                //controller: _usernameController,
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  color: ShopColors.secondaryColor,
                                  fontSize: 17,
                                ),
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.person,
                                      color: ShopColors.secondaryColor,
                                      size: 20),
                                  hintText: "Username or email",
                                  hintStyle: TextStyle(
                                      color: ShopColors.secondaryColor),
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorStyle: TextStyle(fontSize: 15),
                                  disabledBorder: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 15.0),
                                ),
                                // validator: MultiValidator([
                                //   RequiredValidator(
                                //       errorText: "*field cannot be empty"),
                                // ]),
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: isNot,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: ShopColors.secondaryColor!,
                                      width: 2),
                                  borderRadius: BorderRadius.circular(20)),
                              child: TextFormField(
                                obscureText: obsure,
                                //controller: _passwordController,
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                ),
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.lock,
                                      color: ShopColors.secondaryColor),
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
                                      padding: EdgeInsets.only(right: 10),
                                      child: Icon(visibility,
                                          size: 25,
                                          color: ShopColors.secondaryColor),
                                    ),
                                  ),
                                  hintText: "Password",
                                  hintStyle: TextStyle(
                                      color: ShopColors.secondaryColor),
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 15.0),
                                ),
                                // validator: MultiValidator([
                                //   RequiredValidator(
                                //       errorText: "*field cannot be empty"),
                                // ]),
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: isNot,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: ShopColors.secondaryColor!,
                                      width: 2),
                                  borderRadius: BorderRadius.circular(20)),
                              child: TextFormField(
                                obscureText: obsure,
                                //controller: _passwordController,
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                ),
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.lock,
                                      color: ShopColors.secondaryColor),
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
                                      padding: EdgeInsets.only(right: 10),
                                      child: Icon(visibility,
                                          size: 25,
                                          color: ShopColors.secondaryColor),
                                    ),
                                  ),
                                  hintText: "Re-Enter Password",
                                  hintStyle: TextStyle(
                                      color: ShopColors.secondaryColor),
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 15.0),
                                ),
                                // validator: MultiValidator([
                                //   RequiredValidator(
                                //       errorText: "*field cannot be empty"),
                                // ]),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(top: 50),
                            child: InkWell(
                                onTap: () {
                                  setState(() {
                                    isShown = false;
                                    num = 0.7;
                                    isNot = true;
                                  });

                                  // Navigator.push(
                                  //     context, MaterialPageRoute(builder: (context) => ActivatePage()));
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.symmetric(vertical: 13),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      //border: Border.all(color: BaseColors.secondaryColor, width: 1),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                            color: Colors.black45,
                                            offset: Offset(1, 3),
                                            blurRadius: 5,
                                            spreadRadius: 1)
                                      ],
                                      color: ShopColors.secondaryColor),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.person_add,
                                          color: ShopColors.primaryColor),
                                      SizedBox(width: 10),
                                      Text(
                                        'Signup',
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: ShopColors.primaryColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ))),
                      ],
                    ),
                  )),
            ),
          ],
        ));
  }
}
