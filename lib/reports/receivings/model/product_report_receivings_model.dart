import 'package:beben_pos_desktop/core/core.dart';

class ProductReportReceicingsModel {
  int? productId;
  int? merchantProductStocks;
  int? stockAkhir;
  int? lastStock;
  int? trxStock;
  String? status;
  String? tanggalAwal;

  ProductReportReceicingsModel(
      {this.productId,
        this.merchantProductStocks,
        this.stockAkhir,
        this.lastStock,
        this.trxStock,
        this.status,
        this.tanggalAwal});

  ProductReportReceicingsModel.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    merchantProductStocks = json['merchant_product_stocks'];
    stockAkhir = int.tryParse(json['stock_akhir']);
    lastStock = int.tryParse(json['last_stock']);
    trxStock = int.tryParse(json['trx_stock']);
    status = json['status'];
    Core.dateConverter(DateTime.tryParse(json["tanggal_awal"])).then((value) {
      tanggalAwal = value;
    });
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['merchant_product_stocks'] = this.merchantProductStocks;
    data['stock_akhir'] = int.tryParse("${this.stockAkhir}");
    data['last_stock'] = int.tryParse("${this.lastStock}");
    data['trx_stock'] = int.tryParse("${this.trxStock}");
    data['status'] = this.status;
    data['tanggal_awal'] = this.tanggalAwal;
    return data;
  }
}