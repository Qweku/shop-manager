// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String? productName, quantity, price;
  final String image64;
  final int? index;
  final Function()? onTap;
  const ProductCard(
      {Key? key,
      this.productName,
      this.onTap,
      this.index,
      this.quantity,
      this.price,
      required this.image64})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    // File img = File(base64Decode(image64));
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(height * 0.01),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Container(
                  height: height * 0.23,
                  width: width * 0.4,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: index!.isEven ? theme.primaryColor : Colors.white,
                      boxShadow: [
                        const BoxShadow(
                            offset: Offset(2, 2),
                            color: Color.fromARGB(31, 0, 0, 0),
                            blurRadius: 2,
                            spreadRadius: 1)
                      ]),
                  child: image64.isEmpty
                      ? Center(
                          child: Text(
                            productName!.substring(0, 2).toUpperCase(),
                            style: index!.isEven
                                ? theme.textTheme.headline2!
                                    .copyWith(fontSize: 60)
                                : theme.textTheme.headline1!.copyWith(
                                    fontSize: 70, color: theme.primaryColor),
                          ),
                        )
                      : Image.memory(
                          base64Decode(image64),
                          fit: BoxFit.cover,
                        )),
            ),
            SizedBox(height: height * 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productName!,
                      style: theme.textTheme.bodyText1,
                    ),
                    Text(
                      "Quantity: $quantity",
                      style: theme.textTheme.bodyText1!.copyWith(fontSize: 12),
                    ),
                  ],
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                      padding: EdgeInsets.all(height * 0.01),
                      decoration: BoxDecoration(color: theme.primaryColor),
                      child: Text(
                        price!,
                        style:
                            theme.textTheme.bodyText2!.copyWith(fontSize: 12),
                      )),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ProductListTile extends StatelessWidget {
  final String? productName, quantity, price;
  final String image64;
  final int? index;
  final Function()? onTap;
  const ProductListTile(
      {Key? key,
      this.productName,
      this.quantity,
      this.price,
      required this.image64,
      this.index,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
        return ListTile(
          leading:  CircleAvatar(
          radius: height * 0.03,
          backgroundColor: theme.primaryColor,
          child: ( image64 ?? "").isEmpty
              ? Center(
                  child: Text(
                    productName!.substring(0, 2).toUpperCase(),
                    style: theme.textTheme.headline1!
                        .copyWith(fontSize: 20, color: theme.primaryColorLight),
                  ),
                )
              : Container(
                  // width: width * 0.45,
                  // height: height * 0.25,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(height * 0.1),
                      image: DecorationImage(
                          image: MemoryImage(base64Decode(image64)),
                          fit: BoxFit.cover)),
                ),
        ),
          title: Text(productName!, style: theme.textTheme.headline1),
      subtitle: Text("Quantity $quantity",
          style: theme.textTheme.bodyText1),
          trailing: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                    padding: EdgeInsets.all(height * 0.01),
                    decoration: BoxDecoration(color: theme.primaryColor),
                    child: Text(
                      price!,
                      style:
                          theme.textTheme.bodyText2!.copyWith(fontSize: 12),
                    )),
              ),
        );
     
  }
}
