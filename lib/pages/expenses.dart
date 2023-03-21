import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_manager/components/button.dart';
import 'package:shop_manager/components/responsive.dart';
import 'package:shop_manager/components/textFields.dart';
import 'package:shop_manager/models/AccountProvider.dart';
import 'package:shop_manager/models/ShopModel.dart';
import 'package:shop_manager/pages/widgets/clipPath.dart';
import 'package:shop_manager/pages/widgets/constants.dart';

class ExpenseScreen extends StatefulWidget {
  final String? tag;
  const ExpenseScreen({Key? key, this.tag}) : super(key: key);

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  TextEditingController fromDate = TextEditingController();
  TextEditingController toDate = TextEditingController();
  TextEditingController itemName = TextEditingController();
  TextEditingController price = TextEditingController();
  double totalExpense = 0.0;
  bool error = false;
  

  @override
  Widget build(BuildContext context) {
    totalExpense = 0.0;

    context.watch<SalesProvider>().expenseList.forEach((element) {
      totalExpense += element.price;
    });
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addExpense(),
        backgroundColor: primaryColor,
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                ClipPath(
                  clipper: BottomClipper(),
                  child: Container(
                    padding: EdgeInsets.only(
                        right: height * 0.02,
                        left: height * 0.02,
                        top: height * 0.1,
                        bottom: height * 0.13),
                    color: primaryColor,
                    child: HeaderSection(
                      title: 'Shop Expenses',
                      height: height,
                      width: width,
                      trailing: IconButton(
                        icon: const Icon(Icons.filter_list,
                            size: 30, color: Colors.white),
                        onPressed: () {
                          _searchAccount(context);
                        },
                      ),
                    ),
                  ),
                ),
                Positioned(
                    bottom: -height * 0.03,
                    right: 0,
                    left: 0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                      ),
                      child: SizedBox(
                        height: height * 0.12,
                        width: width * 0.5,
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.auto_graph,
                                    size: Responsive.isMobile() ? 20 : 30,
                                    color: actionColor),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text("Total Expense",
                                    style: bodyText1.copyWith(
                                        color: primaryColorDark)),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "GHS ${totalExpense.toStringAsFixed(2)}",
                                  style: headline1.copyWith(
                                      color: primaryColorDark),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ))
              ],
            ),
            SizedBox(height: height * 0.07),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text("Expenses History", style: headline1),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: SizedBox(
                  width: width * 0.1,
                  child: Divider(
                    color: actionColor,
                    thickness: 5,
                  )),
            ),
            SizedBox(height: height * 0.02),
            Expanded(
              child: ExpenseListSection(width: width),
            ),
          ],
        ),
      ),
    );
  }

  void _searchAccount(context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: primaryColorLight,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        ),
        context: context,
        builder: (BuildContext bc) {
          return Container(
            height: height * 0.7,
            padding: EdgeInsets.all(height * 0.02),
            child: Wrap(
              spacing: 20,
              children: <Widget>[
                SizedBox(height: height * 0.02),
                Padding(
                  padding: EdgeInsets.only(
                      bottom: height * 0.02, top: height * 0.04),
                  child: Text("Filter Expenses", style: headline2),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: height * 0.04,
                  ),
                  child: DateTextField(
                      controller: fromDate,
                      hintText: 'From',
                      hintColor: Colors.grey,
                      borderColor: Colors.grey,
                      prefixIcon: const Icon(Icons.calendar_today,
                          color: Colors.grey, size: 20),
                      style: bodyText2),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: height * 0.04,
                  ),
                  child: DateTextField(
                      controller: toDate,
                      hintText: 'To',
                      hintColor: Colors.grey,
                      borderColor: Colors.grey,
                      prefixIcon: const Icon(Icons.calendar_today,
                          color: Colors.grey, size: 20),
                      style: bodyText2),
                ),
                SizedBox(height: height * 0.1),
                Button(
                  color: primaryColor,
                  width: width,
                  buttonText: "Done",
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(height: height * 0.4),
              ],
            ),
          );
        });
  }

  _addExpense() {
    return showDialog<bool>(
        barrierDismissible: false,
        context: context,
        builder: (c) => StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                contentPadding: EdgeInsets.all(20),
                insetPadding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                content: SizedBox(
                  height: height * 0.33,
                  width: width * 0.7,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text('Add Expense',
                              style: bodyText1.copyWith(
                                  letterSpacing: 2,
                                  fontSize: 20,
                                  color: primaryColor)),
                          SizedBox(height: height * 0.01),
                          //Divider
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: width * 0.2,
                                child: Divider(color: primaryColor),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: height * 0.01),
                                child: Icon(Icons.edit,
                                    color: actionColor, size: 20),
                              ),
                              SizedBox(
                                width: width * 0.2,
                                child: Divider(color: primaryColor),
                              )
                            ],
                          ),
                        ],
                      ),
                      error
                          ? Text('*Field Required',
                              style: bodyText1.copyWith(
                                  color: Color.fromARGB(255, 252, 17, 0)))
                          : Container(),
                      CustomTextField(
                        controller: itemName,
                        borderColor: Colors.grey,
                        style: bodyText1,
                        hintText: 'Item',
                        prefixIcon: Icon(
                          Icons.credit_card,
                          color: Colors.grey,
                        ),
                      ),
                      CustomTextField(
                        controller: price,
                        keyboard: TextInputType.number,
                        borderColor: Colors.grey,
                        hintText: 'Amount',
                        style: bodyText1,
                        prefixIcon: Icon(
                          Icons.money,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  Align(
                    alignment: Alignment.center,
                    child: Button(
                      onTap: () async {
                        ExpenseModel expenseModel = ExpenseModel(
                            id: context
                                    .read<SalesProvider>()
                                    .expenseList
                                    .length +
                                1,
                            itemName: itemName.text,
                            price: double.tryParse(price.text) ?? 0.0,
                            date: salesDateFormat.format(DateTime.now()));
                        if (itemName.text.isEmpty || price.text.isEmpty) {
                          setState(() {
                            error = true;
                          });
                        } else {
                          Provider.of<SalesProvider>(context, listen: false)
                              .addExpenses(expenseModel);
                              
                          Navigator.pop(context);
                        }
                      },
                      width: width * 0.4,
                      buttonText: 'Done',
                      color: primaryColor,
                    ),
                  )
                ],
              );
            }));
  }
}

class ExpenseListSection extends StatelessWidget {
  const ExpenseListSection({
    Key? key,
    required this.width,
  }) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    return context.watch<SalesProvider>().expenseList.isEmpty
        ? Center(
            child: Text(
              'No Records Yet',
              style: headline1.copyWith(
                  fontSize: 25, color: Color.fromARGB(255, 133, 133, 133)),
            ),
          )
        : ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: context.watch<SalesProvider>().expenseList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.05,
                ),
                child: ExpenseListItem(
                  item:
                      context.read<SalesProvider>().expenseList[index].itemName,
                  amount:
                      "${context.read<SalesProvider>().expenseList[index].price.toStringAsFixed(2)}",
                  date: context.read<SalesProvider>().expenseList[index].date ??
                      "",
                ),
              );
            });
  }
}

class ExpenseListItem extends StatelessWidget {
  final String item, amount, date;

  const ExpenseListItem({
    Key? key,
    required this.item,
    required this.amount,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 0),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            backgroundColor: primaryColor,
            radius: 17,
            child: Text(
              item.substring(0,1),
              style: bodyText2,
            ),
          ),
          title: Text(
            item.toTitleCase(),
            style: bodyText1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(date, style: bodyText1),
          trailing: Text("GHS $amount", style: bodyText1),
        ));
  }
}
