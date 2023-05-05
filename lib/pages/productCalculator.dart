import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_manager/components/button.dart';
import 'package:shop_manager/components/responsive.dart';
import 'package:shop_manager/components/textFields.dart';
import 'package:shop_manager/models/GeneralProvider.dart';
import 'package:shop_manager/models/ShopModel.dart';
import 'package:shop_manager/pages/Summary.dart';
import 'package:shop_manager/pages/widgets/clipPath.dart';
import 'package:shop_manager/pages/widgets/constants.dart';
import 'package:shop_manager/pages/widgets/counter.dart';

class ProductCalculator extends StatefulWidget {
  const ProductCalculator({
    Key? key,
  }) : super(key: key);

  @override
  _ProductCalculatorState createState() => _ProductCalculatorState();
}

class _ProductCalculatorState extends State<ProductCalculator> {
  final amountReceived = TextEditingController();
  double totalCost = 0.00;
  double balance = 0.00;
  List<TextEditingController> counterController = [];
  List<int> counter = [];

  bool isDone = false;

  @override
  void initState() {
    if (Responsive.isMobile()) {
      context.read<GeneralProvider>().cart.forEach((element) {
        counterController.add(TextEditingController());
      });
    }
    //  context.read<GeneralProvider>().cartList.forEach((element) {
    //    counter.add(element.cartQuantity!);
    //   });

    super.initState();
  }

  @override
  void dispose() {
    for (var element in counterController) {
      element.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    totalCost = 0;

    context.watch<GeneralProvider>().cart.forEach((element) {
      totalCost += element.sellingPrice * (element.cartQuantity);
    });

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                  Responsive.isTablet()
                      ? Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text("Basket", style: headline1),
                        )
                      : ClipPath(
                          clipper: BottomClipper(),
                          child: Container(
                            padding: EdgeInsets.only(
                                right: height * 0.02,
                                left: height * 0.02,
                                top: height * 0.05,
                                bottom: height * 0.07),
                            color: primaryColor,
                            child: HeaderSection(
                              height: height,
                              width: width,
                            ),
                          ),
                        ),
                  Expanded(
                    child: context.watch<GeneralProvider>().cart.isEmpty
                        ? Center(
                            child: Text(
                              "No Orders",
                              style: headline1.copyWith(
                                  fontSize: 25, color: Colors.blueGrey),
                            ),
                          )
                        : ListView.builder(
                            // shrinkWrap: true,
                            padding: EdgeInsets.only(top: height * 0.03),
                            itemCount:
                                context.watch<GeneralProvider>().cart.length,
                            itemBuilder: (context, index) => GestureDetector(
                                onTap: () {},
                                child: CartItemWidget(
                                  index: index,
                                  product: Provider.of<GeneralProvider>(context,
                                          listen: false)
                                      .cart[index],
                                  counterController: counterController[index],
                                  height: height,
                                  width: width,
                                )),
                          ),
                  ),
                  SizedBox(
                    height: height * 0.12,
                  ),
                ],
              ),
              Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    child: Container(
                      color: primaryColor,
                      padding: EdgeInsets.all(height * 0.03),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Total Amount', style: bodyText2),
                              SizedBox(height: height * 0.01),
                              Text(
                                "GHS ${totalCost.toStringAsFixed(2)} ",
                                textAlign: TextAlign.center,
                                style: headline2,
                              ),
                            ],
                          ),
                          Button(
                            onTap: () {
                              if (!isDone) {
                                _calculateBalance(context);
                              } else {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (builder) => SummaryScreen(
                                              amountReceived: double.tryParse(
                                                      amountReceived.text) ??
                                                  0,
                                              change: balance,
                                              totalCost: totalCost,
                                            )));
                              }
                            },
                            buttonText: isDone ? 'Done' : 'Proceed',
                            color: actionColor,
                            width: Responsive.isMobile()
                                ? width * 0.4
                                : width * 0.1,
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

  _calculateBalance(context) {
    return showDialog<bool>(
        context: context,
        builder: (c) => StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                backgroundColor: primaryColorLight,
                insetPadding: EdgeInsets.symmetric(horizontal: 20),
                //contentPadding: EdgeInsets.zero,
                //clipBehavior: Clip.antiAliasWithSaveLayer,
                title: Text(
                  "CALCULATE BALANCE",
                  textAlign: TextAlign.center,
                  style: headline1,
                ),
                content: SizedBox(
                  width: Responsive.isTablet() ? width * 0.4 : width * 0.8,
                  height: height * 0.4,
                  child: Column(
                    // spacing: 20,
                    children: <Widget>[
                      SizedBox(height: height * 0.02),
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: height * 0.02, top: height * 0.04),
                        child: Text("Enter Amount Received",
                            style: headline1.copyWith(color: Colors.grey)),
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
                            borderColor: Colors.grey,
                            prefixIcon: const Icon(Icons.add_box,
                                color: Colors.grey, size: 20),
                            style: bodyText1),
                      ),
                      SizedBox(height: height * 0.03),
                      Column(
                        children: [
                          Text('Change', style: bodyText1),
                          SizedBox(height: height * 0.01),
                          Text(
                            "GHS ${balance.toStringAsFixed(2)}",
                            textAlign: TextAlign.center,
                            style: headline1,
                          ),
                        ],
                      ),
                      SizedBox(height: height * 0.045),
                    ],
                  ),
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Button(
                          verticalPadding: 20,
                          borderRadius: 10,
                          onTap: () {
                            Navigator.pop(context);
                          },
                          width: width * 0.2,
                          textColor: Colors.grey,
                          color: Colors.white,
                          buttonText: 'Cancel',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Button(
                          verticalPadding: 20,
                          borderRadius: 10,
                          color: actionColor,
                          width: width * 0.2,
                          buttonText: "Done",
                          onTap: () {
                            FocusScope.of(context).requestFocus(FocusNode());

                            setState(() {
                              isDone = true;
                            });
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  )
                ],
              );
            }));
  }
}

class HeaderSection extends StatelessWidget {
  const HeaderSection({
    Key? key,
    required this.height,
    //required this.widget,

    required this.width,
    this.onPressed,
  }) : super(key: key);

  final double height;
  //final ProductListScreen widget;

  final double width;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back, color: Colors.white)),
            Text(
              "Basket",
              textAlign: TextAlign.left,
              style: headline2.copyWith(fontSize: 30),
            ),
            SizedBox(
                width: width * 0.1,
                child: Divider(
                  color: primaryColorLight,
                  thickness: 5,
                )),
          ],
        ),
        // Container(
        //   decoration: BoxDecoration(
        //       borderRadius: BorderRadius.circular(10),
        //       color: primaryColorLight),
        //   child: IconButton(
        //       onPressed: onPressed,
        //       icon: Icon(Icons.add, color: primaryColor)),
        // )
      ],
    );
  }
}

class CartItemWidget extends StatefulWidget {
  CartItemWidget(
      {Key? key,
      required this.width,
      required this.height,
      required this.counterController,
      required this.product,
      this.isAllowed = false,
      required this.index})
      : super(key: key);

  final double width;
  final int index;
  final double height;

  final TextEditingController counterController;
  final Product product;
  final bool isAllowed;

  @override
  State<CartItemWidget> createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
  // List<int> counter = [];
  @override
  void initState() {
    widget.counterController.text = widget.product.cartQuantity.toString();
    //widget.counter = widget.product.cartQuantity!;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: widget.width * 0.03, vertical: widget.height * 0.01),
      child: Column(
        children: [
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 5,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    //padding: EdgeInsets.only(top: width * 0.05),
                    height: widget.height * 0.15,
                    width: Responsive.isMobile()
                        ? widget.width * 0.3
                        : widget.width * 0.1,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: (widget.product.productImage ?? '').isNotEmpty
                        ? Image.memory(
                            base64Decode(widget.product.productImage!),
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.shopping_bag,
                            size: 30, color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(width: widget.width * 0.03),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.productName ?? 'N/A',
                      style: headline1.copyWith(fontSize: 17),
                    ),
                    SizedBox(
                      height: widget.height * 0.002,
                    ),
                    Text(
                      widget.product.productDescription ?? 'N/A',
                      style: bodyText1.copyWith(color: Colors.grey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                    SizedBox(
                      height: widget.height * 0.01,
                    ),
                    Text(
                      'GHS ${widget.product.sellingPrice.toStringAsFixed(2)}',
                      style:
                          bodyText1.copyWith(fontSize: 17, color: primaryColor),
                    )
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: widget.height * 0.02,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () =>
                    Provider.of<GeneralProvider>(context, listen: false)
                        .removeFromCart(widget.index),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                      padding: EdgeInsets.all(widget.height * 0.01),
                      decoration: const BoxDecoration(
                          // color: Color.fromARGB(255, 252, 104, 94)
                          ),
                      child: Row(
                        children: [
                          const Icon(Icons.delete_outline,
                              size: 30,
                              color: Color.fromARGB(255, 255, 102, 102)),
                          Text(
                            'REMOVE',
                            style: bodyText1.copyWith(
                                fontSize: 15,
                                color:
                                    const Color.fromARGB(255, 255, 102, 102)),
                          ),
                        ],
                      )),
                ),
              ),
              ItemCounter(
                  color: primaryColor,
                  product: widget.product,
                  counterController: widget.counterController,
                  width: Responsive.isMobile()
                      ? widget.width * 0.3
                      : widget.width * 0.1),

              // ItemCounter(
              //   counter: widget.counter,
              //   color: primaryColor,
              //   product: widget.product,
              // )
            ],
          )
        ],
      ),
    );
  }
}




// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
// import 'package:shop_manager/components/button.dart';
// import 'package:shop_manager/components/textFields.dart';
// import 'package:shop_manager/models/GeneralProvider.dart';
// import 'package:shop_manager/pages/Summary.dart';
// import 'package:shop_manager/pages/productView.dart';

// import 'widgets/productCalculatorWidget.dart';

// class ProductCalculator extends StatefulWidget {
//   const ProductCalculator({Key? key}) : super(key: key);

//   @override
//   _ProductCalculatorState createState() => _ProductCalculatorState();
// }

// class _ProductCalculatorState extends State<ProductCalculator> {
//   final amountReceived = TextEditingController();
//   double totalCost = 0.00;
//   double balance = 0.00;

//   bool isDone = false;

//   @override
//   Widget build(BuildContext context) {
//     double height = MediaQuery.of(context).size.height;
//     double width = MediaQuery.of(context).size.width;
//     totalCost = 0;
//     context.watch<GeneralProvider>().cart.forEach((element) {
//       totalCost += element.sellingPrice! * element.cartQuantity!;
//     });

//     
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       // backgroundColor: ShopColors.secondaryColor,
//       appBar: AppBar(
//         title: Text(
//           "Basket",
//           style:headline1,
//         ),
//         backgroundColor: Colors.white,
//         iconTheme: const IconThemeData(color: Colors.black),
//         elevation: 0,
//         centerTitle: true,
//       ),
//       body: SafeArea(
//         top: false,
//         child: SizedBox(
//           height: height,
//           child: Stack(
//             children: [
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // ClipPath(
//                   //   clipper: BottomClipper(),
//                   //   child: Container(
//                   //     padding: EdgeInsets.only(
//                   //         right: height * 0.02,
//                   //         left: height * 0.02,
//                   //         top: height * 0.13,
//                   //         bottom: height * 0.07),
//                   //     color: primaryColorLight,
//                   //     width: width,
//                   //   ),
//                   // ),
//                   SizedBox(
//                     //height: height * 0.6,
//                     child: ListView.builder(
//                       shrinkWrap: true,
//                       padding: EdgeInsets.only(top: height * 0.03),
//                       itemCount: context.watch<GeneralProvider>().cart.length,
//                       itemBuilder: (context, index) => Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           SizedBox(
//                             width: width * 0.65,
//                             child: GestureDetector(
//                               onTap: () {
//                                 Navigator.pushReplacement(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (builder) => ProductView(
//                                             product:
//                                                 Provider.of<GeneralProvider>(
//                                                         context,
//                                                         listen: false)
//                                                     .cart[index]))).then(
//                                     (value) => setState(() {}));
//                               },
//                               child: ItemDetail(
//                                   backgroundColor:
//                                       const Color.fromARGB(255, 233, 233, 233),
//                                   textColor: const Color.fromARGB(255, 26, 26, 26),
//                                   theme: theme,
//                                   item: Provider.of<GeneralProvider>(context,
//                                           listen: false)
//                                       .cart[index]),
//                             ),
//                           ),
//                           Padding(
//                             padding: EdgeInsets.only(right: width * 0.05),
//                             child: IconButton(
//                               onPressed: () {
//                                 context
//                                     .read<GeneralProvider>()
//                                     .removeFromCart(index);
//                               },
//                               icon: const Icon(
//                                 Icons.delete,
//                                 color: Colors.red,
//                               ),
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
            
//               Positioned(
//                   bottom: 0,
//                   right: 0,
//                   left: 0,
//                   child: ClipRRect(
//                     borderRadius: const BorderRadius.only(
//                         topLeft: Radius.circular(20),
//                         topRight: Radius.circular(20)),
//                     child: Container(
//                       color: primaryColor,
//                       padding: EdgeInsets.all(height * 0.03),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text('Total Amount',
//                                   style:bodyText2),
//                               SizedBox(height: height * 0.01),
//                               Text(
//                                 "GHS $totalCost ",
//                                 textAlign: TextAlign.center,
//                                 style:headline2,
//                               ),
//                             ],
//                           ),
//                           Button(
//                             onTap: () {
//                               if (!isDone) {
//                                 _bottomDrawSheet(context);
//                               } else {
//                                 Navigator.pushReplacement(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (builder) =>
//                                             const SummaryScreen()));
//                               }
//                             },
//                             buttonText: isDone ? 'Done' : 'Proceed',
//                             color: primaryColorLight,
//                             textColor: primaryColor,
//                             width: width * 0.4,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ))
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _bottomDrawSheet(context) {
//     
//     double height = MediaQuery.of(context).size.height;
//     double width = MediaQuery.of(context).size.width;
//     showModalBottomSheet(
//         backgroundColor: primaryColor,
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
//         ),
//         context: context,
//         builder: (BuildContext bc) {
//           return Container(
//             padding: EdgeInsets.all(height * 0.02),
//             child: Column(
//               // spacing: 20,
//               children: <Widget>[
//                 SizedBox(height: height * 0.02),
//                 Padding(
//                   padding: EdgeInsets.only(
//                       bottom: height * 0.02, top: height * 0.04),
//                   child: Text("Enter Amount Received",
//                       style:headline2),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(
//                     bottom: height * 0.04,
//                   ),
//                   child: CustomTextField(
//                       controller: amountReceived,
//                       keyboard: TextInputType.number,
//                       onChanged: (text) {
//                         setState(() {
//                           double amt = double.parse(amountReceived.text);
//                           balance = amt - totalCost;
//                         });
//                       },
//                       hintText: 'Amount',
//                       hintColor: Colors.white,
//                       borderColor: Colors.white,
//                       prefixIcon: const Icon(Icons.add_box,
//                           color: Colors.white, size: 20),
//                       style:bodyText2),
//                 ),
//                 SizedBox(height: height * 0.03),
//                 Column(
//                   children: [
//                     Text('Change', style:bodyText2),
//                     SizedBox(height: height * 0.01),
//                     Text(
//                       "GHS $balance",
//                       textAlign: TextAlign.center,
//                       style:headline2,
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: height * 0.045),
//                 Button(
//                   color: primaryColorLight,
//                   textColor: primaryColor,
//                   width: width,
//                   buttonText: "Done",
//                   onTap: () {
//                     FocusScope.of(context).requestFocus(FocusNode());
//                     isDone = true;
//                     Navigator.pop(context);
//                   },
//                 ),
                
//               ],
//             ),
//           );
//         });
//   }
// }
