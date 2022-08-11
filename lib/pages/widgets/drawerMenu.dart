// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:shop_manager/models/FirebaseApplicationState.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          SizedBox(
            height:height*0.3,
            child: DrawerHeader(
              decoration: BoxDecoration(
              ),
              child:
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    CircleAvatar(
                          backgroundColor: theme.primaryColor,
                          radius: width * 0.1,
                          child:
                              Icon(Icons.shop_2, color: theme.primaryColorLight, size: 30),
                        ),
                        SizedBox(height:height*0.01),
                        Text('Shop Manager',style: theme.textTheme.headline2!.copyWith(color:theme.primaryColor),),
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
            onTap: () {
              ApplicationState().signOut();
            },
            text: 'Logout',
            icon: Icons.logout,
          ),
          
        ],
      ),
    );
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
