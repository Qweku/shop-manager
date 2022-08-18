// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_manager/components/button.dart';
import 'package:shop_manager/components/textFields.dart';
import 'package:shop_manager/models/GeneralProvider.dart';
import 'package:shop_manager/models/ShopModel.dart';
import 'package:shop_manager/pages/categorylist.dart';
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
    var categories = context.watch<GeneralProvider>().categories;
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                    _dialog(context);
                  },
                ),
              ),
            ),
            categories.isEmpty
                ? Center(
                    heightFactor: height * 0.015,
                    child: Text(
                      'No Categories',
                      style: theme.textTheme.headline1!
                          .copyWith(fontSize: 25, color: Colors.blueGrey),
                    ),
                  )
                : Expanded(
                    child: Padding(
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
                            return GestureDetector(
                              onLongPress: () {
                                _bottomEditDrawSheet(
                                    context, categories[index]);
                                setState(() {});
                              },
                              child: CategoryCard(
                                index: index,
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ProductListScreen(
                                                categoryIndex: index,
                                              )));
                                },
                                smallFont: 20.0,
                                largeFont: 50.0,
                                categoryName:
                                    "${categories[index].categoryName}",
                              ),
                            );
                          }),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  void _bottomEditDrawSheet(context, ProductCategory category) {
    final theme = Theme.of(context);
    double height = MediaQuery.of(context).size.height;
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
                      onTap: () {
                        Navigator.pop(context);
                        _dialog(context, edit: true, productCategory: category);
                      },
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: height * 0.04,
                            backgroundColor: theme.primaryColorLight,
                            child: Icon(Icons.edit, color: theme.primaryColor),
                          ),
                          SizedBox(height: height * 0.01),
                          Text('Edit', style: theme.textTheme.bodyText2)
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Provider.of<GeneralProvider>(context, listen: false)
                            .categories
                            .remove(category);

                        Navigator.pop(context);
                        setState(() {});
                      },
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: height * 0.04,
                            backgroundColor: theme.primaryColorLight,
                            child:
                                Icon(Icons.delete, color: theme.primaryColor),
                          ),
                          SizedBox(height: height * 0.01),
                          Text('Delete', style: theme.textTheme.bodyText2)
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

  void _bottomDrawSheet(context,
      {ProductCategory? productCategory, bool edit = false}) {
    final theme = Theme.of(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: theme.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(20.0),
              topRight: const Radius.circular(20.0)),
        ),
        context: context,
        builder: (BuildContext bc) {
          return Container(
            height: height * 0.7,
            padding: EdgeInsets.all(height * 0.02),
            child: Wrap(
              spacing: 20,
              children: <Widget>[
                SizedBox(height: height * 0.02),
                Padding(
                  padding: EdgeInsets.only(
                      bottom: height * 0.02, top: height * 0.04),
                  child: !edit
                      ? Text("Add new category",
                          style: theme.textTheme.headline2)
                      : Text("Edit Category", style: theme.textTheme.headline2),
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
                SizedBox(height: height * 0.1),
                Button(
                  color: theme.primaryColorLight,
                  textColor: theme.primaryColor,
                  width: width,
                  buttonText: "Done",
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());

                    if (!edit && categoryName.text.isEmpty) {
                      ScaffoldMessenger.of(bc)
                          // .showMaterialBanner(
                          //     MaterialBanner(
                          //       leading: CircleAvatar(backgroundColor: Colors.red,child: Icon(Icons.notification_important),),
                          //         content: Text('Type a NAME!',
                          //             textAlign: TextAlign.center,
                          //             style: theme.textTheme.bodyText2),
                          //         actions: <Widget>[
                          //       TextButton(
                          //         onPressed: () {
                          //           Navigator.pop(context);
                          //         },
                          //         child: Text('Dismiss'),
                          //       ),
                          //     ]));
                          .showSnackBar(
                        SnackBar(
                            backgroundColor: Color.fromARGB(255, 255, 17, 1),
                            content: Text('Type a NAME!',
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodyText2),
                            duration: Duration(seconds: 5),
                            behavior: SnackBarBehavior.floating,
                            shape: StadiumBorder()),
                      );
                      return;
                    }
                    // context.watch<GeneralProvider>().categories =
                    Provider.of<GeneralProvider>(context, listen: false)
                        .categories
                        .add(ProductCategory(
                            categoryName: categoryName.text, ));
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

  void _dialog(context, {ProductCategory? productCategory, bool edit = false}) {
    final theme = Theme.of(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            backgroundColor: theme.primaryColor,
            title: !edit
                ? Text("Add new category",
                    style: theme.textTheme.headline2!
                        .copyWith(color: Colors.white))
                : Text("Edit Category",
                    style: theme.textTheme.headline2!
                        .copyWith(color: Colors.white)),
            content: CustomTextField(
                controller: categoryName,
                hintText:
                    edit ? productCategory!.categoryName : 'Category Name',
                hintColor: Colors.white,
                borderColor: Colors.white,
                prefixIcon: Icon(Icons.add_box, color: Colors.white, size: 20),
                style: theme.textTheme.bodyText2),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actions: [
              TextButton(
                  style: TextButton.styleFrom(backgroundColor: Colors.white),
                  onPressed: () {
                    FocusScope.of(context).requestFocus(FocusNode());

                    if (!edit && categoryName.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            backgroundColor: Color.fromARGB(255, 255, 17, 1),
                            content: Text('Type a CATEGORY NAME!',
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodyText2),
                            duration: Duration(seconds: 3),
                            behavior: SnackBarBehavior.floating,
                            shape: StadiumBorder()),
                      );
                      return;
                    }

                    if (Provider.of<GeneralProvider>(context, listen: false)
                        .categories
                        .any((element) =>
                            element.categoryName!.toLowerCase() ==
                            categoryName.text.toLowerCase())) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            backgroundColor: Color.fromARGB(255, 255, 17, 1),
                            content: Text('Name Already Exists!',
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodyText2),
                            duration: Duration(seconds: 3),
                            behavior: SnackBarBehavior.floating,
                            shape: StadiumBorder()),
                      );
                      return;
                    }

                    if (edit) {
                      if (categoryName.text.isNotEmpty) {
                        Provider.of<GeneralProvider>(context, listen: false)
                            .categories
                            .firstWhere(
                                (element) => element == productCategory!)
                            .categoryName = categoryName.text;
                      }
                      categoryName.clear();
                      Navigator.pop(context);
                      return;
                    } else {
                      Provider.of<GeneralProvider>(context, listen: false)
                          .categories
                          .add(ProductCategory(
                              categoryName: categoryName.text,  ));
                      categoryName.clear();
                      Navigator.pop(context);
                      return;
                    }
                  },
                  child: Text(
                    "Save",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: theme.primaryColor),
                  )),
              TextButton(
                  onPressed: (() => Navigator.pop(context)),
                  child: Text(
                    "Cancel",
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 15, color: theme.primaryColorLight),
                  )),
            ],
          );
        }));
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
