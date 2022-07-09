
import 'package:beben_pos_desktop/reports/stockoutgoing/model/stock_outgoing_model.dart';
import 'package:flutter/material.dart';

class StockOutGoingDataSource extends DataTableSource {
  var _formKey;

  StockOutGoingDataSource(this.context,
      List<StockOutgoingModel> reportStockOutgoing) {
    _rows = reportStockOutgoing;

  }

  final BuildContext context;
  List<StockOutgoingModel> _rows = [];
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
            '${row.transactionDate!}',
            style: TextStyle(fontSize: 12),
          ),
        )),
        DataCell(Center(
          child: Text(
            '${row.name!}',
            style: TextStyle(fontSize: 12),
          ),
        )),
        DataCell(Center(
          child: Text(
            '${row.barcode!}',
            style: TextStyle(fontSize: 12),
          ),
        )),
        DataCell(Center(
          child: Text(
            '${row.code!}',
            style: TextStyle(fontSize: 12),
          ),
        )),
        DataCell(Center(
          child: Text(
            '${row.unitName!}',
            style: TextStyle(fontSize: 12),
          ),
        )),
        DataCell(Center(
          child: Text(
            '${row.merchantCurrentStock!}',
            style: TextStyle(fontSize: 12),
          ),
        )),
        DataCell(Center(
          child: Text(
            '${row.qtyTrx!}',
            style: TextStyle(fontSize: 12),
          ),
        )),
        DataCell(Center(
          child: Text(
            '${row.lastStock!}',
            style: TextStyle(fontSize: 12),
          ),
        )),
        DataCell(Center(
          child: Text(
            '${row.status!}',
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