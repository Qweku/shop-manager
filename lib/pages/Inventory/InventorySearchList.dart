import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_manager/models/GeneralProvider.dart';
import 'package:shop_manager/models/ShopModel.dart';
import 'package:shop_manager/pages/productView.dart';
import 'package:shop_manager/pages/widgets/productCard.dart';

class InventorySearchList extends StatefulWidget {
  final bool isList;
  final String query;
  const InventorySearchList({Key? key, this.isList=false, required this.query}) : super(key: key);

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
    for (ProductCategory element
        in Provider.of<GeneralProvider>(context, listen: false).categories!) {
      productItems.addAll(element.products!.where((elements) =>
          elements.productName!.toLowerCase().contains(query.toLowerCase())));
    }
    return productItems;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    //var categories = context.watch<GeneralProvider>();
    var categories = context.watch<GeneralProvider>();
    final theme = Theme.of(context);
    return Expanded(
      child: Column(
        children: [
          (searchItem(widget.query).isEmpty)
              ? Center(
                  child: Text(
                    'No Products',
                    style: theme.textTheme.headline1!
                        .copyWith(fontSize: 25, color: Colors.blueGrey),
                  ),
                )
              : Expanded(
                  child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: height * 0.01),
                  child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 800),
                      child: !widget.isList
                          ? GridView.builder(
                              physics: BouncingScrollPhysics(),
                              padding: EdgeInsets.only(top: height * 0.02),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 2 / 2.9),
                              itemCount: productItems.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                      top: index.isEven ? height * 0.02 : 0,
                                      bottom: index.isOdd ? height * 0.02 : 0),
                                  child: ProductCard(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ProductView(
                                                    product:
                                                        productItems[index],
                                                  )));
                                    },
                                    index: index,
                                    image64: productItems[index].imageb64 ?? "",
                                    productName:
                                        productItems[index].productName,
                                    quantity:
                                        productItems[index].quantity.toString(),
                                    price:
                                        "GHS ${productItems[index].sellingPrice.toString()}",
                                  ),
                                );
                              })
                          : ListView.builder(
                              physics: BouncingScrollPhysics(),
                              padding: EdgeInsets.zero,
                              itemCount: productItems.length,
                              itemBuilder: (context, index) {
                                return ProductListTile(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ProductView(
                                                  product: productItems[index],
                                                )));
                                  },
                                  index: index,
                                  image64: productItems[index].imageb64 ?? "",
                                  productName:
                                      productItems[index].quantity.toString(),
                                  price:
                                      "GHS ${productItems[index].sellingPrice.toString()}",
                                );
                              })),
                ))
        ],
      ),
    );
  }
}
