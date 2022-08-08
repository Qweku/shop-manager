import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shop_manager/components/textFields.dart';

import '../models/ShopModel.dart';

class Search extends SearchDelegate {
List<Product> products = [];


  @override
  List<Widget>? buildActions(BuildContext context) {
    return <Widget>[
      IconButton(onPressed: () {}, icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.pop(context);
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
    // TODO: implement buildSuggestions
    return const Text("data");
  }
}


class ItemSearchBar extends StatefulWidget {
  const ItemSearchBar({ Key? key }) : super(key: key);

  @override
  State<ItemSearchBar> createState() => _ItemSearchBarState();
}

class _ItemSearchBarState extends State<ItemSearchBar> {
  ProductCategory? product;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CustomTextField(
      hintText:'Search Item',
      prefixIcon: Icon(Icons.search,color:theme.primaryColor),
      borderColor:theme.primaryColor,
      style:theme.textTheme.bodyText1,
      onChanged: searchItem,
      
    );
  }

  void searchItem(String query){
    final productItem = product!.products!.where((element) {
      final titleLower = element.productName!.toLowerCase();
      final searchLower = query.toLowerCase();
   
   
      return titleLower.contains(searchLower);
    }).toList();


    setState(() {
      
      product!.products!= productItem;
    });
  }
}
