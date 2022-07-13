import 'package:beben_pos_desktop/units/model/units_model.dart';
import 'package:flutter/material.dart';

class DataSourceUnits extends DataTableSource {
  DataSourceUnits(this.context, this._rows);
  final BuildContext context;
  final List<UnitsModel> _rows;

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
        DataCell(Text(row.id == null ? "-" : row.id.toString().trim())),
        DataCell(Text(
            row.name == null ? "Units Tidak Ditemukan" : row.name!.trim())),
        DataCell(Text(row.description == null ? "-" : row.description!.trim())),
        DataCell(Text(
            row.updatedAt == null ? "-" : row.updatedAt.toString().trim())),
        // DataCell(Text(row.createdAt!)),
        // DataCell(Text(row.salePrice!)),
        // DataCell(Text(row.retailPrice!)),
        // DataCell(Text(row.quantity!)),
        // DataCell(Text(row.taxPercentage!)),
        // DataCell(Text(row.image!)),
        DataCell(row.id != null
            ? IconButton(
                tooltip: "Update Inventory ${row.name}",
                icon: Icon(Icons.edit_road_outlined),
                color: Colors.blue,
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext c) {
                        return Container();
                        // return DialogFormUpdateCustomer(row);
                      });
                },
              )
            : Container()),
        DataCell(row.id != null
            ? IconButton(
                tooltip: "Inventory Count Details ${row.name}",
                icon: Icon(Icons.article_outlined),
                color: Colors.blue,
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext c) {
                        return Container();
                        // return DialogFormUpdateCustomer(row);
                      });
                },
              )
            : Container()),
        DataCell(row.id != null
            ? IconButton(
                tooltip: "Update Product ${row.name}",
                icon: Icon(Icons.edit_outlined),
                color: Colors.blue,
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext c) {
                        return Container();
                        // return DialogFormUpdateCustomer(row);
                      });
                },
              )
            : Container()),
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
