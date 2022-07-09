import 'package:beben_pos_desktop/core/core.dart';
import 'package:beben_pos_desktop/model/head_column_model.dart';
import 'package:beben_pos_desktop/reports/salestransaction/bloc/sales_report_bloc.dart';
import 'package:beben_pos_desktop/reports/salestransaction/model/report_transaction.dart';
import 'package:beben_pos_desktop/reports/salestransaction/model/report_transaction_model.dart';
import 'package:beben_pos_desktop/reports/salestransaction/widget/pdf_detail_transaction.dart';
import 'package:flutter/material.dart';

import 'detail_sales_report_data_source.dart';
import 'new_detail_sales_report_data_source.dart';

class NewSalesReportDataSource extends DataTableSource {

  NewSalesReportDataSource(this.context,
      List<ReportTransaction> reportTransactionModels, this.salesReportBloc, this.startDate, this.endDate, this.merchantName) {
    _rows = reportTransactionModels;
  }

  final BuildContext context;
  final SalesReportBloc salesReportBloc;
  List<ReportTransaction> _rows = [];
  int _selectedCount = 0;
  final String startDate;
  final String endDate;
  final String merchantName;

  List<HeadColumnModel> _headColumnModel = [
    HeadColumnModel(key: "1", name: "Nama Barang", ischecked: false),
    HeadColumnModel(key: "2", name: "Satuan", ischecked: false),
    HeadColumnModel(key: "3", name: "Qty", ischecked: false),
    HeadColumnModel(key: "4", name: "Harga", ischecked: false),
    HeadColumnModel(key: "5", name: "Total", ischecked: false),
  ];

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= _rows.length) return null;
    final row = _rows[index];
    return DataRow.byIndex(
      index: index,
      selected: row.selected,
      onSelectChanged: (value) {
        if (row.selected != value) {
          _selectedCount += value! ? 1 : -1;
          assert(_selectedCount >= 0);
          row.selected = value;
          notifyListeners();
        }
      },
      cells: [
        DataCell(Center(
          child: Text(
            '${row.date ?? '-'}',
            style: TextStyle(fontSize: 12),
          ),
        )),
        DataCell(Text(
          '${row.transactionCode ?? "-"}',
          style: TextStyle(fontSize: 12),
        )),
        DataCell(Center(
          child: Text(
            '${row.type ?? "Retail"}',
            style: TextStyle(fontSize: 12),
          ),
        )),
        DataCell(Center(
          child: Text(
            '${row.payment ?? "CASH"}',
            style: TextStyle(fontSize: 12),
          ),
        )),
        DataCell(Center(
          child: Text(
            '${Core.converNumeric(row.totalTransaction ?? "0")}',
            style: TextStyle(fontSize: 12),
          ),
        )),
        DataCell(Center(
          child: Text(
            '${Core.converNumeric(row.totalPayment ?? "0")}',
            style: TextStyle(fontSize: 12),
          ),
        )),

        DataCell(Center(
          child: ElevatedButton(
            onPressed: () {
              showDetailTransaction(row.transactionCode ?? "0", row.date ?? "-");
            },
            child: Text("Detail"),
            style: ElevatedButton.styleFrom(
                textStyle: TextStyle(color: Colors.white),
                padding: EdgeInsets.only(
                    left: 20, right: 20, top: 15, bottom: 15),
                primary: Color(0xff3498db)),
          ),
        )),
      ],
    );
  }

  @override
  int get rowCount => _rows.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;

  showDetailTransaction(String transactionCode, String date){
    return showDialog(
        context: context,
        builder: (BuildContext ctx) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: FutureBuilder(
              future: salesReportBloc.getDetailSalesTransactionReport(transactionCode),
              builder: (BuildContext context, AsyncSnapshot<ReportTransaction> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (snapshot.hasError){
                    return Center(child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Gagal Memuat Data'),
                        SizedBox(
                          height: 16,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(ctx, 'Batalkan');
                          },
                          child: Text("Tutup"),
                          style: ElevatedButton.styleFrom(
                              textStyle: TextStyle(color: Colors.white),
                              padding: EdgeInsets.only(
                                  left: 20, right: 20, top: 15, bottom: 15),
                              primary: Color(0xff3498db)),
                        ),
                      ],
                    ),);
                  }
                  double totalTransaction = 0;
                  List<TransactionProductList> temp =[];
                  temp.addAll(snapshot.data!.transactionList ?? []);
                  if (temp.isNotEmpty){
                    for (int a =0; a < temp.length; a++){
                      totalTransaction += temp[a].total!;
                    }
                  }

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Detail Transaksi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                                Container(
                                    margin: EdgeInsets.only(top: 12),
                                    child: Text('Kode Transaksi : $transactionCode')),
                                Container(
                                    margin: EdgeInsets.only(top: 4),
                                    child: Text('Tanggal : $date')),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 12),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    await PDFDetailTransaction.generatePDFDetailTransaction(date, transactionCode, temp, merchantName);
                                    Navigator.pop(ctx, 'OK');
                                  },
                                  child: Text("Export PDF"),
                                  style: ElevatedButton.styleFrom(
                                      textStyle: TextStyle(color: Colors.white),
                                      padding: EdgeInsets.only(
                                          left: 20, right: 20, top: 15, bottom: 15),
                                      primary: Color(0xff3498db)),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 12),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(ctx, 'Batalkan');
                                  },
                                  child: Text("Tutup"),
                                  style: ElevatedButton.styleFrom(
                                      textStyle: TextStyle(color: Colors.white),
                                      padding: EdgeInsets.only(
                                          left: 20, right: 20, top: 15, bottom: 15),
                                      primary: Color(0xff3498db)),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 12, bottom: 12),
                          child: Divider()),
                      Container(
                        width: double.infinity,
                        child: PaginatedDataTable(
                            rowsPerPage:
                            temp.length > 5 ? 5 :
                            temp.length > 0 && temp.length < 5 ? temp.length : 0,
                            showCheckboxColumn: false,
                            columns: <DataColumn>[
                              for (final header in _headColumnModel)
                                DataColumn(
                                    label: Expanded(
                                      child: Text(header.name!, textAlign: TextAlign.center, style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    tooltip: header.name,
                                    onSort: (columnIndex, _sortAscending) {}),
                            ],
                            source: NewDetailSalesReportDataSource(
                                context, temp)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 18, ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment:  CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Container(
                                margin: EdgeInsets.only(left: 12),
                                child: Text(
                                  '${Core.converNumeric(totalTransaction.toString())}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                )),
                          ],
                        ),
                      )
                    ],
                  );
                }
              },
            )
          ),
        ));
  }
}