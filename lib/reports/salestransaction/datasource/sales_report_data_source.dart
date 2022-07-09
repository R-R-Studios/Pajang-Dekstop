import 'package:beben_pos_desktop/core/core.dart';
import 'package:beben_pos_desktop/model/head_column_model.dart';
import 'package:beben_pos_desktop/reports/salestransaction/model/report_transaction_model.dart';
import 'package:flutter/material.dart';

import 'detail_sales_report_data_source.dart';

class SalesReportDataSource extends DataTableSource {

  SalesReportDataSource(this.context,
      List<SalesTransactionModel> reportTransactionModels) {
    _rows = reportTransactionModels;
  }

  final BuildContext context;
  List<SalesTransactionModel> _rows = [];
  int _selectedCount = 0;

  List<HeadColumnModel> _headColumnModel = [
    HeadColumnModel(key: "1", name: "Nama Barang", ischecked: false),
    HeadColumnModel(key: "2", name: "Satuan", ischecked: false),
    HeadColumnModel(key: "3", name: "Qty", ischecked: false),
    HeadColumnModel(key: "4", name: "Harga Jual", ischecked: false),
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
            '${row.orderDate ?? '-'}',
            style: TextStyle(fontSize: 12),
          ),
        )),
        DataCell(Text(
          '${row.productName ?? "-"}',
          style: TextStyle(fontSize: 12),
        )),
        DataCell(Text(
          '${row.codeTransaction ?? "-"}',
          style: TextStyle(fontSize: 12),
        )),
        DataCell(Center(
          child: Text(
            '${row.qty ?? "0"}',
            style: TextStyle(fontSize: 12),
          ),
        )),
        DataCell(Center(
          child: Text(
            '${row.unitsName ?? "-"}',
            style: TextStyle(fontSize: 12),
          ),
        )),
        DataCell(Center(
          child: Text(
            '${Core.converNumeric(row.salePrice ?? "0")}',
            style: TextStyle(fontSize: 12),
          ),
        )),
        DataCell(Center(
          child: Text(
            '${Core.converNumeric(row.totalSalePrice ?? "0")}',
            style: TextStyle(fontSize: 12),
          ),
        )),

        // DataCell(Center(
        //   child: Text(
        //     '${Core.converNumeric(row.purchasePrice ?? "0")}',
        //     style: TextStyle(fontSize: 12),
        //   ),
        // )),
        // DataCell(Center(
        //   child: Text(
        //     '${Core.converNumeric(row.totalPurchasePrice ?? "0")}',
        //     style: TextStyle(fontSize: 12),
        //   ),
        // )),
        DataCell(Center(
          child: Text(
            '${Core.converNumeric(row.profit ?? "0")}',
            style: TextStyle(fontSize: 12),
          ),
        )),
        DataCell(Center(
          child: ElevatedButton(
            onPressed: () {
              List<SalesTransactionModel> selectedTransactionList = [];
              _rows.forEach((element) {
                if (row.codeTransaction == element.codeTransaction){
                  selectedTransactionList.add(element);
                }
              });
              showDetailTransaction(row.codeTransaction ?? "-", row.orderDate ?? "-", selectedTransactionList);
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

  showDetailTransaction(String transactionCode, String date, List<SalesTransactionModel> selectedListTransaction){
    double totalTransaction = 0;
    for (int a = 0; a<selectedListTransaction.length; a++) {
      double qty = double.parse(selectedListTransaction[a].qty ?? "0");
      double salePrice = double.parse(selectedListTransaction[a].salePrice ?? "0");
      double total = qty * salePrice;
      totalTransaction += total;
    }

    return showDialog(
        context: context,
        builder: (BuildContext ctx) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
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
                        // ElevatedButton(
                        //   onPressed: () {
                        //     Navigator.pop(ctx, 'Batalkan');
                        //   },
                        //   child: Text("Tutup"),
                        //   style: ElevatedButton.styleFrom(
                        //       textStyle: TextStyle(color: Colors.white),
                        //       padding: EdgeInsets.only(
                        //           left: 20, right: 20, top: 15, bottom: 15),
                        //       primary: Color(0xff3498db)),
                        // ),
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
                        selectedListTransaction.length > 5 ? 5 :
                        selectedListTransaction.length > 0 && selectedListTransaction.length < 5 ? selectedListTransaction.length : 0
                      ,
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
                              source: DetailSalesReportDataSource(
                              context, selectedListTransaction)),
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
                // ListView.builder(
                //   shrinkWrap: true,
                //   itemCount: selectedListTransaction.isNotEmpty ? selectedListTransaction.length : 0,
                //     itemBuilder: (context, index){
                //       return Container(
                //         child: Row(
                //           mainAxisAlignment: MainAxisAlignment.start,
                //           crossAxisAlignment: CrossAxisAlignment.center,
                //           children: [
                //             Text(selectedListTransaction[index].productName??"-"),
                //             Center(child: Text(selectedListTransaction[index].unitsName ?? "-")),
                //             Center(child: Text(selectedListTransaction[index].qty ?? "-")),
                //             Center(child: Text(selectedListTransaction[index].salePrice ?? "-")),
                //           ],
                //         ),
                //       );
                //     })
              ],
            ),
          ),
        ));
  }
}