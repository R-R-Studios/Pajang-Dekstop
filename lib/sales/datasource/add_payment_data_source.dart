
import 'package:beben_pos_desktop/sales/model/sales_payment_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class AddPaymentDataSource extends DataTableSource {
  AddPaymentDataSource(this.context, List<SalesPayment> salesPayment,
      this.box) {
    _rows = salesPayment;
  }

  BuildContext context;
  Box box;
  List<SalesPayment> _rows = [];

  int _selectedCount = 0;

  var _formKey = GlobalKey<FormState>();

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
          onPressed: () {
            notifyListeners();
          },
        )),
        DataCell(Text(row.type!, style: TextStyle(fontSize: 10),)),
        DataCell(Text("${row.amount!}", style: TextStyle(fontSize: 10),)),
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