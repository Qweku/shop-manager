// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:shop_manager/pages/widgets/constants.dart';

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
    this.shadowColor = Colors.black45,
    this.textColor = Colors.white,
    this.verticalPadding,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        padding: EdgeInsets.symmetric(vertical: verticalPadding ?? 15),
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
          buttonText!,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15, color: textColor),
        ),
      ),
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
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: DropdownButtonFormField(
        style: bodyText1,
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
