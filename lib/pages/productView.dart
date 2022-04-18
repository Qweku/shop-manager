import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_manager/components/textFields.dart';
import 'package:shop_manager/models/GeneralProvider.dart';
import 'package:shop_manager/models/ShopModel.dart';
import 'package:shop_manager/pages/productCalculator.dart';
import 'package:shop_manager/pages/widgets/productCalculatorWidget.dart';

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
        title: Text(product.productName!.toUpperCase()),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.05),
            child: GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => const ProductCalculator())),
                child: Icon(
                  Icons.shopping_cart,
                  size: 27,
                )),
          )
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: theme.primaryColor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(height * 0.05),
        child: Column(
          children: [
            SizedBox(height: height * 0.07),
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: EdgeInsets.all(height * 0.03),
                  width: width,
                  height: height * 0.4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: theme.primaryColorLight,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: height * 0.15),
                      Text(
                        product.productName!,
                        style: theme.textTheme.headline1!
                            .copyWith(fontSize: 30, color: theme.primaryColor),
                      ),
                      SizedBox(height: height * 0.02),
                      Text('GHS ${product.sellingPrice}',
                          style: theme.textTheme.headline1),
                    ],
                  ),
                ),
                Positioned(
                  top: -height * 0.1,
                  left: width * 0.17,
                  //right: 0,
                  //bottom: 0,
                  child: Container(
                    width: width * 0.45,
                    height: height * 0.25,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: (product.imageb64 ?? "").isEmpty
                          ? Colors.amber
                          : Colors.transparent,
                    ),
                    child: (product.imageb64 ?? "").isEmpty
                        ? Center(
                            child: Text(
                              product.productName!
                                  .substring(0, 2)
                                  .toUpperCase(),
                              style: theme.textTheme.headline1!.copyWith(
                                  fontSize: 70, color: Colors.lightBlue),
                            ),
                          )
                        : CircleAvatar(
                            foregroundImage:
                                MemoryImage(base64Decode(product.imageb64!))
                            // Image.memory(
                            //     base64Decode(product.imageb64!),
                            //     fit: BoxFit.fill,
                            //   ),
                            ),
                  ),
                ),
                Positioned(
                    bottom: 0,
                    right: 0,
                    left: width * 0.25,
                    child: Padding(
                      padding: EdgeInsets.all(height * 0.02),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            //crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Max Quantity',
                                  style: theme.textTheme.bodyText1!
                                      .copyWith(fontSize: 12)),
                              SizedBox(height: height * 0.005),
                              Text('20',
                                  style: theme.textTheme.headline1!
                                      .copyWith(color: theme.primaryColor)),
                            ],
                          ),
                        ],
                      ),
                    ))
              ],
            ),
            SizedBox(
              height: height * 0.02,
            ),
            SizedBox(
              width: width,
              height: height * 0.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(height * 0.02),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: theme.primaryColorLight),
                      child: GestureDetector(
                          onTap: () {},
                          child: Icon(Icons.remove,
                              size: 25, color: theme.primaryColor)),
                    ),
                  ),
                  SizedBox(
                    width: width * 0.01,
                  ),
                  Expanded(
                    flex: 3,
                    child: SizedBox(
                      width: width,
                      // height: height * 0.1,
                      child: CustomTextField(
                        borderColor: theme.primaryColorLight,
                        textAlign: TextAlign.center,
                        keyboard: TextInputType.number,

                        hintColor: theme.primaryColorLight,
                        style: theme.textTheme.bodyText2!
                            .copyWith(color: theme.primaryColor),
                        hintText: 'Quantity',
                        //borderColor: theme.primaryColorLight
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width * 0.01,
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(height * 0.02),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: theme.primaryColorLight),
                      child: GestureDetector(
                          onTap: () {},
                          child: Icon(Icons.add,
                              size: 25, color: theme.primaryColor)),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: height * 0.05,
            ),
            GestureDetector(
              onTap: (() {
                if (!(Provider.of<GeneralProvider>(context,listen: false)
                    .cart
                    .contains(product))) {
                  Provider.of<GeneralProvider>(context,listen: false).addtoCart(product);
                }
              }),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: height * 0.01),
                // width: width,
                // height: height * 0.1,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color:(context.watch<GeneralProvider>()
                    .cart
                    .contains(product)) ? Colors.blueGrey:theme.primaryColorLight,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    width: width * 0.5,
                    padding: EdgeInsets.all(height * 0.01),
                    color: Colors.transparent,
                    child: Text(
                      'Add to Cart',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyText2!.copyWith(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 17),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
