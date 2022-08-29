import 'package:beben_pos_desktop/customer/model/end_user.dart';
import 'package:flutter/material.dart';

class DataSourceCustomer extends DataTableSource {

  final List<EndUser> list;

  DataSourceCustomer({required this.list});

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
        DataCell(Text("${row.id ?? ""}")),
        DataCell(Text("${row.name}")),
        DataCell(Text("${row.phoneNumber ?? ""}")),
        DataCell(
          Row(
            children: [
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
              const SizedBox(width: 10,),
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
            ],
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
