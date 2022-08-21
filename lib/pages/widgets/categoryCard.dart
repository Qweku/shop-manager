import 'package:flutter/material.dart';

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
    final theme = Theme.of(context);
    double height = MediaQuery.of(context).size.height;
    // Color background = index == 0
    //     ? Colors.blueGrey
    //     : index!.isEven
    //         ? theme.primaryColor
    //         : Colors.white;
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(height * 0.01),
        child: Container(
          padding: EdgeInsets.all(height * 0.02),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: !selected! ? theme.primaryColor : Colors.white,
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
                        ? theme.textTheme.headline2!
                            .copyWith(fontSize: largeFont!)
                        : theme.textTheme.headline1!.copyWith(
                            fontSize: largeFont!, color: theme.primaryColor),
              ),
              SizedBox(height: height * 0.01),
              Text(
                categoryName!,
                overflow: TextOverflow.ellipsis ,
                style:
                    // index!.isEven
                    !selected!
                        ? theme.textTheme.headline2!
                            .copyWith(fontSize: smallFont!)
                        : theme.textTheme.headline1!.copyWith(
                            fontSize: smallFont!, color: theme.primaryColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
