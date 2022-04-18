import 'package:flutter/material.dart';

import '../../components/textFields.dart';

class ItemDetail extends StatelessWidget {
  const ItemDetail({
    Key? key,
    required this.theme,
    required this.itemPrice,
  }) : super(key: key);

  final ThemeData theme;
  final double itemPrice;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return ListTile(
      leading: CircleAvatar(
        radius: height*0.03,
        backgroundColor: theme.primaryColorLight,
      ),
      title: Text("Product name",
          style: theme.textTheme.bodyText2),
      subtitle: Text("GHS $itemPrice",
          style: theme.textTheme.bodyText2!.copyWith(fontSize:12))
    );
  }
}

class ItemCounter extends StatelessWidget {
  const ItemCounter({
    Key? key,
    required this.theme,
    required this.width, required this.height,
  }) : super(key: key);

  final ThemeData theme;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
        padding: EdgeInsets.all(height*0.01),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: theme.primaryColorLight
        ),
        child: GestureDetector(
          onTap: (){},
          child: Icon(Icons.remove,size:15,color:theme.primaryColor)
        ),),
        SizedBox(
          width:width*0.13,
          child:  CustomTextField(
            textAlign: TextAlign.center,
            hintColor: Colors.white,
            style: theme.textTheme.bodyText2,
            hintText: '1',
            //borderColor: theme.primaryColorLight
            ),
        ),
        Container(
           padding: EdgeInsets.all(height*0.01),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: theme.primaryColorLight
        ),
        child: GestureDetector(
          onTap: (){},
          child:Icon(Icons.add,size:15,color:theme.primaryColor)
        ),),
    ],);
  }
}
