//
// import 'dart:convert';
// import 'dart:io';
// import 'dart:typed_data';
//
// import 'package:beben_pos_desktop/core/core.dart';
// import 'package:beben_pos_desktop/db/product_db.dart';
// import 'package:beben_pos_desktop/receivings/model/cart_receivings_model.dart';
// import 'package:flutter/services.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
// import 'package:process_run/shell.dart';
//
// class PrinterManager {
//
//   String outputDir = "";
//   final doc = pw.Document();
//
//   Future<String> printReceivingsStruct(List<CartReceivingsModel> cartReceivings, double totalBelanja, double customerMoney, String kembalian, String trxCode) async {
//     var downloadDir = await getTemporaryDirectory();
//     outputDir = "${downloadDir.path}/struct.p634978155797"
//         "df";
//     doc.addPage(pw.MultiPage(
//       pageFormat: PdfPageFormat(72 * PdfPageFormat.mm, 210 * PdfPageFormat.mm),
//       build: (context) => <pw.Widget>[
//         headerReceivingsStructToPrint(),
//         nameReceivingsStructToPrint(trxCode),
//         // tableRowToPrint(),
//         pw.Divider(thickness: 0.5),
//         for (CartReceivingsModel cart in cartReceivings)
//           tableColumnToPrintV2(cart),
//         pw.Divider(thickness: 0.5),
//         tableBottomToPrintReceivings(cartReceivings, totalBelanja, customerMoney, kembalian),
//       ],
//     ));
//
//     final file = File(outputDir);
//     await file.writeAsBytes(await doc.save());
//     return outputDir;
//   }
//   Future<String> printReceivingsStructV2(List<CartReceivingsModel> cartReceivings, double totalBelanja, String trxCode) async {
//     var downloadDir = await getTemporaryDirectory();
//     outputDir = "${downloadDir.path}/struct.p634978155797"
//         "df";
//     doc.addPage(pw.MultiPage(
//       pageFormat: PdfPageFormat(72 * PdfPageFormat.mm, 210 * PdfPageFormat.mm),
//       build: (context) => <pw.Widget>[
//         headerReceivingsStructToPrint(),
//         nameReceivingsStructToPrint(trxCode),
//         // tableRowToPrint(),
//         pw.Divider(thickness: 0.5),
//         for (CartReceivingsModel cart in cartReceivings)
//           tableColumnToPrintV2(cart),
//         pw.Divider(thickness: 0.5),
//         tableBottomToPrintReceivingsV2(cartReceivings, totalBelanja, trxCode),
//       ],
//     ));
//
//     final file = File(outputDir);
//     await file.writeAsBytes(await doc.save());
//     return outputDir;
//   }
//   Future<String> printTransactionStruct(List<ProductModel> allProducts, double totalBelanja, double customerMoney, String kembalian, String trxCode) async {
//     var downloadDir = await getTemporaryDirectory();
//     outputDir = "${downloadDir.path}/struct_transaction.pdf";
//     doc.addPage(pw.MultiPage(
//       pageFormat: PdfPageFormat(72 * PdfPageFormat.mm, 210 * PdfPageFormat.mm),
//       build: (context) => <pw.Widget>[
//         headerReceivingsStructToPrint(),
//         // nameReceivingsStructToPrint(trxCode),
//         // tableRowToPrint(),
//         pw.Divider(thickness: 0.5),
//         for (ProductModel cart in allProducts)
//           tableColumnToPrintTransaction(cart),
//         pw.Divider(thickness: 0.5),
//         tableBottomToPrintTransaction(totalBelanja, customerMoney, kembalian),
//       ],
//     ));
//
//     final file = File(outputDir);
//     await file.writeAsBytes(await doc.save());
//     return outputDir;
//   }
//
//   pw.Widget headerReceivingsStructToPrint() {
//     return pw.Center(
//       child: pw.Column(
//         children: [
//           pw.Padding(
//             padding: pw.EdgeInsets.only(bottom: 3),
//             child: pw.Text(
//               "Beben Pos Desktop",
//               style: pw.TextStyle(
//                 fontSize: 14,
//               ),
//             ),
//           ),
//           pw.Text(
//             "Jln. Riung Bagja 2B",
//             style: pw.TextStyle(
//               fontSize: 10,
//             ),
//           ),
//           pw.Text(
//             "0813-1246-5791",
//             style: pw.TextStyle(
//               fontSize: 10,
//             ),
//           ),
//           pw.Padding(
//             padding: pw.EdgeInsets.only(top: 10),
//             child: pw.Text(
//               "Receivings Receipt",
//               style: pw.TextStyle(
//                 fontSize: 10,
//               ),
//             ),
//           ),
//           pw.Text(
//             "10/01/2021 09:14:39",
//             style: pw.TextStyle(
//               fontSize: 10,
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//   pw.Widget nameReceivingsStructToPrint(String trxCode) {
//     return pw.Container(
//       padding: pw.EdgeInsets.only(top: 10, bottom: 5),
//       child: pw.Align(
//         alignment: pw.Alignment.centerLeft,
//         child: pw.Column(
//           mainAxisSize: pw.MainAxisSize.max,
//           crossAxisAlignment: pw.CrossAxisAlignment.start,
//           children: [
//             pw.Container(
//               child: pw.Text(
//                 "Transaction Code: $trxCode",
//                 style: pw.TextStyle(
//                   fontSize: 10,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   pw.Widget tableColumnToPrintV2(CartReceivingsModel cart) {
//     return pw.Padding(
//       padding: pw.EdgeInsets.only(bottom: 4, left: 1, right: 1),
//       child: pw.Column(
//         mainAxisSize: pw.MainAxisSize.min,
//         children: [
//           pw.Align(
//             alignment: pw.Alignment.centerLeft,
//             child: pw.Row(
//               mainAxisSize: pw.MainAxisSize.max,
//               mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//               children: [
//                 pw.Text(
//                   "${cart.name}",
//                   style: pw.TextStyle(
//                     fontSize: 10,
//                   ),
//                 ),
//                 pw.Text(
//                   "${Core.converNumeric("${cart.total}")}",
//                   style: pw.TextStyle(
//                     fontSize: 10,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           pw.Align(
//             alignment: pw.Alignment.centerLeft,
//             child: pw.Text(
//               "${cart.unitName} ${cart.qty} @ ${Core.converNumeric("${cart.originalPrice}")}",
//               style: pw.TextStyle(
//                 fontSize: 10,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   pw.Widget tableColumnToPrintTransaction(ProductModel cart) {
//     return pw.Padding(
//       padding: pw.EdgeInsets.only(bottom: 4, left: 1, right: 1),
//       child: pw.Column(
//         mainAxisSize: pw.MainAxisSize.min,
//         children: [
//           pw.Align(
//             alignment: pw.Alignment.centerLeft,
//             child: pw.Row(
//               mainAxisSize: pw.MainAxisSize.max,
//               mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//               children: [
//                 pw.Text(
//                   "${cart.itemName}",
//                   style: pw.TextStyle(
//                     fontSize: 10,
//                   ),
//                 ),
//                 pw.Text(
//                   "${Core.converNumeric("${cart.total}")}",
//                   style: pw.TextStyle(
//                     fontSize: 10,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           pw.Align(
//             alignment: pw.Alignment.centerLeft,
//             child: pw.Text(
//               "${cart.itemName} ${cart.quantity} @ ${Core.converNumeric("${cart.price}")}",
//               style: pw.TextStyle(
//                 fontSize: 10,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   pw.Widget tableBottomToPrintReceivings(List<CartReceivingsModel> cartReceivings, double totalBelanja, double customerMoney, String kembalian) {
//     return pw.Column(
//       children: [
//         pw.Align(
//           alignment: pw.Alignment.centerRight,
//           child: pw.Padding(
//             padding: pw.EdgeInsets.all(4),
//             child: pw.Text(
//               "Total Belanja : ${Core.converNumeric("$totalBelanja")}",
//               style: pw.TextStyle(
//                 fontSize: 10,
//               ),
//             ),
//           ),
//         ),
//         pw.Align(
//           alignment: pw.Alignment.centerRight,
//           child: pw.Padding(
//             padding: pw.EdgeInsets.all(4),
//             child: pw.Text(
//               "Total Bayar : ${Core.converNumeric("$customerMoney")}",
//               style: pw.TextStyle(
//                 fontSize: 10,
//               ),
//             ),
//           ),
//         ),
//         pw.Align(
//           alignment: pw.Alignment.centerRight,
//           child: pw.Padding(
//             padding: pw.EdgeInsets.all(4),
//             child: pw.Text(
//               "Kembalian : ${Core.converNumeric(kembalian)}",
//               style: pw.TextStyle(
//                 fontSize: 10,
//               ),
//             ),
//           ),
//         ),
//         pw.Container(
//             padding: pw.EdgeInsets.only(top: 10),
//             height: 60,
//             width: 80,
//             child: pw.BarcodeWidget(
//               height: 60,
//               width: 80,
//               barcode: pw.Barcode.code128(useCode128B: true),
//               data: 'Invoice#',
//               drawText: true,
//             ))
//       ],
//     );
//   }
//   pw.Widget tableBottomToPrintReceivingsV2(List<CartReceivingsModel> cartReceivings, double totalBelanja, String trxCode) {
//     return pw.Column(
//       children: [
//         pw.Align(
//           alignment: pw.Alignment.centerRight,
//           child: pw.Padding(
//             padding: pw.EdgeInsets.all(4),
//             child: pw.Text(
//               "Total Belanja : ${Core.converNumeric("$totalBelanja")}",
//               style: pw.TextStyle(
//                 fontSize: 10,
//               ),
//             ),
//           ),
//         ),
//         pw.Container(
//             padding: pw.EdgeInsets.only(top: 10),
//             height: 60,
//             width: 80,
//             child: pw.BarcodeWidget(
//               height: 60,
//               width: 80,
//               barcode: pw.Barcode.code128(useCode128B: true),
//               data: '$trxCode',
//               drawText: true,
//             ))
//       ],
//     );
//   }
//   pw.Widget tableBottomToPrintTransaction(double totalBelanja, double customerMoney, String kembalian) {
//     return pw.Column(
//       children: [
//         pw.Align(
//           alignment: pw.Alignment.centerRight,
//           child: pw.Padding(
//             padding: pw.EdgeInsets.all(4),
//             child: pw.Text(
//               "Total Belanja : ${Core.converNumeric("$totalBelanja")}",
//               style: pw.TextStyle(
//                 fontSize: 10,
//               ),
//             ),
//           ),
//         ),
//         pw.Align(
//           alignment: pw.Alignment.centerRight,
//           child: pw.Padding(
//             padding: pw.EdgeInsets.all(4),
//             child: pw.Text(
//               "Total Bayar : ${Core.converNumeric("$customerMoney")}",
//               style: pw.TextStyle(
//                 fontSize: 10,
//               ),
//             ),
//           ),
//         ),
//         pw.Align(
//           alignment: pw.Alignment.centerRight,
//           child: pw.Padding(
//             padding: pw.EdgeInsets.all(4),
//             child: pw.Text(
//               "Kembalian : ${Core.converNumeric(kembalian)}",
//               style: pw.TextStyle(
//                 fontSize: 10,
//               ),
//             ),
//           ),
//         ),
//         pw.Container(
//             padding: pw.EdgeInsets.only(top: 10),
//             height: 60,
//             width: 80,
//             child: pw.BarcodeWidget(
//               height: 60,
//               width: 80,
//               barcode: pw.Barcode.code128(useCode128B: true),
//               data: 'Invoice#',
//               drawText: true,
//             ))
//       ],
//     );
//   }
//
//   String getTotalPayment(List<CartReceivingsModel> cartReceivings) {
//     double total = 0;
//     for (CartReceivingsModel cart in cartReceivings) {
//       total += double.parse(cart.total??"0");
//     }
//
//     return Core.converNumeric(total.toString());
//   }
//
//   printerCommand(String outputDir) async {
//     String printCommand = "lp $outputDir";
//     String cancelCommand = "cancel -a";
//
//     var shell = Shell();
//     //
//     try{
//       await shell.run(cancelCommand);
//       await shell.run(printCommand);
//     }catch(e){
//       print("error $e");
//     }
//   }
//
// }