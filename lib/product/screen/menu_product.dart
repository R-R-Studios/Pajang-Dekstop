import 'dart:convert';

import 'package:beben_pos_desktop/core/core.dart';
import 'package:beben_pos_desktop/core/fireship/fireship_box.dart';
import 'package:beben_pos_desktop/dashboard_bloc.dart';
import 'package:beben_pos_desktop/db/product_model_db.dart';
import 'package:beben_pos_desktop/db/unit_conversions_db.dart';
import 'package:beben_pos_desktop/model/head_column_model.dart';
import 'package:beben_pos_desktop/product/model/product_model.dart';
import 'package:beben_pos_desktop/product/provider/product_provider.dart';

import 'package:beben_pos_desktop/product/widget/dialog_create_product_data.dart';
import 'package:beben_pos_desktop/utils/size_config.dart';
import 'package:flutter/services.dart';
import 'package:beben_pos_desktop/utils/global_functions.dart';
import 'package:hive/hive.dart';

import '../bloc/product_bloc.dart';
import '../datasource/data_source_product.dart';
import '../model/create_product_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MenuProduct extends StatefulWidget {
  MenuProduct(this.dashboardBloc);
  final DashboardBloc dashboardBloc;

  @override
  _MenuProductState createState() => _MenuProductState();
}

class _MenuProductState extends State<MenuProduct> {
  List<HeadColumnModel> _headColumnModel = [
    HeadColumnModel(key: "1", name: "ID", ischecked: false),
    HeadColumnModel(key: "2", name: "Nama", ischecked: false),
    HeadColumnModel(key: "3", name: "Satuan", ischecked: false),
    HeadColumnModel(key: "4", name: "Kode", ischecked: false),
    HeadColumnModel(key: "5", name: "Barcode", ischecked: false),
    HeadColumnModel(key: "6", name: "Harga Beli", ischecked: false),
    HeadColumnModel(key: "7", name: "Harga Jual", ischecked: false),
    HeadColumnModel(key: "8", name: "Sisa Stok", ischecked: false),
    HeadColumnModel(key: "9", name: "Deskripsi", ischecked: false),
    HeadColumnModel(key: "10", name: "Tanggal", ischecked: false),
    // HeadColumnModel(key: "6", name: "Date", ischecked: false),
  ];

  List<String> _exportMap = [
    "JSON",
    "XML",
    "CSV",
    "TXT",
    "SQL",
    "MS-EXCEL",
    "PDF"
  ];

  List<ProductModel> _productModel = [];

  bool isDone = false;

  ProductBloc productBloc = ProductBloc();
  bool _isSortAscending = false;
  int _currentSortColumn = 0;

  String keySearch = "";

  DateTimeRange pickedDateTime = DateTimeRange(
      start: DateTime(2020, 1, 1),
      end: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day));
  late var selectedDateString =
      "${pickedDateTime.start.year}/${pickedDateTime.start.month}/${pickedDateTime.start.day} - ${pickedDateTime.end.year}/${pickedDateTime.end.month}/${pickedDateTime.end.day}";
  late TextEditingController _dateController =
      TextEditingController(text: selectedDateString);
  TextEditingController _barcodeController = TextEditingController();
  TextEditingController _productNameController = TextEditingController();
  TextEditingController _productPriceController = TextEditingController();
  TextEditingController _productUnitsController = TextEditingController();
  TextEditingController _codeController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  ProductModel newProduct = ProductModel();
  var _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    productBloc.initProductList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        body: Container(
            padding: EdgeInsets.all(10),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.only(right: 5, left: 5),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 5),
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    _showCreateProduct("", context);
                                  },
                                  icon: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 24.0,
                                  ),
                                  label: Text("Tambah Produk"),
                                  style: ElevatedButton.styleFrom(
                                      textStyle: TextStyle(color: Colors.white),
                                      padding: EdgeInsets.only(
                                          left: 20,
                                          right: 20,
                                          top: 15,
                                          bottom: 15),
                                      primary: Color(0xff3498db)),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 5),
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    bool hasConnection = await GlobalFunctions.checkConnectivityApp();
                                    if (hasConnection){
                                      productBloc.refreshProduct();
                                    }
                                  },
                                  icon: Icon(
                                    Icons.refresh,
                                    color: Colors.white,
                                    size: 24.0,
                                  ),
                                  label: Text("Perbarui Produk"),
                                  style: ElevatedButton.styleFrom(
                                      textStyle: TextStyle(color: Colors.white),
                                      padding: EdgeInsets.only(
                                          left: 20,
                                          right: 20,
                                          top: 15,
                                          bottom: 15),
                                      primary: Color(0xff3498db)),
                                ),
                              ),
                              // Padding(
                              //   padding: EdgeInsets.only(left: 5),
                              //   child: ElevatedButton.icon(
                              //     onPressed: () {
                              //     },
                              //     icon: Icon(
                              //       Icons.download,
                              //       color: Colors.white,
                              //       size: 24.0,
                              //     ),
                              //     label: Text("Import"),
                              //     style: ElevatedButton.styleFrom(
                              //         textStyle: TextStyle(color: Colors.white),
                              //         padding: EdgeInsets.only(
                              //             left: 20,
                              //             right: 20,
                              //             top: 15,
                              //             bottom: 15),
                              //         primary: Color(0xff3498db)),
                              //   ),
                              // )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 10, right: 5, left: 5),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //Delete & Email
                            Container(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 5),
                                    child: Container(
                                        width: 180,
                                        child: GestureDetector(
                                          onTap: () => _selectDate(context),
                                          child: AbsorbPointer(
                                            child: TextFormField(
                                              controller: _dateController,
                                              keyboardType:
                                                  TextInputType.datetime,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black),
                                              decoration: InputDecoration(
                                                  // labelStyle: TextStyle(color: Colors.black87),
                                                  //   focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black38)),
                                                  border: OutlineInputBorder(),
                                                  labelText: "Pilihan Tanggal"),
                                            ),
                                          ),
                                        )),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(right: 5),
                                    child: Container(
                                        width: 200,
                                        child: TextField(
                                          onChanged: (value) {
                                            onSearchProduct(value);
                                          },
                                          style: TextStyle(
                                              fontSize: 14, color: Colors.blue),
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: "Cari"),
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 10),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        StreamBuilder(
                            stream: productBloc.streamListProduct,
                            builder: (BuildContext context,
                                AsyncSnapshot<List<ProductModel>> snapshot) {
                              if (snapshot.hasData) {
                                if (snapshot.data!.length > 0) {
                                  _productModel = snapshot.data??[];
                                  _productModel.sort((pA, pB) => pA.product?.productId??0.compareTo(pB.product?.productId??0));
                                } else {
                                  _productModel = [
                                    ProductModel(),
                                  ];
                                }
                                return dataTable(_productModel);
                              } else {
                                return Center(
                                  child: CupertinoActivityIndicator(),
                                );
                              }
                            })
                      ],
                    ),
                  )
                ])));
  }

  Widget dataTable(List<ProductModel> productModel) {
    print("dataTable createdAt ${productModel.first.product?.createdAt}");
    return PaginatedDataTable(
      header: Text("Produk"),
      sortAscending: _isSortAscending,
      sortColumnIndex: _currentSortColumn,
      columnSpacing: 0,
      horizontalMargin: 30,
      showCheckboxColumn: false,
      rowsPerPage: productModel.length > 5 ? 5 : productModel.length,
      columns: <DataColumn>[
        for (final header in _headColumnModel)
          DataColumn(
              label: Text(header.name!),
              tooltip: header.name,
              onSort: (columnIndex, _sortAscending) {
                productBloc.sortProduct(columnIndex, _sortAscending);
                setState(() {
                  _isSortAscending = _sortAscending;
                  _currentSortColumn = columnIndex;
                });
              }),
        // DataColumn(label: Center(child: Text(""))),
        // DataColumn(label: Text("")),
        DataColumn(label: Text("")),
      ],
      source: DataSourceProduct(context, productModel, productBloc),
    );
  }

  _selectDate(BuildContext context) async {
    final DateTimeRange? dateTime = await showDateRangePicker(
        context: context,
        initialEntryMode: DatePickerEntryMode.inputOnly,
        initialDateRange: pickedDateTime,
        firstDate: DateTime(2020),
        // locale: Locale(_languageCode),
        lastDate: DateTime.now());
    setState(() {
      pickedDateTime = DateTimeRange(
          start: DateTime(
              dateTime!.start.year, dateTime.start.month, dateTime.start.day),
          end: DateTime(
              dateTime.end.year, dateTime.end.month, dateTime.end.day));
      selectedDateString =
          "${pickedDateTime.start.year}/${pickedDateTime.start.month}/${pickedDateTime.start.day} - ${pickedDateTime.end.year}/${pickedDateTime.end.month}/${pickedDateTime.end.day}";
      _dateController.text = selectedDateString;
    });
  }

  _showCreateProduct(String barcode, BuildContext context) async {
    _barcodeController.text = barcode;
    await showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return DialogCreateProductData();
    }).then((value) async {
      GlobalFunctions.logPrint("request Create Merchant Product", '$value');
      if (value != null){
        if(value){
          productBloc.refreshProduct();
        }
      }
    });
  }

  _postCreateProduct(ProductModel productModel) {
    ProductBloc()
        .createProduct(CreateProductModel(product: productModel))
        .then((value) {
      setState(() {});
    });
    //   Navigator.pop(context);
    // });
  }

  void _clearForm() {
    _barcodeController.clear();
    _codeController.clear();
    _productNameController.clear();
    _descriptionController.clear();
  }

  Future dismissCreateProduct(BuildContext dialogContext) async {
    Navigator.pop(dialogContext);
  }

  onSearchProduct(String text) {
    productBloc.searchProduct(text);
  }
}
