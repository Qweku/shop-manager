import 'package:flutter/material.dart';
import 'package:shop_manager/components/textFields.dart';

class CounterWidget extends StatefulWidget {
  final TextEditingController counterController;
  const CounterWidget({Key? key, required this.counterController})
      : super(key: key);

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int counter = 1;
  @override
  void initState() {
    widget.counterController.text = widget.counterController.text.isEmpty
        ? '0'
        : widget.counterController.text;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(height * 0.01),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: theme.primaryColorLight)),
          child: GestureDetector(
              onTap: () {
                counter = int.parse(widget.counterController.text);
                if (counter > 0) {
                  setState(() {
                    counter--;
                  });
                }
                widget.counterController.text = counter.toString();
              },
              child:
                  Icon(Icons.remove, size: 15, color: theme.primaryColorLight)),
        ),
        SizedBox(
          width: width * 0.15,
          child: CustomTextField(
            textAlign: TextAlign.center,
            keyboard: TextInputType.number,
            controller: widget.counterController,
            hintColor: theme.primaryColorLight,
            style: theme.textTheme.bodyText2,
            onChanged: (text) {
              counter = int.parse(widget.counterController.text);
            },
            //hintText: '1',
            //borderColor: theme.primaryColorLight
          ),
        ),
        Container(
          padding: EdgeInsets.all(height * 0.01),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: theme.primaryColorLight)),
          child: GestureDetector(
              onTap: () {
                counter = int.parse(widget.counterController.text);
                setState(() {
                  counter++;
                });
                widget.counterController.text = counter.toString();
              },
              child: Icon(Icons.add, size: 15, color: theme.primaryColorLight)),
        ),
      ],
    );
  }
}
