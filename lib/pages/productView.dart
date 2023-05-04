// import 'dart:convert';

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_manager/components/notificationButton.dart';
import 'package:shop_manager/models/GeneralProvider.dart';
import 'package:shop_manager/models/ShopModel.dart';
import 'package:shop_manager/pages/productCalculator.dart';
import 'package:shop_manager/pages/widgets/constants.dart';

import '../components/button.dart';

class ProductView extends StatefulWidget {
  Product product;
  ProductView({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  final TextEditingController _counterController = TextEditingController();
  int counter = 1;
  bool isContained = false;
  late var productImage;
  @override
  void initState() {
    _counterController.text =
        Provider.of<GeneralProvider>(context, listen: false)
            .cart
            .firstWhere(
              (element) => element == widget.product,
              orElse: () => Product(cartQuantity: 1, pid: widget.product.pid),
            )
            .cartQuantity
            .toString();
    // Provider.of<ShopProvider>(context,listen:false)
    // _counterController.text = widget.product.cartQuantity.toString();
    widget.product.cartQuantity = counter;
    productImage = base64Decode(widget.product.productImage!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        //title: Text(product.productName!.toUpperCase()),
        actions: [
          CartIconButton(
              quantity: context.watch<GeneralProvider>().cart.length,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => const ProductCalculator()));
              })
        ],
        backgroundColor:
            primaryColorLight, //const Color.fromARGB(255, 221, 221, 221),
        elevation: 0,
      ),
      //backgroundColor: primaryColor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
          child: SizedBox(
        height: height,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: width,
                  //color:Color.fromARGB(255, 221, 221, 221),
                  height: height * 0.5,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                        primaryColorLight,
                        primaryColorLight,
                        // Color.fromARGB(255, 221, 221, 221),
                        // Color.fromARGB(255, 221, 221, 221),
                        Colors.white
                      ])),
                  child: Center(
                    child: ProductAvatar(
                      image: productImage,
                      product: widget.product,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(widget.product.productName!,
                                  style: headline1.copyWith(
                                      fontSize: 25,
                                      color: const Color.fromARGB(
                                          255, 32, 32, 32))),
                            ),
                            SizedBox(width: width * 0.03),
                            Expanded(
                              child: Text(
                                  'GHS ${widget.product.sellingPrice.toStringAsFixed(2)}',
                                  textAlign: TextAlign.end,
                                  style:
                                      headline1.copyWith(color: primaryColor)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          //crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Total Stock:', style: bodyText1),
                            SizedBox(width: width * 0.03),
                            Text("${widget.product.productQuantity}",
                                style: bodyText1.copyWith(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14)),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: height * 0.02),
                        child:
                            Divider(height: height * 0.05, color: Colors.grey),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: height * 0.02),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Description',
                              style: bodyText1.copyWith(fontSize: 15),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Description of the product goes here but there's no description currently!",
                              style: bodyText1.copyWith(color: Colors.grey),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  child: Container(
                    color: primaryColor,
                    padding: const EdgeInsets.all(20),
                    child: Row(children: [
                      Text(
                        "GHS ${(widget.product.sellingPrice) * counter}0",
                        style: headline2.copyWith(fontSize: 16),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                          // width: width * 0.7,
                          // height: height * 0.1,
                          child: Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                if ((Provider.of<GeneralProvider>(context, listen: false).cart.any(
                                    (element) =>
                                        element.pid == widget.product.pid))) {
                                  return;
                                }
                                if (counter > 1) {
                                  setState(() {
                                    counter--;
                                  });
                                }
                                widget.product.cartQuantity = counter;
                              },
                              icon: Icon(Icons.remove_circle_outline,
                                  size: 30,
                                  color: (counter == 1 ||
                                          (Provider.of<GeneralProvider>(context, listen: false).cart
                                              .any((element) =>
                                                  element.pid ==
                                                  widget.product.pid)))
                                      ? Colors.grey
                                      : Colors.white)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              "$counter",
                              style: headline2.copyWith(
                                  fontSize: 16, color: Colors.white),
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                if ((Provider.of<GeneralProvider>(context, listen: false).cart.any(
                                    (element) =>
                                        element.pid == widget.product.pid))) {
                                  return;
                                }

                                if (counter < widget.product.productQuantity) {
                                  setState(() {
                                    counter++;
                                  });
                                }
                                widget.product.cartQuantity = counter;
                              },
                              icon: Icon(Icons.add_circle_outline,
                                  size: 30,
                                  color: (counter ==
                                              widget.product.productQuantity ||
                                          (Provider.of<GeneralProvider>(context, listen: false).cart
                                              .any((element) =>
                                                  element.pid ==
                                                  widget.product.pid)))
                                      ? Colors.grey
                                      : Colors.white))
                        ],
                      )),
                      const SizedBox(width: 20),
                      Button(
                        onTap: (() {
                          if (!(context
                              .read<GeneralProvider>()
                              .cart
                              .contains(widget.product))) {
                            Provider.of<GeneralProvider>(context, listen: false)
                                .addToCart(widget.product);
                          }
                        }),
                        buttonText: 'Cart',
                        color: (context.watch<GeneralProvider>().cart.any(
                                (element) => element.pid == widget.product.pid))
                            ? Colors.grey
                            : actionColor,
                        width: width * 0.2,
                      )
                    ]),
                  ),
                )
              ],
            ),
          ],
        ),
      )),
    );
  }

  @override
  void dispose() {
    _counterController.dispose();
    super.dispose();
  }
}

class ProductAvatar extends StatelessWidget {
  const ProductAvatar({
    Key? key,
    required this.image,
    required this.product,
  }) : super(key: key);

  final image;
  final Product product;

  @override
  Widget build(BuildContext context) {
    // var image = base64Decode(product.imageb64!);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return CircleAvatar(
        backgroundColor: Colors.white,
        radius: 80,
        child: (product.productImage ?? "").isEmpty
            ? Center(
                child: Text(
                  product.productName!.substring(0, 2).toUpperCase(),
                  style: headline1.copyWith(fontSize: 50, color: primaryColor),
                ),
              )
            : Container(
                width: width * 0.45,
                height: height * 0.25,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(height * 0.1),
                    image: DecorationImage(
                        image: MemoryImage(image), fit: BoxFit.cover)),
              ));
  }
}

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shop_manager/components/button.dart';
// import 'package:shop_manager/components/textFields.dart';
// import 'package:shop_manager/models/GeneralProvider.dart';
// import 'package:shop_manager/models/ShopModel.dart';
// import 'package:shop_manager/pages/productCalculator.dart';
// import 'package:shop_manager/pages/widgets/clipPath.dart';

// class ProductView extends StatefulWidget {
//   Product product;
//   ProductView({Key? key, required this.product}) : super(key: key);

//   @override
//   State<ProductView> createState() => _ProductViewState();
// }

// class _ProductViewState extends State<ProductView> {
//   TextEditingController _counterController = TextEditingController();
//   int counter = 1;
//  late var productImage ;
//   @override
//   void initState() {
//     _counterController.text = widget.product.cartQuantity.toString();
//     counter = widget.product.cartQuantity ?? 1;
//      productImage = base64Decode(widget.product.imageb64!);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     double height = MediaQuery.of(context).size.height;
//     double width = MediaQuery.of(context).size.width;
//     
//     return Scaffold(
//       appBar: AppBar(
//         //title: Text(product.productName!.toUpperCase()),
//         actions: [
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: width * 0.05),
//             child: GestureDetector(
//                 onTap: () => Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(
//                         builder: (builder) => const ProductCalculator())),
//                 child: const Icon(
//                   Icons.shopping_cart,
//                   size: 27,
//                 )),
//           )
//         ],
//         backgroundColor: primaryColor,
//         elevation: 0,
//       ),
//       //backgroundColor: primaryColor,
//       resizeToAvoidBottomInset: true,
//       body: SafeArea(
//           child: SingleChildScrollView(
//         child: Stack(
//           children: [
//             Column(
//               children: [
//                 ClipPath(
//                   clipper: BottomLineClipper(),
//                   child: Container(
//                     width: width,
//                     color: primaryColor,
//                     height: height * 0.2,
//                   ),
//                 ),
//                 SizedBox(height: height * 0.12),
//                 Text(
//                   widget.product.productName!,
//                   style:headline1!
//                       .copyWith(fontSize: 30, color: primaryColor),
//                 ),
//                 SizedBox(height: height * 0.01),
//                 Text('GHS ${widget.product.sellingPrice}',
//                     style:headline1),
//                 Padding(
//                   padding: EdgeInsets.all(height * 0.02),
//                   child: Column(
//                     //crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('Max Quantity',
//                           style:bodyText1!
//                               .copyWith(fontSize: 12)),
//                       SizedBox(height: height * 0.01),
//                       Text("${widget.product.quantity!}",
//                           style:headline1!
//                               .copyWith(color: primaryColor)),
//                     ],
//                   ),
//                 ),
                
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(10),
//                   child: Container(
//                       padding: EdgeInsets.all(height * 0.02),
//                       decoration: BoxDecoration(color: primaryColor),
//                       child: Column(
//                         children: [
//                           Text('Total', style:bodyText2),
//                           SizedBox(
//                             height: height * 0.01,
//                           ),
//                           Text(
//                             "GHS ${widget.product.sellingPrice! * counter}",
//                             style:headline2,
//                           ),
//                         ],
//                       )),
//                 ),
//                 SizedBox(
//                   height: height * 0.02,
//                 ),
//                 SizedBox(
//                     width: width * 0.7,
//                     height: height * 0.1,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Container(
//                           padding: EdgeInsets.all(height * 0.01),
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(10),
//                               color: (counter > 1)
//                                   ? primaryColor
//                                   : Colors.blueGrey),
//                           child: GestureDetector(
//                               onTap: () {
//                                 counter =
//                                     int.tryParse(_counterController.text)!;
//                                 if (counter > 1) {
//                                   setState(() {
//                                     counter--;
//                                     widget.product.cartQuantity = counter;
//                                   });
//                                 }
//                                 _counterController.text = counter.toString();
//                               },
//                               child: Icon(Icons.remove,
//                                   size: 20, color: primaryColorLight)),
//                         ),
//                         Expanded(
//                           flex: 3,
//                           child: SizedBox(
//                             width: width,
//                             child: CustomTextField(
//                               textAlign: TextAlign.center,
//                               keyboard: TextInputType.number,
//                               controller: _counterController,
//                               hintColor: primaryColor,
//                               style:headline2!
//                                   .copyWith(color: primaryColor),
//                               onChanged: (text) {
//                                 counter =
//                                     int.tryParse(_counterController.text)!;
//                                 if (counter < 0 ||
//                                     counter > widget.product.cartQuantity!) {
//                                   setState(() {
//                                     counter = widget.product.cartQuantity!;
//                                     widget.product.cartQuantity = counter;
//                                   });
//                                 }
//                               },
//                               //hintText: '1',
//                               //borderColor: primaryColorLight
//                             ),
//                           ),
//                         ),
//                         Container(
//                           padding: EdgeInsets.all(height * 0.01),
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(10),
//                               color: (counter < widget.product.quantity!)
//                                   ? primaryColor
//                                   : Colors.blueGrey),
//                           child: GestureDetector(
//                               onTap: () {
//                                 counter =
//                                     int.tryParse(_counterController.text)!;
//                                 if (counter < widget.product.quantity!) {
//                                   setState(() {
//                                     counter++;
//                                     widget.product.cartQuantity = counter;
//                                   });
//                                 }
//                                 _counterController.text = counter.toString();
//                               },
//                               child: Icon(Icons.add,
//                                   size: 20, color: primaryColorLight)),
//                         ),
//                       ],
//                     )),
//                 SizedBox(
//                   height: height * 0.03,
//                 ),
//                 Button(
//                   onTap: (() {
//                     if (!(Provider.of<GeneralProvider>(context, listen: false)
//                         .cart
//                         .contains(widget.product))) {
//                       Provider.of<GeneralProvider>(context, listen: false)
//                           .addToCart(widget.product);
//                     }
//                   }),
//                   buttonText: 'Add to Cart',
//                   color: (context
//                           .watch<GeneralProvider>()
//                           .cart
//                           .contains(widget.product))
//                       ? Colors.blueGrey
//                       : primaryColor,
//                   width: width * 0.7,
//                 )
//               ],
//             ),
//             Positioned(
//               top: height * 0.05,
//               left: width * 0.27,
//               //right: 0,
//               //bottom: 0,
//               child: ProductAvatar(
//                 image: productImage,
//                   product: widget.product,
//                   theme: theme),
//             ),
//           ],
//         ),
//       )),
//     );
//   }

//   @override
//   void dispose() {
//     _counterController.dispose();
//     super.dispose();
//   }
// }

// class ProductAvatar extends StatelessWidget {
//   const ProductAvatar({
//     Key? key,
 
//     required this.image,
//     required this.product,
//     required this.theme,
//   }) : super(key: key);

   
//   final image;
//   final Product product;
//   final ThemeData theme;

//   @override
//   Widget build(BuildContext context) {
//     // var image = base64Decode(product.imageb64!);
//       double height = MediaQuery.of(context).size.height;
//     double width = MediaQuery.of(context).size.width;
//     return Container(
//         width: width * 0.45,
//         height: height * 0.25,
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(height * 0.1),
//             color: (product.imageb64 ?? "").isEmpty
//                 ? primaryColor
//                 : primaryColorLight,
//             border: Border.all(color: primaryColorLight, width: 3)),
//         child: (product.imageb64 ?? "").isEmpty
//             ? Center(
//                 child: Text(
//                   product.productName!.substring(0, 2).toUpperCase(),
//                   style:headline1!
//                       .copyWith(fontSize: 70, color: Colors.white),
//                 ),
//               )
//             : Container(
//                 width: width * 0.45,
//                 height: height * 0.25,
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(height * 0.1),
//                     image: DecorationImage(
//                         image: MemoryImage(image), fit: BoxFit.cover)),
//               ));
//   }
// }
