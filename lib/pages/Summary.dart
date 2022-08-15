import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_manager/components/button.dart';
import 'package:shop_manager/models/GeneralProvider.dart';
import 'package:shop_manager/pages/widgets/clipPath.dart';
import 'package:shop_manager/pages/widgets/productCalculatorWidget.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({ Key? key }) : super(key: key);

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  @override
  Widget build(BuildContext context) {
     double height = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
             ClipPath(
                  clipper: BottomClipper(),
                  child: Container(
                    padding: EdgeInsets.only(
                        right: height * 0.02,
                        left: height * 0.02,
                        top: height * 0.13,
                        bottom: height * 0.07),
                    color: theme.primaryColor,
                    child: HeaderSection(
                      title: 'Summary',
                      height: height,
                      width: width,
                      theme: theme,
                      
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Padding(
                    padding:  EdgeInsets.all(width*0.05),
                    child: Column(
                      children: [
                        Container(
                      width: width * 0.9,
                      padding: EdgeInsets.all(width * 0.05),
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 239, 245, 255),
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Balance',
                                style: theme.textTheme.headline1!
                                    .copyWith(fontSize: 17)),
                            SizedBox(height: height * 0.01),
                            Text('GHS10.00',
                                style: theme.textTheme.headline1!
                                    .copyWith(color: theme.primaryColor)),
                          ]),
                    ), 
                    SizedBox(height:height*0.03),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          Text(DateTime.now().toString(),style: theme.textTheme.bodyText1,),
                          Text('#0001',style: theme.textTheme.bodyText1),
                        ]),
                       SizedBox(height:height*0.03),
                        ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                           itemCount: context.watch<GeneralProvider>().cart.length,
                          itemBuilder: (context,index){
                          return ItemDetail(
                            theme: theme, 
                            textColor: Colors.black,
                            backgroundColor: theme.primaryColor,
                            item:Provider.of<GeneralProvider>(context,
                                          listen: false)
                                      .cart[index] );
                        }),
                        SizedBox(height:height*0.03),
                        Divider(
                          color: Colors.grey,thickness: 1,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total',style: theme.textTheme.headline1,),
                            Text('GHS20.00',style: theme.textTheme.headline1,)
                          ],
                        )
                      ],
                    ),
                  ),
                )
          ]),
               Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Container(
                    
                    padding: EdgeInsets.all(height * 0.03),
                    child: Button(
                      onTap: () {
                        Navigator.pop(context);
                        
                      },
                      buttonText:'Done',
                      color: theme.primaryColor,
                      
                      width: width,
                    ),
                  ))
        
        ],
      ),
      
    );
  }
}