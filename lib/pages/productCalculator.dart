import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shop_manager/components/button.dart';
import 'package:shop_manager/components/textFields.dart';
import 'package:shop_manager/config/colors.dart';
import 'package:shop_manager/models/GeneralProvider.dart';
import 'package:shop_manager/pages/Summary.dart';
import 'package:shop_manager/pages/productView.dart';
import 'package:shop_manager/pages/widgets/clipPath.dart';
import 'package:shop_manager/pages/widgets/constants.dart';

import 'widgets/productCalculatorWidget.dart';

class ProductCalculator extends StatefulWidget {
  const ProductCalculator({Key? key}) : super(key: key);

  @override
  _ProductCalculatorState createState() => _ProductCalculatorState();
}

class _ProductCalculatorState extends State<ProductCalculator> {
  final amountReceived = TextEditingController();
  double totalCost = 0.00;
  double balance = 0.00;

  bool isDone = false;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    totalCost = 0;
    context.watch<GeneralProvider>().cart.forEach((element) {
      totalCost += element.sellingPrice! * element.cartQuantity!;
    });

    final theme = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // backgroundColor: ShopColors.secondaryColor,
      appBar: AppBar(
        title: Text(
          "Basket",
          style: theme.textTheme.headline1,
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        centerTitle: true,
      ),
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
                  // ClipPath(
                  //   clipper: BottomClipper(),
                  //   child: Container(
                  //     padding: EdgeInsets.only(
                  //         right: height * 0.02,
                  //         left: height * 0.02,
                  //         top: height * 0.13,
                  //         bottom: height * 0.07),
                  //     color: theme.primaryColorLight,
                  //     width: width,
                  //   ),
                  // ),
                  SizedBox(
                    //height: height * 0.6,
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.only(top: height * 0.03),
                      itemCount: context.watch<GeneralProvider>().cart.length,
                      itemBuilder: (context, index) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: width * 0.65,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
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
                                  backgroundColor:
                                      Color.fromARGB(255, 233, 233, 233),
                                  textColor: Color.fromARGB(255, 26, 26, 26),
                                  theme: theme,
                                  item: Provider.of<GeneralProvider>(context,
                                          listen: false)
                                      .cart[index]),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: width * 0.05),
                            child: IconButton(
                              onPressed: () {
                                context
                                    .read<GeneralProvider>()
                                    .removeFromCart(index);
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // Positioned(
              //   top: height * 0.08,
              //   child: Padding(
              //     padding: EdgeInsets.all(height * 0.03),
              //     child: Card(
              //       color: primaryColor,
              //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              //       elevation: 5,
              //       child: SizedBox(
              //         height: height * 0.2,

              //         child: Row(
              //           children: [
              //             Center(
              //               child: Container(
              //                   height: 50,
              //                   width: width * 0.43,
              //                   decoration: const BoxDecoration(),
              //                   child: Column(
              //                     children: [
              //                       Text('Total Amount',
              //                           style: theme.textTheme.bodyText2),
              //                       SizedBox(height: height * 0.01),
              //                       Text(
              //                         "GHS $totalCost ",
              //                         textAlign: TextAlign.center,
              //                         style: theme.textTheme.headline2,
              //                       ),
              //                     ],
              //                   )),
              //             ),
              //             Container(
              //                 height: height * 0.1,
              //                 width: 1,
              //                 color: theme.primaryColorLight),
              //             Center(
              //               child: Container(
              //                   height: 50,
              //                   width: width * 0.43,
              //                   decoration: const BoxDecoration(),
              //                   child: Column(
              //                     children: [
              //                       Text('Change',
              //                           style: theme.textTheme.bodyText2),
              //                       SizedBox(height: height * 0.01),
              //                       Text(
              //                         "GHS $balance",
              //                         textAlign: TextAlign.center,
              //                         style: theme.textTheme.headline2,
              //                       ),
              //                     ],
              //                   )),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //   ),
              // ),

              Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    child: Container(
                      color: theme.primaryColor,
                      padding: EdgeInsets.all(height * 0.03),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Total Amount',
                                  style: theme.textTheme.bodyText2),
                              SizedBox(height: height * 0.01),
                              Text(
                                "GHS $totalCost ",
                                textAlign: TextAlign.center,
                                style: theme.textTheme.headline2,
                              ),
                            ],
                          ),
                          Button(
                            onTap: () {
                              if (!isDone) {
                                _bottomDrawSheet(context);
                              } else {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (builder) =>
                                            const SummaryScreen()));
                              }
                            },
                            buttonText: isDone ? 'Done' : 'Proceed',
                            color: theme.primaryColorLight,
                            textColor: theme.primaryColor,
                            width: width * 0.4,
                          ),
                        ],
                      ),
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
            child: Column(
              // spacing: 20,
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
                      keyboard: TextInputType.number,
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
                SizedBox(height: height * 0.03),
                Column(
                  children: [
                    Text('Change', style: theme.textTheme.bodyText2),
                    SizedBox(height: height * 0.01),
                    Text(
                      "GHS $balance",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headline2,
                    ),
                  ],
                ),
                SizedBox(height: height * 0.045),
                Button(
                  color: theme.primaryColorLight,
                  textColor: theme.primaryColor,
                  width: width,
                  buttonText: "Done",
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    isDone = true;
                    Navigator.pop(context);
                  },
                ),
                
              ],
            ),
          );
        });
  }
}
