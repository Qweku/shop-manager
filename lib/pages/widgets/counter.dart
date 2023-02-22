 import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shop_manager/components/textFields.dart';
import 'package:shop_manager/models/GeneralProvider.dart';
import 'package:shop_manager/models/ShopModel.dart';
import 'package:shop_manager/pages/widgets/constants.dart';

class CounterWidget extends StatefulWidget {
  final TextEditingController counterController;
  final Color? borderColor;
  final TextStyle? style;
  const CounterWidget(
      {Key? key, required this.counterController, this.borderColor, this.style})
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
              border: Border.all(
                  color: widget.borderColor ?? theme.primaryColorLight)),
          child: GestureDetector(
              onTap: () {
                counter = int.parse(widget.counterController.text.isEmpty
                  ? '0'
                  : widget.counterController.text);
                if (counter > 0) {
                  setState(() {
                    counter--;
                  });
                }
                widget.counterController.text = counter.toString();
              },
              child: Icon(Icons.remove,
                  size: 15,
                  color: widget.borderColor ?? theme.primaryColorLight)),
        ),
        SizedBox(
          width: width * 0.15,
          child: CustomTextField(
            textAlign: TextAlign.center,
            keyboard:
                const TextInputType.numberWithOptions(signed: false, decimal: false),
            controller: widget.counterController,
            hintColor: widget.borderColor ?? theme.primaryColorLight,
            style: widget.style ?? theme.textTheme.bodyText2,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            maxLines: 1,
            maxLength: 3,
            hintText: '0',
            onChanged: (text) {
              if (text.isEmpty) {
                // setState(() {
                //   widget.counterController.text = '0';
                //   text = '0';
                // });
              }
              counter = int.parse(widget.counterController.text.isEmpty
                  ? '0'
                  : widget.counterController.text);
            },
            //hintText: '1',
            //borderColor: theme.primaryColorLight
          ),
        ),
        Container(
          padding: EdgeInsets.all(height * 0.01),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: widget.borderColor ?? theme.primaryColorLight)),
          child: GestureDetector(
              onTap: () {
                counter =int.parse(widget.counterController.text.isEmpty
                  ? '0'
                  : widget.counterController.text);
                setState(() {
                  counter++;
                });
                widget.counterController.text = counter.toString();
              },
              child: Icon(Icons.add,
                  size: 15,
                  color: widget.borderColor ?? theme.primaryColorLight)),
        ),
      ],
    );
  }
}



class ItemCounter extends StatefulWidget {
 final Color? color;
  final TextStyle? style;
  final TextEditingController counterController;
  final double width;
  bool? active;
  Product? product;
   ItemCounter(
      {Key? key, required this.counterController, this.color, this.style, required this.width,this.product})
      : super(key: key);

  @override
  State<ItemCounter> createState() => _ItemCounterState();
}

class _ItemCounterState extends State<ItemCounter> {
  int counter = 1;
  @override
  void initState() {
    widget.counterController.text = widget.counterController.text.isEmpty
        ? '1'
        : widget.counterController.text;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.remove_circle_outline,
                size: 30, color: counter == 1 ? Colors.grey : widget.color),
            onPressed: () {
               FocusScope.of(context).unfocus();
              counter = int.parse(widget.counterController.text.isEmpty
                ? '1'
                : widget.counterController.text);
              if (counter > 0) {
                setState(() {
                  counter--;
                }); 
                if (widget.product != null) {
                    Product product = Product(
                      pid: widget.product!.pid,
                      productName: widget.product?.productName,
                      sellingPrice: widget.product?.sellingPrice,
                      productDescription: widget.product?.productDescription,
                      cartQuantity: counter,
                      productImage: widget.product?.productImage,
                    );
                    context.read<GeneralProvider>().updateCart(product);
                    context.read<GeneralProvider>().total(product);
                  } 
                  
                  widget.counterController.text = counter.toString();
              }
              
             
            },
            ),
        SizedBox(
          width: width * 0.15,
          child: CustomTextField(
            textAlign: TextAlign.center,
            keyboard:
                const TextInputType.numberWithOptions(signed: false, decimal: false),
            controller: widget.counterController,
            
            hintColor: widget.color ?? theme.primaryColorLight,
            style: widget.style ?? theme.textTheme.bodyText2,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            maxLines: 1,
            maxLength: 3,
            hintText: '0',
             onEditingComplete: () {
                FocusScope.of(context).unfocus();
              },
            onChanged: (text) {
              if (text.isEmpty) {
                 setState(() {
                    widget.counterController.text = '1';
                    text = '1';
                  });
              }
              counter = int.parse(widget.counterController.text.isEmpty
                  ? '1'
                  : widget.counterController.text);
            },
            //hintText: '1',
            //borderColor: theme.primaryColorLight
          ),
        ),
        IconButton(
           icon: Icon(Icons.add_circle_outline,
                size: 30,
                color: counter == 100 //widget.product!.productQuantity!
                    ? Colors.grey
                    : widget.color),
            onPressed: () {
              counter =int.parse(widget.counterController.text.isEmpty
                ? '0'
                : widget.counterController.text);
              setState(() {
                counter++;
              });
               if (widget.product != null) {
                    Product product = Product(
                      pid: widget.product!.pid,
                      productName: widget.product?.productName,
                     sellingPrice: widget.product?.sellingPrice,
                      productDescription: widget.product?.productDescription,
                      cartQuantity: counter,
                      productImage: widget.product?.productImage,
                    );
                    context.read<GeneralProvider>().updateCart(product);
                    context.read<GeneralProvider>().total(product);
                  }
              widget.counterController.text = counter.toString();
            },
            ),
      ],
    );
  }
}



