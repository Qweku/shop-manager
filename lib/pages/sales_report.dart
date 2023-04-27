import 'dart:io';

import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
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
import 'package:shop_manager/models/GeneralProvider.dart';
import 'package:shop_manager/models/ShopModel.dart';
import 'package:shop_manager/pages/widgets/constants.dart';

class SalesReport extends StatefulWidget {
  final List<SalesModel> salesList;
  final String fromDate, toDate;
  const SalesReport(
      {Key? key,
      required this.salesList,
      required this.fromDate,
      required this.toDate})
      : super(key: key);

  @override
  State<SalesReport> createState() => _SalesReportState();
}

class _SalesReportState extends State<SalesReport> {
  ScreenshotController screenshotController = ScreenshotController();
  late Uint8List _imageFile;

  shareImage() async {
    String tempPath = (await getDownloadsDirectory())?.path ??
        ''; //(await getExternalStorageDirectory())?.path ?? '';
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
    String tempPath = (await DownloadsPathProvider.downloadsDirectory)?.path ?? '';
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
  Widget build(BuildContext context) {
    totalSales = 0.0;
    totalProfit = 0.0;
    widget.salesList.forEach((element) {
      element.products.forEach((item) {
        totalSales += item.sellingPrice * item.cartQuantity;
        totalProfit += (item.sellingPrice - item.costPrice) * item.cartQuantity;
      });
    });

    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: primaryColor,
        floatingActionButton: FloatingActionButton(
          onPressed: getPdf,
          backgroundColor: primaryColor,
          child: const Icon(Icons.save_alt, color: Colors.white),
        ),
        body: SizedBox(
          height: height,
          width: width,
          child: SafeArea(
              child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
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
                                    padding: EdgeInsets.all(width * 0.05),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Sales Report', style: headline1),
                                        Text(
                                            "${dateformat.format(DateTime.now())},  ${timeformat.format(DateTime.now())}"),
                                      ],
                                    )),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width * 0.05),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            context
                                                .read<GeneralProvider>()
                                                .shop
                                                .shopname
                                                .toString(),
                                            style:
                                                headline1.copyWith(fontSize: 20)),
                                        Image.asset(
                                          'assets/app_icon.png',
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
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text('From:',
                                                    style: bodyText1.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Text(
                                                  widget.fromDate,
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
                                                Text('To:',
                                                    style: bodyText1.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Text(widget.toDate,
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
                                                Text('Total Profit:',
                                                    style: bodyText1.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Text(
                                                  "GHS ${totalProfit.toStringAsFixed(2)}",
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
                                                    "GHS ${totalSales.toStringAsFixed(2)}",
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
                                      child: widget.salesList.isEmpty
                                          ? Center(
                                              child: Text("No Records",
                                                  style: headline1.copyWith(
                                                      color: Colors.grey)))
                                          : ListView(
                                              reverse: true,
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              children: List.generate(
                                                  widget.salesList.length,
                                                  (index) => SummaryListItem(
                                                      salesModel: widget
                                                          .salesList[index])))),
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
                child: Text(
                    salesModel.products[index].productName!.toTitleCase(),
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
