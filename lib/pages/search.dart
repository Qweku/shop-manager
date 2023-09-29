// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_manager/components/textFields.dart';
import 'package:shop_manager/models/GeneralProvider.dart';
import 'package:shop_manager/pages/widgets/constants.dart';

import '../models/ShopModel.dart';

class Search extends SearchDelegate {
  final List<Product> productList;
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

    productItems = List.from(Provider.of<GeneralProvider>(context,
            listen: false)
        .inventory
        .where((element) =>
            element.productName!.toLowerCase().contains(query.toLowerCase())));
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
 final  Function(String) valueCallback;
  ItemSearchBar({Key? key, required this.valueCallback}) : super(key: key);

  @override
  State<ItemSearchBar> createState() => _ItemSearchBarState();
}

class _ItemSearchBarState extends State<ItemSearchBar> {
  late GeneralProvider shop;
  late List<Product> productList;

  @override
  void initState() {
   
    super.initState();

    shop = context.read<GeneralProvider>();
    // productList = shop.categories;
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      hintText: 'Search Item',
      prefixIcon: Icon(Icons.search, color: primaryColor),
      color: Color.fromARGB(255, 247, 247, 247),
      style: bodyText1,
      onChanged: (searchValue) {
        widget.valueCallback(searchValue);
      },
    );
  }

  void searchItem(String query) {
    late final List<Product> productItems;
    productItems = List.from(Provider.of<GeneralProvider>(context,
            listen: false)
        .inventory
        .where((element) =>
            element.productName!.toLowerCase().contains(query.toLowerCase())));
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
