// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:shop_manager/components/button.dart';
import 'package:shop_manager/components/notificationButton.dart';
import 'package:shop_manager/components/notifiers.dart';
import 'package:shop_manager/components/responsive.dart';
import 'package:shop_manager/components/textFields.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:shop_manager/config/size.dart';
import 'package:shop_manager/models/GeneralProvider.dart';
import 'package:shop_manager/models/ShopModel.dart';
import 'package:shop_manager/models/api_client.dart';
import 'package:shop_manager/pages/addProductSuccess.dart';
import 'package:shop_manager/pages/widgets/constants.dart';
import 'package:shop_manager/pages/widgets/counter.dart';
import 'package:shop_manager/utils/firebase_functions.dart';

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
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  String? shopName;
  LocalStorage storage = LocalStorage('shop_mate');

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
  Uint8List imageFile = Uint8List(0);
  //String imagePath;
  bool isLoading = false;
  final picker = ImagePicker();

  int categoryIndex = 0;
  getRemoveImage(String imgPath) async {
    imageFile = await ApiClient().removeBgApi(imgPath);
    isLoading = false;
    setState(() {});
  }

  Future _imgFromCamera() async {
    try {
      // imageFile = Uint8List(0);
      final image =
          await picker.pickImage(source: ImageSource.camera, imageQuality: 50);
      // final toBytes = await
      setState(() {
        isLoading = true;
        _image = File(image!.path);
        getRemoveImage(image.path);

        imageString = base64Encode(File(image.path).readAsBytesSync());
      });
    } catch (e) {}
  }

  _imgFromGallery() async {
    try {
      // imageFile = Uint8List(0);
      final image =
          await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
      setState(() {
        isLoading = true;
        _image = File(image!.path);
        getRemoveImage(image.path);
        imageString = base64Encode(File(image.path).readAsBytesSync());
      });
      //isLoading = false;
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
    setState(() {});
  }

  Future exportProduct(Product product) async {
    String customId = productName.text;
    await fireStore.collection(shopName ?? "").doc(customId).set({
      'product id': product.pid,
      'product name': product.productName,
      'product description': product.productDescription,
      'product image': product.productImage,
      'selling price': product.sellingPrice,
      'cost price': product.costPrice,
      //'product category': product.productCategory,
      'product quantity': product.productQuantity,
      'low stock quantity': product.lowStockQuantity,
      'low stock': product.isLowStock,
    });
  }

  void successDialog() async {
    return await showDialog(
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
                          textAlign: TextAlign.center, style: bodyText1)
                    ]),
              ),
            ));
  }

  Future getShopName() async {
    shopName = auth.currentUser!.displayName;
  }

  @override
  void initState() {
    getShopName();
    categoryList = List.from(
        Provider.of<GeneralProvider>(context, listen: false).categories);
    _selectedCategory = (categoryList.isEmpty) ? null : categoryList.first;
    if (widget.toEdit) {
      setState(() {
        productName.text = widget.product!.productName!;
        productDescription.text = widget.product!.productDescription!;
        lowStockQuantity.text = widget.product!.lowStockQuantity.toString();
        productPrice.text =
            formatter.format(widget.product!.sellingPrice.toStringAsFixed(2));
        productCostPrice.text =
            formatter2.format(widget.product!.costPrice.toStringAsFixed(2));
        productQuantity.text = widget.product!.productQuantity.toString();
        imageString = (widget.product!.productImage ?? "").isEmpty
            ? ""
            : widget.product!.productImage!;
        _selectedCategory = Provider.of<GeneralProvider>(context, listen: false)
            .categories
            .singleWhere((element) =>
                element.cid == widget.product!.productCategory!.cid);
        isChecked = widget.product!.isLowStock;
        imageFile =
            imageString.isNotEmpty ? base64Decode(imageString) : Uint8List(0);
      });

      log((widget.product!.productImage ?? "").isEmpty.toString());
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: primaryColorLight,
      appBar: AppBar(
        // iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          (widget.toEdit) ? "Edit Product" : "Add Product",
          style: Responsive.isTablet() ? headline1 : headline2,
        ),
        centerTitle: Responsive.isTablet() ? false : true,
        elevation: 0,
        backgroundColor:
            Responsive.isTablet() ? primaryColorLight : primaryColor,
        actions: [
          Responsive.isTablet()
              ? Row(
                  children: [
                    const NotificationIconButton(quantity: 1),
                    SizedBox(
                      width: width * 0.01,
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.account_circle_outlined,
                        size: 35,
                        color: primaryColor,
                      ),
                    ),
                  ],
                )
              : Container()
        ],
      ),
      body: SizedBox(
        height: height,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30, bottom: 20),
                  child: Text(
                      (widget.toEdit)
                          ? "Edit Product Detail"
                          : "Let's add the products in your shop",
                      style: headline1.copyWith(color: primaryColor)),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: CustomTextField(
                      prefixIcon: Icon(Icons.add_box, color: Colors.grey),
                      hintText: "Product name",
                      borderColor: Colors.grey,
                      controller: productName,
                      style: bodyText1,
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
                          style: bodyText1,
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
                          style: bodyText1,
                          hintColor: Colors.grey,
                          inputFormatters: formatter2,
                        ),
                      ),
                    ],
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
                      style: bodyText1,
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
                                color: imageFile.isNotEmpty
                                    ? Colors.white
                                    : Colors.grey),
                            child: imageFile.isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.memory(
                                      imageFile,
                                      width: width * 0.45,
                                      height: height * 0.25,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                // : (widget.toEdit)
                                //     ? (widget.product!.productImage ?? "")
                                //             .isEmpty
                                //         ? Container(
                                //             height: height * 0.23,
                                //             width: width * 0.4,
                                //             decoration: BoxDecoration(
                                //                 borderRadius:
                                //                     BorderRadius.circular(20.0),
                                //                 color: Colors.white,
                                //                 boxShadow: [
                                //                   const BoxShadow(
                                //                       offset: Offset(2, 2),
                                //                       color: Color.fromARGB(
                                //                           31, 0, 0, 0),
                                //                       blurRadius: 2,
                                //                       spreadRadius: 1)
                                //                 ]),
                                //             child: Center(
                                //               child: Text(
                                //                 widget.product!.productName!
                                //                     .substring(0, 2)
                                //                     .toUpperCase(),
                                //                 style: headline2.copyWith(
                                //                     fontSize: 70,
                                //                     color: primaryColorLight),
                                //               ),
                                //             ))
                                //         : ClipRRect(
                                //             borderRadius:
                                //                 BorderRadius.circular(20),
                                //             child: Image.memory(
                                //               base64Decode(widget
                                //                   .product!.productImage!),
                                //               width: width * 0.45,
                                //               height: height * 0.25,
                                //               fit: BoxFit.cover,
                                //             ),
                                //           )
                                : isLoading
                                    ? Center(
                                        child: CircularProgressIndicator(
                                        color: primaryColorLight,
                                      ))
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
                                          color: primaryColorLight,
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Quantity', style: bodyText1),
                                      SizedBox(height: height * 0.02),
                                      CounterWidget(
                                          borderColor: Colors.grey,
                                          style: bodyText1,
                                          counterController: productQuantity)
                                    ],
                                  )),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Checkbox(
                                          value: isChecked,
                                          activeColor: actionColor,
                                          onChanged: (val) {
                                            setState(() {
                                              isChecked = val ?? false;
                                            });
                                          }),
                                      //SizedBox(width:width*0.03),
                                      Text('Low Stock Alert', style: bodyText1),
                                    ],
                                  ),
                                  Text(
                                      'Check if you want to receive alerts when this stock is running out',
                                      style: bodyText1.copyWith(
                                          color: Colors.grey)),
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
                          Text('Low Stock Quantity', style: bodyText1),
                          SizedBox(width: width * 0.03),
                          CounterWidget(
                              borderColor: Colors.grey,
                              style: bodyText1,
                              counterController: lowStockQuantity),
                        ],
                      ),
                SizedBox(height: height * 0.05),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Button(
                    width: width,
                    color: primaryColor,
                    buttonText: 'Done',
                    onTap: () async {
                      // log(formatter.getUnformattedValue().toString());
                      // log(productPrice.text);
                      imageString = base64Encode(imageFile);
                      if (widget.toEdit) {
                        Product product = Product(
                          pid: widget.product!.pid,
                          productName: productName.text,
                          sellingPrice: double.tryParse(formatter
                                  .getUnformattedValue()
                                  .toStringAsFixed(2)) ??
                              0,
                          productDescription: productDescription.text,
                          costPrice: double.tryParse(formatter2
                                  .getUnformattedValue()
                                  .toStringAsFixed(2)) ??
                              0,
                          productQuantity:
                              int.tryParse(productQuantity.text) ?? 0,
                          lowStockQuantity:
                              int.tryParse(lowStockQuantity.text) ?? 0,
                          productImage: imageString,
                          isLowStock: isChecked,
                          productCategory: ProductCategory(
                              cid: widget.product!.productCategory!.cid,
                              categoryName:
                                  widget.product!.productCategory!.categoryName,
                              categoryDescription: widget.product!
                                  .productCategory!.categoryDescription),
                        );

                         
                        Provider.of<GeneralProvider>(context, listen: false)
                            .editProduct(product);

                        FirebaseFunction().updateProduct(
                            context, product, productName.text, shopName);

                        // .inventory
                        //   .singleWhere(
                        //       (element) => element == widget.product)
                        // ..quantity = product.quantity
                        // ..sellingPrice = product.sellingPrice
                        // ..itemcategory = product.itemcategory
                        // ..costPrice = product.costPrice
                        // ..imageb64 = product.imageb64;
                      } else if (productName.text.isEmpty ||
                          double.tryParse(
                                  formatter.getUnformattedValue().toString()) ==
                              0 ||
                          double.tryParse(formatter2
                                  .getUnformattedValue()
                                  .toString()) ==
                              0 ||
                          ((int.tryParse(productQuantity.text) ?? 0) == 0 ||
                              productQuantity.text.isEmpty)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              backgroundColor:
                                  const Color.fromARGB(255, 255, 17, 1),
                              content: Text('Field Required',
                                  textAlign: TextAlign.center,
                                  style: bodyText2),
                              duration: const Duration(milliseconds: 1500),
                              behavior: SnackBarBehavior.floating,
                              shape: const StadiumBorder()),
                        );

                        return;
                      } else if (!(Provider.of<GeneralProvider>(context,
                              listen: false)
                          .inventory
                          .any((element) =>
                              element.productName == productName.text))) {
                        Product product = Product(
                            pid: context.read<GeneralProvider>().generateUID(),
                            productName: productName.text,
                            productDescription: productDescription.text,
                            sellingPrice: double.tryParse(
                                    formatter
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
                        Provider.of<GeneralProvider>(context, listen: false)
                                .shop
                                .products =
                            Provider.of<GeneralProvider>(context, listen: false)
                                .inventory;

                        await storage.setItem(
                            shopName!,
                            shopProductsToJson(Provider.of<GeneralProvider>(
                                    context,
                                    listen: false)
                                .shop));
                        exportProduct(product);
                        // FirebaseFunction()
                        //     .addProducts(product, productName.text, shopName);
                      } else {
                        Notifier().toast(
                            context: context,
                            message: "ERROR PRODUCT ALREADY EXIST!",
                            color: Colors.red);
                        return;
                      }
                      successDialog();
                      productCostPrice.clear();
                      productName.clear();
                      productPrice.clear();
                      productDescription.clear();
                      productQuantity.clear();
                      lowStockQuantity.clear();
                      imageFile = Uint8List(0);
                      startTime();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _attachImage(context) {
    double height = MediaQuery.of(context).size.height;
    showModalBottomSheet(
        backgroundColor: primaryColorLight,
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
                        imageFile = Uint8List(0);
                        _imgFromGallery();

                        Navigator.pop(context);
                      },
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: height * 0.04,
                            backgroundColor: primaryColor,
                            child: Icon(Icons.cloud_upload_outlined,
                                color: primaryColorLight),
                          ),
                          SizedBox(height: height * 0.01),
                          Text('Upload', style: bodyText1)
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        imageFile = Uint8List(0);
                        _imgFromCamera();

                        Navigator.pop(context);
                      },
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: height * 0.04,
                            backgroundColor: primaryColor,
                            child: Icon(Icons.camera_alt,
                                color: primaryColorLight),
                          ),
                          SizedBox(height: height * 0.01),
                          Text('Take Photo', style: bodyText1)
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
