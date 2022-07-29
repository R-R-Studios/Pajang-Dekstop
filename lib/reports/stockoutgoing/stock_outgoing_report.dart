import 'package:beben_pos_desktop/model/head_column_model.dart';
import 'package:beben_pos_desktop/receivings/model/product_receivings_model.dart';
import 'package:beben_pos_desktop/reports/stockoutgoing/bloc/stock_outgoing_bloc.dart';
import 'package:beben_pos_desktop/reports/stockoutgoing/datasource/stock_outgoing_data_source.dart';
import 'package:beben_pos_desktop/reports/stockoutgoing/model/stock_outgoing_model.dart';
import 'package:beben_pos_desktop/reports/stockoutgoing/widget/dialog_find_product.dart';
import 'package:beben_pos_desktop/utils/global_color_palette.dart';
import 'package:beben_pos_desktop/utils/global_functions.dart';
import 'package:beben_pos_desktop/utils/size_config.dart';
import 'package:flutter/material.dart';

import '../bloc/report_bloc.dart';
import '../reports_merchant.dart';

class StockOutgoingReport extends StatefulWidget {
  const StockOutgoingReport({Key? key}) : super(key: key);

  @override
  _StockOutgoingReportState createState() => _StockOutgoingReportState();
}

class _StockOutgoingReportState extends State<StockOutgoingReport> {
  ReportBloc _reportBloc = ReportBloc();
  late ProductReceivingsModel productReceivings;
  StockOutGoingBloc stockOutGoingBloc = StockOutGoingBloc();
  TextEditingController productTextController = TextEditingController();
  TextEditingController unitTextController = TextEditingController();
  int _currentSortColumn = 0;
  bool _isAscending = true;

  List<HeadColumnModel> _headColumnModel = [
    HeadColumnModel(key: "1", name: "Tanggal", ischecked: false),
    HeadColumnModel(key: "2", name: "Nama Barang", ischecked: false),
    HeadColumnModel(key: "3", name: "Barcode", ischecked: false),
    HeadColumnModel(key: "4", name: "Kode barang", ischecked: false),
    HeadColumnModel(key: "5", name: "Satuan", ischecked: false),
    HeadColumnModel(key: "6", name: "Jumlah stock awal", ischecked: false),
    HeadColumnModel(key: "7", name: "Jumlah transaksi", ischecked: false),
    HeadColumnModel(key: "8", name: "Stock akhir", ischecked: false),
    HeadColumnModel(key: "9", name: "Status", ischecked: false),
  ];

  DateTimeRange pickedDateTime = DateTimeRange(
      start: DateTime(2020, 1, 1),
      end: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day));
  late var selectedDateString =
      "${pickedDateTime.start.year}-${pickedDateTime.start.month}-${pickedDateTime.start.day}";
  late var selectedToDateString =
      "${pickedDateTime.end.year}-${pickedDateTime.end.month}-${pickedDateTime.end.day}";
  late var productId = 0;
  String productName = "";
  late var unitsId = 0;
  late TextEditingController _dateController = TextEditingController(
      text:
          "${pickedDateTime.start.year}/${pickedDateTime.start.month}/${pickedDateTime.start.day} - ${pickedDateTime.end.year}/${pickedDateTime.end.month}/${pickedDateTime.end.day}");
  late TextEditingController _toDateController = TextEditingController(
      text:
          "${pickedDateTime.start.year}/${pickedDateTime.start.month}/${pickedDateTime.start.day} - ${pickedDateTime.end.year}/${pickedDateTime.end.month}/${pickedDateTime.end.day}");

  _selectDate(BuildContext context) async {
    final DateTimeRange? dateTime = await showDateRangePicker(
        context: context,
        initialEntryMode: DatePickerEntryMode.inputOnly,
        initialDateRange: pickedDateTime,
        firstDate: DateTime(2020),
        // locale: Locale(_languageCode),
        lastDate: DateTime.now());
    pickedDateTime = DateTimeRange(
        start: DateTime(
            dateTime!.start.year, dateTime.start.month, dateTime.start.day),
        end: DateTime(dateTime.end.year, dateTime.end.month, dateTime.end.day));
    selectedDateString =
        "${pickedDateTime.start.year}-${pickedDateTime.start.month}-${pickedDateTime.start.day}";
    selectedToDateString =
        "${pickedDateTime.end.year}-${pickedDateTime.end.month}-${pickedDateTime.end.day}";
    _dateController.text =
        "${pickedDateTime.start.year}/${pickedDateTime.start.month}/${pickedDateTime.start.day} - ${pickedDateTime.end.year}/${pickedDateTime.end.month}/${pickedDateTime.end.day}";
    _toDateController.text =
        "${pickedDateTime.start.year}/${pickedDateTime.start.month}/${pickedDateTime.start.day} - ${pickedDateTime.end.year}/${pickedDateTime.end.month}/${pickedDateTime.end.day}";
  }

  Widget transactionDataSource(context) => Container(
        width: double.infinity,
        child: FutureBuilder(
            future: stockOutGoingBloc.futureProductReceivings(
                selectedDateString, selectedToDateString),
            builder:
                (context, AsyncSnapshot<List<StockOutgoingModel>> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  if (snapshot.data!.length == 0) {
                    return Container(
                      height: SizeConfig.screenHeight * 0.5,
                      child: Center(
                        child: Text("Tidak ada barang masuk dan keluar",
                            textAlign: TextAlign.center),
                      ),
                    );
                  } else {
                    return PaginatedDataTable(
                      sortColumnIndex: _currentSortColumn,
                      sortAscending: _isAscending,
                      columnSpacing: 0,
                      horizontalMargin: 0,
                      rowsPerPage: 15,
                      showCheckboxColumn: false,
                      columns: <DataColumn>[
                        for (final header in _headColumnModel)
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
                                  // if(_currentSortColumn == 0){
                                  //   _sortId();
                                  // }else if(_currentSortColumn == 1){
                                  //   _sortFirstName();
                                  // }else if(_currentSortColumn == 2){
                                  //   _sortLastName();
                                  // }else if(_currentSortColumn == 3){
                                  //   _sortEmail();
                                  // }else if(_currentSortColumn == 4){
                                  //   _sortPhoneNumber();
                                  // }else if(_currentSortColumn == 5){
                                  //   _sortTotalSpent();
                                  // }
                                });
                              }),
                      ],
                      source: StockOutGoingDataSource(context, snapshot.data!),
                    );
                  }
                } else {
                  return Container(
                    height: SizeConfig.screenHeight * 0.5,
                    child: Center(
                      child: Text("Lakukan pencarian terlebih dahulu",
                          textAlign: TextAlign.center),
                    ),
                  );
                }
              } else {
                return Container(
                  height: SizeConfig.screenHeight * 0.5,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                    ],
                  ),
                );
              }
            }),
      );

  bool allproduct = true;
  bool canSearchDataReport = false;

  @override
  void initState() {
    // TODO: implement initState
    stockOutGoingBloc.init();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    stockOutGoingBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return StreamBuilder<String>(
        stream: _reportBloc.streamReportView,
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.data == "")
            return ReportsMerchant();
          else {
            return SingleChildScrollView(
              child: Container(
                  margin: EdgeInsets.all(12),
                  child: Column(children: [
                    Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            _reportBloc.setToReportView("");
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 16.0,
                          ),
                          label: Text(''),
                          style: ElevatedButton.styleFrom(
                              textStyle: TextStyle(color: Colors.white),
                              padding: EdgeInsets.only(
                                  left: 14, right: 14, top: 14, bottom: 14),
                              primary: Color(0xff3498db)),
                        ),
                        Container(
                            margin: EdgeInsets.only(left: 12),
                            child: Text(
                              'Laporan Barang Keluar',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 24),
                            ))
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Periode',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
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
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Checkbox(
                                        value: allproduct,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            allproduct = value!;
                                            if (value == false) {
                                              productTextController.text = "";
                                              productName =
                                                  productTextController.text;
                                            } else {
                                              productName =
                                                  productTextController.text;
                                            }
                                          });
                                          print('$allproduct');
                                        }),
                                    Text(
                                      'Semua Produk',
                                      style: new TextStyle(fontSize: 14.0),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            allproduct == false
                                ? Row(
                                    children: [
                                      Text('Nama barang'),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 6, right: 6),
                                        child: SizedBox(
                                          width: SizeConfig.screenWidth * 0.2,
                                          child: TextFormField(
                                            controller: productTextController,
                                            onTap: () {
                                              showDialog(
                                                  context: context,
                                                  barrierDismissible: true,
                                                  builder: (BuildContext c) {
                                                    return DialogFindProduct();
                                                  }).then((value) {
                                                if (value != null) {
                                                  productReceivings = value;
                                                  GlobalFunctions.logPrint(
                                                      "Open Dialog Product",
                                                      '${productReceivings.name}');
                                                  productTextController.text =
                                                      productReceivings.name!;
                                                  productId =
                                                      productReceivings.id!;
                                                }
                                              });
                                            },
                                            maxLines: 1,
                                            style: TextStyle(
                                                fontSize: 14, height: 1),
                                            decoration: new InputDecoration(
                                              fillColor: Colors.white,
                                              isDense: true,
                                              contentPadding:
                                                  EdgeInsets.fromLTRB(
                                                      8, 14.0, 8, 14.0),
                                              filled: true,
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: GlobalColorPalette
                                                        .colorButtonActive,
                                                    width: 1.0),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey,
                                                    width: 1.0),
                                              ),
                                              hintText: 'etc..',
                                            ),
                                            onChanged: (String value) {},
                                            onFieldSubmitted: (String value) {},
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Container(),
                            ElevatedButton.icon(
                              onPressed: () {
                                productName = productTextController.text;
                                requestGetStockOutgoingReport();
                              },
                              icon: Icon(
                                Icons.search,
                                color: Colors.white,
                                size: 14.0,
                              ),
                              label: Text("Cari"),
                              style: ElevatedButton.styleFrom(
                                  textStyle: TextStyle(color: Colors.white),
                                  padding: EdgeInsets.only(
                                      left: 20, right: 20, top: 16, bottom: 16),
                                  primary: Color(0xff3498db)),
                            ),
                          ]),
                    ),
                    Divider(),
                    canSearchDataReport
                        ? transactionDataSource(context)
                        : Container(
                            height: SizeConfig.screenHeight * 0.5,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/ic_reports.png',
                                  height: 60,
                                  width: 60,
                                ),
                                Container(
                                    margin: EdgeInsets.only(top: 16),
                                    child: Text(
                                        'Lakukan pencarian terlebih dahulu')),
                              ],
                            ),
                          ),

                    // transactionDataSource(context),
                  ])),
            );
          }
        });
  }

  void requestGetStockOutgoingReport() async {
    print('start_date $selectedDateString');
    print('end_date $selectedToDateString');
    print('product_name $productTextController.text');
    setState(() {
      canSearchDataReport = true;
    });
    await stockOutGoingBloc.futureProductReceivings(
        selectedDateString, selectedToDateString);
  }
}
