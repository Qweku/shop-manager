import 'package:flutter/material.dart';
import 'package:shop_manager/components/notificationButton.dart';
import 'package:shop_manager/components/responsive.dart';
import 'package:shop_manager/pages/widgets/clipPath.dart';
import 'package:shop_manager/pages/widgets/constants.dart';
import 'package:shop_manager/pages/widgets/productCard.dart';

class LowStockList extends StatelessWidget {
  const LowStockList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      body: Column(children: [
        Responsive.isMobile()?ClipPath(
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
              theme: theme,
            ),
          ),
        ):Padding(
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

class LowStockGridList extends StatelessWidget {
  const LowStockGridList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      physics: const BouncingScrollPhysics(),
      crossAxisCount: Responsive.isMobile()?3:6,
      childAspectRatio: 2 / 3.5,
      children: List.generate(
          10,
          (index) => ProductCard(
            index: index,
                image64: "",
                price: "GHS20.0",
                productName: "Ideal Milk",
                quantity: "3",
              )),
    );
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
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back, color: Colors.white)),
            Text(
              "Low Stock Basket",
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
        // Container(
        //   decoration: BoxDecoration(
        //       borderRadius: BorderRadius.circular(10),
        //       color: theme.primaryColorLight),
        //   child: IconButton(
        //       onPressed: onPressed,
        //       icon: Icon(Icons.add, color: theme.primaryColor)),
        // )
      ],
    );
  }
}
