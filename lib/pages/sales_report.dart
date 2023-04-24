import 'dart:io';


import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:shop_manager/models/ShopModel.dart';
import 'package:shop_manager/pages/widgets/constants.dart';

class SalesReport extends StatefulWidget {
  final SalesModel salesModel;
  const SalesReport({Key? key,  required this.salesModel}): super(key: key);


  @override
  State<SalesReport> createState() => _SalesReportState();
}

class _SalesReportState extends State<SalesReport> {
 
  ScreenshotController screenshotController = ScreenshotController();
  late Uint8List _imageFile;
  

  shareImage() async {
    String tempPath = (await getDownloadsDirectory())?.path ?? '';//(await getExternalStorageDirectory())?.path ?? '';
    String fileName = "sales-report";
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    _imageFile = (await screenshotController.capture())!;

    if (await Permission.storage.request().isGranted) {
      File file = await File('$tempPath/$fileName.png');
      file.writeAsBytesSync(_imageFile);
      await Share.shareFiles([file.path]);
      scaffoldMessenger.showSnackBar(SnackBar(
        content: Text("Share result: ${file}"),
      ));
    }
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
    String tempPath = (await getDownloadsDirectory())?.path ?? '';//(await getApplicationDocumentsDirectory()).path;
    String fileName = "mytransactionFile";
    if (await Permission.storage.request().isGranted) {
      File pdfFile = File('$tempPath/$fileName.pdf');
      pdfFile.writeAsBytes(await pdf.save());
      scaffoldMessenger.showSnackBar(SnackBar(
        content: Text("File Saved: $pdfFile"),
      ));
    }
  }

 

  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: primaryColor,
        // floatingActionButton:
        // Column(
        //   mainAxisAlignment: MainAxisAlignment.end,
        //   children: [
        //     FloatingActionButton(
        //       onPressed: () => shareImage(),
        //       backgroundColor: primaryColorLight,
        //       child: const Icon(Icons.share, color: Colors.white),
        //     ),
        //     SizedBox(height: height * 0.02),
        //     FloatingActionButton(
        //       onPressed: getPdf,
        //       backgroundColor: primaryColorLight,
        //       child: const Icon(Icons.save_alt, color: Colors.white),
        //     ),
        //   ],
        // ),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                  padding: EdgeInsets.all(width * 0.03),
                                  child: Text(
                                      "${dateformat.format(DateTime.now())},  ${timeformat.format(DateTime.now())}")),
                              Padding(
                                padding: EdgeInsets.all(width * 0.05),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          "ShopMate",
                                          style:
                                              headline1.copyWith(fontSize: 20)),
                                      Image.asset(
                                        'assets/app_logo.png',
                                        width: width * 0.15,
                                      ),
                                    ]),
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
                                      child: Text('Transactions',
                                          style: headline1),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Total Credit:',
                                                  style: bodyText1.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text(
                                                 "GHS 20.00",
                                                  style: bodyText1),
                                            ],
                                          ),
                                          SizedBox(
                                            height: height * 0.01,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Total Debit:',
                                                  style: bodyText1.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text(
                                               "GHS 10.00",
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
                                              Text('Total Sales:',
                                                  style: bodyText1.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text(
                                                  "GHS 1200.00",
                                                  style: bodyText1),
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
                                    Expanded(
                                        child: Text('Items',
                                            style: bodyText1.copyWith(
                                                fontWeight: FontWeight.bold))),
                                    Expanded(
                                        child: Text('Date',
                                            style: bodyText1.copyWith(
                                                fontWeight: FontWeight.bold))),
                                    Expanded(
                                        child: Text('Transaction Type',
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
                                    child: ListView(
                                                  reverse: true,
                                                    shrinkWrap: true,
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    children: List.generate(
                                                        5,
                                                        (index) =>
                                                            SummaryListItem(
                                                              item: "",
                                                              date:
                                                                  "",
                                                              transactionType:
                                                                 "",
                                                              amount:"",
                                                              expenseOrIncome:
                                                                 "",
                                                            )))
                                            ),
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
                                      'Net Total:   GHS 1200.00',
                                      style: bodyText1.copyWith(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold)),
                                ),
                              )
                            ]),
                      ),
                    ),
                  )
                ],
              ),
              Positioned(
                bottom: height * 0.05,
                left: width * 0.05,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () => shareImage(),
                      child: CircleAvatar(
                          radius: 25,
                          backgroundColor: primaryColorLight,
                          child: const Icon(Icons.share, color: Colors.white)),
                    ),
                    SizedBox(height: height * 0.02),
                    GestureDetector(
                      onTap: getPdf,
                      child: CircleAvatar(
                          radius: 25,
                          backgroundColor: primaryColorLight,
                          child:
                              const Icon(Icons.save_alt, color: Colors.white)),
                    ),
                  ],
                ),
              )
            ],
          )),
        ));
  }
}

class SummaryListItem extends StatelessWidget {
  final String item, amount, expenseOrIncome, date, transactionType;

  const SummaryListItem({
    Key? key,
    required this.item,
    required this.amount,
    required this.expenseOrIncome,
    required this.date,
    required this.transactionType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(child: Text(item.toTitleCase(), style: bodyText1)),
          Expanded(child: Text(date, style: bodyText1)),
          Expanded(
              child: Text(transactionType,
                  textAlign: TextAlign.center, style: bodyText1)),
          Expanded(
              child: Text(
                  '${expenseOrIncome == 'credit' ? '+' : "-"}GHS $amount',
                  textAlign: TextAlign.right,
                  style: bodyText1)),
        ],
      ),
    );
  }
}