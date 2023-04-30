import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:shop_manager/models/GeneralProvider.dart';
import 'package:shop_manager/models/ShopModel.dart';
import 'package:shop_manager/pages/widgets/constants.dart';

class SalesReceipt extends StatefulWidget {
  final SalesModel sales;

  const SalesReceipt({
    Key? key,
    required this.sales,
  }) : super(key: key);

  @override
  State<SalesReceipt> createState() => _SalesReceiptState();
}

class _SalesReceiptState extends State<SalesReceipt> {
  ScreenshotController screenshotController = ScreenshotController();
  late Uint8List _imageFile;
  FirebaseAuth auth = FirebaseAuth.instance;
  String? shopEmail;
  Future getShopEmail() async {
    shopEmail = auth.currentUser!.email;
  }

  shareImage() async {
    String tempPath = ( Directory('/storage/emulated/0/Download')).path; //(await getExternalStorageDirectory())?.path ?? '';
    String fileName = "sales-report";
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    _imageFile = (await screenshotController.capture())!;

    //if (await Permission.storage.request().isGranted) {
    File file =  File('$tempPath/$fileName.png');
    file.writeAsBytesSync(_imageFile);
   await Share.shareFiles([file.path]);
    scaffoldMessenger.showSnackBar(SnackBar(
      content: Text("Share result: $file"),
    ));
    //}
  }

  Future getPdf() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final screenShot = (await screenshotController.capture())!;
    pw.Document pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Expanded(
              child:
                  pw.Image(pw.MemoryImage(screenShot), fit: pw.BoxFit.contain));
        },
      ),
    );
    String tempPath =
        (await Directory('/storage/emulated/0/Download')).path;
    String fileName = "my-sales-report" + "${DateTime.now().microsecond}";
    //if (await Permission.storage.request().isGranted) {
    File pdfFile = File('$tempPath/$fileName.pdf');
    pdfFile.writeAsBytes(await pdf.save());
    scaffoldMessenger.showSnackBar(SnackBar(
      content: Text("File Saved: $pdfFile"),
    ));
    // }
  }

  double totalSales = 0.0;
  double totalProfit = 0.0;

  @override
  void initState() {
    getShopEmail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    totalSales = 0.0;
    totalProfit = 0.0;
    widget.sales.products.forEach(
      (element) {
        totalSales += element.sellingPrice * element.cartQuantity;
      },
    );

    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: primaryColor,
        floatingActionButton: FloatingActionButton(
          onPressed: shareImage,
          backgroundColor: primaryColor,
          child: const Icon(Icons.share, color: Colors.white),
        ),
        body: SizedBox(
          height: height,
          width: width,
          child: SafeArea(
              child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Screenshot(
                      controller: screenshotController,
                      child: Container(
                        decoration: BoxDecoration(color: Colors.white),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 50),
                              Text(
                                  context
                                      .read<GeneralProvider>()
                                      .shop
                                      .shopname
                                      .toString()
                                      .toUpperCase(),
                                  style: headline1.copyWith(fontSize: 30)),
                              Padding(
                                  padding: EdgeInsets.all(width * 0.05),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text('contact: +233246013840',
                                          style: bodyText1),
                                      Text('email: $shopEmail',
                                          style: bodyText1),
                                    ],
                                  )),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.05),
                                child: Text("Receipt",
                                    style: headline1.copyWith(fontSize: 25)),
                              ),
                              SizedBox(height: height * 0.03),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.05),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Date:',
                                                  style: bodyText1.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text(
                                                widget.sales.date!,
                                                style: bodyText1,
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: height * 0.01,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Receipt No.:',
                                                  style: bodyText1.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text(
                                                  "000" +
                                                      "${widget.sales.accId}",
                                                  style: bodyText1),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 30),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Total:',
                                                  style: bodyText1.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text(
                                                "GHS ${totalSales.toStringAsFixed(2)}",
                                                style: bodyText1,
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: height * 0.01,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('',
                                                  style: bodyText1.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text("", style: bodyText1),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: height * 0.05),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: height * 0.01,
                                    horizontal: width * 0.05),
                                color: Color.fromARGB(255, 197, 196, 196),
                                child: Row(
                                  children: [
                                    // Expanded(
                                    //     child: Text('No.',
                                    //         style: bodyText1.copyWith(
                                    //             fontWeight: FontWeight.bold))),
                                    Expanded(
                                        child: Text('Items',
                                            //textAlign: TextAlign.center,
                                            style: bodyText1.copyWith(
                                                fontWeight: FontWeight.bold))),
                                    Expanded(
                                        child: Text('Date',
                                            textAlign: TextAlign.center,
                                            style: bodyText1.copyWith(
                                                fontWeight: FontWeight.bold))),
                                    Expanded(
                                        child: Text('Quantity',
                                            textAlign: TextAlign.center,
                                            style: bodyText1.copyWith(
                                                fontWeight: FontWeight.bold))),
                                    Expanded(
                                        child: Text('Amount',
                                            textAlign: TextAlign.right,
                                            style: bodyText1.copyWith(
                                                fontWeight: FontWeight.bold))),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(width * 0.05),
                                child: SizedBox(
                                    // height: height * 0.7,
                                    child: widget.sales.products.isEmpty
                                        ? Center(
                                            child: Text("No Records",
                                                style: headline1.copyWith(
                                                    color: Colors.grey)))
                                        : SummaryListItem(
                                            salesModel: widget.sales)),
                              ),
                              Divider(
                                color: Colors.grey,
                                height: height * 0.05,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.05),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                      'Net Total:   GHS ${totalSales.toStringAsFixed(2)}',
                                      style: bodyText1.copyWith(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                ),
                              )
                            ]),
                      ),
                    ),
                  )
                ],
              ),
            ],
          )),
        ));
  }
}

class SummaryListItem extends StatelessWidget {
  final SalesModel salesModel;

  const SummaryListItem({
    Key? key,
    required this.salesModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        children: List.generate(
      salesModel.products.length,
      (index) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            // Expanded(child: Text("${index + 1}", style: bodyText1)),
            Expanded(
                child:
                    Text(salesModel.products[index].productName!.toTitleCase(),
                        // textAlign: TextAlign.center,
                        style: bodyText1)),
            Expanded(
                child: Text(salesModel.date!,
                    textAlign: TextAlign.center, style: bodyText1)),
            Expanded(
                child: Text(salesModel.products[index].cartQuantity.toString(),
                    textAlign: TextAlign.center, style: bodyText1)),
            Expanded(
                child: Text(
                    salesModel.products[index].sellingPrice.toStringAsFixed(2),
                    textAlign: TextAlign.right,
                    style: bodyText1)),
          ],
        ),
      ),
    ));
  }
}
