import 'package:flutter/material.dart';
import 'package:shop_manager/config/colors.dart';
import 'package:shop_manager/pages/productCalculator.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({Key? key}) : super(key: key);

  // const BottomNavigation({Key key}) : super(key: key);

  // BottomNavigationBarItem _icons(IconData icon, String title, String route) {
  //   return BottomNavigationBarItem(
  //       icon: Icon(
  //         icon,
  //       ),
  //       label: title);
  // }

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
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => NFCLoader()));
              }),
          // Container(
          //     height: 60,
          //     width: 60,
          //     decoration: BoxDecoration(
          //       color: ShopColors.primaryColor,
          //       borderRadius: BorderRadius.circular(30),
          //       boxShadow: <BoxShadow>[
          //         BoxShadow(
          //             color: Colors.black45,
          //             offset: Offset(1, 3),
          //             blurRadius: 5,
          //             spreadRadius: 1)
          //       ],
          //     ),
          //     child: Padding(
          //       padding: const EdgeInsets.all(10),
          //       child: Image.asset('assets/logo.png'),
          //     )),
          
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
          )// GestureDetector(
          //     child: Container(
          //         height: 30,
          //         width: 30,
          //         child: Icon(Icons.)),
          //     onTap: () {
          //       // Navigator.push(context,
          //       //     MaterialPageRoute(builder: (context) => AddFundsPage()));
          //     })
        
        ]),
      ),

      // Padding(
      //   padding: const EdgeInsets.only(top: 10),
      //   child: BottomNavigationBar(
      //     backgroundColor: Colors.transparent, //BaseColors.grad1
      //     type: BottomNavigationBarType.fixed,
      //     iconSize: 25,
      //     selectedFontSize: 15,
      //     unselectedFontSize: 13,
      //     showUnselectedLabels: true,
      //     showSelectedLabels: true,
      //     selectedItemColor: BaseColors.secondaryColor,
      //     unselectedItemColor: BaseColors.textColor,
      //     currentIndex: 0,
      //     items: [
      //       _icons(Icons.home, "Home", ""),
      //       _icons(Icons.credit_card, "Cards", ""),
      //       _icons(Icons.monetization_on, "Loans", ""),
      //       _icons(Icons.point_of_sale, "Invest ", ""),
      //       _icons(Icons.enhanced_encryption_outlined, "Insurance ", ""),
      //       _icons(Icons.more_horiz_rounded, "More", ""),
      //     ],

      //     onTap: (index) {
      //       switch (index) {
      //         case 0:
      //           Navigator.pushNamed(context, "/dashboard");
      //           break;
      //         case 1:
      //           Navigator.pushNamed(context, "/addcard");
      //           break;
      //         case 2:
      //           Navigator.pushNamed(context, "/loans");
      //           break;
      //         case 3:
      //           Navigator.pushNamed(context, "/investments");
      //           break;
      //         case 4:
      //           Navigator.pushNamed(context, "/insurance");
      //           break;
      //         case 5:
      //           Navigator.pushNamed(context, "/more");
      //           break;
      //       }
      //     },

      //     // onTap: (int index) {
      //     //   if (index == 1) {
      //     //     Navigator.of(context).push(MaterialPageRoute(
      //     //       builder: (context) => ListMenu(),
      //     //     ));
      //     //   }
      //     //   if (index != 1) {
      //     //     Navigator.of(context).push(MaterialPageRoute(
      //     //       builder: (context) => ListMenu(),
      //     //     ));
      //     //   }
      //     // }
      //   ),
      // ),
    );
  }
}
