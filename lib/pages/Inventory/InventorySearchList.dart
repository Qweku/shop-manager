import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_manager/components/responsive.dart';
import 'package:shop_manager/models/GeneralProvider.dart';
import 'package:shop_manager/models/ShopModel.dart';
import 'package:shop_manager/pages/addproduct.dart';
import 'package:shop_manager/pages/productView.dart';
import 'package:shop_manager/pages/widgets/constants.dart';
import 'package:shop_manager/pages/widgets/productCard.dart';

class InventorySearchList extends StatefulWidget {
  final bool isList;
  final String query;
  const InventorySearchList(
      {Key? key, this.isList = false, required this.query})
      : super(key: key);

  @override
  State<InventorySearchList> createState() => _InventorySearchListState();
}

class _InventorySearchListState extends State<InventorySearchList> {
  List<String>? imagePaths;

  Product? product;
  String? imagePath;

  bool isScrolled = false;
  int isSelected = 0;
  List<Product> productItems = [];
  List<Product> searchItem(String query) {
    productItems.clear();
    // for (Product element
    //     in Provider.of<GeneralProvider>(context, listen: false).inventory) {
    //   productItems.addAll(element.where((elements) =>
    //       elements.productName!.toLowerCase().contains(query.toLowerCase())));
    // }
    productItems = List.from(Provider.of<GeneralProvider>(context,
            listen: false)
        .inventory
        .where((element) =>
            element.productName!.toLowerCase().contains(query.toLowerCase())));
    return productItems;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        (searchItem(widget.query).isEmpty)
            ? Center(
                child: Text(
                  'No Products',
                  style:
                      headline1.copyWith(fontSize: 25, color: Colors.blueGrey),
                ),
              )
            : Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: height * 0.01),
                  child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 800),
                      child: GridView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.only(top: height * 0.02),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: Responsive.isMobile() ? 3 : 4,
                                  childAspectRatio: 2 / 3.5),
                          itemCount: productItems.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                top: 10,
                              ),
                              child: ProductCard(
                                onLongPress: () {
                                  _bottomDrawSheet(
                                      context,
                                      productItems
                                          .where((element) =>
                                              element.productCategory!.cid ==
                                              context
                                                  .read<GeneralProvider>()
                                                  .category
                                                  .cid)
                                          .toList()[index]);
                                },
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ProductView(
                                                product: productItems[index],
                                              )));
                                },
                                index: index,
                                image64: productItems[index].productImage ?? "",
                                productName: productItems[index].productName,
                                quantity: productItems[index]
                                    .productQuantity
                                    .toString(),
                                price:
                                    "GHS ${productItems[index].sellingPrice.toString()}",
                              ),
                            );
                          })),
                ),
              )
      ],
    );
  }

  void _bottomDrawSheet(BuildContext context, Product product) {
    double height = MediaQuery.of(context).size.height;
    showModalBottomSheet(
        backgroundColor: primaryColorLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(20.0),
              topRight: const Radius.circular(20.0)),
        ),
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.all(height * 0.02),
            child: Wrap(
              spacing: 20,
              children: <Widget>[
                SizedBox(height: height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => AddProductScreen(
                                      toEdit: true,
                                      product: product,
                                    ))).then((value) {
                          setState(() {});
                          Navigator.pop(context);
                        });
                      },
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: height * 0.04,
                            backgroundColor: primaryColor,
                            child: Icon(Icons.edit, color: primaryColorLight),
                          ),
                          SizedBox(height: height * 0.01),
                          Text('Edit', style: bodyText1)
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Provider.of<GeneralProvider>(context, listen: false)
                            .deleteProduct(product);

                        Navigator.pop(context);
                      },
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: height * 0.04,
                            backgroundColor: primaryColor,
                            child: Icon(Icons.delete, color: primaryColorLight),
                          ),
                          SizedBox(height: height * 0.01),
                          Text('Remove', style: bodyText1)
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.04),
              ],
            ),
          );
        });
  }
}



// ListView.builder(
//                               physics: const BouncingScrollPhysics(),
//                               padding: EdgeInsets.zero,
//                               itemCount: productItems.length,
//                               itemBuilder: (context, index) {
//                                 return ProductListTile(
//                                   onTap: () {
//                                     Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) => ProductView(
//                                                   product: productItems[index],
//                                                 )));
//                                   },
//                                   index: index,
//                                   image64:
//                                       productItems[index].productImage ?? "",
//                                   productName: productItems[index]
//                                       .productQuantity
//                                       .toString(),
//                                   price:
//                                       "GHS ${productItems[index].sellingPrice.toString()}",
//                                 );
//                               })