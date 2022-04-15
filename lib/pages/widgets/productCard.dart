// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String? productName, quantity,price;
  final int? index;
  final Function()? onTap;
  const ProductCard({Key? key, this.productName, this.onTap, this.index, this.quantity, this.price})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(height * 0.01),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height:height*0.23,
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

            ),
            SizedBox(height:height*0.01),
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
                      "Quantity: $quantity!",
                      style: theme.textTheme.bodyText1!.copyWith(fontSize:12),
                    ),
                  ],
                ),
                ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: EdgeInsets.all(height * 0.01),
            decoration:
                BoxDecoration(color: theme.primaryColor),
            child: Text(price!, style: theme.textTheme.bodyText2!.copyWith(fontSize:12),)
          ),
        )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

