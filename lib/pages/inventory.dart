// ignore_for_file: unnecessary_cast, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:shop_manager/config/colors.dart';
import 'package:shop_manager/models/GeneralProvider.dart';
import 'package:shop_manager/models/productModel.dart';
import 'package:shop_manager/pages/addproduct.dart';
import 'package:shop_manager/pages/dashboard.dart';
import 'package:shop_manager/pages/widgets/categoryCard.dart';

import 'widgets/clipPath.dart';
import 'widgets/productCard.dart';

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
    //var categories = context.watch<GeneralProvider>();
    var categories = context.watch<GeneralProvider>();
    final theme = Theme.of(context);
    return Scaffold(
        body: SafeArea(
      top: false,
      child: Column(
          // height: height * 0.8,
          children: [
            ClipPath(
              clipper: BottomClipper(),
              child: Container(
                width: width,
                padding: EdgeInsets.only(
                    right: height * 0.02,
                    left: height * 0.02,
                    top: height * 0.1,
                    bottom: height * 0.07),
                color: theme.primaryColor,
                child: HeaderSection(
                  height: height,
                  theme: theme,
                  width: width,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: height * 0.01),
              height: height * 0.15,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.categories!.length,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      width: width * 0.3,
                      child: CategoryCard(
                        index: index,
                        onTap: () {
                          // categories =
                          //     categories.categories[index];
                          // categories.categorised = true;
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => ProductListScreen(
                          //               categoryIndex: index,
                          //             )));
                        },
                        smallFont: 12.0,
                        largeFont: 25.0,
                        categoryName: "${categories.categories![index].categoryName}",
                        categoryInitial:
                            categories.categories![index].categoryName!.substring(0, 2),
                      ),
                    );
                  }),
            ),

            Expanded(
                child: Padding(
              padding: EdgeInsets.symmetric(horizontal: height * 0.01),
              child: GridView.builder(
                  padding: EdgeInsets.only(top: height * 0.02),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: 2 / 2.9),
                  itemCount: categories.inventory.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(
                          top: index.isEven ? height * 0.02 : 0,
                          bottom: index.isOdd ? height * 0.02 : 0),
                      child: ProductCard(
                        index: index,
                        image64:  categories.inventory[index].imageb64.toString(),
                        productName: categories.inventory[index].productName,
                        quantity: categories.inventory[index].quantity.toString(),
                        price: categories.inventory[index].sellingPrice.toString(),
                      ),
                    );
                  }),
            ))

            // ListView.builder(
            //     itemCount: categories.length,
            //     itemBuilder: (context, index) {
            //       return ListTile(
            //           onTap: () {
            //             // categories.category =
            //             //     categories.categories[index];
            //             // categories.categorised = true;
            //             // Navigator.push(
            //             //     context,
            //             //     MaterialPageRoute(
            //             //         builder: (context) =>
            //             //             ProductListScreen()));
            //           },
            //           leading: Icon(Icons.category,
            //               color: ShopColors.secondaryColor),
            //           // title: Text(
            //           //     "${categories[index].productName}",
            //           //     style: TextStyle(fontSize: 17)),
            //           trailing: Icon(Icons.circle,
            //               color: ShopColors.secondaryColor));
            //     }),

            //),
          ]),
    ));
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
            }));
  }
}

class HeaderSection extends StatelessWidget {
  const HeaderSection({
    Key? key,
    required this.height,
    required this.theme,
    required this.width,
    this.onPressed,
  }) : super(key: key);

  final double height;

  final ThemeData theme;
  final double width;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Inventory",
          textAlign: TextAlign.left,
          style: theme.textTheme.headline2!.copyWith(fontSize: 30),
        ),
        SizedBox(
            width: width * 0.1,
            child: Divider(
              color: theme.primaryColorLight,
              thickness: 5,
            )),
      ],
    );
  }
}

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
          