import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_manager/components/responsive.dart';
import 'package:shop_manager/pages/Auth/authentication.dart';
import 'package:shop_manager/pages/dashboard.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const MyHomeScreen();
          } else {
            return Responsive.isMobile()
                ? const Authentication()
                : const TabletAuth();
          }
        },
      ),
    );
  }
}
