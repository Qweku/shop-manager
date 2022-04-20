import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_manager/components/button.dart';
import 'package:shop_manager/components/textFields.dart';
import 'package:shop_manager/config/colors.dart';
import 'package:shop_manager/models/GeneralProvider.dart';
import 'package:shop_manager/pages/productView.dart';
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
  static int indx = 0;
  final TextEditingController _counterController = TextEditingController();
  int counter = 1;

  @override
  void dispose() {
    quantityItem.dispose();
    _counterController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    Provider.of<GeneralProvider>(context, listen: false)
        .cart
        .forEach((element) {
      setState(() {
        totalCost += element.sellingPrice! * element.cartQuantity!;
      });
    });
    _counterController.text = "1";

    super.initState();
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
                          top: height * 0.13,
                          bottom: height * 0.07),
                      color: theme.primaryColorLight,
                      width: width,
                    ),
                  ),
                  SizedBox(
                    //height: height * 0.6,
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.only(top: height * 0.15),
                      itemCount:
                          Provider.of<GeneralProvider>(context, listen: false)
                              .cart
                              .length,
                      itemBuilder: (context, index) => Row(
                        children: [
                          SizedBox(
                            width: width * 0.65,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (builder) => ProductView(
                                            product:
                                                Provider.of<GeneralProvider>(
                                                        context,
                                                        listen: false)
                                                    .cart[index]))).then(
                                    (value) => setState(() {}));
                              },
                              child: ItemDetail(
                                  theme: theme,
                                  item: Provider.of<GeneralProvider>(context,
                                          listen: false)
                                      .cart[index]),
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(height * 0.01),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: theme.primaryColorLight),
                                child: GestureDetector(
                                    onTap: () {
                                      counter =
                                          int.parse(_counterController.text);
                                      if (counter > 1) {
                                        setState(() {
                                          counter--;
                                        });
                                      }
                                      _counterController.text =
                                          counter.toString();
                                    },
                                    child: Icon(Icons.remove,
                                        size: 15, color: theme.primaryColor)),
                              ),
                              SizedBox(
                                width: width * 0.13,
                                child: CustomTextField(
                                  textAlign: TextAlign.center,
                                  keyboard: TextInputType.number,
                                  controller: _counterController,
                                  hintColor: theme.primaryColor,
                                  style: theme.textTheme.bodyText2,
                                  onChanged: (text) {
                                    counter =
                                        int.parse(_counterController.text);
                                  },
                                  //hintText: '1',
                                  //borderColor: theme.primaryColorLight
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(height * 0.01),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: theme.primaryColorLight),
                                child: GestureDetector(
                                    onTap: () {
                                      counter =
                                          int.parse(_counterController.text);
                                      setState(() {
                                        counter++;
                                      });

                                      _counterController.text =
                                          counter.toString();
                                    },
                                    child: Icon(Icons.add,
                                        size: 15, color: theme.primaryColor)),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: height * 0.08,
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
                                    "GHS ${totalCost * counter}",
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
                      controller: amountReceived,
                      onChanged: (text) {
                        setState(() {
                          double amt = double.parse(amountReceived.text);
                          balance = amt - totalCost;
                        });
                      },
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
