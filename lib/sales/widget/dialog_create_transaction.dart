import 'package:beben_pos_desktop/core/fireship/fireship_box.dart';
import 'package:beben_pos_desktop/db/product_db.dart';
import 'package:beben_pos_desktop/model/head_column_model.dart';
import 'package:beben_pos_desktop/sales/bloc/sales_bloc.dart';
import 'package:beben_pos_desktop/sales/datasource/sales_data_source.dart';
import 'package:beben_pos_desktop/utils/global_color_palette.dart';
import 'package:beben_pos_desktop/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'dialog_find_product.dart';
import 'dialog_save_transaction.dart';

class DialogCreateTransaction extends StatefulWidget {
  const DialogCreateTransaction( {Key? key}) : super(key: key);

  @override
  _DialogCreateTransactionState createState() =>
      _DialogCreateTransactionState();
}

class _DialogCreateTransactionState extends State<DialogCreateTransaction> {
  
  final _formKey = GlobalKey<FormState>();
  SalesBloc salesBloc = SalesBloc();
  int _currentSortColumn = 0;
  bool _isAscending = true;
  late Box box = Hive.box(FireshipBox.BOX_PRODUCT);
  TextEditingController qtyEditingController = TextEditingController();
  double totalTransaction = 0;

  List<HeadColumnModel> _checkboxModel = [
    HeadColumnModel(key: "1", name: "Deleted", ischecked: false),
    HeadColumnModel(key: "2", name: "Item", ischecked: false),
    HeadColumnModel(key: "3", name: "Item Name", ischecked: false),
    HeadColumnModel(key: "4", name: "Price", ischecked: false),
    HeadColumnModel(key: "5", name: "Quantity", ischecked: false),
    // HeadColumnModel(key: "6", name: "Disc", ischecked: false),
    HeadColumnModel(key: "6", name: "Total", ischecked: false),
    HeadColumnModel(key: "7", name: "Updated", ischecked: false),
  ];

  @override
  void initState() {
    // TODO: implement initState
    salesBloc.init();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Widget productPaginateData(context) => Container(
        width: double.infinity,
        child: StreamBuilder(
            stream: salesBloc.streamListProductModel,
            builder: (context, AsyncSnapshot<List<ProductModel>> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data?.length == 0)
                  return Container();
                else
                  return Container(
                    width: SizeConfig.screenHeight * 0.6,
                    height: SizeConfig.screenHeight * 0.6,
                    child: PaginatedDataTable(
                      sortColumnIndex: _currentSortColumn,
                      sortAscending: _isAscending,
                      columnSpacing: 0,
                      horizontalMargin: 0,
                      rowsPerPage: 5,
                      showCheckboxColumn: false,
                      columns: <DataColumn>[
                        for (final header in _checkboxModel)
                          DataColumn(
                              label: Expanded(
                                child: Text(
                                  header.name!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              tooltip: header.name,
                              onSort: (columnIndex, _sortAscending) {
                                setState(() {
                                  _currentSortColumn = columnIndex;
                                });
                              }),
                      ],
                      source: SalesDataSource(
                        context,
                        snapshot.data!,
                        box,
                        _formKey,
                        salesBloc,
                        FocusNode()
                      ),
                    ),
                  );
                return Container(
                  child: Text('TEst'),
                );
              } else {
                return Center(child: Text('kosong'));
              }
            }),
      );

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return AlertDialog(
      contentPadding: EdgeInsets.all(16),
      titlePadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: GlobalColorPalette.colorButtonActive,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Buat Transaksi",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () async {
                          await showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (BuildContext context) {
                                return DialogSaveTransaction("manual", salesBloc, totalTransaction);
                              });
                          print('error');
                          // await salesBloc.addTransactionFailed();
                          // salesBloc.deleteAll();
                        },
                        icon: Icon(
                          Icons.shopping_cart_rounded,
                          color: Colors.white,
                          size: 16.0,
                        ),
                        label: Text('Simpan'),
                        style: ElevatedButton.styleFrom(
                            textStyle: TextStyle(color: Colors.white),
                            padding: EdgeInsets.only(
                                left: 14, right: 14, top: 14, bottom: 14),
                            primary: Color(0xff3498db)),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        tooltip: "Close",
                        icon: Icon(Icons.close),
                        color: Colors.white,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              Container(
                width: SizeConfig.screenWidth * 0.8,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        child: InputDecorator(
                          decoration: new InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              isDense: true,
                              contentPadding: EdgeInsets.all(14),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black, width: 1.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1.0),
                              ),
                              prefixText: 'Pilih Produk',
                              prefixStyle: TextStyle(fontSize: 12)),
                        ),
                        onTap: () {
                          showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (BuildContext c) {
                                return DialogFindProduct(salesBloc.addProduct, "0");
                              });
                        },
                      ),
                    ),
                    Expanded(
                      child: StreamBuilder(
                          stream: salesBloc.streamSumTotalPayment,
                          builder: (context, AsyncSnapshot<double> snapshot) {
                            if (snapshot.hasData) {
                              totalTransaction = snapshot.data!;
                              return Align(
                                  alignment: Alignment.centerRight,
                                  child: Text("Total : Rp ${snapshot.data}"));
                            } else {
                              return Align(
                                  alignment: Alignment.centerRight,
                                  child: Text("Total : Rp 0"));
                            }
                          }),
                    )
                  ],
                ),
              ),
              productPaginateData(context),
            ],
          ),
        ),
      ),
    );
  }
}
