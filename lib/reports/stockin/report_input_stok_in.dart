import 'dart:convert';

import 'package:beben_pos_desktop/db/profile_db.dart';
import 'package:beben_pos_desktop/model/head_column_model.dart';
import 'package:beben_pos_desktop/profile/bloc/profile_bloc.dart';
import 'package:beben_pos_desktop/receivings/model/product_receivings_model.dart';
import 'package:beben_pos_desktop/reports/bloc/report_bloc.dart';
import 'package:beben_pos_desktop/reports/stockin/bloc/report_stock_in_bloc.dart';
import 'package:beben_pos_desktop/reports/stockin/datasource/stock_in_data_source.dart';
import 'package:beben_pos_desktop/reports/stockin/model/report_stock_in_model.dart';
import 'package:beben_pos_desktop/utils/global_functions.dart';
import 'package:beben_pos_desktop/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReportInputStockIn extends StatefulWidget {
  ReportInputStockIn(this.reportBloc);

  final ReportBloc reportBloc;

  @override
  _ReportInputStockInState createState() => _ReportInputStockInState();
}

class _ReportInputStockInState extends State<ReportInputStockIn> {
  DateTimeRange pickedDateTime = DateTimeRange(
      start: DateTime(2021, 10, 1),
      end: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day));

  late var selectedDateString =
      "${pickedDateTime.start.year}/${pickedDateTime.start.month}/${pickedDateTime.start.day} - ${pickedDateTime.end.year}/${pickedDateTime.end.month}/${pickedDateTime.end.day}";

  late var startDate =
      "${pickedDateTime.start.year}-${pickedDateTime.start.month}-${pickedDateTime.start.day}";
  late var endDate =
      "${pickedDateTime.end.year}-${pickedDateTime.end.month}-${pickedDateTime.end.day}";

  late TextEditingController _dateController =
      TextEditingController(text: selectedDateString);

  List<ProductReceivingsModel> _productReceivings = [];
  List<ProductReceivingsModel> baseProduct = [];

  bool isAllProduct = true;
  bool isAllUnit = false;

  bool isSearchStockIn = false;

  ProductReceivingsModel selectedProduct = ProductReceivingsModel();
  late ReportBloc reportBloc = widget.reportBloc;

  List<ReportStockInModel> listReport = [];
  ReportStockInBloc stockInBloc = ReportStockInBloc();

  ProfileDB profile = ProfileDB();

  List<HeadColumnModel> _headColumnModel = [
    HeadColumnModel(key: "1", name: "Tanggal", ischecked: false),
    HeadColumnModel(key: "2", name: "Nama Barang", ischecked: false),
    HeadColumnModel(key: "3", name: "Satuan", ischecked: false),
    HeadColumnModel(key: "3", name: "Harga Beli", ischecked: false),
    HeadColumnModel(key: "5", name: "Harga Jual", ischecked: false),
    HeadColumnModel(key: "6", name: "Qty", ischecked: false),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ProfileBloc().getProfile().then((value) {
      profile = value;
    });
    getProductReportReceivings();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: (){
                  setState(() {
                    reportBloc.setToReportView("");
                  });
                }, child: Icon(
        Icons.arrow_back,
        color: Colors.white,
        size: 16.0,
      ),
                  style: ElevatedButton.styleFrom(
                      textStyle: TextStyle(color: Colors.white),
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 15, bottom: 15),
                      primary: Color(0xff3498db)),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    "Laporan Stok Masuk",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 14, left: 8, bottom: 8),
            child: Row(
              children: [
                Text(
                  "Periode : ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 6, right: 6),
                  child: Container(
                      width: SizeConfig.screenWidth * 0.125,
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
                                filled: true,
                                fillColor: Colors.white,
                                isDense: true,
                                contentPadding:
                                EdgeInsets.fromLTRB(
                                    8, 14.0, 8, 14.0),
                                // labelStyle: TextStyle(color: Colors.black87),
                                //   focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: GlobalColorPalette.colorButtonActive)),
                                border:
                                OutlineInputBorder()),
                          ),
                        ),
                      )),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: ElevatedButton(
                        onPressed: () {
                          if (selectedProduct.id != null || isAllProduct) {
                            setState(() {
                              isSearchStockIn = true;
                            });
                          } else {
                            GlobalFunctions.showSnackBarWarning(
                                "Masukan nama produk");
                          }
                        },
                        child: Text("Cari"),
                        style: ElevatedButton.styleFrom(
                            textStyle: TextStyle(color: Colors.white),
                            padding: EdgeInsets.only(
                                left: 20, right: 20, top: 15, bottom: 15),
                            primary: Color(0xff3498db)),
                      )),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 12),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.2,
                child: Row(
                  children: [
                    Text(
                      "Semua Produk : ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Checkbox(
                      value: isAllProduct,
                      onChanged: (bool? value) {
                        setState(() {
                          isSearchStockIn = false;
                          selectedProduct = ProductReceivingsModel();
                          isAllProduct = value!;
                        });
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
          !isAllProduct ? autoCompleteProduct() : Container(),
          Divider(
            color: Colors.black,
            thickness: 0.5,
          ),
          isSearchStockIn ? _tableReportStockIn() : _emptyReportStockIn()
        ],
      ),
    );
  }

  Widget autoCompleteProduct() {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Row(
        children: [
          Text(
            "Nama Produk : ",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          Container(
            width: 200,
            child: Autocomplete<ProductReceivingsModel>(
              fieldViewBuilder: (BuildContext context,
                  TextEditingController fieldTextEditingController,
                  FocusNode fieldFocusNode,
                  VoidCallback onFieldSubmitted) {
                return TextFormField(
                  controller: fieldTextEditingController,
                  focusNode: fieldFocusNode,
                  onFieldSubmitted: (value) {
                    onFieldSubmitted();
                  },
                  style: TextStyle(fontSize: 14, color: Colors.black),
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      isDense: true,
                      contentPadding:
                      EdgeInsets.fromLTRB(
                          8, 14.0, 8, 14.0),
                      // labelStyle: TextStyle(color: Colors.black87),
                      //   focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: GlobalColorPalette.colorButtonActive)),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.black
                          )
                      ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black
                      )
                    )
                  ),
                );
              },
              displayStringForOption: (ProductReceivingsModel product) =>
                  product.name!,
              optionsViewBuilder: (context,
                  AutocompleteOnSelected<ProductReceivingsModel> onSelected,
                  Iterable<ProductReceivingsModel> options) {
                return Align(
                    alignment: Alignment.topLeft,
                    child: Material(
                      elevation: 4.0,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.3,
                          maxWidth: MediaQuery.of(context).size.width * 0.15,
                        ),
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _productReceivings.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  onSelected(_productReceivings[index]);
                                },
                                child: ListTile(
                                  title: Text(_productReceivings[index].name!),
                                ),
                              );
                            }),
                      ),
                    ));
              },
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text == '') {
                  return Iterable<ProductReceivingsModel>.empty();
                }
                _productReceivings = baseProduct.where((element) {
                  return element.name!
                      .toLowerCase()
                      .contains(textEditingValue.text.toLowerCase());
                }).toList();
                return _productReceivings;
              },
              onSelected: (ProductReceivingsModel product) {
                selectedProduct = product;
                print("ProductReceivingsModel Selected ${jsonEncode(product)}");
              },
            ),
          ),
        ],
      ),
    );
  }

  _selectDate(BuildContext context) async {
    final DateTimeRange? dateTime = await showDateRangePicker(
            context: context,
            initialEntryMode: DatePickerEntryMode.inputOnly,
            initialDateRange: pickedDateTime,
            firstDate: DateTime(2021),
            // locale: Locale(_languageCode),
            lastDate: DateTime.now())
        .then((value) {});
    if (dateTime != null) {
      setState(() {
        pickedDateTime = DateTimeRange(
            start: DateTime(
                dateTime.start.year, dateTime.start.month, dateTime.start.day),
            end: DateTime(
                dateTime.end.year, dateTime.end.month, dateTime.end.day));
        startDate =
            "${pickedDateTime.start.year}-${pickedDateTime.start.month}-${pickedDateTime.start.day}";
        endDate =
            "${pickedDateTime.end.year}-${pickedDateTime.end.month}-${pickedDateTime.end.day}";
        selectedDateString =
            "${pickedDateTime.start.year}-${pickedDateTime.start.month}-${pickedDateTime.start.day} - ${pickedDateTime.end.year}-${pickedDateTime.end.month}-${pickedDateTime.end.day}";
        _dateController.text = selectedDateString;
      });
    }
  }

  void getProductReportReceivings() async {
    baseProduct = await reportBloc.initProductReportReceivings();
    _productReceivings = baseProduct;
  }

  Future<List<ProductReceivingsModel>> onSearchProductReportReceivings(
      textEditingValue) async {
    List<ProductReceivingsModel> list =
        await reportBloc.initProductReportReceivings();
    _productReceivings = list.where((element) {
      return element.name!
          .toLowerCase()
          .contains(textEditingValue.text.toLowerCase());
    }).toList();
    return _productReceivings;
  }

  Widget _emptyReportStockIn(
      {String title = "Lakukan pencarian terlebih dahulu"}) {
    return Container(
      height: SizeConfig.blockSizeVertical * 40,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/ic_reports.png',
            height: 60,
            width: 60,
          ),
          Container(margin: EdgeInsets.only(top: 16), child: Text(title)),
        ],
      ),
    );
  }

  Widget _tableReportStockIn() {
    return Container(
      width: SizeConfig.blockSizeHorizontal * 100,
      child: FutureBuilder(
          future: stockInBloc.searchReportStockIn(profile.merchantId.toString(), startDate, endDate),
          builder: (context, AsyncSnapshot<List<ReportStockInModel>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            if (snapshot.data!.length == 0) {
              return _emptyReportStockIn(title: "Data Tidak Ditemukan");
            } else {
              print("snapshot.data ${jsonEncode(snapshot.data)}");
              return PaginatedDataTable(
                // sortColumnIndex: _currentSortColumn,
                // sortAscending: _isAscending,
                // columnSpacing: 0,
                // horizontalMargin: 0,
                rowsPerPage: 5,
                showCheckboxColumn: false,
                columns: <DataColumn>[
                  for (final header in _headColumnModel)
                    DataColumn(
                        label: Expanded(
                          child: Text(
                            header.name!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                        tooltip: header.name,
                        ),
                ],
                source: StockInDataSource(context, snapshot.data!),
              );
            }
          } else {
            return _emptyReportStockIn();
          }
        }
        else {
          return Container(
            height: SizeConfig.blockSizeVertical * 40,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [CircularProgressIndicator(),
              ],
            ),
          );
        }
      }),
    );
  }
}
