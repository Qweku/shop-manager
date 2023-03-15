import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shop_manager/pages/Auth/login.dart';
import 'package:shop_manager/pages/Auth/signup.dart';
import 'package:shop_manager/pages/widgets/constants.dart';

class Authentication extends StatefulWidget {
  const Authentication({Key? key}) : super(key: key);

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  bool isToggle = false;
  void toggleScreen() {
    setState(() {
      isToggle = !isToggle;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () => _backButton(),
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        backgroundColor: theme.primaryColor,
        body: Stack(
          children: [
            Positioned(
              top:-height*0.15,
              right:-width*0.5,
              child: CircleAvatar(
              radius:width*0.6,
              backgroundColor:Colors.black.withOpacity(0.4)
            )),
             Positioned(
              bottom:-height*0.1,
              left:-width*0.1,
              child: CircleAvatar(
              radius:width*0.4,
              backgroundColor:Colors.black.withOpacity(0.4)
            )),
            Container(
              alignment: const Alignment(0,0),
              
              width: width,
              child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: theme.primaryColorLight,
                        radius: width * 0.12,
                        backgroundImage: AssetImage("assets/app_icon.png"),
                      
                      ),
                      SizedBox(height:height*0.01),
                      Text('Smart Shop Mate',style: theme.textTheme.headline2,),
                      SizedBox(height: height * 0.05),
                      AnimatedSwitcher(duration: const Duration(milliseconds: 700),
                      child: isToggle ?  SignUp(toggleScreen: toggleScreen,) :  LoginScreen(toggleScreen: toggleScreen,),
                      )
                      
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _backButton() {
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


class TabletAuth extends StatefulWidget {
  const TabletAuth({Key? key}) : super(key: key);

  @override
  State<TabletAuth> createState() => _TabletAuthState();
}

class _TabletAuthState extends State<TabletAuth> {
  bool isToggle = false;
  void toggleScreen() {
    setState(() {
      isToggle = !isToggle;
    });
  }
  @override
  Widget build(BuildContext context) {
    var theme=Theme.of(context);
    return WillPopScope(
      onWillPop: () => _backButton(),
      child: Scaffold(
        //resizeToAvoidBottomInset: false,
        backgroundColor: theme.primaryColor,
        body: Stack(
          children: [
            Positioned(
              top:-height*0.15,
              right:-width*0.5,
              child: CircleAvatar(
              radius:width*0.6,
              backgroundColor:Colors.black.withOpacity(0.4)
            )),
             Positioned(
              bottom:-height*0.1,
              left:-width*0.1,
              child: CircleAvatar(
              radius:width*0.1,
              backgroundColor:Colors.black.withOpacity(0.4)
            )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                Container(
                  alignment: const Alignment(0,0),
                  
                  width: width*0.35,
                  child: SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(isToggle?'Welcome,':'Hi, ',style: theme.textTheme.headline2,),
                          SizedBox(height: height * 0.01),
                          Text(isToggle?'Sign up to get started':"We've missed you, login to continue",style: theme.textTheme.bodyText2,),
                          SizedBox(height: height * 0.05),
                          AnimatedSwitcher(duration: const Duration(milliseconds: 700),
                          child: isToggle ?  SignUp(toggleScreen: toggleScreen,) :  LoginScreen(toggleScreen: toggleScreen,),
                          )
                          
                        ]),
                  ),
                ),
                Image.asset('assets/shop-3d.png',)
              ],
            ),
          ],
        ),
      ),
    );
 
  }
   _backButton() {
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
