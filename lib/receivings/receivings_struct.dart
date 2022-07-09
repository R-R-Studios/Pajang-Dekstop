import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:beben_pos_desktop/core/core.dart';
import 'package:beben_pos_desktop/receivings/bloc/receivings_bloc.dart';
import 'package:beben_pos_desktop/receivings/model/cart_receivings_model.dart';
import 'package:beben_pos_desktop/utils/printer/printer_manager.dart';
import 'package:beben_pos_desktop/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ReceivingsStruct extends StatefulWidget {
  ReceivingsStruct(this.cartReceivings, this.receivingsBloc);

  final List<CartReceivingsModel> cartReceivings;
  final ReceivingsBloc receivingsBloc;

  @override
  _ReceivingsStructState createState() => _ReceivingsStructState();
}

class _ReceivingsStructState extends State<ReceivingsStruct> {
  late List<CartReceivingsModel> cartReceivings = widget.cartReceivings;
  var totalPayment = 0;
  final pdf = pw.Document();
  final doc = pw.Document();

  bool isPrinting = false;
  String outputDir = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // printToPdf();
    // CartReceivingsModel cart = CartReceivingsModel.fromJson(jsonDecode(
    //     "{\"id\":64,\"name\":\"Gudang Garam Filter 12\",\"code\":\"12FIM\",\"barcode\":\"RDSR001\",\"description\":\"Gudang Garam Filter 12 Batang\",\"unit_id\":2,\"sale_price\":380000,\"original_price\":380000,\"unit\":\"Slop\",\"qty\":10,\"total\":\"3800000\"}"));
    // for (int i = 0; i < 50; i++) {
    //   cartReceivings.add(cart);
    // }
    printPdfMultiPageNew();
  }

  String getTotalPayment() {
    double total = 0;
    for (CartReceivingsModel cart in cartReceivings) {
      total += double.parse(cart.total!);
    }

    return Core.converNumeric(total.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      color: Colors.grey[100],
      child: Column(
        children: [
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.4,
              padding: EdgeInsets.only(right: 5, left: 5, bottom: 10),
              child: Text(
                "Struk Barang Masuk",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.7,
                maxWidth: MediaQuery.of(context).size.width * 0.4,
              ),
              child: previewStruct(),
            ),
          )
        ],
      ),
    );
  }

  Widget tableRow() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              "Product",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              "Units",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              "Price",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              "Qty",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              "Total",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget tableRowToPrint() {
    return pw.Row(
      mainAxisSize: pw.MainAxisSize.max,
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Expanded(
          flex: 2,
          child: pw.Text(
            "Product",
            style: pw.TextStyle(
              fontSize: 10,
            ),
          ),
        ),
        pw.Expanded(
          flex: 1,
          child: pw.Text(
            "Units",
            style: pw.TextStyle(
              fontSize: 10,
            ),
          ),
        ),
        pw.Expanded(
          flex: 1,
          child: pw.Text(
            "Price",
            style: pw.TextStyle(
              fontSize: 10,
            ),
          ),
        ),
        pw.Expanded(
          flex: 1,
          child: pw.Text(
            "Qty",
            style: pw.TextStyle(
              fontSize: 10,
            ),
          ),
        ),
        pw.Expanded(
          flex: 1,
          child: pw.Text(
            "Total",
            style: pw.TextStyle(
              fontSize: 10,
            ),
          ),
        ),
      ],
    );
  }

  pw.Widget tableColumnToPrint(CartReceivingsModel cart) {
    return pw.Row(
      mainAxisSize: pw.MainAxisSize.max,
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Expanded(
          flex: 2,
          child: pw.Text(
            "${cart.name}",
            style: pw.TextStyle(
              fontSize: 10,
            ),
          ),
        ),
        pw.Expanded(
          flex: 1,
          child: pw.Text(
            "${cart.unitName}",
            style: pw.TextStyle(
              fontSize: 10,
            ),
          ),
        ),
        pw.Expanded(
          flex: 1,
          child: pw.Text(
            Core.converNumeric(cart.originalPrice.toString()),
            style: pw.TextStyle(
              fontSize: 10,
            ),
          ),
        ),
        pw.Expanded(
          flex: 1,
          child: pw.Text(
            "${cart.qty}",
            style: pw.TextStyle(
              fontSize: 10,
            ),
          ),
        ),
        pw.Expanded(
          flex: 1,
          child: pw.Text(
            Core.converNumeric(cart.total!),
            style: pw.TextStyle(
              fontSize: 10,
            ),
          ),
        ),
      ],
    );
  }

  pw.Widget tableColumnToPrintV2(CartReceivingsModel cart) {
    return pw.Padding(
      padding: pw.EdgeInsets.only(bottom: 4, left: 1, right: 1),
      child: pw.Column(
        mainAxisSize: pw.MainAxisSize.min,
        children: [
          pw.Align(
            alignment: pw.Alignment.centerLeft,
            child: pw.Row(
              mainAxisSize: pw.MainAxisSize.max,
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  "${cart.name}",
                  style: pw.TextStyle(
                    fontSize: 10,
                  ),
                ),
                pw.Text(
                  "${Core.converNumeric("${cart.total}")}",
                  style: pw.TextStyle(
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          pw.Align(
            alignment: pw.Alignment.centerLeft,
            child: pw.Text(
              "${cart.unitName} ${cart.qty} @ ${Core.converNumeric("${cart.originalPrice}")}",
              style: pw.TextStyle(
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget tableBottom() {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 4,
              child: Container(),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
                child: Text(
                  "Total Pembayaran :",
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
                child: Text(
                  getTotalPayment(),
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 4,
              child: Container(),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
                child: Text(
                  "Jenis Pembayaran :",
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
                child: Text(
                  "Cash",
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  pw.Widget tableBottomToPrint() {
    return pw.Column(
      children: [
        pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Padding(
            padding: pw.EdgeInsets.all(4),
            child: pw.Text(
              "Total : ${getTotalPayment()}",
              style: pw.TextStyle(
                fontSize: 10,
              ),
            ),
          ),
        ),
        pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Padding(
            padding: pw.EdgeInsets.all(4),
            child: pw.Text(
              "Cash",
              style: pw.TextStyle(
                fontSize: 10,
              ),
            ),
          ),
        ),
        pw.Container(
            padding: pw.EdgeInsets.only(top: 10),
            height: 60,
            width: 80,
            child: pw.BarcodeWidget(
              height: 60,
              width: 80,
              barcode: pw.Barcode.code128(),
              data: 'Invoice#',
              drawText: true,
            ))
      ],
    );
  }

  Widget barcodeStruct() {
    return Center(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 10, bottom: 4),
            child: Text("Barcode"),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.08,
            width: MediaQuery.of(context).size.width * 0.12,
            child: SfBarcodeGenerator(value: "RECV 10", showValue: true),
          )
        ],
      ),
    );
  }

  void setIsStruct(bool bool) {
    setState(() {
      widget.receivingsBloc.isStructController.sink.add(false);
    });
  }

  pw.Widget nameReceivingsStructToPrint() {
    return pw.Container(
      padding: pw.EdgeInsets.only(top: 10, bottom: 5),
      child: pw.Align(
        alignment: pw.Alignment.centerLeft,
        child: pw.Column(
          mainAxisSize: pw.MainAxisSize.max,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Container(
              child: pw.Text(
                "Receiving ID: RECV 10",
                style: pw.TextStyle(
                  fontSize: 10,
                ),
              ),
            ),
            pw.Container(
              child: pw.Text(
                "Employee: John Doe",
                style: pw.TextStyle(
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  pw.Widget headerReceivingsStructToPrint() {
    return pw.Center(
      child: pw.Column(
        children: [
          pw.Padding(
            padding: pw.EdgeInsets.only(bottom: 3),
            child: pw.Text(
              "Beben Pos Desktop",
              style: pw.TextStyle(
                fontSize: 14,
              ),
            ),
          ),
          pw.Text(
            "Jln. Riung Bagja 2B",
            style: pw.TextStyle(
              fontSize: 10,
            ),
          ),
          pw.Text(
            "0813-1246-5791",
            style: pw.TextStyle(
              fontSize: 10,
            ),
          ),
          pw.Padding(
            padding: pw.EdgeInsets.only(top: 10),
            child: pw.Text(
              "Receivings Receipt",
              style: pw.TextStyle(
                fontSize: 10,
              ),
            ),
          ),
          pw.Text(
            "10/01/2021 09:14:39",
            style: pw.TextStyle(
              fontSize: 10,
            ),
          )
        ],
      ),
    );
  }

  pw.Widget barcodeToPrint() {
    return pw.Center(
        child: pw.Container(
      width: 200,
      height: 50,
      child: pw.BarcodeWidget(
          barcode: pw.Barcode.pdf417(), data: "RECV 10", drawText: true),
    ));
  }

  pw.PageTheme _buildTheme(
      PdfPageFormat pageFormat, pw.Font base, pw.Font bold, pw.Font italic) {
    return pw.PageTheme(
      pageFormat: pageFormat,
      theme: pw.ThemeData.withFont(
        base: base,
        bold: bold,
        italic: italic,
      ),
    );
  }

  printPdfMultiPageNew() async {
    var downloadDir = await getTemporaryDirectory();
    outputDir = "${downloadDir.path}/struct.pdf";
    doc.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat(80 * PdfPageFormat.mm, 210 * PdfPageFormat.mm, marginLeft: 0.5 * PdfPageFormat.cm, marginRight: 0.5 * PdfPageFormat.cm),
        build: (context) => <pw.Widget>[
          headerReceivingsStructToPrint(),
          nameReceivingsStructToPrint(),
          // tableRowToPrint(),
          pw.Divider(thickness: 0.5),
          for (CartReceivingsModel cart in cartReceivings)
            tableColumnToPrintV2(cart),
          pw.Divider(thickness: 0.5),
          tableBottomToPrint(),
        ],
    ));

    final file = File(outputDir);
    await file.writeAsBytes(await doc.save());
  }

  printPdfNew() async {
    doc.addPage(pw.Page(
        pageFormat: PdfPageFormat.roll80,
        clip: false,
        build: (pw.Context context) {
          return pw.Container(
            width: 80 * PdfPageFormat.mm,
            child: pw.Column(children: [
              headerReceivingsStructToPrint(),
              nameReceivingsStructToPrint(),
              // tableRowToPrint(),
              pw.Divider(thickness: 0.5),
              for (CartReceivingsModel cart in cartReceivings)
                tableColumnToPrintV2(cart),
              pw.Divider(thickness: 0.5),
              tableBottomToPrint(),
            ]),
          );
        }));
    final output = await getTemporaryDirectory();
    final file = File('${output.path}/example.pdf');
    await file.writeAsBytes(await doc.save());
  }

  Map<String, PdfPageFormat> pageFormats = {"80mm": PdfPageFormat(8 * PdfPageFormat.cm, 20 * PdfPageFormat.cm, marginAll: 0.5 * PdfPageFormat.cm)};

  Widget previewStruct() {
    List<PdfPreviewAction> actions = [];
    actions.add(
      PdfPreviewAction(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: (context, callback, pageFormat) async {

          // setIsStruct(false);
          // PrinterManager().printerCommand(outputDir);
          // PrinterManager().checkPort();
          // PrinterManager().checkPortRange("192.168.0", 9100, 9102);
        },
      ),
    );
    return PdfPreview(
      canChangeOrientation: false,
      canChangePageFormat: false,
      pageFormats: pageFormats,
      canDebug: false,
      actions: actions,
      onPrinted: (context) {
        print("sukses");
      },
      maxPageWidth: MediaQuery.of(context).size.height * 0.5,
      build: (format) => doc.save(),
    );
  }



}
