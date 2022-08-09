// ignore_for_file: prefer_const_constructors

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_manager/components/textFields.dart';
import 'package:shop_manager/models/GeneralProvider.dart';

import '../models/ShopModel.dart';

class Search extends SearchDelegate {
  final List<ProductCategory> productList;
  Search({required this.productList});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return const Text("data");
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Product> productItems = [];

    productList.where((element) {
      productItems = List.from(element.products!.where((elements) =>
          elements.productName!.toLowerCase().contains(query.toLowerCase())));
      return false;
    });
    return (productList.isEmpty)
        ? Center(
            child: const Text("No Data"),
          )
        : ListView.builder(
            // physics: BouncingScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: productItems.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  productItems[index].productName!,
                  style: TextStyle(fontSize: 40),
                ),
              );
            });
  }
}

class ItemSearchBar extends StatefulWidget {
  Function(String) valueCallback;
  ItemSearchBar({Key? key, required this.valueCallback}) : super(key: key);

  @override
  State<ItemSearchBar> createState() => _ItemSearchBarState();
}

class _ItemSearchBarState extends State<ItemSearchBar> {
  late GeneralProvider shop;
  late List<ProductCategory> productList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    shop = context.read<GeneralProvider>();
    productList = shop.categories!;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CustomTextField(
      hintText: 'Search Item',
      prefixIcon: Icon(Icons.search, color: theme.primaryColor),
      borderColor: theme.primaryColor,
      style: theme.textTheme.bodyText1,
      onChanged: (searchValue) {
        widget.valueCallback(searchValue);
      },
    );
  }

  void searchItem(String query) {
    late final List<Product> productItems;
    productList.where((element) {
      productItems = element.products!
          .where((elements) =>
              elements.productName!.toLowerCase().contains(query.toLowerCase()))
          .toList();
      return false;
    });
    // products!.where((element) {
    //   final titleLower = element.productName!.toLowerCase();
    //   final searchLower = query.toLowerCase();

    //   return titleLower.contains(searchLower);
    // }).toList();

    // setState(() {
    //   productList!.products != productItem;
    // });
  }
}
