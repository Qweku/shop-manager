// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:shop_manager/components/notifiers.dart';
import 'package:shop_manager/components/textFields.dart';
import 'package:shop_manager/config/colors.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:shop_manager/models/GeneralProvider.dart';
import 'package:shop_manager/models/ShopModel.dart';
import 'package:shop_manager/pages/widgets/counter.dart';

class AddProductScreen extends StatefulWidget {
  final bool toEdit;
  final Product? product;
  const AddProductScreen({Key? key, this.toEdit = false, this.product})
      : super(key: key);

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final CurrencyTextInputFormatter formatter = CurrencyTextInputFormatter(
      turnOffGrouping: true,
      decimalDigits: 2,
      // locale: 'usa',
      symbol: 'GHS ');
  final productName = TextEditingController();
  final productPrice = TextEditingController();
  final productCategory = TextEditingController();
  final productQuantity = TextEditingController();
  File? _image;

  late Box shopBox;
  ProductCategory? _selectedCategory;
  String imageString = '';
  List<ProductCategory> categoryList = [];
  //String imagePath;
  final picker = ImagePicker();

  int categoryIndex = 0;

  Future _imgFromCamera() async {
    try {
      final image =
          await picker.pickImage(source: ImageSource.camera, imageQuality: 50);
      // final toBytes = await
      setState(() {
        _image = File(image!.path);

        imageString = base64Encode(File(image.path).readAsBytesSync());
      });
    } catch (e) {}
  }

  _imgFromGallery() async {
    try {
      final image =
          await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
      setState(() {
        _image = File(image!.path);
        imageString = base64Encode(File(image.path).readAsBytesSync());
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  var productBox = Hive.box<Product>('Product');
  var categoryBox = Hive.box<ProductCategory>('Category');
  Widget _submitButton() {
    return InkWell(
        onTap: () async {
          Product product = Product(
              productName: productName.text,
              sellingPrice:
                  double.tryParse(formatter.getUnformattedValue().toString()) ??
                      0,
              itemcategory: _selectedCategory?.categoryName ?? 'Uncategorised',
              quantity: int.tryParse(productQuantity.text) ?? 0,
              costPrice: double.tryParse(productPrice.text) ?? 0,
              imageb64: imageString);

          if (widget.toEdit) {
            await productBox.values
                .singleWhere((element) => element == widget.product)
              ..quantity = product.quantity
              ..costPrice = product.costPrice
              ..sellingPrice = product.sellingPrice
              ..itemcategory = product.itemcategory
              ..costPrice = product.costPrice
              ..imageb64 = product.imageb64
              ..save();

            Provider.of<GeneralProvider>(context, listen: false)
                .inventory
                .singleWhere((element) => element == widget.product)
              ..quantity = product.quantity
              ..sellingPrice = product.sellingPrice
              ..itemcategory = product.itemcategory
              ..costPrice = product.costPrice
              ..imageb64 = product.imageb64;

            Provider.of<GeneralProvider>(context, listen: false)
                .reArrangeCategory();
            HiveFunctions().reArrangeCategory();
          } else {
            if (!(Provider.of<GeneralProvider>(context, listen: false)
                .inventory
                .any(
                    (element) => element.productName == product.productName))) {
              Provider.of<GeneralProvider>(context, listen: false)
                  .inventory
                  .add(product);

              await productBox.add(product);

              if (_selectedCategory?.categoryName.isNotEmpty ?? false) {
                Provider.of<GeneralProvider>(context, listen: false)
                    .saveToCategory(_selectedCategory!);

                HiveFunctions().saveToCategory(_selectedCategory!);
              }
            } else {
              Notifier().toast(
                  context: context,
                  message: "ERROR PRODUCT ALREADY EXIST!",
                  color: Colors.red);
              return;
            }
          }

          Navigator.pop(context);
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 13),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              //border: Border.all(color: BaseColors.secondaryColor, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(20)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.black45,
                    offset: Offset(1, 3),
                    blurRadius: 5,
                    spreadRadius: 1)
              ],
              color: ShopColors.primaryColor),
          child: Text(
            'Done',
            style: TextStyle(fontSize: 20, color: ShopColors.secondaryColor),
          ),
        ));
  }

  @override
  void initState() {
    categoryList = List.from(
        Provider.of<GeneralProvider>(context, listen: false).categories);

    if (widget.toEdit) {
      productName.text = widget.product!.productName!;
      productPrice.text =
          formatter.format(widget.product!.sellingPrice!.toString());
      productQuantity.text = widget.product!.quantity!.toString();
      imageString = (widget.product!.imageb64 ?? "").isEmpty
          ? ""
          : widget.product!.imageb64!;
      _selectedCategory = Provider.of<GeneralProvider>(context, listen: false)
          .categories
          .singleWhere((element) => element.products!.contains(widget.product));
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ShopColors.secondaryColor,
      body: SafeArea(
        child: SizedBox(
          height: height,
          child: Stack(
            children: [
              SingleChildScrollView(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 30, bottom: 20),
                      child: Text(
                          (widget.toEdit)
                              ? "Edit Product Detail"
                              : "Let's add the products in your shop",
                          style: TextStyle(
                              color: ShopColors.textColor, fontSize: 25)),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: CustomTextField(
                          prefixIcon: Icon(Icons.add_box,
                              color: theme.primaryColorLight, size: 20),
                          hintText: "Product name",
                          borderColor: theme.primaryColorLight,
                          controller: productName,
                          style: theme.textTheme.bodyText2,
                          hintColor: Colors.white,
                        )),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                width: 2,
                                style: BorderStyle.solid,
                                color: ShopColors.primaryColor)),
                        child: TextFormField(
                          // initialValue: formatter.format(productPrice.text),
                          controller: productPrice,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                              color: ShopColors.textColor, fontSize: 15),
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.money,
                                  color: ShopColors.primaryColor, size: 20),
                              hintText: "GHS 00.00",
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                  color: ShopColors.primaryColor,
                                  fontSize: 15)),
                          inputFormatters: [
                            formatter,
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: ShopColors.primaryColor, width: 2),
                            borderRadius: BorderRadius.circular(20)),
                        child: DropdownButtonFormField(
                          dropdownColor: Colors.black,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              hintStyle: TextStyle(color: Colors.white),
                              border: InputBorder.none,
                              enabled: false,
                              fillColor: Colors.transparent,
                              filled: true),
                          hint: Text(
                            'Select Category',
                            style: theme.textTheme.bodyText2,
                          ),
                          value: _selectedCategory,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedCategory = newValue as ProductCategory;
                              categoryIndex = categoryList.indexOf(newValue);
                            });
                          },
                          items: categoryList.map((location) {
                            return DropdownMenuItem(
                              child: Text(
                                location.categoryName,
                                style: theme.textTheme
                                    .bodyText2, /* ,style: TextStyle(color: Colors.white), */
                              ),
                              value: location,
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Quantity', style: theme.textTheme.bodyText2),
                            CounterWidget(counterController: productQuantity)
                          ],
                        )),
                    Padding(
                      padding: EdgeInsets.only(top: height * 0.02),
                      child: Align(
                          alignment: Alignment(0, 0),
                          child: Text('Attach Image',
                              style: theme.textTheme.bodyText2)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Align(
                        alignment: Alignment(0, 0),
                        child: GestureDetector(
                          onTap: () {
                            _attachImage(context);
                          },
                          child: Container(
                            width: width * 0.45,
                            height: height * 0.25,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: ShopColors.primaryColor),
                            child: _image != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.file(
                                      _image!,
                                      width: width * 0.45,
                                      height: height * 0.25,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : (widget.toEdit)
                                    ? (widget.product!.imageb64 ?? "").isEmpty
                                        ? Container(
                                            height: height * 0.23,
                                            width: width * 0.4,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                color: Colors.white,
                                                boxShadow: [
                                                  const BoxShadow(
                                                      offset: Offset(2, 2),
                                                      color: Color.fromARGB(
                                                          31, 0, 0, 0),
                                                      blurRadius: 2,
                                                      spreadRadius: 1)
                                                ]),
                                            child: Center(
                                              child: Text(
                                                widget.product!.productName!
                                                    .substring(0, 2)
                                                    .toUpperCase(),
                                                style: theme
                                                    .textTheme.headline1!
                                                    .copyWith(
                                                        fontSize: 70,
                                                        color:
                                                            theme.primaryColor),
                                              ),
                                            ))
                                        : ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: Image.memory(
                                              base64Decode(
                                                  widget.product!.imageb64!),
                                              width: width * 0.45,
                                              height: height * 0.25,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                    : Container(
                                        decoration: BoxDecoration(
                                          //color: Colors.grey[200],
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        width: width * 0.45,
                                        height: height * 0.25,
                                        child: Icon(
                                          Icons.camera_alt,
                                          color: ShopColors.secondaryColor,
                                          size: 30,
                                        ),
                                      ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
              Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: _submitButton(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _attachImage(context) {
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
                        _imgFromGallery();
                        Navigator.pop(context);
                      },
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: height * 0.04,
                            backgroundColor: theme.primaryColorLight,
                            child: Icon(Icons.cloud_upload_outlined,
                                color: theme.primaryColor),
                          ),
                          SizedBox(height: height * 0.01),
                          Text('Upload', style: theme.textTheme.bodyText2)
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _imgFromCamera();
                        Navigator.pop(context);
                      },
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: height * 0.04,
                            backgroundColor: theme.primaryColorLight,
                            child: Icon(Icons.camera_alt,
                                color: theme.primaryColor),
                          ),
                          SizedBox(height: height * 0.01),
                          Text('Take Photo', style: theme.textTheme.bodyText2)
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
