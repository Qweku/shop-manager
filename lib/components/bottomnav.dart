import 'package:flutter/material.dart';
import 'package:shop_manager/config/colors.dart';
import 'package:shop_manager/pages/productCalculator.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: ShopColors.secondaryColor,
         
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          GestureDetector(
              child: SizedBox(
                  height: 30,
                  width: 30,
                  child: Icon(Icons.home,size:30,color:ShopColors.primaryColor)),
              onTap: () {
                //Navigator.pushNamed(context, "/dashboard");
              }),
          GestureDetector(
              child: SizedBox(
                  height: 30,
                  width: 30,
                  child: Icon(Icons.account_balance_wallet,size:30,color:ShopColors.primaryColor)),
              onTap: () {
                
              }),
          
          GestureDetector(
            onTap:(){
              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ProductCalculator()));
            },
            child:SizedBox(
              height: 30,
              width: 30,
              child: Icon(Icons.monetization_on,size:30,color:ShopColors.primaryColor)),
          )
        
        ]),
      ),

       );
  }
}
