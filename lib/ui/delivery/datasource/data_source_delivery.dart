import 'package:beben_pos_desktop/ui/delivery/model/delivery.dart';
import 'package:flutter/material.dart';

class DataSourceDelivery extends DataTableSource {

  final List<Delivery> list;

  DataSourceDelivery({required this.list});

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
        DataCell(Text("${row.no ?? ""}")),
        DataCell(Text("${row.product}")),
        DataCell(Text("${row.status ?? ""}")),
        DataCell(Text("${row.date ?? ""}")),
        DataCell(
          ElevatedButton.icon(
            onPressed: (){},
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 16.0,
            ),
            label: Text("Update"),
            style: ElevatedButton.styleFrom(
              textStyle: TextStyle(color: Colors.white),
              padding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
              primary: Color(0xff3498db)
            ),
          ),
        ),
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
