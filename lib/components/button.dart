// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final Function()? onTap;
  final String? buttonText;
  final Color color, textColor;
  final double? width, verticalPadding, borderRadius;
  final Color borderColor;
  final Color shadowColor;
  const Button({
    Key? key,
    this.onTap,
    this.buttonText,
    this.color = Colors.transparent,
    this.width,
    this.borderColor = Colors.transparent,
    this.shadowColor = Colors.black45, this.textColor = Colors.white, this.verticalPadding, this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        padding: EdgeInsets.symmetric(vertical:verticalPadding ?? 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 20)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: shadowColor,
              offset: Offset(1, 2),
              blurRadius: 2,
            )
          ],
          color: color,
        ),
        child: Text(
          buttonText!,textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15, color: textColor),
        ),
      ),
    );
  }
}

class CustomToggleButton extends StatefulWidget {
  final List<bool>? isSelected;
  final List<String>? label;
  final double btnWidth;
  final Function? onTap;
  const CustomToggleButton(
      {Key? key,
      this.isSelected,
      this.label,
      required this.btnWidth,
      this.onTap})
      : super(key: key);

  @override
  State<CustomToggleButton> createState() => _CustomToggleButtonState();
}

class _CustomToggleButtonState extends State<CustomToggleButton> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return ToggleButtons(
        //renderBorder: false,
        selectedBorderColor: theme.cardColor,
        direction: Axis.horizontal,
        constraints:
            BoxConstraints(minHeight: height * 0.07, minWidth: widget.btnWidth),
        color: Colors.white,
        selectedColor: Colors.white,
        fillColor: theme.cardColor,
        borderColor: Colors.white,
        borderRadius: BorderRadius.circular(20),
        children: List.generate(widget.isSelected!.length, (index) {
          return Container(
            //width: width * 0.2,
            padding: EdgeInsets.all(width * 0.02),
            child: SizedBox(
              width: width * 0.2,
              child: Text(widget.label![index],
                  softWrap: true,
                  style: TextStyle(fontSize: 17),
                  textAlign: TextAlign.center),
            ),
          );
        }),
        isSelected: widget.isSelected!,
        onPressed: (int index) {
          setState(() {
            for (int indexBtn = 0;
                indexBtn < widget.isSelected!.length;
                indexBtn++) {
              if (indexBtn == index) {
                widget.isSelected![indexBtn] = true;
              } else {
                widget.isSelected![indexBtn] = false;
              }
            }
          });
        });
  }

  toggleItem() {
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width * 0.2,
      padding: EdgeInsets.all(10),
      child: Text('Mobile money',
          softWrap: true,
          style: TextStyle(fontSize: 17),
          textAlign: TextAlign.center),
    );
  }
}

class CustomDropdownList extends StatefulWidget {
  final List<DropdownMenuItem<String>> items;
  final void Function(String?)? onChanged;
  final String? value;
  final String hint;
  const CustomDropdownList(
      {Key? key,
      required this.items,
      required this.onChanged,
      required this.value,
      required this.hint})
      : super(key: key);

  @override
  _CustomDropdownListState createState() => _CustomDropdownListState();
}

class _CustomDropdownListState extends State<CustomDropdownList> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: DropdownButtonFormField(
        style: theme.textTheme.bodyText1,
        decoration: InputDecoration(
            hintStyle: TextStyle(color: Colors.black87),
            border: InputBorder.none,
            fillColor: Colors.transparent,
            filled: true),
        hint: Text(widget.hint),
        value: widget.value,
        onChanged: widget.onChanged,
        items: widget.items,
      ),
    );
  }
}
