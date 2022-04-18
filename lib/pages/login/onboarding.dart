import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shop_manager/pages/login/login.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;
  Animation<Offset>? offsetAnimation;
  int currentPage = 0;
  List<IconData> icons = [
    Icons.store,
    Icons.category,
    Icons.receipt_long,
  ];
  List<String> splashContent = [
    "Welcome to your shop manager, where you can manage all your assets with ease!",
    "Organize all your products into categories for easy accessibility",
    "Get timely accounts of all your sales at your convenience",
  ];
  

  @override
  void initState() {
    animationController =
        AnimationController(duration: const Duration(seconds: 2), vsync: this)
          ..repeat(reverse: true);
    Timer(const Duration(seconds: 2), () => animationController!.forward());
    offsetAnimation =
        Tween<Offset>(begin: Offset.zero, end: const Offset(1.5, 0.0)).animate(
            CurvedAnimation(
                parent: animationController!, curve: Curves.elasticIn));

    super.initState();
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(color: theme.primaryColorLight),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            SizedBox(height: height * 0.1),
            Text('SHOP MANAGER',
                style: theme.textTheme.headline2!
                    .copyWith(color: theme.primaryColor,fontWeight: FontWeight.bold,fontSize: 25)),
            SizedBox(height: height * 0.05),
            Expanded(
              //flex: 3,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 800),
                child: 
                SplashPage(
                    icon: icons[currentPage],
                    text: splashContent[currentPage]),
              ),
            ),

            SizedBox(
              //flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    alignment: const Alignment(0, 0.9),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                           width: width*0.3,
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                currentPage = splashContent.length - 1;
                              });
                            },
                            child: Text('Skip',
                                style: theme.textTheme.bodyText2!
                                    .copyWith(color: theme.primaryColor)),
                          ),
                        ),
                        SizedBox(
                          width: width*0.3,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(splashContent.length,
                                (index) => buildDot(index: index)),
                          ),
                        ),
                        currentPage < splashContent.length - 1
                            ? SizedBox(
                               width: width*0.3,
                              child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (currentPage <
                                          splashContent.length - 1) {
                                        currentPage++;
                                      }
                                    });
                                  },
                                  child: Icon(Icons.arrow_forward,
                                      size: 30, color: theme.primaryColor)),
                            )
                            : SizedBox(
                               width: width*0.3,
                              child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginScreen()));
                                  },
                                  child: Text('Get Started',
                                      style: theme.textTheme.bodyText2!
                                          .copyWith(color: theme.primaryColor)),
                                ),
                            ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: height * 0.02)
            // _label()
          ],
        ),
      ),
    );
  }

  GestureDetector buildDot({int? index}) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        setState(() {
          currentPage = index!;
        });
      },
      child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          margin: const EdgeInsets.only(right: 5),
          height: 6,
          width: currentPage == index ? 20 : 6,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: currentPage == index ? theme.primaryColor : Colors.grey,
          )),
    );
  }
}

class SplashPage extends StatelessWidget {
  final String? text;
  final IconData icon;
  const SplashPage({
    Key? key,
    this.text,
    required this.icon,
    //required this.animationController
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);
    return Column(
      children: [
        SizedBox(height: height * 0.1),
        Icon(icon, size: height * 0.2, color: theme.primaryColor),
        SizedBox(height: height * 0.15),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            text!,
            textAlign: TextAlign.center,
            style: theme.textTheme.headline2!.copyWith(
                color: theme.primaryColor,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w300),
          ),
        ),
      ],
    );
  }
}
