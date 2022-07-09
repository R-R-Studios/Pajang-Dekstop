import 'package:beben_pos_desktop/sales/model/daily_sales_model.dart';
import 'package:flutter/material.dart';

class DailySalesDataSource extends DataTableSource {
  var _formKey;

  DailySalesDataSource(this.context, List<DailySalesModel> dailySaleModels,
      GlobalKey<FormState> _fromKey) {
    _rows = dailySaleModels;
    _formKey = _formKey;
  }

  final BuildContext context;
  List<DailySalesModel> _rows = [];
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
        DataCell(IconButton(
          tooltip: "Delete Item",
          icon: Icon(Icons.delete),
          iconSize: 16,
          color: Colors.red,
          onPressed: () {},
        )),
        DataCell(Text("${row.id!}", style: TextStyle(fontSize: 12),)),
        DataCell(Text(
          "${row.time!}",
          style: TextStyle(fontSize: 12),
        )),
        DataCell(Text(
          "${row.customer!}",
          style: TextStyle(fontSize: 12),
        )),
        DataCell(Text(
          "${row.amountDue!}",
          style: TextStyle(fontSize: 12),
        )),
        DataCell(Text(
          "${row.amountTendered!}",
          style: TextStyle(fontSize: 12),
        )),
        DataCell(Text(
          "${row.changeDue!}",
          style: TextStyle(fontSize: 12),
        )),
        DataCell(Text(
          "${row.type!}",
          style: TextStyle(fontSize: 12),
        )),
        DataCell(Text(
          "${row.invoice!}",
          style: TextStyle(fontSize: 12),
        )),
        DataCell(IconButton(
          tooltip: "Update Item",
          icon: Icon(Icons.update),
          iconSize: 16,
          color: Colors.blue,
          onPressed: () {},
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