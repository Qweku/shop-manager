// ignore_for_file: file_names, prefer_const_constructors
//import 'package:country_select/country_select.dart';
//import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
//import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
//import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
//import 'package:intl_phone_number_input/intl_phone_number_input.dart';

// class DateTextField extends StatelessWidget {
//   final String? hintText;
//   final TextEditingController? controller;
//   final Color borderColor;
//   final Color color;
//   final TextStyle? style;
//   final Widget? prefixIcon;
//   final Widget? suffixIcon;
//   final Color hintColor;
//   const DateTextField(
//       {Key? key,
//       this.hintText,
//       this.controller,
//       this.borderColor = Colors.transparent,
//       this.color = Colors.transparent,
//       this.style,
//       this.prefixIcon,
//       this.suffixIcon,
//       this.hintColor = Colors.grey})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     //final fromDate = TextEditingController();
//     final dateformat = DateFormat("yyyy-MM-dd");
//     //final theme = Theme.of(context);
//     return Padding(
//       padding: const EdgeInsets.symmetric(
//         horizontal: 0,
//       ),
//       child: Container(
//         //width: MediaQuery.of(context).size.width,
//         decoration: BoxDecoration(
//             border: Border.all(
//               color: borderColor,
//             ),
//             color: color,
//             borderRadius: BorderRadius.circular(20)),
//         child: Theme(
//           data: ThemeData.from(
//             colorScheme: ColorScheme.fromSwatch(
//               primarySwatch: Colors.blue,
//               accentColor: Colors.white,
//             ),
//           ),
//           child: DateTimeField(
//             style: style,
//             decoration: InputDecoration(
//               hintText: hintText,
//               hintStyle: TextStyle(color: hintColor),
//               prefixIcon: prefixIcon,
//               border: InputBorder.none,
//               focusedBorder: InputBorder.none,
//               enabledBorder: InputBorder.none,
//               errorBorder: InputBorder.none,
//               disabledBorder: InputBorder.none,
//               contentPadding:
//                   EdgeInsets.symmetric(horizontal: 15, vertical: 15.0),
//             ),
//             // validator: MultiValidator([
//             //   RequiredValidator(
//             //       errorText: "*field cannot be empty"),
//             // ]),
//             format: dateformat,
//             controller: controller,
//             onShowPicker: (context, currentValue) {
//               return showDatePicker(
//                   context: context,
//                   firstDate: DateTime(1900),
//                   initialDate: currentValue ?? DateTime.now(),
//                   lastDate: DateTime(2100));
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

// class TimeTextField extends StatelessWidget {
//   const TimeTextField({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final timeformat = DateFormat("HH:mm");
//     final theme = Theme.of(context);
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 0),
//       child: Container(
//         width: MediaQuery.of(context).size.width,
//         decoration: BoxDecoration(
//             border: Border.all(
//               color: Colors.black,
//             ),
//             borderRadius: BorderRadius.circular(20)),
//         child: Theme(
//           data: ThemeData.from(
//             colorScheme: ColorScheme.fromSwatch(
//               primarySwatch: Colors.green,
//               accentColor: Colors.white,
//             ),
//           ),
//           child: DateTimeField(
//             style: theme.textTheme.bodyText1,
//             decoration: InputDecoration(
//               hintText: "Time",
//               prefixIcon: Icon(Icons.watch, color: Colors.black),
//               border: InputBorder.none,
//               hintStyle: theme.textTheme.bodyText1,
//               focusedBorder: InputBorder.none,
//               enabledBorder: InputBorder.none,
//               errorBorder: InputBorder.none,
//               disabledBorder: InputBorder.none,
//               contentPadding:
//                   EdgeInsets.symmetric(horizontal: 15, vertical: 15.0),
//             ),
//             // validator: MultiValidator([
//             //   RequiredValidator(
//             //       errorText: "*field cannot be empty"),
//             // ]),
//             format: timeformat,
//             //controller: fromDate,
//             onShowPicker: (context, currentValue) async {
//               final time = await showTimePicker(
//                 context: context,
//                 initialTime:
//                     TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
//               );
//               return DateTimeField.convert(time);
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

class CustomTextField extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType? keyboard;
  final int maxLines;
  final Color borderColor;
  final Color color;
  final TextStyle? style;
  final bool obscure;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextAlign textAlign;
  final Function(String)? onChanged;
  final Color hintColor;
  final bool? readOnly;
  final bool? autoFocus;
  const CustomTextField(
      {Key? key,
      this.hintText,
      this.controller,
      this.keyboard,
      this.maxLines=1,
      this.borderColor = Colors.transparent,
      this.color = Colors.transparent,
      this.style,
      this.readOnly = false,
      this.obscure = false,
      this.suffixIcon,
      this.textAlign = TextAlign.justify,
      this.hintColor = Colors.grey,
      this.prefixIcon,
      this.onChanged,
      this.autoFocus = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      //width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          border: Border.all(
            color: borderColor,
          ),
          color: color,
          borderRadius: BorderRadius.circular(20)),
      child: TextFormField(
        autofocus: autoFocus!,
        obscureText: obscure,
        readOnly: readOnly!,
        maxLines: maxLines,
        onChanged: onChanged,
        keyboardType: keyboard,
        controller: controller,
        textAlign: textAlign,
        style: style,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: hintColor),
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15.0),
        ),
        // validator: MultiValidator([
        //   EmailValidator(errorText: ""),
        //   RequiredValidator(errorText: ""),
        // ]),
      ),
    );
  }
}

// class CustomPhoneTextField extends StatefulWidget {
//   final TextStyle? textStyle;
//   final Color borderColor;
//   final Color color;
//   final TextEditingController? controller;
//   final Function(bool _validation)? getValidation;
//   final String? hint;

//   const CustomPhoneTextField(
//       {Key? key,
//       this.borderColor = Colors.transparent,
//       this.color = Colors.transparent,
//       this.textStyle,
//       this.controller,
//       this.hint,
//       this.getValidation})
//       : super(key: key);

//   @override
//   State<CustomPhoneTextField> createState() => _CustomPhoneTextFieldState();
// }

// class _CustomPhoneTextFieldState extends State<CustomPhoneTextField> {
//   String initialCountry = 'GH';
//   PhoneNumber number = PhoneNumber(isoCode: 'GH');
//   String val = "";
//   bool validation = false;
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 10),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(
//           color: widget.borderColor,
//         ),
//         color: widget.color,
//       ),
//       child: Center(
//         child: InternationalPhoneNumberInput(
//           autoFocus: false,
//           textStyle: widget.textStyle,
//           // inputDecoration: InputDecoration(contentPadding: EdgeInsets.all(5)),
//           onInputChanged: (PhoneNumber number) {
//             // print(number.phoneNumber);
//           },
//           onInputValidated: (bool value) {
//             // print(value);
//             setState(() {
//               widget.getValidation!(value);
//             });
//           },
//           selectorConfig: SelectorConfig(
//             selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
//           ),
//           ignoreBlank: false,
//           autoValidateMode: AutovalidateMode.disabled,
//           selectorTextStyle: widget.textStyle,
//           initialValue: number,
//           textFieldController: widget.controller,
//           formatInput: true,
//           inputDecoration: InputDecoration(
//               border: InputBorder.none, contentPadding: EdgeInsets.all(20)),
//           isEnabled: true,
//           hintText: widget.hint,
//           // keyboardType:
//           //     TextInputType.numberWithOptions(
//           //         signed: true,
//           //         decimal: true),
//           // inputBorder: OutlineInputBorder(borderRadius:BorderRadius.circular(20),
//           //  borderSide: BorderSide(color: Colors.grey[800],
//           // width: 1) ),
//           onSaved: (PhoneNumber number) {
//             // print('On Saved: $number');
//             setState(() {
//               val = number.toString();
//             });
//           },
//         ),
//       ),
//     );
//   }
// }

// class AmountTextField extends StatefulWidget {
//   final TextEditingController? controller;
//   final Color borderColor;
//   final Color color;
//   final TextStyle? style;
//   final String? hintText;
//   Country? currency;
//   final void Function(String text)? onChanged;
//   final bool? readOnly;
//   AmountTextField(
//       {Key? key,
//       this.controller,
//       this.hintText,
//       this.borderColor = Colors.white,
//       this.color = Colors.transparent,
//       this.readOnly = false,
//       this.style,
//       this.currency,
//       this.onChanged})
//       : super(key: key);

//   @override
//   State<AmountTextField> createState() => _AmountTextFieldState();
// }

// class _AmountTextFieldState extends State<AmountTextField> {
//   Country _selected = Country(
//     asset: "assets/flags/gh_flag.png",
//     dialingCode: "233",
//     isoCode: "GH",
//     name: "Ghana",
//     currency: "Ghana Cedis",
//     currencyISO: "GHS",
//   );

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 5),
//       child: Container(
//         padding: const EdgeInsets.only(top: 10, bottom: 10),
//         //width: MediaQuery.of(context).size.width * 0.55,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(
//               width: 1, style: BorderStyle.solid, color: widget.borderColor),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Container(
//               padding: const EdgeInsets.only(left: 10, top: 10),
//               height: 50,
//               width: MediaQuery.of(context).size.width * 0.5,
//               child: TextField(
//                 readOnly: widget.readOnly!,
//                 controller: widget.controller,
//                 textAlign: TextAlign.justify,
//                 onChanged: widget.onChanged,
//                 keyboardType: TextInputType.number,
//                 style: widget.style,
//                 decoration: InputDecoration(
//                   border: InputBorder.none,
//                   hintText: "${_selected.currencyISO} 0.00",
//                   hintStyle: widget.style,
//                 ),
//                 inputFormatters: [
//                   CurrencyTextInputFormatter(
//                       turnOffGrouping: true,
//                       decimalDigits: 2,
//                       // locale: 'usa',
//                       symbol: "${_selected.currencyISO} "),
//                 ],
//               ),
//             ),
//             Container(
//               width: MediaQuery.of(context).size.width * 0.15,
//               height: 50,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Align(
//                 alignment: Alignment.centerRight,
//                 child: CountryPicker(
//                   showFlag: true,
//                   showName: false,
//                   showDialingCode: false,
//                   onChanged: (Country country) {
//                     setState(() {
//                       _selected = country;
//                     });
//                   },
//                   selectedCountry: _selected,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
