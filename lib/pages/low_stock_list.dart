import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_manager/components/button.dart';
import 'package:shop_manager/components/notificationButton.dart';
import 'package:shop_manager/components/responsive.dart';
import 'package:shop_manager/components/textFields.dart';
import 'package:shop_manager/models/GeneralProvider.dart';
import 'package:shop_manager/models/ShopModel.dart';
import 'package:shop_manager/pages/widgets/clipPath.dart';
import 'package:shop_manager/pages/widgets/constants.dart';
import 'package:shop_manager/pages/widgets/counter.dart';
import 'package:shop_manager/pages/widgets/productCard.dart';

class LowStockList extends StatefulWidget {
  const LowStockList({Key? key}) : super(key: key);

  @override
  State<LowStockList> createState() => _LowStockListState();
}

class _LowStockListState extends State<LowStockList> {
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Responsive.isMobile()
            ? ClipPath(
                clipper: BottomClipper(),
                child: Container(
                  padding: EdgeInsets.only(
                      right: height * 0.02,
                      left: height * 0.02,
                      top: height * 0.05,
                      bottom: height * 0.07),
                  color: primaryColor,
                  child: HeaderSection(
                    height: height,
                    width: width,
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Low Stock Items",
                      textAlign: TextAlign.left,
                      style: headline1.copyWith(fontSize: 20),
                    ),
                    Row(
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
                  ],
                ),
              ),
        Expanded(
          child: LowStockGridList(),
        )
      ]),
    );
  }
}

class LowStockGridList extends StatefulWidget {
  const LowStockGridList({
    Key? key,
  }) : super(key: key);

  @override
  State<LowStockGridList> createState() => _LowStockGridListState();
}

class _LowStockGridListState extends State<LowStockGridList> {
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
  final productPrice = TextEditingController();
  final productCostPrice = TextEditingController();
  final productQuantity = TextEditingController();
  final lowStockQuantity = TextEditingController();
  bool isChecked = false;
   @override
  void initState() {
    context.read<GeneralProvider>().lowStocks.forEach((element) {
      lowStockQuantity.text = element.lowStockQuantity.toString();
      productCostPrice.text = element.costPrice.toString();
      productPrice.text = element.sellingPrice.toString();
      productQuantity.text = element.productQuantity.toString();
      isChecked = element.isLowStock;
      // if (element.productQuantity > element.lowStockQuantity) {
      //   context.read<GeneralProvider>().removeLowStock(element);
      // }
    });
    
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return context.watch<GeneralProvider>().lowStocks.isEmpty
        ? Center(
            child: Text(
              'No Low Stock Products',
              style: headline1.copyWith(fontSize: 25, color: Colors.blueGrey),
            ),
          )
        : GridView.count(
          padding: EdgeInsets.symmetric(horizontal: 15),
            physics: const BouncingScrollPhysics(),
            crossAxisCount: Responsive.isMobile() ? 3 : 6,
            childAspectRatio: 2 / 3.5,
            children: List.generate(
                context.watch<GeneralProvider>().lowStocks.length,
                (index) => ProductCard(
                  onTap: ()=>_editProduct(context, index),
                      index: index,
                      image64: context.read<GeneralProvider>().lowStocks[index].productImage ?? "",
                      price:
                          "GHS ${context.read<GeneralProvider>().lowStocks[index].sellingPrice.toStringAsFixed(2)}",
                      productName: context
                              .read<GeneralProvider>()
                              .lowStocks[index]
                              .productName ??
                          "",
                      quantity:
                          "${context.read<GeneralProvider>().lowStocks[index].productQuantity}",
                    )),
          );
  }

 
    _editProduct(context, int index) {
    return showDialog<bool>(
        context: context,
        builder: (c) => StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                backgroundColor: primaryColorLight,
                insetPadding: EdgeInsets.symmetric(horizontal: 20),
                //contentPadding: EdgeInsets.zero,
                //clipBehavior: Clip.antiAliasWithSaveLayer,
                title: Text(
                  "Update Product",
                  textAlign: TextAlign.center,
                  style: headline1,
                ),
                content: SizedBox(
                  width: Responsive.isTablet()? width * 0.4:width*0.8,
                  height: height * 0.5,
                  child: SingleChildScrollView(
                    child: Column(
                                children: [
                                  AmountTextField(
                    prefixIcon: Icon(Icons.money, color: Colors.grey),
                    hintText: "Selling Price",
                    borderColor: Colors.grey,
                    controller: productPrice,
                    style: bodyText1,
                    hintColor: Colors.grey,
                    inputFormatters: formatter,
                                  ),
                                  SizedBox(height: 10),
                                  AmountTextField(
                    prefixIcon: Icon(Icons.money, color: Colors.grey),
                    hintText: "Cost Price",
                    borderColor: Colors.grey,
                    controller: productCostPrice,
                    style: bodyText1,
                    hintColor: Colors.grey,
                    inputFormatters: formatter2,
                                  ),
                                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Quantity', style: bodyText1),
                          SizedBox(height: height * 0.02),
                          CounterWidget(
                              borderColor: Colors.grey,
                              style: bodyText1,
                              counterController: productQuantity)
                        ],
                      )),
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
                      style: bodyText1.copyWith(color: Colors.grey)),
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
                          SizedBox(height:20),
                         
                                ],
                              ),
                  ),
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
                          textColor: Colors.grey,
                          color: Colors.white,
                          buttonText: 'Cancel',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Button(
                          verticalPadding: 20,
                          borderRadius: 10,
                          color: actionColor,
                          width: width * 0.2,
                          buttonText: "Done",
                          onTap: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                            Product product = Product(
                            pid: context.read<GeneralProvider>().lowStocks[index].pid,
                            productName: context.read<GeneralProvider>().lowStocks[index].productName,
                            sellingPrice: double.tryParse(formatter
                                    .getUnformattedValue()
                                    .toString()) ??
                                0,
                            productDescription: context.read<GeneralProvider>().lowStocks[index].productDescription,
                            costPrice: double.tryParse(formatter2
                                    .getUnformattedValue()
                                    .toString()) ??
                                0,
                            productQuantity:
                               int.tryParse(productQuantity.text) ?? 0,
                            lowStockQuantity:
                                int.tryParse(lowStockQuantity.text) ?? 0,
                            productImage: context.read<GeneralProvider>().lowStocks[index].productImage,
                            isLowStock: isChecked,
                            productCategory: ProductCategory(
                                cid: context.read<GeneralProvider>().lowStocks[index].productCategory!.cid,
                                categoryName: context.read<GeneralProvider>().lowStocks[index].productCategory!.categoryName,
                                categoryDescription: context.read<GeneralProvider>().lowStocks[index].productCategory!.categoryDescription),
                          );

                          Provider.of<GeneralProvider>(context, listen: false)
                              .editProduct(product);

                            Provider.of<GeneralProvider>(context, listen: false)
                              .removeLowStock(product);

                            
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  )
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
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back, color: Colors.white)),
            Text(
              "Low Stock Basket",
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
        // Container(
        //   decoration: BoxDecoration(
        //       borderRadius: BorderRadius.circular(10),
        //       color: primaryColorLight),
        //   child: IconButton(
        //       onPressed: onPressed,
        //       icon: Icon(Icons.add, color: primaryColor)),
        // )
      ],
    );
  }
}
