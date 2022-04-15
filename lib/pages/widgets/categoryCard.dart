import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String? categoryName;
  final int? index;
  final Function()? onTap;
  const CategoryCard({Key? key, this.categoryName, this.onTap, this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(height * 0.01),
        child: Container(
          padding: EdgeInsets.all(height * 0.02),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: index!.isEven ? theme.primaryColor : Colors.white,
              // ignore: prefer_const_literals_to_create_immutables
              boxShadow: [
                BoxShadow(
                    offset: Offset(2, 2),
                    color: Color.fromARGB(31, 0, 0, 0),
                    blurRadius: 2,
                    spreadRadius: 1)
              ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.category_outlined,
                color: index!.isEven ? Colors.white : theme.primaryColor,
                size: 50,
              ),
              SizedBox(height:height*0.01),
              Text(
                categoryName!,
                style: index!.isEven
                    ? theme.textTheme.headline2
                    : theme.textTheme.headline1!.copyWith(color: theme.primaryColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
