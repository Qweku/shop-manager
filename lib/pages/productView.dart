import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_manager/components/button.dart';
import 'package:shop_manager/components/textFields.dart';
import 'package:shop_manager/models/GeneralProvider.dart';
import 'package:shop_manager/models/ShopModel.dart';
import 'package:shop_manager/pages/productCalculator.dart';
import 'package:shop_manager/pages/widgets/clipPath.dart';

class ProductView extends StatelessWidget {
  final Product product;
  const ProductView({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        //title: Text(product.productName!.toUpperCase()),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.05),
            child: GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => const ProductCalculator())),
                child: const Icon(
                  Icons.shopping_cart,
                  size: 27,
                )),
          )
        ],
        backgroundColor: theme.primaryColor,
        elevation: 0,
      ),
      //backgroundColor: theme.primaryColor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                ClipPath(
                  clipper: BottomLineClipper(),
                  child: Container(
                    width: width,
                    color: theme.primaryColor,
                    height: height * 0.2,
                  ),
                ),
                SizedBox(height: height * 0.15),
                Text(
                  product.productName!,
                  style: theme.textTheme.headline1!
                      .copyWith(fontSize: 30, color: theme.primaryColor),
                ),
                SizedBox(height: height * 0.02),
                Text('GHS ${product.sellingPrice}',
                    style: theme.textTheme.headline1),
                Padding(
                  padding: EdgeInsets.all(height * 0.02),
                  child: Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Max Quantity',
                          style: theme.textTheme.bodyText1!
                              .copyWith(fontSize: 12)),
                      SizedBox(height: height * 0.01),
                      Text("${product.quantity!}",
                          style: theme.textTheme.headline1!
                              .copyWith(color: theme.primaryColor)),
                    ],
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                SizedBox(
                  width: width * 0.7,
                  height: height * 0.1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.all(height * 0.01),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: theme.primaryColor),
                        child: GestureDetector(
                            onTap: () {},
                            child: Icon(Icons.remove,
                                size: 20, color: theme.primaryColorLight)),
                      ),
                      // SizedBox(
                      //   width: width * 0.01,
                      // ),
                      Expanded(
                        flex: 3,
                        child: SizedBox(
                          width: width,
                          // height: height * 0.1,
                          child: CustomTextField(
                            //borderColor: theme.primaryColorLight,
                            textAlign: TextAlign.center,
                            keyboard: TextInputType.number,

                            hintColor: theme.primaryColor,
                            style: theme.textTheme.headline2!
                                .copyWith(color: theme.primaryColor),
                            hintText: '1',
                            //borderColor: theme.primaryColorLight
                          ),
                        ),
                      ),
                      // SizedBox(
                      //   width: width * 0.01,
                      // ),
                      Container(
                        padding: EdgeInsets.all(height * 0.01),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: theme.primaryColor),
                        child: GestureDetector(
                            onTap: () {},
                            child: Icon(Icons.add,
                                size: 20, color: theme.primaryColorLight)),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: height * 0.05,
                ),
                Button(
                  onTap: (() {
                    if (!(Provider.of<GeneralProvider>(context, listen: false)
                        .cart
                        .contains(product))) {
                      Provider.of<GeneralProvider>(context, listen: false)
                          .addtoCart(product);
                    }
                  }),
                  buttonText: 'Add to Cart',
                  color:
                      (context.watch<GeneralProvider>().cart.contains(product))
                          ? Colors.blueGrey
                          : theme.primaryColor,
                  width: width * 0.7,
                )
              ],
            ),
            Positioned(
              top: height * 0.05,
              left: width * 0.27,
              //right: 0,
              //bottom: 0,
              child: Container(
                  width: width * 0.45,
                  height: height * 0.25,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(height * 0.1),
                      color: (product.imageb64 ?? "").isEmpty
                          ? theme.primaryColor
                          : theme.primaryColorLight,
                      border:
                          Border.all(color: theme.primaryColorLight, width: 3)),
                  child: (product.imageb64 ?? "").isEmpty
                      ? Center(
                          child: Text(
                            product.productName!.substring(0, 2).toUpperCase(),
                            style: theme.textTheme.headline1!
                                .copyWith(fontSize: 70, color: Colors.white),
                          ),
                        )
                      : Container(
                          width: width * 0.45,
                          height: height * 0.25,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(height * 0.1),
                              image: DecorationImage(
                                  image: MemoryImage(
                                      base64Decode(product.imageb64!)),
                                  fit: BoxFit.cover)),
                        )),
            ),
          ],
        ),
      )),
    );
  }
}
