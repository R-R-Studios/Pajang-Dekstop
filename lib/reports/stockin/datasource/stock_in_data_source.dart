import 'package:beben_pos_desktop/reports/stockin/model/report_stock_in_model.dart';
import 'package:flutter/material.dart';

class StockInDataSource extends DataTableSource {
  var _formKey;

  StockInDataSource(
      this.context, List<ReportStockInModel> reportStockOutgoing) {
    _rows = reportStockOutgoing;
  }

  final BuildContext context;
  List<ReportStockInModel> _rows = [];
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
        DataCell(Center(
          child: Text(
            '${row.tanggal}',
            style: TextStyle(fontSize: 12),
          ),
        )),
        DataCell(Center(
          child: Text(
            '${row.productName}',
            style: TextStyle(fontSize: 12),
          ),
        )),
        DataCell(Center(
          child: Text(
            '${row.unitName}',
            style: TextStyle(fontSize: 12),
          ),
        )),
        DataCell(Center(
          child: Text(
            '${row.originalPrice}',
            style: TextStyle(fontSize: 12),
          ),
        )),
        DataCell(Center(
          child: Text(
            '${row.salePrice}',
            style: TextStyle(fontSize: 12),
          ),
        )),
        DataCell(Center(
          child: Text(
            '${row.qty}',
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
