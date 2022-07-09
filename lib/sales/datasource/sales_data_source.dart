import 'package:beben_pos_desktop/db/product_db.dart';
import 'package:beben_pos_desktop/sales/bloc/sales_bloc.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class SalesDataSource extends DataTableSource {
  var _formKey;

  SalesDataSource(this.context,
      List<ProductModel> productModels,
      this.box,
      GlobalKey<FormState> _fromKey,
      this.salesBloc,
      this.saveFocusNode) {
    _rows = productModels;
    _formKey = _formKey;
  }
  dynamic sumTotalQty;
  final SalesBloc salesBloc;
  // dynamic deleteProduct;
  // dynamic updateItem;
  // dynamic updateItemPrice;
  // dynamic updateItemTotalPrice;
  // TextEditingController qtyController;
  final BuildContext context;
  final Box box;
  final FocusNode saveFocusNode;
  List<ProductModel> _rows = [];
  int _selectedCount = 0;

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= _rows.length) return null;
    final row = _rows[index];
    // qtyController = TextEditingController(text: '${row.quantity}');
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
        DataCell(Center(
          child: IconButton(
            tooltip: "Delete Item",
            icon: Icon(Icons.delete),
            iconSize: 16,
            color: Colors.red,
            onPressed: () {
              salesBloc.deleteProduct(index);
            },
          ),
        )),
        DataCell(Text(
          row.item!,
          style: TextStyle(fontSize: 12),
        )),
        DataCell(Text(
          row.itemName!,
          style: TextStyle(fontSize: 12),
        )),
        DataCell(Center(
          child: Text(
            '${row.price!}',
            style: TextStyle(fontSize: 12),
          ),
        )),
        DataCell(
          TextFormField(
            initialValue: "${row.quantity!}",
            // controller: qtyController,
            style: TextStyle(fontSize: 12),
            onFieldSubmitted: (String _editQuantity) {
              print("saveFocusNode");
              FocusScope.of(context).unfocus();
              saveFocusNode.requestFocus();
              // if (_editQuantity.isEmpty){
              //   print('quantity empty');
              //   _editQuantity = "0";
              // }
              // updateItem(index, row, double.parse(_editQuantity));
              // updateItemTotalPrice(index, row, double.parse(_editQuantity), row.price );
            },
            onChanged: (String _editQuantity){
              if (_editQuantity.isEmpty){
                print('quantity empty');
                _editQuantity = "0";
              }
              salesBloc.updateItem(index, row, double.parse(_editQuantity));
              salesBloc.updateItemTotalPrice(index, row, double.parse(_editQuantity), row.price??0);
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
                borderSide: BorderSide(color: Colors.grey, width: 0.5),
              ),
            ),
          ),
          // Text(row.itemName!, style: TextStyle(fontSize: 12),)
        ),
        DataCell(Center(
          child: StreamBuilder<List<double>>(
            stream: salesBloc.streamTotalPrice,
            builder: (context, snapshot) {
              double totalPrice = 0;
              if(snapshot.hasData){
                totalPrice = snapshot.data![index];
              }
              return Text(
                "$totalPrice",
                style: TextStyle(fontSize: 12),
              );
            }
          ),
        )),
        DataCell(Center(
          child: IconButton(
            tooltip: "Update Item",
            icon: Icon(Icons.update),
            iconSize: 16,
            color: Colors.blue,
            onPressed: () {},
          ),
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
