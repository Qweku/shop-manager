 import 'package:flutter/material.dart';
import 'package:shop_manager/config/colors.dart';

class ProductCalculator extends StatefulWidget {
  const ProductCalculator({Key? key}) : super(key: key);

  @override
  _ProductCalculatorState createState() => _ProductCalculatorState();
}

class _ProductCalculatorState extends State<ProductCalculator> {
  final totalPrice = TextEditingController();
  final quantityItem = TextEditingController();
  bool items = false;
  double totalCost = 0.00;
  double itemPrice = 13.00;
  int quantity = 1;

  @override
  void dispose() {
    quantityItem.dispose();
    super.dispose();
  }

  // calculateTotal() {
  //   quantity = int.parse(quantityItem.text);
  //   totalCost = itemPrice * quantity;
  // }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ShopColors.secondaryColor,
      body: SafeArea(
        child: Container(
          height: height,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: height * 0.3,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 70),
                    child: Center(
                      child: Container(
                          height: 50,
                          decoration: BoxDecoration(),
                          child: Text(
                            "GHS " + "$totalCost",
                            style: TextStyle(
                                color: ShopColors.textColor, fontSize: 40),
                          )
                          //  TextField(
                          //   controller: totalPrice,
                          //   textAlign: TextAlign.center,
                          //   readOnly: true,
                          //   keyboardType: TextInputType.number,
                          //   style: TextStyle(
                          //       color: ShopColors.textColor, fontSize: 15),
                          //   decoration: InputDecoration(
                          //       hintText: "GHS 15.00",
                          //       border: InputBorder.none,
                          //       hintStyle: TextStyle(
                          //           color: ShopColors.textColor, fontSize: 40)),
                          //   inputFormatters: [
                          //     CurrencyTextInputFormatter(
                          //         decimalDigits: 2,
                          //         // locale: 'usa',
                          //         symbol: 'GHS '),
                          //   ],
                          // ),

                          ),
                    ),
                  ),
                ),
                Container(
                  
                    child: !items
                        ? GestureDetector(
                            onTap: () {
                              showDialog<bool>(
                                  context: context,
                                  builder: (c) => SimpleDialog(
                                        title: Text(
                                          "Product List",
                                          textAlign: TextAlign.center,
                                        ),
                                        children: [
                                          ListTile(
                                            onTap: () {
                                              setState(() {
                                                items = true;
                                                // quantity = int.parse(
                                                //     quantityItem.text);
                                                // // quantity = 1;
                                                // totalCost =
                                                //     itemPrice * quantity;
                                                //     totalCost.toStringAsFixed(2);

                                                Navigator.pop(context);
                                              });
                                            },
                                            leading: CircleAvatar(
                                              radius: 30,
                                              backgroundColor:
                                                  ShopColors.secondaryColor,
                                            ),
                                            title: Text("Product name",
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                            subtitle: Text("Quantity " + "30",
                                                style: TextStyle(fontSize: 17)),
                                            trailing:
                                                Text("GHS " + "$itemPrice",
                                                    style: TextStyle(
                                                      fontSize: 17,
                                                    )),
                                          )
                                        ],
                                      ));
                            },
                            child: ListTile(
                              
                              tileColor: ShopColors.primaryColor.withOpacity(0.6),
                              title:Center(child: Icon(Icons.add,size:30,color:ShopColors.textColor))
                            ))
                        : Container(
                            height: height * 0.6,
                          child: ListView(
                              padding: EdgeInsets.zero,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListTile(
                                      leading: CircleAvatar(
                                        radius: 30,
                                        backgroundColor: ShopColors.primaryColor,
                                      ),
                                      title: Text("Product name",
                                          style: TextStyle(
                                              fontSize: 17,
                                              color: ShopColors.textColor,
                                              fontWeight: FontWeight.w600)),
                                      trailing: Text("GHS " + "$itemPrice",
                                          style: TextStyle(
                                            fontSize: 17,
                                            color: ShopColors.textColor,
                                          )),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 20),
                                      child: Container(
                                        width: MediaQuery.of(context).size.width *
                                            0.6,
                                        height: 50,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: ShopColors.primaryColor,
                                                width: 2),
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: TextField(
                                           onChanged:(text){
                                             setState(() {
                                                     quantity = int.parse(
                                                      quantityItem.text.trim());
                                                  
                                                  totalCost =
                                                      itemPrice * quantity;
                                                      totalCost.toStringAsFixed(2);                                     
                                                                                        });
                                           },
                                          keyboardType: TextInputType.number,
                                          controller: quantityItem,
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(
                                            color: ShopColors.primaryColor,
                                            fontSize: 17,
                                          ),
                                          
                                          decoration: InputDecoration(
                                            prefixIcon: Icon(Icons.add_box,
                                                color: ShopColors.primaryColor,
                                                size: 20),
                                            hintText: "Enter quantity",
                                            hintStyle: TextStyle(
                                                color: ShopColors.primaryColor),
                                            border: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            errorStyle: TextStyle(fontSize: 15),
                                            disabledBorder: InputBorder.none,
                                            isDense: true,
                                           
                                            contentPadding: EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 15.0),
                                          ),
                                          // validator: MultiValidator([
                                          //   RequiredValidator(
                                          //       errorText: "*field cannot be empty"),
                                          // ]),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                        )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
