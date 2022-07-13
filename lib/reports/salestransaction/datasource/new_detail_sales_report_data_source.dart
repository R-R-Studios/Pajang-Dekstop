import 'package:beben_pos_desktop/core/core.dart';
import 'package:beben_pos_desktop/reports/salestransaction/model/report_transaction.dart';
import 'package:flutter/material.dart';

class NewDetailSalesReportDataSource extends DataTableSource {
  NewDetailSalesReportDataSource(
      this.context, List<TransactionProductList> reportTransactionModels) {
    _rows = reportTransactionModels;
  }

  final BuildContext context;
  List<TransactionProductList> _rows = [];
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
          '${row.productName ?? "-"}',
          style: TextStyle(fontSize: 12),
        )),
        DataCell(Center(
          child: Text(
            '${row.unitName ?? "-"}',
            style: TextStyle(fontSize: 12),
          ),
        )),
        DataCell(Center(
          child: Text(
            '${row.qty ?? "0"}',
            style: TextStyle(fontSize: 12),
          ),
        )),
        DataCell(Center(
          child: Text(
            '${Core.converNumeric('${row.price ?? "0"}')}',
            style: TextStyle(fontSize: 12),
          ),
        )),
        DataCell(Center(
          child: Text(
            '${Core.converNumeric('${row.total ?? "0"}')}',
            style: TextStyle(fontSize: 12),
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
}
