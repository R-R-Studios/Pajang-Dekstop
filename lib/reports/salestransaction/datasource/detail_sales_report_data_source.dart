import 'package:beben_pos_desktop/core/core.dart';
import 'package:beben_pos_desktop/reports/salestransaction/model/report_transaction_model.dart';
import 'package:flutter/material.dart';

class DetailSalesReportDataSource extends DataTableSource {
  DetailSalesReportDataSource(
      this.context, List<SalesTransactionModel> reportTransactionModels) {
    _rows = reportTransactionModels;
  }

  final BuildContext context;
  List<SalesTransactionModel> _rows = [];
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
            '${row.unitsName ?? "-"}',
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
            '${Core.converNumeric(row.salePrice ?? "0")}',
            style: TextStyle(fontSize: 12),
          ),
        )),
        DataCell(Center(
          child: Text(
            '${sumTotalPayment(row.qty ?? "0", row.salePrice ?? "0")}',
            style: TextStyle(fontSize: 12),
          ),
        )),
      ],
    );
  }

  sumTotalPayment(String qty, String salePrice) {
    double qtyData = double.parse(qty);
    double salesPrice = double.parse(salePrice);
    double total = qtyData * salesPrice;
    return Core.converNumeric(total.toString());
  }

  @override
  int get rowCount => _rows.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;
}
