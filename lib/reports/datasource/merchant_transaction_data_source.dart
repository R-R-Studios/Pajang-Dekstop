
import 'package:beben_pos_desktop/reports/model/report_merchant_transaction_model.dart';
import 'package:flutter/material.dart';

class MerchantTransactionDataSource extends DataTableSource {

  MerchantTransactionDataSource(this.context,
      List<ReportMerchantTransactionModel> reportTransactionModels) {
    _rows = reportTransactionModels;
  }

  final BuildContext context;
  List<ReportMerchantTransactionModel> _rows = [];
  int _selectedCount = 0;

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
        DataCell(Text(
          '${row.merchantName!}',
          style: TextStyle(fontSize: 12),
        )),
        DataCell(Text(
          '${row.lastStock!}',
          style: TextStyle(fontSize: 12),
        )),
        DataCell(Text(
          '${row.currentStock!}',
          style: TextStyle(fontSize: 12),
        )),
        DataCell(Text(
          '${row.currentPrice!}',
          style: TextStyle(fontSize: 12),
        )),
        DataCell(Text(
          '${row.salePrice!}',
          style: TextStyle(fontSize: 12),
        )),
        DataCell(Text(
          '${row.qty!}',
          style: TextStyle(fontSize: 12),
        )),
        DataCell(Text(
          '${row.totalAmount!}',
          style: TextStyle(fontSize: 12),
        )),
        DataCell(Text(
          '${row.createdAt!}',
          style: TextStyle(fontSize: 12),
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
}