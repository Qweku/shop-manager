// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_manager/models/GeneralProvider.dart';
import 'package:shop_manager/pages/widgets/constants.dart';

class ProductCard extends StatelessWidget {
  final String? productName, price;
  String? quantity;
  final String image64;
  final int? index;
  final Function()? onTap, onLongPress, onPressed;
  ProductCard(
      {Key? key,
      this.productName,
      this.onTap,
      this.index,
      this.quantity,
      this.price,
      required this.image64,
      this.onLongPress,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    bool isLow = false;
    // File img = File(base64Decode(image64));
    context.read<GeneralProvider>().inventory.forEach(
      (element) {
        if (int.tryParse(quantity!)! <= element.lowStockQuantity) {
          isLow = true;
        } else {
          isLow = false;
        }
      },
    );
    return GestureDetector(
      onLongPress: onLongPress,
      onTap: onTap,
      child: Stack(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  child: Container(
                      height: height * 0.15,
                      width: width,
                      decoration: BoxDecoration(
                        //borderRadius: BorderRadius.circular(20.0),
                        color: index!.isEven && image64.isEmpty
                            ? primaryColor
                            : Colors.white,
                      ),
                      child: image64.isEmpty
                          ? Center(
                              child: Text(
                                productName!.substring(0, 2).toUpperCase(),
                                style: index!.isEven
                                    ? theme.textTheme.headline2!
                                        .copyWith(fontSize: 30)
                                    : theme.textTheme.headline1!.copyWith(
                                        fontSize: 30, color: primaryColor),
                              ),
                            )
                          : Image.memory(
                              base64Decode(image64),
                              fit: BoxFit.cover,
                            )),
                ),
                // SizedBox(height: height * 0.01),
                Column(
                  children: [
                    Text(
                      productName!,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyText1!.copyWith(
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "$quantity left",
                      style: theme.textTheme.bodyText1!
                          .copyWith(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "$price",
                      style: theme.textTheme.bodyText1!
                          .copyWith(fontSize: 15, color: primaryColor),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.01),
              ],
            ),
          ),
          isLow?Positioned(
              child: Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            color: const Color.fromARGB(255, 255, 245, 160),
            child: Text("Low Stock!",
                style: theme.textTheme.bodyText1!
                    .copyWith(fontSize: 10, color: Colors.red)),
          )):Container(),
          Positioned(
              right: 10,
              top: 10,
              child: CircleAvatar(
                backgroundColor: index!.isOdd || image64.isNotEmpty
                    ? primaryColor
                    : Colors.white,
                radius: 15,
                child: IconButton(
                  icon: Icon(Icons.add,
                      color: index!.isEven && image64.isEmpty
                          ? primaryColor
                          : Colors.white,
                      size: 15),
                  onPressed: onPressed,
                ),
              ))
        ],
      ),
    );
  }
}

class ProductListTile extends StatelessWidget {
  final String? productName, quantity, price;
  final String image64;
  final int? index;
  final Function()? onTap;
  final bool isSelected;
  const ProductListTile(
      {Key? key,
      this.productName,
      this.quantity,
      this.price,
      this.image64 = "",
      this.isSelected = false,
      this.index,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return ListTile(
      tileColor: isSelected ? theme.primaryColor : Colors.transparent,
      leading: CircleAvatar(
        radius: height * 0.03,
        backgroundColor:
            isSelected ? theme.primaryColorLight : theme.primaryColor,
        child: image64.isEmpty
            ? Center(
                child: Text(
                  productName!.substring(0, 2).toUpperCase(),
                  style: theme.textTheme.headline1!.copyWith(
                      fontSize: 20,
                      color: isSelected
                          ? theme.primaryColor
                          : theme.primaryColorLight),
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
      title: Text(productName!,
          style: isSelected
              ? theme.textTheme.headline2
              : theme.textTheme.headline1),
      subtitle: Text("Quantity $quantity",
          style: isSelected
              ? theme.textTheme.bodyText2
              : theme.textTheme.bodyText1),
      trailing: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
            padding: EdgeInsets.all(height * 0.01),
            decoration: BoxDecoration(
                color:
                    isSelected ? theme.primaryColorLight : theme.primaryColor),
            child: Text(
              price!,
              style: isSelected
                  ? theme.textTheme.bodyText2!
                      .copyWith(fontSize: 12, color: theme.primaryColor)
                  : theme.textTheme.bodyText2!.copyWith(fontSize: 12),
            )),
      ),
    );
  }
}
