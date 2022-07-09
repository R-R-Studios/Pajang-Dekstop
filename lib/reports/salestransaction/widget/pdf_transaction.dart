
import 'dart:io';
import 'package:beben_pos_desktop/core/core.dart';
import 'package:beben_pos_desktop/reports/salestransaction/model/report_transaction.dart';
import 'package:beben_pos_desktop/sales/widget/pdf_sales.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

class PDFTransaction {

  static Future<File> generatePDFTransaction(String startDate, String endDate, List<ReportTransaction> transactions, String merchantName) async {
    final pdf = Document();
    pdf.addPage(MultiPage(
      build: (context) => [
        buildHeader(
          merchantName: merchantName,
          startDate: startDate,
          endDate: endDate,
        ),
        SizedBox(height: 0.05 * PdfPageFormat.cm),
        Divider(),
        buildInvoice(transactions),
        Divider(),
        buildTotal(transactions),
      ],
      footer: (context) => buildFooter(),
    ));

    return await PdfSales.saveDocument(name: "SALES_"+startDate+"_"+endDate+".pdf", pdf: pdf);
  }

  static Widget buildTotal(List<ReportTransaction> transactions) {
    double subtotal = 0;
    double total = 0;

    for (int a = 0; a<transactions.length;a++){
      double allTotalSalePrice = double.parse(transactions[a].totalTransaction ?? "0");
      subtotal += allTotalSalePrice;
    }
    for (int a = 0; a<transactions.length;a++){
      double allTotalSalePrice = double.parse(transactions[a].totalTransaction ?? "0");
      total += allTotalSalePrice;
    }

    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Spacer(flex: 6),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildText(
                  title: 'Sub Total',
                  value: '${Core.converNumeric(subtotal.toString())}',
                  titleStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  unite: true,
                ),
                // buildText(
                //   title: 'Diskon',
                //   titleStyle: TextStyle(
                //     fontSize: 12,
                //     fontWeight: FontWeight.bold,
                //   ),
                //   value: GlobalFunctions.formatPriceDouble(0),
                //   unite: true,
                // ),
                Divider(),
                buildText(
                  title: 'Total',
                  titleStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  value: '${Core.converNumeric(total.toString())}',
                  unite: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildHeader({required String merchantName, required String startDate, required String endDate}) =>
      Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              buildCustomerAddress(merchantName, startDate, endDate),
            ],
          )
      );

  static Widget buildCustomerAddress(String name, String startDate, String endDate) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: pw.MainAxisAlignment.center,
      children: [
        Text('Laporan Transaksi', style: TextStyle(fontWeight: FontWeight.bold)),
        Text('$name', style: TextStyle(fontWeight: FontWeight.bold)),
        Text('Print mulai tanggal : $startDate , sampai tanggal : $endDate'),
        SizedBox(height: 1 * PdfPageFormat.cm),
      ],
    );
  }

  static buildInvoice(List<ReportTransaction> transactions) {
    final headers = [
      'Tanggal',
      'Kode Transaksi',
      'Tipe',
      'Pembayaran',
      '',
      'Total',
      'Total Pembayaran'
    ];
    final data = transactions.map((item) {
      return [
        '${item.date}',
        '${item.transactionCode}',
        '${item.type}',
        '${item.payment}',
        '${Core.converNumeric(item.totalTransaction ?? "0")}',
        '',
        '${Core.converNumeric(item.totalPayment ?? "0")}',
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 10),
      headerDecoration: BoxDecoration(color: PdfColors.grey300),
      cellStyle: TextStyle(fontSize: 8),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerLeft,
        2: Alignment.centerLeft,
        3: Alignment.centerLeft,
        4: Alignment.center,
        5: Alignment.centerRight,
        6: Alignment.centerRight
      },
    );
  }

  static Widget buildFooter() => Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Divider(),
      SizedBox(height: 2 * PdfPageFormat.mm),
    ],
  );

  static buildSimpleText({
    required String title,
    required String value,
  }) {
    final style = TextStyle(fontWeight: FontWeight.bold);
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        Text(title, style: style),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(value),
      ],
    );
  }

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }
}