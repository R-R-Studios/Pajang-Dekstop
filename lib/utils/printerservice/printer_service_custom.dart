import 'package:beben_pos_desktop/core/core.dart';
import 'package:beben_pos_desktop/core/fireship/fireship_encrypt.dart';
import 'package:beben_pos_desktop/db/product_db.dart';
import 'package:beben_pos_desktop/receivings/model/cart_receivings_model.dart';
import 'package:flutter_esc_pos_network/flutter_esc_pos_network.dart';
import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';

class PrinterServiceCustom {
  static Future printSales(
      List<ProductModel> list,
      double totalPayment,
      double customerMoney,
      String cashback,
      String trxCode,
      String merchantName) async {
    var ticket = await PrinterServiceCustom.structSales(
        list, totalPayment, customerMoney, cashback, trxCode, merchantName);
    PrinterServiceCustom.connectPrint(ticket);
  }

  static Future printReceivings(List<CartReceivingsModel> list,
      double totalPayment, String trxCode) async {
    var ticket = await PrinterServiceCustom.structReceivings(
        list, totalPayment, trxCode);
    PrinterServiceCustom.connectPrint(ticket);
  }

  static Future connectPrint(List<int> ticket) async {
    var initialAddress = await FireshipCrypt().getPrinterAddress();
    print("initialAddress $initialAddress");
    final printer = PrinterNetworkManager(initialAddress);
    var connect = await printer.connect();
    print("PrinterNetworkManager ${connect.msg}");
    if (connect == PosPrintResult.success) {
      PosPrintResult printing = await printer.printTicket(ticket);
      print(printing.msg);
      printer.disconnect();
    } else if (connect == PosPrintResult.timeout) {
      print("PosPrintResult.timeout");
    }
  }

  static Future<List<int>> structReceivings(
      List<CartReceivingsModel> allProducts,
      double totalBelanja,
      String trxCode) async {
    List<int> bytes = [];
    var date = DateTime.now();
    var hour = date.hour < 10 ? "0${date.hour}" : "${date.hour}";
    var minute = date.minute < 10 ? "0${date.minute}" : "${date.minute}";
    var second = date.second < 10 ? "0${date.second}" : "${date.second}";
    var strDate =
        "${date.day}/${date.month}/${date.year} $hour:$minute:$second";
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);

    //header
    bytes += generator.row(
      [
        PosColumn(
            text: "",
            width: 3,
            styles: PosStyles(
                align: PosAlign.left, height: PosTextSize.size2, bold: true)),
        PosColumn(
            text: "Pajang Desktop",
            width: 6,
            styles: PosStyles(
                align: PosAlign.center, height: PosTextSize.size2, bold: true)),
        PosColumn(text: "", width: 3, styles: PosStyles(align: PosAlign.right)),
      ],
    );
    bytes += generator.row(
      [
        PosColumn(
            text: "",
            width: 3,
            styles: PosStyles(
                align: PosAlign.center, height: PosTextSize.size2, bold: true)),
        PosColumn(
            text: strDate,
            width: 6,
            styles:
                PosStyles(align: PosAlign.center, height: PosTextSize.size1)),
        PosColumn(text: "", width: 3, styles: PosStyles(align: PosAlign.right)),
      ],
    );
    bytes += generator.emptyLines(1);

    if (trxCode.isNotEmpty) {
      bytes += generator.text("No. Transaksi : $trxCode",
          styles: PosStyles(align: PosAlign.left, height: PosTextSize.size1));
    }

    bytes += generator.hr(ch: "-");
    bytes += generator.row([
      PosColumn(
        text: "Nama Barang",
        width: 6,
        styles: PosStyles(
            align: PosAlign.left, height: PosTextSize.size1, bold: true),
      ),
      PosColumn(
        text: "Harga",
        width: 6,
        styles: PosStyles(
            align: PosAlign.right, height: PosTextSize.size1, bold: true),
      ),
    ]);
    bytes += generator.hr(ch: "-");
    for (int i = 0; i < allProducts.length; i++) {
      var product = allProducts[i];
      bytes += generator.row([
        PosColumn(
            text: product.name ?? "-",
            width: 6,
            styles: PosStyles(align: PosAlign.left, height: PosTextSize.size1)),
        PosColumn(
            text: Core.converNumeric("${product.total ?? 0}"),
            width: 6,
            styles: PosStyles(align: PosAlign.right)),
      ]);
      int qty = product.qty!.toInt();
      bytes += generator.text(
          "${product.unitName} $qty @ ${Core.converNumeric("${product.originalPrice}")}",
          styles: PosStyles(align: PosAlign.left, height: PosTextSize.size1));
      if (i != allProducts.length - 1) {
        bytes += generator.emptyLines(1);
      }
    }
    bytes += generator.hr(ch: "-");
    bytes += generator.row([
      PosColumn(
        text: "",
        width: 6,
      ),
      PosColumn(
          text: "Total : ${Core.converNumeric("$totalBelanja")}",
          width: 6,
          styles: PosStyles(align: PosAlign.right, height: PosTextSize.size1)),
    ]);

    bytes += generator.feed(2);
    bytes += generator.cut();
    return bytes;
  }

  static Future<List<int>> structSales(
      List<ProductModel> allProducts,
      double totalBelanja,
      double customerMoney,
      String kembalian,
      String trxCode,
      String merchantName) async {
    List<int> bytes = [];
    var date = DateTime.now();
    var hour = date.hour < 10 ? "0${date.hour}" : "${date.hour}";
    var minute = date.minute < 10 ? "0${date.minute}" : "${date.minute}";
    var second = date.second < 10 ? "0${date.second}" : "${date.second}";
    var strDate =
        "${date.day}/${date.month}/${date.year} $hour:$minute:$second";
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);

    //header
    bytes += generator.row(
      [
        PosColumn(
            text: "",
            width: 3,
            styles: PosStyles(
                align: PosAlign.left, height: PosTextSize.size2, bold: true)),
        PosColumn(
            text: "Pajang Desktop",
            width: 6,
            styles: PosStyles(
                align: PosAlign.center, height: PosTextSize.size2, bold: true)),
        PosColumn(text: "", width: 3, styles: PosStyles(align: PosAlign.right)),
      ],
    );
    bytes += generator.row(
      [
        PosColumn(
            text: "",
            width: 3,
            styles: PosStyles(
                align: PosAlign.left, height: PosTextSize.size2, bold: true)),
        PosColumn(
            text: merchantName,
            width: 6,
            styles: PosStyles(
                align: PosAlign.center, height: PosTextSize.size1, bold: true)),
        PosColumn(text: "", width: 3, styles: PosStyles(align: PosAlign.right)),
      ],
    );
    bytes += generator.row(
      [
        PosColumn(
            text: "",
            width: 3,
            styles: PosStyles(
                align: PosAlign.center, height: PosTextSize.size2, bold: true)),
        PosColumn(
            text: strDate,
            width: 6,
            styles:
                PosStyles(align: PosAlign.center, height: PosTextSize.size1)),
        PosColumn(text: "", width: 3, styles: PosStyles(align: PosAlign.right)),
      ],
    );
    bytes += generator.emptyLines(1);

    if (trxCode.isNotEmpty) {
      bytes += generator.text("No. Transaksi : $trxCode",
          styles: PosStyles(align: PosAlign.left, height: PosTextSize.size1));
    }

    bytes += generator.hr(ch: "-");
    bytes += generator.row([
      PosColumn(
        text: "Nama Barang",
        width: 6,
        styles: PosStyles(
            align: PosAlign.left, height: PosTextSize.size1, bold: true),
      ),
      PosColumn(
        text: "Harga",
        width: 6,
        styles: PosStyles(
            align: PosAlign.right, height: PosTextSize.size1, bold: true),
      ),
    ]);
    bytes += generator.hr(ch: "-");
    for (int i = 0; i < allProducts.length; i++) {
      var product = allProducts[i];
      double qtyProduct = product.quantity ?? 0;
      double price = product.price ?? 0;
      var totalPriceProduct = qtyProduct * price;
      bytes += generator.row([
        PosColumn(
            text: product.itemName ?? "-",
            width: 6,
            styles: PosStyles(align: PosAlign.left, height: PosTextSize.size1)),
        PosColumn(
            text: Core.converNumeric("$totalPriceProduct"),
            width: 6,
            styles: PosStyles(align: PosAlign.right)),
      ]);
      int qty = product.quantity!.toInt();
      bytes += generator.text(
          "${product.unitName} $qty @ ${Core.converNumeric("${product.price}")}",
          styles: PosStyles(align: PosAlign.left, height: PosTextSize.size1));
      if (i != allProducts.length - 1) {
        bytes += generator.emptyLines(1);
      }
    }
    bytes += generator.hr(ch: "-");
    bytes += generator.row([
      PosColumn(
        text: "",
        width: 6,
      ),
      PosColumn(
          text: "Total : ${Core.converNumeric("$totalBelanja")}",
          width: 6,
          styles: PosStyles(align: PosAlign.right, height: PosTextSize.size1)),
    ]);
    bytes += generator.row([
      PosColumn(
        text: "",
        width: 6,
      ),
      PosColumn(
          text: "Kembalian : ${Core.converNumeric("$kembalian")}",
          width: 6,
          styles: PosStyles(align: PosAlign.right, height: PosTextSize.size1)),
    ]);

    bytes += generator.feed(2);
    bytes += generator.cut();
    return bytes;
  }
}
