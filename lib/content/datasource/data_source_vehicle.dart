import 'package:beben_pos_desktop/delivery/model/vehicle.dart';
import 'package:flutter/material.dart';

class DataSourceVehicle extends DataTableSource {

  final List<Vehicle> list;

  DataSourceVehicle({required this.list});

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
        DataCell(Text("${row.nopol ?? ""}")),
        DataCell(Text("${row.merk}")),
        DataCell(Text("${row.deskripsi ?? ""}")),
        DataCell(
          ElevatedButton.icon(
            onPressed: (){},
            icon: Icon(
              Icons.delete,
              color: Colors.white,
              size: 16.0,
            ),
            label: Text("Hapus"),
            style: ElevatedButton.styleFrom(
              textStyle: TextStyle(color: Colors.white),
              padding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
              primary: Colors.red
            ),
          ),
        )
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
