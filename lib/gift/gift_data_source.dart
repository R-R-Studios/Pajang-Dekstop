
import 'package:flutter/material.dart';
import 'gift_model.dart';

class GiftDataSource extends DataTableSource {
  GiftDataSource(this.context, List<GiftModel> customerModel) {
    _rows = customerModel;
  }

  final BuildContext context;
  List<GiftModel> _rows = [];

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
        DataCell(Text("${row.id!}")),
        DataCell(Text(row.firstName!)),
        DataCell(Text(row.lastName!)),
        DataCell(Text(row.giftCardNumber!)),
        DataCell(Text("${row.value!}"))
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