import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_manager/components/responsive.dart';
import 'package:shop_manager/models/AuthService.dart';
import 'package:shop_manager/models/UserModel.dart';
import 'package:shop_manager/pages/Auth/authentication.dart';
import 'package:shop_manager/pages/TabletScreens/Dashboard.dart';
import 'package:shop_manager/pages/dashboard.dart';
import 'package:shop_manager/pages/widgets/constants.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return StreamBuilder<UserModel?>(
        stream: authService.user,//FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            UserModel? user = snapshot.data;
            if (user == null) {
              return Responsive.isMobile()
                  ? const Authentication()
                  : const TabletAuth();
            }
            // int currentTime = Timestamp.now().millisecondsSinceEpoch;
            // usersReference
            //     .doc(user.uid)
            //     .set({"lastLoggedIn": currentTime}, SetOptions(merge: true));
            return Responsive.isMobile() ? MyHomeScreen() : TabletDashboard();
          } else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(color: primaryColor),
              ),
            );
          }
        });
  }

  // Widget build(BuildContext context) {
  //   return Scaffold(
  //       body: Responsive.isMobile()
  //           ? const Authentication()
  //           : const TabletAuth());
  // }
}
