// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shop_manager/models/AuthService.dart';
import 'package:shop_manager/models/FirebaseApplicationState.dart';
import 'package:shop_manager/models/services.dart';
import 'package:shop_manager/pages/Auth/authentication.dart';
import 'package:shop_manager/pages/widgets/constants.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          SizedBox(
            height: height * 0.3,
            child: DrawerHeader(
              decoration: BoxDecoration(),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                CircleAvatar(
                  backgroundColor: primaryColor,
                  radius: 30,
                  child:
                      Icon(Icons.shopify, color: primaryColorLight, size: 30),
                ),
                SizedBox(width: width * 0.02),
                Text(
                  'ShopMate',
                  style: headline2.copyWith(color: primaryColor),
                ),
              ]),
            ),
          ),
          DrawerItem(
            onTap: () {},
            text: 'Profile',
            icon: Icons.person,
          ),
          DrawerItem(
            onTap: () {},
            text: 'Settings',
            icon: Icons.settings,
          ),
          DrawerItem(
            onTap: () => _backButton(context),
            text: 'Logout',
            icon: Icons.logout,
          ),
        ],
      ),
    );
  }

  _backButton(context) {
   
    return showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              content: SizedBox(
                height: height * 0.13,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.warning_amber_outlined,
                        size: 40, color: Color.fromARGB(255, 255, 38, 23)),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Do you really want to logout?",
                      style: bodyText1,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () async {
                      ApplicationState().signOut();
                      Navigator.pop(context);
                    },
                    child: const Text("Yes")),
                TextButton(
                    onPressed: () => Navigator.pop(c, false),
                    child: const Text("No"))
              ],
            ));
  }
}

class DrawerItem extends StatelessWidget {
  final String text;
  final IconData icon;
  final Function()? onTap;
  const DrawerItem({
    Key? key,
    required this.text,
    required this.icon,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
        leading: Icon(icon, color: theme.primaryColor),
        title: Text(text,
            style: theme.textTheme.bodyText1!.copyWith(fontSize: 14)),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: theme.primaryColor,
          size: 15,
        ),
        onTap: onTap);
  }
}
