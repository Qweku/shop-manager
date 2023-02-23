// ignore_for_file: file_names

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shop_manager/models/ShopModel.dart';
import 'package:shop_manager/pages/widgets/constants.dart';

class ItemDetail extends StatelessWidget {
  const ItemDetail({
    Key? key,
    required this.theme,
    required this.item,
    this.backgroundColor,
    this.textColor,
  }) : super(key: key);

  final ThemeData theme;
  final Product item;
  final Color? backgroundColor, textColor;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return ListTile(
        leading: CircleAvatar(
          radius: height * 0.03,
          backgroundColor: backgroundColor ?? theme.primaryColorLight,
          child: (item.productImage ?? "").isEmpty
              ? Center(
                  child: Text(
                    item.productName!.substring(0, 2).toUpperCase(),
                    style: theme.textTheme.headline1!
                        .copyWith(fontSize: 20, color: textColor??theme.primaryColor),
                  ),
                )
              : Container(
                  width: width * 0.2,
                  height: height * 0.15,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(height * 0.1),
                      image: DecorationImage(
                          image: MemoryImage(base64Decode(item.productImage!)),
                          fit: BoxFit.cover)),
                ),
        ),
        title: Text(item.productName!,
            style: theme.textTheme.bodyText2!
                .copyWith(color: textColor ?? Colors.white,fontWeight: FontWeight.bold)),
        subtitle: Text("GHS ${item.sellingPrice.toStringAsFixed(2)}",
            style: theme.textTheme.bodyText2!
                .copyWith(fontSize: 15, color: primaryColor),
                
                ),
                
                trailing: Text("x ${item.cartQuantity}",
            style: theme.textTheme.bodyText1!
                .copyWith(fontSize: 15),
                
                ),);
  }
}
