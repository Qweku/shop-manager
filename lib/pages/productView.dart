import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_manager/components/button.dart';
import 'package:shop_manager/components/textFields.dart';
import 'package:shop_manager/models/GeneralProvider.dart';
import 'package:shop_manager/models/ShopModel.dart';
import 'package:shop_manager/pages/productCalculator.dart';
import 'package:shop_manager/pages/widgets/clipPath.dart';
import 'package:shop_manager/pages/widgets/constants.dart';

class ProductView extends StatefulWidget {
  Product product;
  ProductView({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  final TextEditingController _counterController = TextEditingController();
  int counter = 1;
  late var productImage;
  @override
  void initState() {
    _counterController.text =
        Provider.of<GeneralProvider>(context, listen: false)
            .cart
            .firstWhere(
              (element) => element == widget.product,
              orElse: () => Product(pid: -1, cartQuantity: 1),
            )
            .cartQuantity
            .toString();
    counter = widget.product.cartQuantity ?? 1;
    productImage = base64Decode(widget.product.productImage!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        //title: Text(product.productName!.toUpperCase()),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.05),
            child: GestureDetector(
                onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => const ProductCalculator())),
                child: const Icon(
                  Icons.shopping_cart,
                  size: 27,
                  color: Colors.black,
                )),
          )
        ],
        backgroundColor: const Color.fromARGB(255, 221, 221, 221),
        elevation: 0,
      ),
      //backgroundColor: theme.primaryColor,
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
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                          Color.fromARGB(255, 221, 221, 221),
                          Color.fromARGB(255, 221, 221, 221),
                          Colors.white
                        ])
                      ),
                       child: Center(
                         child: ProductAvatar(
                    image: productImage, product: widget.product, theme: theme),
                       ),
                    ),
                   
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal:20),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              widget.product.productName!,
                              style: theme.textTheme.headline1!.copyWith(fontSize: 25,color:const Color.fromARGB(255, 32, 32, 32))
                                  
                            ),
                          ),
                          SizedBox(width: width * 0.03),
                          Expanded(
                            child: Text('GHS ${widget.product.sellingPrice}',textAlign: TextAlign.end,
                                style: theme.textTheme.headline1!.copyWith(color:primaryColor)),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height:10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal:20),
                      child: Row(
                        //crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Total Stock:',
                              style: theme.textTheme.bodyText1),
                          SizedBox(width: width * 0.03),
                          Text("${widget.product.productQuantity}",
                              style: theme.textTheme.bodyText1!
                                  .copyWith(color: Colors.grey,fontWeight: FontWeight.bold,fontSize: 14)),
                        ],
                      ),
                    ), Padding(
                     padding: EdgeInsets.symmetric(horizontal:height * 0.02),
                      child: Divider(height: height*0.05,color:Colors.grey),
                    ),
                    Padding(
                     padding: EdgeInsets.symmetric(horizontal:height * 0.02),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        Text('Description',style: theme.textTheme.bodyText1!.copyWith(fontSize:15),),
                       const SizedBox(height:10),
                        Text("Description of the product goes here but there's no description currently!",style: theme.textTheme.bodyText1!.copyWith(color:Colors.grey),)
                      ],),
                    )
                     ],
                ),
               
                Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                    child: ClipRRect(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
                  child: Container(
                    color: primaryColor,
                    padding: const EdgeInsets.all(20),
                    child: Row(children: [
                      Text(
                        "GHS ${widget.product.sellingPrice! * counter}",
                        style: theme.textTheme.headline2,
                      ),
                      const SizedBox(width:20),
                      Expanded(
                          // width: width * 0.7,
                          // height: height * 0.1,
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.all(height * 0.01),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                // border: Border.all(color: Colors.white),
                                // color: (counter > 1)
                                //     ? theme.primaryColor
                                //     : Colors.blueGrey
                                ),
                            child: GestureDetector(
                                onTap: () {
                                  counter = int.tryParse(_counterController.text)!;
                                  if (counter > 1) {
                                    setState(() {
                                      counter--;
                                      widget.product.cartQuantity = counter;
                                    });
                                  }
                                  _counterController.text = counter.toString();
                                },
                                child: Icon(Icons.remove,
                                    size: 20, color: theme.primaryColorLight)),
                          ),
                          Expanded(
                           
                            child: SizedBox(
                              width: width,
                              child: CustomTextField(
                                textAlign: TextAlign.center,
                                keyboard: TextInputType.number,
                                controller: _counterController,
                                hintColor: theme.primaryColor,
                                style: theme.textTheme.bodyText2,
                                   
                                onChanged: (text) {
                                  counter = int.tryParse(_counterController.text)!;
                                  if (counter < 0 ||
                                      counter > widget.product.cartQuantity!) {
                                    setState(() {
                                      counter = widget.product.cartQuantity!;
                                      widget.product.cartQuantity = counter;
                                    });
                                  }
                                },
                                //hintText: '1',
                                //borderColor: theme.primaryColorLight
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(height * 0.01),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                // border: Border.all(color: Colors.white),
                                color: (counter < widget.product.productQuantity!)
                                    ? theme.primaryColor
                                    : Colors.blueGrey),
                            child: GestureDetector(
                                onTap: () {
                                  counter = int.tryParse(_counterController.text)!;
                                  if (counter < widget.product.productQuantity!) {
                                    setState(() {
                                      counter++;
                                      widget.product.cartQuantity = counter;
                                    });
                                  }
                                  _counterController.text = counter.toString();
                                },
                                child: Icon(Icons.add,
                                    size: 20, color: theme.primaryColorLight)),
                          ),
                        ],
                      )),
                     const SizedBox(width:20),
                      Button(
                        onTap: (() {
                          if (!(Provider.of<GeneralProvider>(context, listen: false)
                              .cart
                              .contains(widget.product))) {
                            Provider.of<GeneralProvider>(context, listen: false)
                                .addToCart(widget.product);
                          }
                        }),
                        buttonText: 'Cart',
                        color: (context
                                .watch<GeneralProvider>()
                                .cart
                                .contains(widget.product))
                            ? Colors.blueGrey
                            : theme.primaryColorLight,
                        width: width * 0.2,
                        textColor: theme.primaryColor,
                      )
                    ]),
                  ),
                ))
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
    required this.theme,
  }) : super(key: key);

  final image;
  final Product product;
  final ThemeData theme;

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
                  style: theme.textTheme.headline1!
                      .copyWith(fontSize: 50,color: primaryColor),
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
