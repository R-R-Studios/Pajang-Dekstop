import 'package:beben_pos_desktop/reports/receivings/report_input_receivings.dart';
import 'package:beben_pos_desktop/reports/salestransaction/new_sales_report.dart';
import 'package:beben_pos_desktop/reports/stockin/report_input_stok_in.dart';
import 'package:beben_pos_desktop/reports/stockoutgoing/stock_outgoing_report.dart';
import 'package:beben_pos_desktop/reports/merchant_transaction_report.dart';
import 'package:beben_pos_desktop/reports/price_product_history.dart';
import 'package:beben_pos_desktop/reports/warehouse_product_stock_report.dart';
import 'package:beben_pos_desktop/utils/global_color_palette.dart';
import 'package:beben_pos_desktop/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'bloc/report_bloc.dart';

class ReportsMerchant extends StatefulWidget {
  const ReportsMerchant({Key? key}) : super(key: key);

  @override
  _ReportsMerchantState createState() => _ReportsMerchantState();
}

class _ReportsMerchantState extends State<ReportsMerchant> {
  ReportBloc reportBloc = ReportBloc();

  Widget _headerReports() => Container(
        color: GlobalColorPalette.colorPrimary,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Icon(
                Icons.note_add_rounded,
                color: GlobalColorPalette.white,
              ),
              Container(
                  margin: EdgeInsets.only(left: 12),
                  child: Text(
                    'Detailed Reports',
                    style: TextStyle(
                        color: GlobalColorPalette.white,
                        fontWeight: FontWeight.bold),
                  ))
            ],
          ),
        ),
      );

  Widget _transactionReports() => InkWell(
        onTap: () {
          // open report transactions
          reportBloc.setToReportView('salestransaction');
        },
        child: Container(
            margin: EdgeInsets.all(14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Report Transaksi',
                  style: TextStyle(),
                ),
              ],
            )),
      );

  Widget _deliveryOrder() => InkWell(
        onTap: () {
          // open report transactions
          reportBloc.setToReportView('delivery_order');
        },
        child: Container(
            margin: EdgeInsets.all(14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Delivery Order',
                  style: TextStyle(),
                ),
              ],
            )),
      );

  Widget _merchantTransactionReports() => InkWell(
        onTap: () {
          // open report transactions
          reportBloc.setToReportView('merchant_transaction');
        },
        child: Container(
            margin: EdgeInsets.all(14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Merchant Transaction',
                  style: TextStyle(),
                ),
              ],
            )),
      );

  Widget _cardStockReports() => InkWell(
        onTap: () {
          // open report transactions
          reportBloc.setToReportView('stock_outgoing_report');
        },
        child: Container(
            margin: EdgeInsets.all(14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Report Kartu Stock',
                  style: TextStyle(),
                ),
              ],
            )),
      );

  Widget _warehouseProductStockReport() => InkWell(
        onTap: () {
          // open report transactions
          reportBloc.setToReportView('warehouse_product_stock');
        },
        child: Container(
            margin: EdgeInsets.all(14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Warehouse Product Stock',
                  style: TextStyle(),
                ),
              ],
            )),
      );

  Widget _priceProductHistory() => InkWell(
        onTap: () {
          // open report transactions
          reportBloc.setToReportView('price_product_history');
        },
        child: Container(
            margin: EdgeInsets.all(14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Price Product History',
                  style: TextStyle(),
                ),
              ],
            )),
      );

  Widget _inputReportReceivings() => InkWell(
        onTap: () {
          reportBloc.setToReportView("input_report_receivings");
        },
        child: Container(
            margin: EdgeInsets.all(14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Report Barang Masuk',
                  style: TextStyle(),
                ),
              ],
            )),
      );

  Widget _inputReportStockIn() => InkWell(
        onTap: () {
          reportBloc.setToReportView("input_report_stock_in");
        },
        child: Container(
            margin: EdgeInsets.all(14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Report Stok Masuk',
                  style: TextStyle(),
                ),
              ],
            )),
      );

  @override
  void initState() {
    // TODO: implement initState
    reportBloc.init();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    reportBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return StreamBuilder<String>(
        stream: reportBloc.streamReportView,
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.data == 'salestransaction')
            // return SalesReports();
            return NewSalesReport();
          else if (snapshot.data == 'merchant_transaction')
            return MerchantTransactionReport();
          else if (snapshot.data == 'stock_outgoing_report')
            return StockOutgoingReport();
          else if (snapshot.data == 'warehouse_product_stock')
            return WarehouseProductStockReport();
          else if (snapshot.data == 'price_product_history')
            return PriceProductHistory();
          else if (snapshot.data == 'input_report_receivings')
            return ReportInputReceivings(reportBloc);
          else if (snapshot.data == 'input_report_stock_in')
            return ReportInputStockIn(reportBloc);
          else
            return Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    child: Container(
                      width: SizeConfig.screenWidth * 0.5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _headerReports(),
                          _transactionReports(),
                          Divider(),
                          _cardStockReports(),
                          Divider(),
                          _merchantTransactionReports(),
                          Divider(),
                          _deliveryOrder(),
                          Divider(),
                          _warehouseProductStockReport(),
                          Divider(),
                          _priceProductHistory(),
                          Divider(),
                          _inputReportReceivings(),
                          Divider(),
                          _inputReportStockIn()
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
        });
  }
}
