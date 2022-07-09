import 'package:beben_pos_desktop/core/core.dart';
import 'package:beben_pos_desktop/product/bloc/product_bloc.dart';
import 'package:beben_pos_desktop/product/model/product_model.dart';
import 'package:flutter/material.dart';

class DataSourceProduct extends DataTableSource {
  DataSourceProduct(
      this.context, List<ProductModel> productModel, this.productBloc) {
    _rows = productModel;
  }

  ProductBloc productBloc;

  final BuildContext context;
  List<ProductModel> _rows = [];
  List<String> _createdAt = [];

  int _selectedCount = 0;

  var _formKey = GlobalKey<FormState>();

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= _rows.length) return null;
    final row = _rows[index];
    return DataRow.byIndex(
      index: index,
      // onSelectChanged: (value) {
      //   if (row.selected != value) {
      //     _selectedCount += value! ? 1 : -1;
      //     assert(_selectedCount >= 0);
      //     row.selected = value;
      //     notifyListeners();
      //   }
      // },
      cells: [
        DataCell(Container(
          width: MediaQuery.of(context).size.width * 0.02,
          child: Text("${row.product?.productId ?? "-"}"),
        )),
        DataCell(Container(
          width: MediaQuery.of(context).size.width * 0.11,
          child: Tooltip(
            message: "${row.product?.name ?? "-"}",
            child: Text(
                "${row.product?.name ?? "Product Tidak Ditemukan".trim()}"),
          ),
        )),
        DataCell(
          Container(
            width: MediaQuery.of(context).size.width * 0.06,
            child: Tooltip(
                message: "${row.product?.unit ?? "-".trim()}",
                child: Text(
                  "${row.product?.unit ?? "-".trim()}".trim(),
                  overflow: TextOverflow.ellipsis,
                )),
          ),
        ),
        DataCell(
          Container(
              width: MediaQuery.of(context).size.width * 0.05,
              child: Tooltip(
                message: "${row.product?.code ?? "-".trim()}",
                child: Text("${row.product?.code ?? "-".trim()}"),
              )),
        ),
        DataCell(
          Container(
              width: MediaQuery.of(context).size.width * 0.06,
              child: Tooltip(
                message: "${row.product?.barcode ?? "-".trim()}",
                child: Text("${row.product?.barcode ?? "-".trim()}"),
              )),
        ),
        DataCell(
          Container(
            width: MediaQuery.of(context).size.width * 0.08,
            child: Text(Core.converNumeric(
                "${double.parse(Core.convertToDouble("${row.product?.originalPrice ?? "0".trim()}"))}")),
          ),
        ),
        DataCell(
          Container(
            width: MediaQuery.of(context).size.width * 0.08,
            child: Text(Core.converNumeric(
                "${Core.convertToDouble("${row.product?.salePrice ?? "0".trim()}")}")),
          ),
        ),
        DataCell(
          Container(
            width: MediaQuery.of(context).size.width * 0.05,
            child: Text(Core.convertToDouble(
                "${row.product?.lastStock ?? "0".trim()}")),
          ),
        ),
        DataCell(
          Container(
            width: MediaQuery.of(context).size.width * 0.08,
            child: Tooltip(
              message: "${row.product?.description ?? "-".trim()}",
              child: Text(
                "${row.product?.description ?? "-".trim()}",
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
        DataCell(
          Container(
            width: MediaQuery.of(context).size.width * 0.08,
            child: Tooltip(
              message:
                  "${row.product?.createdAt ?? "-".trim()}",
              child: Text(
                  "${row.product?.createdAt ?? "-".trim()}"),
            ),
          ),
        ),
        DataCell(Container())
        // DataCell(
        //   row.product?.productId != null
        //       ? Container(
        //           width: MediaQuery.of(context).size.width * 0.04,
        //           child: IconButton(
        //             icon: Icon(Icons.article_outlined),
        //             color: Colors.blue,
        //             onPressed: () async {
        //               // ProductBloc().procesUnitConversion();
        //               print("ROW DATA ${jsonEncode(row)}");
        //               // ProductBloc().procesUnitConversionV2(row, 2);
        //               bool canUnitConversion =
        //                   await ProductBloc().checkUnitConversionV2(row);
        //               if (canUnitConversion) {
        //                 showDialog(
        //                     context: context,
        //                     builder: (BuildContext c) {
        //                       // return Container(
        //                       //   child: Text("Detail"),
        //                       // );
        //                       return DialogFormConversionUnit(row);
        //                     }).then((value) {
        //                   productBloc.refreshProductDB();
        //                 });
        //               } else {
        //                 GlobalFunctions.showSnackBarWarning(
        //                     "Produk tidak dapat di konversi");
        //               }
        //             },
        //           ),
        //         )
        //       : Container(),
        // ),
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
