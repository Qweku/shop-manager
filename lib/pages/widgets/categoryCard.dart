import 'package:flutter/material.dart';
import 'package:shop_manager/pages/widgets/constants.dart';

class CategoryCard extends StatelessWidget {
  final String? categoryName;
  final int? index;
  final bool? selected;
  final double? smallFont, largeFont;
  final Function()? onTap;
  const CategoryCard(
      {Key? key,
      this.categoryName,
      this.onTap,
      this.index,
      this.smallFont,
      this.largeFont,
      this.selected = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    // Color background = index == 0
    //     ? Colors.blueGrey
    //     : index!.isEven
    //         ? primaryColor
    //         : Colors.white;
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(height * 0.01),
        child: Container(
          padding: EdgeInsets.all(height * 0.02),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: !selected! ? primaryColor : Colors.white,
              // ignore: prefer_const_literals_to_create_immutables
              boxShadow: [
                const BoxShadow(
                    offset: Offset(2, 2),
                    color: Color.fromARGB(31, 0, 0, 0),
                    blurRadius: 2,
                    spreadRadius: 1)
              ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                categoryName!.substring(0, 3),
                style:
                    // index!.isEven
                    !selected!
                        ? headline2.copyWith(fontSize: largeFont!)
                        : headline1.copyWith(
                            fontSize: largeFont!, color: primaryColor),
              ),
              SizedBox(height: height * 0.01),
              Text(
                categoryName!,
                overflow: TextOverflow.ellipsis,
                style:
                    // index!.isEven
                    !selected!
                        ? headline2.copyWith(fontSize: smallFont!)
                        : headline1.copyWith(
                            fontSize: smallFont!, color: primaryColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
