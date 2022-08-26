import 'package:beben_pos_desktop/content/model/employee.dart';
import 'package:beben_pos_desktop/content/model/merchant_bank.dart';
import 'package:flutter/material.dart';

class DataSourceEmployee extends DataTableSource {

  final List<Employee> list;

  DataSourceEmployee({required this.list});

  int _selectedCount = 0;


  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= list.length) return null;
    final row = list[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(
          Text("${index + 1}")
        ),
        DataCell(Text("${row.name ?? ""}")),
        DataCell(Text("${row.jobDesk}")),
        DataCell(Text("${row.phoneNumber ?? ""}")),
      ],
    );
  }

  @override
  int get rowCount => list.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;
}
