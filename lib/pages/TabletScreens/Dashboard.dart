import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:shop_manager/components/button.dart';
import 'package:shop_manager/components/notificationButton.dart';
import 'package:shop_manager/components/notifiers.dart';
import 'package:shop_manager/components/responsive.dart';
import 'package:shop_manager/components/textFields.dart';
import 'package:shop_manager/models/AccountProvider.dart';
import 'package:shop_manager/models/FirebaseApplicationState.dart';
import 'package:shop_manager/models/GeneralProvider.dart';
import 'package:shop_manager/models/NotificationModel.dart';
import 'package:shop_manager/models/NotificationProvider.dart';
import 'package:shop_manager/models/ShopModel.dart';
import 'package:shop_manager/models/api_client.dart';
import 'package:shop_manager/pages/TabletScreens/widgets.dart/sideMenu.dart';
import 'package:shop_manager/pages/addproduct.dart';
import 'package:shop_manager/pages/dashboard.dart';
import 'package:shop_manager/pages/productCalculator.dart';
import 'package:shop_manager/pages/widgets/barChart.dart';
import 'package:shop_manager/pages/widgets/constants.dart';
import 'package:shop_manager/pages/widgets/counter.dart';
import 'package:shop_manager/pages/widgets/itemGraph.dart';

class TabletDashboard extends StatefulWidget {
  const TabletDashboard({Key? key}) : super(key: key);

  @override
  State<TabletDashboard> createState() => _TabletDashboardState();
}

class _TabletDashboardState extends State<TabletDashboard> {
  int count = 0;
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

  // late Box shopBox;
  // ProductCategory? _selectedCategory;
  String imageString = '';
  // List<ProductCategory> categoryList = [];
  Uint8List imageFile = Uint8List(0);
  //String imagePath;
  bool isLoading = false;
  final picker = ImagePicker();
  LocalStorage storage = LocalStorage('shop_mate');

  int categoryIndex = 0;
  getRemoveImage(String imgPath) async {
    imageFile = await ApiClient().removeBgApi(imgPath);
    bool isLoading = false;
    setState(() {});
  }

  Future _imgFromCamera() async {
    try {
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
      final image =
          await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
      setState(() {
        isLoading = true;
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
                          textAlign: TextAlign.center, style: bodyText1)
                    ]),
              ),
            ));
  }

  @override
  void initState() {
    // categoryList = List.from(
    //     Provider.of<GeneralProvider>(context, listen: false).categories);
    //_selectedCategory = (categoryList.isEmpty) ? null : categoryList.first;
     Provider.of<GeneralProvider>(context, listen: false).inventory =
        Provider.of<GeneralProvider>(context, listen: false).shop.products;
    Provider.of<SalesProvider>(context, listen: false).expenseList =
        Provider.of<GeneralProvider>(context, listen: false).shop.expenses;
    Provider.of<GeneralProvider>(context, listen: false).lowStocks =
        Provider.of<GeneralProvider>(context, listen: false).shop.lowStocks;
    Provider.of<SalesProvider>(context, listen: false).salesList =
        Provider.of<GeneralProvider>(context, listen: false).shop.sales;
    Provider.of<NotificationProvider>(context, listen: false).notiList =
        notificationModelFromJson(storage.getItem('notification') ?? '[]');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: count != 0
          ? Container()
          : FloatingActionButton(
              onPressed: () => _addProduct(context),
              backgroundColor: primaryColor,
              child: Icon(Icons.add, color: Colors.white),
            ),
      // backgroundColor: primaryColor,
      body: SafeArea(
        child: Row(
          children: [
            SideMenu(
              indx: (menuIndex) {
                setState(() {
                  count = menuIndex;
                });
              },
            ),
            //SizedBox(width: width*0.05,),
            Expanded(
              flex: count == 4 ? 2 : 1,
              child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 600),
                  child: sideMenuItems[count]),
            ),
            count == 4
                ? Expanded(
                    child: Container(
                        height: height,
                        color: Color.fromARGB(255, 243, 243, 243),
                        child: ProductCalculator()))
                : Container()
          ],
        ),
      ),
    );
  }

  _addProduct(context) {
    return showDialog<bool>(
        context: context,
        builder: (c) => StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                insetPadding: EdgeInsets.zero,
                //contentPadding: EdgeInsets.zero,
                //clipBehavior: Clip.antiAliasWithSaveLayer,
                title: const Text("Add Products"),
                content: SizedBox(
                  width: width * 0.6,
                  height: height * 0.8,
                  child: SingleChildScrollView(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 30, bottom: 20),
                          child: Text("Let's add the products in your shop",
                              style: headline1.copyWith(color: primaryColor)),
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: CustomTextField(
                              prefixIcon:
                                  Icon(Icons.add_box, color: Colors.grey),
                              hintText: "Product name",
                              borderColor: Colors.grey,
                              controller: productName,
                              style: bodyText1,
                              hintColor: Colors.grey,
                            )),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: AmountTextField(
                                  prefixIcon:
                                      Icon(Icons.money, color: Colors.grey),
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
                                  prefixIcon:
                                      Icon(Icons.money, color: Colors.grey),
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
                            padding: const EdgeInsets.symmetric(vertical: 10),
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
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Align(
                            alignment: Alignment(0, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        //_attachImage(context);
                                      },
                                      child: Container(
                                        width: width * 0.2,
                                        height: height * 0.3,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: imageFile.isNotEmpty
                                                ? Colors.white
                                                : Colors.grey),
                                        child: imageFile.isNotEmpty
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: Image.memory(
                                                  imageFile,
                                                  width: width * 0.2,
                                                  height: height * 0.3,
                                                  fit: BoxFit.cover,
                                                ),
                                              )
                                            : isLoading
                                                ? Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                    color: primaryColorLight,
                                                  ))
                                                : Container(
                                                    decoration: BoxDecoration(
                                                      //color: Colors.grey[200],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    width: width * 0.2,
                                                    height: height * 0.3,
                                                    child: Icon(
                                                      Icons.image,
                                                      color: primaryColorLight,
                                                      size: 30,
                                                    ),
                                                  ),
                                      ),
                                    ),
                                    const SizedBox(height: 7),
                                    //imageFile.isEmpty?Container():
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CircleAvatar(
                                            backgroundColor: Colors.grey,
                                            child: IconButton(
                                                onPressed: () {
                                                  imageFile = Uint8List(0);
                                                  _imgFromCamera();
                                                },
                                                icon: Icon(Icons.camera_alt,
                                                    color: Colors.white))),
                                        const SizedBox(width: 20),
                                        CircleAvatar(
                                            backgroundColor: Colors.grey,
                                            child: IconButton(
                                                onPressed: () {
                                                  imageFile = Uint8List(0);
                                                  _imgFromGallery();
                                                },
                                                icon: Icon(
                                                    Icons.drive_folder_upload,
                                                    color: Colors.white))),
                                        const SizedBox(width: 20),
                                        CircleAvatar(
                                            backgroundColor: imageFile.isEmpty
                                                ? Colors.grey
                                                : Colors.red,
                                            child: IconButton(
                                                onPressed: () {
                                                  if (imageFile.isNotEmpty) {
                                                    imageFile = Uint8List(0);
                                                  }
                                                },
                                                icon: Icon(Icons.delete_outline,
                                                    color: Colors.white))),
                                      ],
                                    )
                                  ],
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
                                                  style: bodyText1),
                                              SizedBox(height: height * 0.02),
                                              CounterWidget(
                                                  borderColor: Colors.grey,
                                                  style: bodyText1,
                                                  counterController:
                                                      productQuantity)
                                            ],
                                          )),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                                  style: bodyText1),
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
                      ],
                    ),
                  )),
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Button(
                          verticalPadding: 20,
                          borderRadius: 10,
                          onTap: () {
                            Navigator.pop(context);
                          },
                          width: width * 0.2,
                          color: Colors.white,
                          buttonText: 'Cancel',
                          textColor: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Button(
                          verticalPadding: 20,
                          borderRadius: 10,
                          width: width * 0.2,
                          color: primaryColor,
                          buttonText: 'Done',
                          onTap: () async {
                            // log(formatter.getUnformattedValue().toString());
                            // log(productPrice.text);
                            imageString = base64Encode(imageFile);

                            if (!(Provider.of<GeneralProvider>(context,
                                    listen: false)
                                .inventory
                                .any((element) =>
                                    element.productName == productName.text))) {
                              Product product = Product(
                                  pid:context.read<GeneralProvider>().generateUID(),
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
                               /*  ??
                                      ProductCategory(
                                          cid: 0,
                                          categoryName: 'Uncategorised',
                                          categoryDescription:
                                              'No Description') */
                                  
                                  isLowStock: isChecked,
                                  productQuantity:
                                      int.tryParse(productQuantity.text) ?? 0,
                                  lowStockQuantity:
                                      int.tryParse(lowStockQuantity.text) ?? 0,
                                  // sellingPrice:
                                  //     double.tryParse(productPrice.text) ?? 0,
                                  productImage: imageString);

                              Provider.of<GeneralProvider>(context,
                                      listen: false)
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

                            successDialog();
                            productCostPrice.clear();
                            productName.clear();
                            productPrice.clear();
                            productDescription.clear();
                            productQuantity.clear();
                            lowStockQuantity.clear();
                            imageFile = Uint8List(0);
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
                  )
                ],
              );
            }));
  }

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
}

class TabletHomeScreen extends StatefulWidget {
  const TabletHomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<TabletHomeScreen> createState() => _TabletHomeScreenState();
}

class _TabletHomeScreenState extends State<TabletHomeScreen> {
  double totalSales = 0.0;
  double totalProfit = 0.0;
  @override
  Widget build(BuildContext context) {
    totalSales = 0.0;
    totalProfit = 0.0;
    context.watch<SalesProvider>().salesList.forEach((element) {
      element.products.forEach((item) {
        totalSales += item.sellingPrice * item.cartQuantity;
        totalProfit += (item.sellingPrice - item.costPrice) * item.cartQuantity;
      });
    });
List<Map<String, dynamic>> statusList = [
  {'status': 'GHS ${totalSales.toStringAsFixed(2)}', 'label': 'Total Sales', 'icon': Icons.monetization_on},
  {'status': 'GHS 1.2K', 'label': 'Total Expenses', 'icon': Icons.auto_graph},
  {'status': '${context.watch<GeneralProvider>().lowStocks.length}', 'label': 'Low Stock', 'icon': Icons.arrow_circle_down},
  {'status': '${context.watch<GeneralProvider>().inventory.length}', 'label': 'Total Stock', 'icon': Icons.inventory},
];
    return Padding(
      padding: EdgeInsets.all(width * 0.02),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const NotificationIconButton(quantity: 1),
                SizedBox(
                  width: width * 0.01,
                ),
                IconButton(
                  onPressed: () {
                    ApplicationState().signOut();
                  },
                  icon: Icon(
                    Icons.account_circle_outlined,
                    size: 35,
                    color: primaryColor,
                  ),
                )
              ],
            ),
            SizedBox(height: height * 0.03),
            Expanded(
              // height: height*0.8,
              child: ListView(
                physics: BouncingScrollPhysics(),
                //shrinkWrap: true,
                children: [
                  GridView.count(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      crossAxisCount: 4,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1.8,
                      children: List.generate(
                        statusList.length,
                        (index) => ItemStatus(
                          textColor: primaryColorLight,
                          status: statusList[index]['status'],
                          label: statusList[index]['label'],
                          icon: statusList[index]['icon'],
                          menuColor: primaryColor,
                          iconColor: primaryColorLight,
                        ),
                      )),
                  SizedBox(height: height * 0.03),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                              //height: height * 0.4,
                              width: width * 0.45,
                              child: Container(
                                  padding: const EdgeInsets.all(10),
                                  //height: height * 0.25,
                                  width: width,
                                  decoration: BoxDecoration(
                                      color: Responsive.isMobile()
                                          ? primaryColor
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: const [
                                        BoxShadow(
                                            offset: Offset(0, 1),
                                            color: Color.fromARGB(
                                                255, 219, 219, 233),
                                            blurRadius: 2,
                                            spreadRadius: 1),
                                      ]),
                                  child: const ItemGraph())),
                          const SizedBox(height: 20),
                          SizedBox(
                              height: height * 0.4,
                              width: width * 0.45,
                              child: const ShopBarChart()),
                        ],
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Container(
                            padding: const EdgeInsets.all(10),
                            // height: height * 0.7,
                            decoration: BoxDecoration(
                                color: Responsive.isMobile()
                                    ? primaryColor
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [
                                  BoxShadow(
                                      offset: Offset(0, 1),
                                      color: Color.fromARGB(255, 239, 240, 245),
                                      blurRadius: 2,
                                      spreadRadius: 1),
                                ]),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Top Products',
                                  style: headline1,
                                ),
                                Divider(
                                    height: height * 0.05, color: Colors.grey),
                                ListView(
                                  shrinkWrap: true,
                                  children: List.generate(
                                      7,
                                      (index) => Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 10),
                                            child: ListTile(
                                              leading: const CircleAvatar(
                                                backgroundColor: Color.fromARGB(
                                                    255, 228, 228, 228),
                                                child: Icon(
                                                  Icons.shopping_bag,
                                                  size: 17,
                                                  color: Colors.blueGrey,
                                                ),
                                              ),
                                              title: Text(
                                                'Product Name',
                                                style: bodyText1,
                                              ),
                                              subtitle: Text(
                                                '30 sold out',
                                                style: bodyText1.copyWith(
                                                    fontSize: 14,
                                                    color: Colors.grey),
                                              ),
                                              trailing: Text(
                                                'GHS 350.00',
                                                style: bodyText1.copyWith(
                                                    fontSize: 15),
                                              ),
                                            ),
                                          )),
                                )
                              ],
                            )),
                      )
                    ],
                  ),
                ],
              ),
            )
          ]),
    );
  }
}
