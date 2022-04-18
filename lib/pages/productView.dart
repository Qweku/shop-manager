import 'package:flutter/material.dart';
import 'package:shop_manager/pages/widgets/productCalculatorWidget.dart';

class ProductView extends StatelessWidget {
  const ProductView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(height * 0.05),
        child: Column(
          children: [
            SizedBox(height: height * 0.2),
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: EdgeInsets.all(height * 0.03),
                  width: width,
                  height: height * 0.4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: theme.primaryColorLight,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: height * 0.15),
                      Text(
                        'Ideal Milk',
                        style: theme.textTheme.headline1!.copyWith(
                            fontSize: 30, color: theme.primaryColor),
                      ),
                      SizedBox(height: height * 0.02),
                      Text('GHS 5.00', style: theme.textTheme.headline1),
                    ],
                  ),
                ),
                Positioned(
                  top: -height * 0.1,
                  left: width * 0.17,
                  //right: 0,
                  //bottom: 0,
                  child: Container(
                    width: width * 0.45,
                    height: height * 0.25,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.amber),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right:0,
                  left: 0,
                    child: Padding(
                      padding:  EdgeInsets.all(height*0.02),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            //crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Max Quantity',style:theme.textTheme.bodyText1!.copyWith(fontSize:12)),
                              SizedBox(height: height * 0.005),
                              Text('20',style:theme.textTheme.headline1!.copyWith(color: theme.primaryColor)),
                            ],
                          ),
                          ItemCounter(
                            iconColor: theme.primaryColorLight,
                            boxColor: theme.primaryColor,
                  height: height,
                  width: width,
                  theme: theme,
                ),
                        ],
                      ),
                    ))
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: height * 0.05),
              child: Container(
                padding: EdgeInsets.all(height * 0.01),
                width: width,
                height: height * 0.1,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: theme.primaryColorLight,
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal:height * 0.03),
                        child: Icon(Icons.shopping_cart,size:30,color:theme.primaryColor)
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          width: width * 0.5,
                          padding: EdgeInsets.all(height * 0.03),
                          color: theme.primaryColorDark,
                          child: Text(
                            'Add to Cart',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyText2,
                          ),
                        ),
                      )
                    ]),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
