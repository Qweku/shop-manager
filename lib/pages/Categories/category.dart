// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:shop_manager/components/button.dart';
import 'package:shop_manager/components/notifiers.dart';
import 'package:shop_manager/components/textFields.dart';
import 'package:shop_manager/models/GeneralProvider.dart';
import 'package:shop_manager/models/ShopModel.dart';
import 'package:shop_manager/pages/Categories/categorylist.dart';
import 'package:shop_manager/pages/widgets/clipPath.dart';
import 'package:shop_manager/pages/widgets/constants.dart';
import '../widgets/categoryCard.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final categoryName = TextEditingController();
  final categoryDescription = TextEditingController();

  bool isV = false;
  @override
  void dispose() {
    categoryDescription.dispose();
    categoryName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

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
                color: primaryColor,
                child: HeaderSection(
                  height: height,
                  width: width,
                
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
                      style: headline1
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
                                  context.read<GeneralProvider>().category =
                                      categories[index];
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ProductListScreen(
                                                  // categoryIndex: index,
                                                  )));
                                },
                                smallFont: 20.0,
                                largeFont: 50.0,
                                categoryName: categories[index].categoryName,
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
    double height = MediaQuery.of(context).size.height;
    showModalBottomSheet(
        backgroundColor: primaryColor,
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
                            backgroundColor: primaryColorLight,
                            child: Icon(Icons.edit, color: primaryColor),
                          ),
                          SizedBox(height: height * 0.01),
                          Text('Edit', style: bodyText2)
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
                            backgroundColor: primaryColorLight,
                            child: Icon(Icons.delete, color: primaryColor),
                          ),
                          SizedBox(height: height * 0.01),
                          Text('Delete', style: bodyText2)
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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: primaryColor,
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
                      ? Text("Add new category", style: headline2)
                      : Text("Edit Category", style: headline2),
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
                      style: bodyText2),
                ),
                SizedBox(height: height * 0.1),
                Button(
                  color: primaryColorLight,
                  textColor: primaryColor,
                  width: width,
                  buttonText: "Done",
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode());

                    if (!edit && categoryName.text.isEmpty) {
                      Notifier().toast(
                          context: bc,
                          message: 'Type a NAME!',
                          color: Color.fromARGB(255, 255, 17, 1));

                      return;
                    }
                    // context.watch<GeneralProvider>().categories =
                    // Provider.of<GeneralProvider>(context, listen: false)
                    //     .categories
                    //     .add(ProductCategory(
                    //       categoryName.text,
                    //     ));
                    // var categoryBox = Hive.box<ProductCategory>('Category');

                    // await categoryBox.add(ProductCategory(
                    //   categoryName.text,
                    // ));

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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    showDialog(
        context: context,
        builder: ((context) {
          if (edit) {
            categoryName.text = productCategory!.categoryName!;
            categoryDescription.text = productCategory.categoryDescription!;
          }
          return AlertDialog(
            backgroundColor: primaryColor,
            title: !edit
                ? Text("Add new category",
                    style: headline2.copyWith(color: Colors.white))
                : Text("Edit Category",
                    style: headline2.copyWith(color: Colors.white)),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomTextField(
                    controller: categoryName,
                    hintText:
                        edit ? productCategory!.categoryName : 'Category Name',
                    hintColor: Colors.white,
                    borderColor: Colors.white,
                    prefixIcon:
                        Icon(Icons.add_box, color: Colors.white, size: 20),
                    style: bodyText2),
                CustomTextField(
                    controller: categoryDescription,
                    hintText: edit
                        ? productCategory!.categoryDescription
                        : 'Category Description',
                    hintColor: Colors.white,
                    borderColor: Colors.white,
                    maxLines: 5,
                    // prefixIcon:
                    //     Icon(Icons.add_box, color: Colors.white, size: 20),
                    style: bodyText2),
              ],
            ),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actions: [
              TextButton(
                  style: TextButton.styleFrom(backgroundColor: Colors.white),
                  onPressed: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    // var categoryBox = Hive.box<ProductCategory>('Category');

                    if (!edit && categoryName.text.isEmpty) {
                      Notifier().toast(
                          context: context,
                          message: 'Type a CATEGORY NAME!',
                          color: Color.fromARGB(255, 255, 17, 1));

                      return;
                    }
                    //  ProductCategory category = ProductCategory(
                    //   cid: context.read<GeneralProvider>().categories.last.cid,
                    //   categoryName: categoryName.text,
                    //   categoryDescription: categoryDescription.text
                    // );

                    if (edit) {
                      if (categoryName.text.isEmpty) {
                        ProductCategory category = ProductCategory(
                            cid: productCategory!.cid,
                            categoryName: categoryName.text,
                            categoryDescription: categoryDescription.text);

                        context
                            .read<GeneralProvider>()
                            .editCategory(productCategory);
                      }

                      categoryName.clear();
                      Navigator.pop(context);
                      return;
                    } else {
                      ProductCategory category = ProductCategory(
                          cid:
                              context.read<GeneralProvider>().categories.isEmpty
                                  ? 1
                                  : context
                                          .read<GeneralProvider>()
                                          .categories
                                          .last
                                          .cid! +
                                      1,
                          categoryName: categoryName.text,
                          categoryDescription: categoryDescription.text);
                      if (!context
                          .read<GeneralProvider>()
                          .addCategory(category)) {
                        Notifier().toast(
                            context: context,
                            message: 'Name Already Exists!',
                            color: Color.fromARGB(255, 255, 17, 1));
                      }

                      categoryName.clear();
                      categoryDescription.clear();
                      Navigator.pop(context);
                      return;
                    }
                  },
                  child: Text(
                    "Save",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: primaryColor),
                  )),
              TextButton(
                  onPressed: (() => Navigator.pop(context)),
                  child: Text(
                    "Cancel",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: primaryColorLight),
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
   
    required this.width,
    this.onPressed,
  }) : super(key: key);

  final double height;
  //final ProductListScreen widget;
 
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
              style: headline2.copyWith(fontSize: 30),
            ),
            SizedBox(
                width: width * 0.1,
                child: Divider(
                  color: primaryColorLight,
                  thickness: 5,
                )),
          ],
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: primaryColorLight),
          child: IconButton(
              onPressed: onPressed, icon: Icon(Icons.add, color: primaryColor)),
        )
      ],
    );
  }
}
