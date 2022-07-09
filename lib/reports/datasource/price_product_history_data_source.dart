import 'package:beben_pos_desktop/reports/model/price_product_history_model.dart';
import 'package:flutter/material.dart';

class PriceProductHistoryDataSource extends DataTableSource {
  var _formKey;

  PriceProductHistoryDataSource(this.context,
      List<PriceProductHistoryModel> reportPriceProductModel) {
    _rows = reportPriceProductModel;
  }

  final BuildContext context;
  List<PriceProductHistoryModel> _rows = [];
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
        DataCell(
          Center(
            child: Container(
              width: 20,
              child: Center(child: Text(row.id != null ? row.id.toString() : "-")),
            ),
          ),
        ),
        DataCell(
          Center(
            child: Container(
              child: Center(child: Text(row.productName != null ? row.productName! : "Product Tidak Ditemukan")),
            ),
          ),
        ),
        DataCell(
          Center(
            child: Container(
              child: Center(child: Text(row.code != null ? row.code! : "-")),
            ),
          ),
        ),
        DataCell(
          Center(
            child: Container(
              child: Center(child: Text(row.barcode != null ? row.barcode! : "-")),
            ),
          ),
        ),
        DataCell(
          Center(
            child: Container(
              child: row.id != null ? Center(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: Text("Detail"),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text("Print"),
                    )
                  ],
                ),
              ) : Text("-"),
            ),
          ),
        ),
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
