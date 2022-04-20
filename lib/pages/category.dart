// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_manager/components/button.dart';
import 'package:shop_manager/components/textFields.dart';

import 'package:shop_manager/models/GeneralProvider.dart';
import 'package:shop_manager/models/ShopModel.dart';
import 'package:shop_manager/pages/productlist.dart';
import 'package:shop_manager/pages/widgets/clipPath.dart';

import 'widgets/categoryCard.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final categoryName = TextEditingController();

  bool isV = false;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    double width = MediaQuery.of(context).size.width;
    var categories = context.watch<GeneralProvider>().categories!;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      // appBar: AppBar(
      //   title: Text("Categories"),
      //   backgroundColor: ShopColors.secondaryColor,
      // ),
      body: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipPath(
              clipper: BottomClipper(),
              child: Container(
                padding: EdgeInsets.only(
                    right: height * 0.02,
                    left: height * 0.02,
                    top: height * 0.13,
                    bottom: height * 0.07),
                color: theme.primaryColor,
                child: HeaderSection(
                  height: height,
                  width: width,
                  theme: theme,
                  onPressed: () {
                    _bottomDrawSheet(context);
                  },
                ),
              ),
            ),
            Expanded(
              //height: height*0.5,
              child: categories.isEmpty
                  ? Center(
                      child: Text(
                        'No Categories',
                        style:
                            theme.textTheme.headline1!.copyWith(fontSize: 25),
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(horizontal: height * 0.02),
                      child: GridView.builder(
                          physics: BouncingScrollPhysics(),
                          padding: EdgeInsets.only(top: height * 0.04),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 20,
                                  childAspectRatio: 2 / 2.7),
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            return CategoryCard(
                              index: index,
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProductListScreen(
                                              categoryIndex: index,
                                            )));
                              },
                              smallFont: 20.0,
                              largeFont: 50.0,
                              categoryName: "${categories[index].categoryName}",
                              categoryInitial: categories[index]
                                  .categoryName!
                                  .substring(0, 2),
                            );
                          }),
                    ),
            ),
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
                Padding(
                  padding: EdgeInsets.only(
                      bottom: height * 0.02, top: height * 0.04),
                  child: Text("Add new category",
                      style: theme.textTheme.headline2),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: height * 0.04,
                  ),
                  child: CustomTextField(
                      controller: categoryName,
                      hintText: 'Category Name',
                      hintColor: Colors.white,
                      borderColor: Colors.white,
                      prefixIcon:
                          Icon(Icons.add_box, color: Colors.white, size: 20),
                      style: theme.textTheme.bodyText2),
                ),
                SizedBox(height: height * 0.04),
                Button(
                  color: theme.primaryColorLight,
                  textColor: theme.primaryColor,
                  width: width,
                  buttonText: "Done",
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());

                    // context.watch<GeneralProvider>().categories =
                    Provider.of<GeneralProvider>(context, listen: false)
                        .categories!
                        .add(ProductCategory(
                            categoryName: categoryName.text, products: []));
                    categoryName.clear();
                    Navigator.pop(context);
                    // setState(() {
                    //   showBottomMenu = false;
                    //   bttMenu = true;
                    //   isV = false;
                    // });
                  },
                ),
                SizedBox(height: height * 0.4),
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
    //required this.widget,
    required this.theme,
    required this.width,
    this.onPressed,
  }) : super(key: key);

  final double height;
  //final ProductListScreen widget;
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
              "Categories",
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
