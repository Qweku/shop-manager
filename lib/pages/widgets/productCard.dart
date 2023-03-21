// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_manager/components/responsive.dart';
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
                      height:
                          Responsive.isMobile() ? height * 0.15 : height * 0.25,
                      width: width,
                      decoration: BoxDecoration(
                        //borderRadius: BorderRadius.circular(20.0),
                        color: Color.fromARGB(255, 247, 247, 247),
                      ),
                      child: image64.isEmpty
                          ? Center(
                              child: Text(
                                productName!.substring(0, 2).toUpperCase(),
                                style: headline1.copyWith(
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
                      style: bodyText1.copyWith(
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "$quantity left",
                      style:
                          bodyText1.copyWith(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "$price",
                      style:
                          bodyText1.copyWith(fontSize: 15, color: primaryColor),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.01),
              ],
            ),
          ),
          isLow
              ? Positioned(
                  child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                  color: const Color.fromARGB(255, 255, 245, 160),
                  child: Text("Low Stock!",
                      style:
                          bodyText1.copyWith(fontSize: 10, color: Colors.red)),
                ))
              : Container(),
          !isLow
              ? Positioned(
                  right: 10,
                  top: 10,
                  child: CircleAvatar(
                    backgroundColor: actionColor,
                    radius: 15,
                    child: IconButton(
                      icon: Icon(Icons.add, color: Colors.white, size: 15),
                      onPressed: onPressed,
                    ),
                  ))
              : Container()
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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return ListTile(
      tileColor: isSelected ? primaryColor : Colors.transparent,
      leading: CircleAvatar(
        radius: height * 0.03,
        backgroundColor: isSelected ? primaryColorLight : primaryColor,
        child: image64.isEmpty
            ? Center(
                child: Text(
                  productName!.substring(0, 2).toUpperCase(),
                  style: headline1.copyWith(
                      fontSize: 20,
                      color: isSelected ? primaryColor : primaryColorLight),
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
      title: Text(productName!, style: isSelected ? headline2 : headline1),
      subtitle:
          Text("Quantity $quantity", style: isSelected ? bodyText2 : bodyText1),
      trailing: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
            padding: EdgeInsets.all(height * 0.01),
            decoration: BoxDecoration(
                color: isSelected ? primaryColorLight : primaryColor),
            child: Text(
              price!,
              style: isSelected
                  ? bodyText2.copyWith(fontSize: 12, color: primaryColor)
                  : bodyText2.copyWith(fontSize: 12),
            )),
      ),
    );
  }
}
