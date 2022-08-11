import 'package:flutter/material.dart';
import 'package:shop_manager/pages/widgets/clipPath.dart';

class Accounts extends StatefulWidget {
  const Accounts({Key? key}) : super(key: key);

  @override
  State<Accounts> createState() => _AccountsState();
}

class _AccountsState extends State<Accounts> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            ClipPath(
              clipper: BottomClipper(),
              child: Container(
                padding: EdgeInsets.only(
                    right: height * 0.02,
                    left: height * 0.02,
                    top: height * 0.13,
                    bottom: height * 0.07),
                color: theme.primaryColor,
                child: HeaderSection(
                  title: 'Account History',
                  height: height,
                  width: width,
                  theme: theme,
                  onPressed: () {},
                ),
              ),
            ),
            
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.05,
              ),
              child: Container(
                width: width*0.9,
                padding: EdgeInsets.all(width*0.05),
                decoration: BoxDecoration(
                  color:Color.fromARGB(255, 239, 245, 255),
                  borderRadius: BorderRadius.circular(20)
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Text('Grand Total',style:theme.textTheme.headline1!.copyWith(fontSize:17)),
                  SizedBox(height:height*0.01),
                   Text('GHS2000.00',style:theme.textTheme.headline1!.copyWith(color:theme.primaryColor)),
                ]),
              ),
            ),
            SizedBox(height:height*0.02),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.05,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width:width*0.3,
                      child: Text('Item Name',
                          style: theme.textTheme.bodyText1!
                              .copyWith(fontWeight: FontWeight.bold))),
                  SizedBox(
                    width:width*0.3,
                      child: Text('Quantity',textAlign: TextAlign.center,
                          style: theme.textTheme.bodyText1!
                              .copyWith(fontWeight: FontWeight.bold))),
                  SizedBox(
                    width:width*0.3,
                      child: Text('Total',textAlign: TextAlign.end,
                          style: theme.textTheme.bodyText1!
                              .copyWith(fontWeight: FontWeight.bold))),
                ],
              ),
            ),
            SizedBox(height: height * 0.03),
            Expanded(
              child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: 25,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: width * 0.05, vertical: height * 0.01),
                      child: AccountList(width:width,theme: theme),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}

class AccountList extends StatelessWidget {
  const AccountList({
    Key? key,
    required this.theme, required this.width,
  }) : super(key: key);

  final ThemeData theme;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
         SizedBox(
                    width:width*0.3,
                      child: Text('Milk',
                          style: theme.textTheme.bodyText1)),
                  SizedBox(
                    width:width*0.3,
                      child: Text('2',textAlign: TextAlign.center,
                          style: theme.textTheme.bodyText1)),
                  SizedBox(
                    width:width*0.3,
                      child: Text('GHS12.00',textAlign: TextAlign.end,
                          style: theme.textTheme.bodyText1)),
      ],
    );
  }
}
