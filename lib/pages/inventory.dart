// ignore_for_file: unnecessary_cast, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:shop_manager/config/colors.dart';
import 'package:shop_manager/models/GeneralProvider.dart';
import 'package:shop_manager/models/productModel.dart';
import 'package:shop_manager/pages/addproduct.dart';
import 'package:shop_manager/pages/dashboard.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({
    Key? key,
  }) : super(key: key);

  @override
  _InventoryScreenState createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  //File _image;
  List<String>? imagePaths;
  // final toBytes = Io.File(widget.imagePath).readAsBytesSync();
  // String base64Image = base64Encode(toBytes);
  Product? product;
  String? imagePath;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var categories = context.watch<GeneralProvider>();

    return WillPopScope(
      onWillPop: () {
        return Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) => Dashboard()),
          ModalRoute.withName('/'),
        ).then((value) => value as bool);
      },
      child: Scaffold(
          //backgroundColor: ShopColors.primaryColor,
          appBar: AppBar(
            title: Text("Inventory"),
            backgroundColor: ShopColors.secondaryColor,
            //iconTheme: IconThemeData(color: Colors.black),
          ),
          body: Container(
            padding: const EdgeInsets.only(/*    */ right: 20, left: 20),
            child: Column(
                // height: height * 0.8,
                children: [
                  Padding(
                      padding: const EdgeInsets.all(20),
                      child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddProductScreen())).then((value) {setState(() {
                                      
                                    });} );
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(vertical: 13),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                //border: Border.all(color: BaseColors.secondaryColor, width: 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: Colors.black45,
                                      offset: Offset(1, 3),
                                      blurRadius: 5,
                                      spreadRadius: 1)
                                ],
                                color: ShopColors.secondaryColor),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_moderator,
                                    color: ShopColors.primaryColor),
                                SizedBox(width: 10),
                                Text(
                                  'Add product',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: ShopColors.primaryColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ))),

                  Expanded(
                    child: ListView.builder(
                        itemCount: categories.inventory.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                              onTap: () {
                                // categories.category =
                                //     categories.categories[index];
                                // categories.categorised = true;
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) =>
                                //             ProductListScreen()));
                              },
                              leading: Icon(Icons.category,
                                  color: ShopColors.secondaryColor),
                              title: Text(
                                  "${categories.inventory[index].productName}",
                                  style: TextStyle(fontSize: 17)),
                              trailing: Icon(Icons.circle,
                                  color: ShopColors.secondaryColor));
                        }),
                  ),
                ]
                // imagePath != null
                //     ? GridView.builder(
                //         gridDelegate:
                //             const SliverGridDelegateWithFixedCrossAxisCount(
                //                 crossAxisCount: 2,
                //                 mainAxisSpacing: 10,
                //                 crossAxisSpacing: 10,
                //                 childAspectRatio: 0.5),
                //         itemCount: imagePath != null && imagePath.isNotEmpty
                //             ? imagePath.length
                //             : 1,
                //         padding: EdgeInsets.zero,
                //         itemBuilder: (BuildContext context, int index) {
                //           //List<String> imagePaths;
                //           return Container(
                //             height: height * 0.25,
                //             child: Column(
                //               crossAxisAlignment: CrossAxisAlignment.start,
                //               children: [
                //                 Container(
                //                   width: width,
                //                   height: height * 0.25,
                //                   decoration: BoxDecoration(
                //                       borderRadius: BorderRadius.circular(20),
                //                       color: ShopColors.secondaryColor),
                //                   child:  imagePath != null
                //                       ? ClipRRect(
                //                           borderRadius: BorderRadius.circular(20),
                //                           child: Image.file(
                //                             Io.File( imagePath),
                //                             width: width,
                //                             height: height * 0.25,
                //                             fit: BoxFit.cover,
                //                           ),
                //                         )
                //                       : Container(
                //                           decoration: BoxDecoration(
                //                             //color: Colors.grey[200],
                //                             borderRadius:
                //                                 BorderRadius.circular(20),
                //                           ),
                //                           width: width,
                //                           height: height * 0.25,
                //                           child: Icon(
                //                             Icons.camera_alt,
                //                             color: ShopColors.primaryColor,
                //                             size: 30,
                //                           ),
                //                         ),
                //                 ),
                //                 Padding(
                //                   padding:
                //                       const EdgeInsets.symmetric(vertical: 8),
                //                   child: Text(
                //                       "${ product.productName}" +
                //                           " (${ product.costPrice})",
                //                       style: TextStyle(
                //                           fontSize: 17,
                //                           fontWeight: FontWeight.bold)),
                //                 ),
                //                 Text("${ product.sellingPrice}",
                //                     style: TextStyle(fontSize: 17)),
                //               ],
                //             ),
                //           );
                //         },
                //       )
                //     : Container(),
                ),
          )),
    );
  }
}

class ProductList extends StatelessWidget {
  const ProductList(
      {Key? key,
      this.maxheight,
      this.prefixWidget,
      this.title,
      this.subtitle,
      this.suffixWidget})
      : super(key: key);

  final Widget? prefixWidget;
  final double? maxheight;
  final String? title;
  final String? subtitle;
  final Widget? suffixWidget;

  @override
  Widget build(BuildContext context) {
    var categories = context.watch<GeneralProvider>();

    return Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        height: maxheight,
        child: ListView.builder(
            itemCount: categories.inventory.length,
            itemBuilder: (context, index) {
              return ListTile(
                  onTap: () {
                    // categories.category =
                    //     categories.categories[index];
                    // categories.categorised = true;
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) =>
                    //             ProductListScreen()));
                  },
                  leading:
                      Icon(Icons.category, color: ShopColors.secondaryColor),
                  title: Text("${categories.inventory[index].productName}",
                      style: TextStyle(fontSize: 17)),
                  trailing:
                      Icon(Icons.circle, color: ShopColors.secondaryColor));
            })

        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     Expanded(child: prefixWidget),
        //     Padding(
        //       padding: const EdgeInsets.symmetric(horizontal: 10),
        //       child: Column(
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: [
        //           Text(title,
        //               style: TextStyle(
        //                 fontSize: 20,
        //                 fontWeight: FontWeight.bold,
        //               )),
        //           Padding(
        //             padding: const EdgeInsets.only(top: 10),
        //             child: Text(subtitle,
        //                 style: TextStyle(
        //                   fontSize: 17,
        //                 )),
        //           )
        //         ],
        //       ),
        //     ),
        //     Expanded(
        //       child: Padding(
        //         padding: const EdgeInsets.only(left: 20),
        //         child: suffixWidget,
        //       ),
        //     )
        //   ],
        // ),
        );
  }
}
