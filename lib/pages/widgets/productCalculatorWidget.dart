import 'package:flutter/material.dart';

import '../../components/textFields.dart';
import '../../models/ShopModel.dart';

class ItemDetail extends StatelessWidget {
  const ItemDetail({
    Key? key,
    required this.theme,
    required this.item,
  }) : super(key: key);

  final ThemeData theme;
  final Product item;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return ListTile(
        leading: CircleAvatar(
          radius: height * 0.03,
          backgroundColor: theme.primaryColorLight,
        ),
        title: Text(item.productName!, style: theme.textTheme.bodyText2),
        subtitle: Text("GHS ${item.sellingPrice}",
            style: theme.textTheme.bodyText2!.copyWith(fontSize: 12)));
  }
}

