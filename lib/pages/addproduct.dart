// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:shop_manager/components/button.dart';
import 'package:shop_manager/components/notifiers.dart';
import 'package:shop_manager/components/textFields.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:shop_manager/models/GeneralProvider.dart';
import 'package:shop_manager/models/ShopModel.dart';
import 'package:shop_manager/models/api_client.dart';
import 'package:shop_manager/pages/addProductSuccess.dart';
import 'package:shop_manager/pages/widgets/constants.dart';
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
  final CurrencyTextInputFormatter formatter2 = CurrencyTextInputFormatter(
      turnOffGrouping: true,
      decimalDigits: 2,
      // locale: 'usa',
      symbol: 'GHS ');

  final productName = TextEditingController();
  final productDescription = TextEditingController();
  final productPrice = TextEditingController();
  final productCostPrice = TextEditingController();
  final productCategory = TextEditingController();
  final productQuantity = TextEditingController();
  final lowStockQuantity = TextEditingController();
  File? _image;

  @override
  void dispose() {
    productName.dispose();
    productDescription.dispose();
    productPrice.dispose();
    productCostPrice.dispose();
    productCategory.dispose();
    productQuantity.dispose();
    lowStockQuantity.dispose();
    super.dispose();
  }

  // late Box shopBox;
  ProductCategory? _selectedCategory;
  String imageString = '';
  List<ProductCategory> categoryList = [];
  Uint8List? imageFile;
  //String imagePath;
  final picker = ImagePicker();

  int categoryIndex = 0;
  getRemoveImage(String imgPath) async {
    imageFile = await ApiClient().removeBgApi(imgPath);
    setState(() {});
  }

  Future _imgFromCamera() async {
    try {
      final image =
          await picker.pickImage(source: ImageSource.camera, imageQuality: 50);
      // final toBytes = await
      setState(() {
        _image = File(image!.path);
        getRemoveImage(image.path);

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
        getRemoveImage(image.path);
        imageString = base64Encode(File(image.path).readAsBytesSync());
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  bool isChecked = false;

  // var productBox = Hive.box<Product>('Product');
  // var categoryBox = Hive.box<ProductCategory>('Category');
  startTime() async {
    var _duration = const Duration(seconds: 2);
    return Timer(_duration, navigationDialog);
  }

  void navigationDialog() {
    Navigator.pop(context);
  }

  void successDialog() {
    var theme = Theme.of(context);
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => AlertDialog(
              content: Container(
                width: width * 0.4,
                height: height * 0.25,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/confetti-gif-2.gif"),
                        fit: BoxFit.cover)),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Color.fromARGB(255, 0, 184, 6),
                        child: const Icon(Icons.check,
                            color: Colors.white, size: 50),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text('Product added successfully',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyText1)
                    ]),
              ),
            ));
  }

  @override
  void initState() {
    categoryList = List.from(
        Provider.of<GeneralProvider>(context, listen: false).categories);
    _selectedCategory = categoryList.first;
    if (widget.toEdit) {
      productName.text = widget.product!.productName!;
      productPrice.text =
          formatter.format(widget.product!.sellingPrice.toString());
      productCostPrice.text =
          formatter2.format(widget.product!.costPrice.toString());
      productQuantity.text = widget.product!.productQuantity.toString();
      imageString = (widget.product!.productImage ?? "").isEmpty
          ? ""
          : widget.product!.productImage!;
      _selectedCategory = Provider.of<GeneralProvider>(context, listen: false)
          .categories
          .singleWhere(
              (element) => element.cid == widget.product!.productCategory!.cid);
      isChecked = widget.product!.isLowStock;
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
      backgroundColor: primaryColorLight,
      appBar: AppBar(
        // iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          (widget.toEdit) ? "Edit Product" : "Add Product",
          style: theme.textTheme.headline2,
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: primaryColor,
      ),
      body: SizedBox(
        height: height,
        child: Stack(
          children: [
            SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30, bottom: 20),
                    child: Text(
                        (widget.toEdit)
                            ? "Edit Product Detail"
                            : "Let's add the products in your shop",
                        style: theme.textTheme.headline1!
                            .copyWith(color: theme.primaryColor)),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: CustomTextField(
                        prefixIcon: Icon(Icons.add_box, color: Colors.grey),
                        hintText: "Product name",
                        borderColor: Colors.grey,
                        controller: productName,
                        style: theme.textTheme.bodyText1,
                        hintColor: Colors.grey,
                      )),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      children: [
                        Expanded(
                          child: AmountTextField(
                            prefixIcon: Icon(Icons.money, color: Colors.grey),
                            hintText: "Selling Price",
                            borderColor: Colors.grey,
                            controller: productPrice,
                            style: theme.textTheme.bodyText1,
                            hintColor: Colors.grey,
                            inputFormatters: formatter,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: AmountTextField(
                            prefixIcon: Icon(Icons.money, color: Colors.grey),
                            hintText: "Cost Price",
                            borderColor: Colors.grey,
                            controller: productCostPrice,
                            style: theme.textTheme.bodyText1,
                            hintColor: Colors.grey,
                            inputFormatters: formatter2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(20)),
                      child: DropdownButtonFormField(
                        //dropdownColor: Colors.black,
                        style: theme.textTheme.bodyText1,
                        decoration: InputDecoration(
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                            enabled: false,
                            fillColor: Colors.transparent,
                            filled: true),
                        hint: Text(
                          'Select Category',
                          style: TextStyle(color: Colors.grey),
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
                              location.categoryName!,
                              style: theme.textTheme
                                  .bodyText1, /* ,style: TextStyle(color: Colors.white), */
                            ),
                            value: location,
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: CustomTextField(
                        maxLines: 5,
                        prefixIcon: Icon(Icons.edit, color: Colors.grey),
                        hintText: "Product Description",
                        borderColor: Colors.grey,
                        controller: productDescription,
                        style: theme.textTheme.bodyText1,
                        hintColor: Colors.grey,
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Align(
                      alignment: Alignment(0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _attachImage(context);
                            },
                            child: Container(
                              width: width * 0.45,
                              height: height * 0.25,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: imageFile != null
                                      ? Colors.white
                                      : Colors.grey),
                              child: imageFile != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.memory(
                                        imageFile!,
                                        width: width * 0.45,
                                        height: height * 0.25,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : (widget.toEdit)
                                      ? (widget.product!.productImage ?? "")
                                              .isEmpty
                                          ? Container(
                                              height: height * 0.23,
                                              width: width * 0.4,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  color: Colors.grey,
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
                                                      .textTheme.headline2!
                                                      .copyWith(
                                                          fontSize: 70,
                                                          color: theme
                                                              .primaryColorLight),
                                                ),
                                              ))
                                          : ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: Image.memory(
                                                base64Decode(widget
                                                    .product!.productImage!),
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
                                            color: theme.primaryColorLight,
                                            size: 30,
                                          ),
                                        ),
                            ),
                          ),
                          SizedBox(width: width * 0.05),
                          Expanded(
                            child: Column(
                              children: [
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Quantity',
                                            style: theme.textTheme.bodyText1),
                                        SizedBox(height: height * 0.02),
                                        CounterWidget(
                                            borderColor: Colors.grey,
                                            style: theme.textTheme.bodyText1,
                                            counterController: productQuantity)
                                      ],
                                    )),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Checkbox(
                                            value: isChecked,
                                            activeColor: primaryColor,
                                            onChanged: (val) {
                                              setState(() {
                                                isChecked = val ?? false;
                                              });
                                            }),
                                        //SizedBox(width:width*0.03),
                                        Text('Low Stock Alert',
                                            style: theme.textTheme.bodyText1),
                                      ],
                                    ),
                                    Text(
                                        'Check if you want to receive alerts when this stock is running out',
                                        style: theme.textTheme.bodyText1!
                                            .copyWith(color: Colors.grey)),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  !isChecked
                      ? Container()
                      : Row(
                          children: [
                            Text('Low Stock Quantity',
                                style: theme.textTheme.bodyText1),
                            SizedBox(width: width * 0.03),
                            CounterWidget(
                                borderColor: Colors.grey,
                                style: theme.textTheme.bodyText1,
                                counterController: lowStockQuantity),
                          ],
                        ),
                  SizedBox(height: height * 0.05),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Button(
                      width: width,
                      color: theme.primaryColor,
                      buttonText: 'Done',
                      onTap: () async {
                        // log(formatter.getUnformattedValue().toString());
                        // log(productPrice.text);
                        imageString = base64Encode(imageFile!);
                        if (widget.toEdit) {
                          Product product = Product(
                            pid: widget.product!.pid,
                            productName: productName.text,
                            sellingPrice: double.tryParse(formatter
                                    .getUnformattedValue()
                                    .toString()) ??
                                0,
                            productDescription: productDescription.text,
                            costPrice: double.tryParse(formatter2
                                    .getUnformattedValue()
                                    .toString()) ??
                                0,
                            productQuantity:
                                int.tryParse(productQuantity.text) ?? 0,
                            lowStockQuantity:
                                int.tryParse(lowStockQuantity.text) ?? 0,
                            productImage: imageString,
                            isLowStock: isChecked,
                            productCategory: ProductCategory(
                                cid: widget.product!.productCategory!.cid,
                                categoryName: widget
                                    .product!.productCategory!.categoryName,
                                categoryDescription: widget.product!
                                    .productCategory!.categoryDescription),
                          );

                          Provider.of<GeneralProvider>(context, listen: false)
                              .editProduct(product);
                          // .inventory
                          //   .singleWhere(
                          //       (element) => element == widget.product)
                          // ..quantity = product.quantity
                          // ..sellingPrice = product.sellingPrice
                          // ..itemcategory = product.itemcategory
                          // ..costPrice = product.costPrice
                          // ..imageb64 = product.imageb64;

                        } else {
                          if (!(Provider.of<GeneralProvider>(context,
                                  listen: false)
                              .inventory
                              .any((element) =>
                                  element.productName == productName.text))) {
                            Product product = Product(
                                pid: context
                                        .read<GeneralProvider>()
                                        .inventory
                                        .isEmpty
                                    ? 1
                                    : context
                                            .read<GeneralProvider>()
                                            .inventory
                                            .last
                                            .pid +
                                        1,
                                productName: productName.text,
                                productDescription: productDescription.text,
                                sellingPrice: double.tryParse(formatter
                                        .getUnformattedValue()
                                        .toString()) ??
                                    0,
                                costPrice: double.tryParse(formatter2
                                        .getUnformattedValue()
                                        .toString()) ??
                                    0,
                                productCategory:
                                    _selectedCategory /*  ??
                                      ProductCategory(
                                          cid: 0,
                                          categoryName: 'Uncategorised',
                                          categoryDescription:
                                              'No Description') */
                                ,
                                isLowStock: isChecked,
                                productQuantity:
                                    int.tryParse(productQuantity.text) ?? 0,
                                lowStockQuantity:
                                    int.tryParse(lowStockQuantity.text) ?? 0,
                                // sellingPrice:
                                //     double.tryParse(productPrice.text) ?? 0,
                                productImage: imageString);

                            Provider.of<GeneralProvider>(context, listen: false)
                                .addProduct(product);
                            // .inventory
                            // .add(product);

                            // await productBox.add(product);

                            // if (_selectedCategory?.categoryName.isNotEmpty ??
                            //     false) {
                            //   // Provider.of<GeneralProvider>(context,
                            //   //         listen: false)
                            //   //     .saveToCategory(_selectedCategory!);

                            //   // HiveFunctions()
                            //   //     .saveToCategory(_selectedCategory!);
                            // }
                          } else {
                            Notifier().toast(
                                context: context,
                                message: "ERROR PRODUCT ALREADY EXIST!",
                                color: Colors.red);
                            return;
                          }
                        }
                        successDialog();
                        productCostPrice.clear();
                        productName.clear();
                        productPrice.clear();
                        productDescription.clear();
                        productQuantity.clear();
                        lowStockQuantity.clear();
                        startTime();
                        // Navigator.pushReplacement(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) =>
                        //             const AddProductSuccess()));

                        //Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            )),
            // Positioned(
            //   bottom: 0,
            //   right: 0,
            //   left: 0,
            //   child: Container(
            //     color: theme.primaryColorLight,
            //     child: Padding(
            //       padding: const EdgeInsets.all(20),
            //       child: _submitButton(),
            //     ),
            //   ),
            // )
          ],
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
