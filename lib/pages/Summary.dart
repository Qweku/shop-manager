import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:shop_manager/components/button.dart';
import 'package:shop_manager/models/GeneralProvider.dart';
import 'package:shop_manager/pages/addProductSuccess.dart';
import 'package:shop_manager/pages/widgets/clipPath.dart';
import 'package:shop_manager/pages/widgets/constants.dart';
import 'package:shop_manager/pages/widgets/productCalculatorWidget.dart';


class SummaryScreen extends StatefulWidget {
  final double amountReceived, change, totalCost;
  const SummaryScreen(
      {Key? key,
      required this.amountReceived,
      required this.change,
      required this.totalCost})
      : super(key: key);

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  DateFormat dateformat = DateFormat.yMMMd();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Column(children: [
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
                  title: 'Summary',
                  height: height,
                  width: width,
                  theme: theme,
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(width * 0.05),
                  child: Column(
                    children: [
                      Text(
                        "Your order summary!",
                        style: theme.textTheme.headline1,
                      ),
                      SizedBox(height: height * 0.03),
                      Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Order #: ',
                                style: theme.textTheme.bodyText1!
                                    .copyWith(fontWeight: FontWeight.bold)),
                            Text('0001', style: theme.textTheme.bodyText1),
                          ]),
                      Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Status: ',
                                style: theme.textTheme.bodyText1!
                                    .copyWith(fontWeight: FontWeight.bold)),
                            Text('Paid', style: theme.textTheme.bodyText1),
                          ]),
                      Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Date: ',
                                style: theme.textTheme.bodyText1!
                                    .copyWith(fontWeight: FontWeight.bold)),
                            Text(
                              dateformat.format(DateTime.now()),
                              style: theme.textTheme.bodyText1,
                            ),
                          ]),
                      SizedBox(height: height * 0.03),
                      ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount:
                              context.watch<GeneralProvider>().cart.length,
                          itemBuilder: (context, index) {
                            return ItemDetail(
                                theme: theme,
                                backgroundColor:
                                    const Color.fromARGB(255, 233, 233, 233),
                                textColor:
                                    const Color.fromARGB(255, 26, 26, 26),
                                item: Provider.of<GeneralProvider>(context,
                                        listen: false)
                                    .cart[index]);
                          }),
                     
                      SizedBox(height: height * 0.03),
                      const Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total',
                            style: theme.textTheme.headline1,
                          ),
                          Text(
                            "GHS ${widget.totalCost.toStringAsFixed(2)} ",
                            style: theme.textTheme.headline1,
                          )
                        ],
                      ),
                      SizedBox(height: height * 0.05),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Amount Received',
                            style: theme.textTheme.bodyText1!
                                .copyWith(fontSize: 15),
                          ),
                          Text(
                            "GHS ${widget.amountReceived.toStringAsFixed(2)}",
                            style: theme.textTheme.bodyText1!
                                .copyWith(fontSize: 15),
                          )
                        ],
                      ),
                      const Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Change',
                            style: theme.textTheme.headline1,
                          ),
                          Text(
                            "GHS ${widget.change.toStringAsFixed(2)}",
                            style: theme.textTheme.headline1,
                          )
                        ],
                      ),
                      SizedBox(height: height * 0.05),
                      Button(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddProductSuccess(
                                  tag: 'order',
                                )));

                   
                    // print("${context}");
                    context.read<GeneralProvider>().cart.clear();
                  },
                  buttonText: 'Done',
                  color: primaryColor,
                  width: width*0.8,
                ),
              
                    ],
                  ),
                ),
              ),
            ),
          ]),

          // Positioned(
          //     bottom: 0,
          //     right: 0,
          //     left: 0,
          //     child: Container(
          //       color:Colors.white,
          //       padding: EdgeInsets.all(height * 0.03),
          //       child: Button(
          //         onTap: () {
          //           Navigator.pushReplacement(
          //               context,
          //               MaterialPageRoute(
          //                   builder: (context) => const AddProductSuccess(
          //                         tag: 'order',
          //                       )));

                   
          //           // print("${context}");
          //           context.read<GeneralProvider>().cartList.clear();
          //         },
          //         buttonText: 'Done',
          //         color: primaryColor,
          //         width: width,
          //       ),
          //     ))
       
        ],
      ),
    );
  }
}
