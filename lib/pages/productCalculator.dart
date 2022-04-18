import 'package:flutter/material.dart';
import 'package:shop_manager/components/button.dart';
import 'package:shop_manager/components/textFields.dart';
import 'package:shop_manager/config/colors.dart';
import 'package:shop_manager/pages/widgets/clipPath.dart';

import 'widgets/productCalculatorWidget.dart';

class ProductCalculator extends StatefulWidget {
  const ProductCalculator({Key? key}) : super(key: key);

  @override
  _ProductCalculatorState createState() => _ProductCalculatorState();
}

class _ProductCalculatorState extends State<ProductCalculator> {
  final totalPrice = TextEditingController();
  final quantityItem = TextEditingController();
  final amountReceived = TextEditingController();
  bool items = false;
  double totalCost = 0.00;
  double balance = 0.00;
  double itemPrice = 13.00;
  int quantity = 1;

  @override
  void dispose() {
    quantityItem.dispose();
    super.dispose();
  }

  // calculateTotal() {
  //   quantity = int.parse(quantityItem.text);
  //   totalCost = itemPrice * quantity;
  // }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ShopColors.secondaryColor,
      body: SafeArea(
        top: false,
        child: SizedBox(
          height: height,
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipPath(
                    clipper: BottomClipper(),
                    child: Container(
                      padding: EdgeInsets.only(
                          right: height * 0.02,
                          left: height * 0.02,
                          top: height * 0.1,
                          bottom: height * 0.07),
                      color: theme.primaryColorLight,
                      width: width,
                    ),
                  ),
                  SizedBox(
                    //height: height * 0.6,
                    child: ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.only(top: height * 0.15),
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: width * 0.65,
                              child: ItemDetail(
                                  theme: theme, itemPrice: itemPrice),
                            ),
                            ItemCounter(
                              iconColor:theme.primaryColor,
                              boxColor: theme.primaryColorLight,
                                height: height, theme: theme, width: width),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                top: height * 0.05,
                child: Padding(
                  padding: EdgeInsets.all(height * 0.03),
                  child: Container(
                    height: height * 0.2,
                    decoration: BoxDecoration(
                        color: theme.primaryColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                              offset: Offset(2, 2),
                              color: Colors.black,
                              blurRadius: 3,
                              spreadRadius: 1)
                        ]),
                    child: Row(
                      children: [
                        Center(
                          child: Container(
                              height: 50,
                              width: width * 0.43,
                              decoration: const BoxDecoration(),
                              child: Column(
                                children: [
                                  Text('Total Amount',
                                      style: theme.textTheme.bodyText2),
                                  SizedBox(height: height * 0.01),
                                  Text(
                                    "GHS $totalCost",
                                    textAlign: TextAlign.center,
                                    style: theme.textTheme.headline2,
                                  ),
                                ],
                              )),
                        ),
                        Container(
                            height: height * 0.1,
                            width: 1,
                            color: theme.primaryColorLight),
                        Center(
                          child: Container(
                              height: 50,
                              width: width * 0.43,
                              decoration: const BoxDecoration(),
                              child: Column(
                                children: [
                                  Text('Balance',
                                      style: theme.textTheme.bodyText2),
                                  SizedBox(height: height * 0.01),
                                  Text(
                                    "GHS $balance",
                                    textAlign: TextAlign.center,
                                    style: theme.textTheme.headline2,
                                  ),
                                ],
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Container(
                    color: theme.primaryColor,
                    padding: EdgeInsets.all(height * 0.03),
                    child: Button(
                      onTap: () {
                        _bottomDrawSheet(context);
                      },
                      buttonText: 'Proceed',
                      color: theme.primaryColorLight,
                      textColor: theme.primaryColor,
                      width: width,
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  void _bottomDrawSheet(context) {
    final theme = Theme.of(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    showModalBottomSheet(
        backgroundColor: theme.primaryColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        ),
        context: context,
        builder: (BuildContext bc) {
          return Container(
            padding: EdgeInsets.all(height * 0.02),
            child: Wrap(
              spacing: 20,
              children: <Widget>[
                SizedBox(height: height * 0.02),
                Padding(
                  padding: EdgeInsets.only(
                      bottom: height * 0.02, top: height * 0.04),
                  child: Text("Enter Amount Received",
                      style: theme.textTheme.headline2),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: height * 0.04,
                  ),
                  child: CustomTextField(
                      //controller: categoryName,
                      hintText: 'Amount',
                      hintColor: Colors.white,
                      borderColor: Colors.white,
                      prefixIcon: const Icon(Icons.add_box,
                          color: Colors.white, size: 20),
                      style: theme.textTheme.bodyText2),
                ),
                SizedBox(height: height * 0.04),
                Button(
                  color: theme.primaryColorLight,
                  textColor: theme.primaryColor,
                  width: width,
                  buttonText: "Done",
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());

                    Navigator.pop(context);
                  },
                ),
                SizedBox(height: height * 0.4),
              ],
            ),
          );
        });
  }
}
