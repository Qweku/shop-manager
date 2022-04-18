// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:shop_manager/config/colors.dart';
import 'package:shop_manager/models/GeneralProvider.dart';
import 'package:provider/provider.dart';
import 'package:shop_manager/models/ShopModel.dart';

import 'addproduct.dart';
import 'widgets/clipPath.dart';
import 'widgets/productCard.dart';

class ProductListScreen extends StatefulWidget {
  int categoryIndex;
  ProductListScreen({Key? key, required this.categoryIndex}) : super(key: key);

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final categoryName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            Column(
                // height: height,
                children: [
                  ClipPath
                  (
                    clipper: BottomClipper(),
                    child: Container(
                      padding: EdgeInsets.only(
                        right: height * 0.02,
                        left: height * 0.02,
                        top: height * 0.1,
                        bottom: height*0.07),
                                  color: theme.primaryColor,
                      child: HeaderSection(
                        height: height,
                        widget: widget,
                        theme: theme,
                        width: width,
                        onPressed: () {
                          Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddProductScreen()))
                              .then((value) {
                            setState(() {});
                          });
                        },
                      ),
                    ),
                  ),
                  Consumer<GeneralProvider>(builder: (builder, state, child) {
                    return Expanded(
                        child: state.categories![widget.categoryIndex]
                              .products!.isEmpty
                  ? Center(
                      child: Text(
                        'No Products',
                        
                        style:
                            theme.textTheme.headline1!.copyWith(fontSize: 25),
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(horizontal: height * 0.01),
                      child: GridView.builder(
                         physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.only(
                 
                  top: height * 0.02),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  
                                  childAspectRatio: 2 / 2.9),
                          itemCount: state.categories![widget.categoryIndex]
                              .products!.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                  top: index.isEven ? height * 0.02 : 0,
                                  bottom: index.isOdd ? height * 0.02 : 0),
                              child: ProductCard(
                                onTap: (){
                                  _bottomDrawSheet(context);
                                },
                                index: index,
                                image64:state.categories![widget.categoryIndex].products![index].imageb64 ?? '',
                                productName:
                                    "${state.categories![widget.categoryIndex].products![index].productName}",
                                quantity:
                                    "${state.categories![widget.categoryIndex].products![index].quantity}",
                                price:
                                    "GHS ${state.categories![widget.categoryIndex].products![index].sellingPrice}",
                              ),
                            );
                          }),
                    ));
                  })
                ]),
          ],
        ),
      ),
    );
  }
  void _bottomDrawSheet(context) {
    final theme = Theme.of(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    showModalBottomSheet(
        backgroundColor: theme.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(20.0),
              topRight: const Radius.circular(20.0)),
        ),
        context: context,
        builder: (BuildContext bc) {
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
                      onTap: (){},
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: height*0.04,
                            backgroundColor: theme.primaryColorLight,
                            child: Icon(Icons.edit,color:theme.primaryColor),
                          ),
                          SizedBox(height:height*0.01),
                          Text('Edit',style:theme.textTheme.bodyText2)
                        ],
                      ),
                    ),
                     GestureDetector(
                    onTap: (){},
                       child: Column(
                        children: [
                          CircleAvatar(
                            radius: height*0.04,
                            backgroundColor: theme.primaryColorLight,
                            child: Icon(Icons.delete,color:theme.primaryColor),
                          ),
                          SizedBox(height:height*0.01),
                          Text('Delete',style:theme.textTheme.bodyText2)
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

class HeaderSection extends StatelessWidget {
  const HeaderSection({
    Key? key,
    required this.height,
    required this.widget,
    required this.theme,
    required this.width,
    this.onPressed,
  }) : super(key: key);

  final double height;
  final ProductListScreen widget;
  final ThemeData theme;
  final double width;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                "${context.read<GeneralProvider>().categories![widget.categoryIndex].categoryName}",
                textAlign: TextAlign.left,
                style: theme.textTheme.headline2),
            Text(
              "Product List",
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
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: theme.primaryColorLight),
          child: IconButton(
              onPressed: onPressed,
              icon: Icon(Icons.add, color: theme.primaryColor)),
        )
      ],
    );
  }
}
