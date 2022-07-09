import 'package:beben_pos_desktop/product/model/product_model.dart';
import 'package:beben_pos_desktop/utils/size_config.dart';
import 'package:flutter/material.dart';

class DataSourceReceivings extends DataTableSource {
  DataSourceReceivings(this.context, List<ProductModel> productModel) {
    _rows = productModel;
  }

  final BuildContext context;
  List<ProductModel> _rows = [];

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
          iconSize: MediaQuery.of(context).size.width * 0.018,
          color: Colors.blue,
          onPressed: () {},
          icon: Icon(Icons.delete_outline_sharp),
        )),
        DataCell(
          Container(
            width: MediaQuery.of(context).size.width * 0.1,
            child: Text(row.product?.barcode??"-"),
          ),
        ),
        DataCell(
          Container(
            width: MediaQuery.of(context).size.width * 0.12,
            child: Text(row.product?.name??"-"),
          ),
        ),
        DataCell(
          Container(
            width: MediaQuery.of(context).size.width * 0.1,
            child: TextFormField(
              style: TextStyle(fontSize: 12, height: 1),
              onFieldSubmitted: (String _search) {
                print('search-> $_search');
              },
              decoration: new InputDecoration(
                fillColor: Colors.white,
                filled: true,
                isDense: true,
                contentPadding: EdgeInsets.fromLTRB(6.0, 18.0, 6.0, 18.0),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1.0),
                ),
                hintText: "Price",
              ),
            ),
          ),
        ),
        DataCell(Container(
          width: MediaQuery.of(context).size.width * 0.05,
          child: TextFormField(
            style: TextStyle(fontSize: 12, height: 1),
            onFieldSubmitted: (String _search) {
              print('search-> $_search');
            },
            decoration: new InputDecoration(
              fillColor: Colors.white,
              filled: true,
              isDense: true,
              contentPadding: EdgeInsets.fromLTRB(6.0, 18.0, 6.0, 18.0),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 1.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
              ),
              hintText: "Qty",
            ),
          ),
        )),
        DataCell(
          Container(
            width: MediaQuery.of(context).size.width * 0.1,
            child: Text("Rp. 20.000.000"),
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
