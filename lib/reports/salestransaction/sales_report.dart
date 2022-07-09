import 'package:beben_pos_desktop/db/profile_db.dart';
import 'package:beben_pos_desktop/model/head_column_model.dart';
import 'package:beben_pos_desktop/profile/bloc/profile_bloc.dart';
import 'package:beben_pos_desktop/reports/reports_merchant.dart';
import 'package:beben_pos_desktop/sales/widget/pdf_invoice.dart';
import 'package:beben_pos_desktop/utils/size_config.dart';
import 'package:flutter/material.dart';

import '../bloc/report_bloc.dart';
import 'bloc/sales_report_bloc.dart';
import 'datasource/sales_report_data_source.dart';
import 'model/report_transaction_model.dart';

class SalesReports extends StatefulWidget {
  const SalesReports({Key? key}) : super(key: key);

  @override
  _SalesReportsState createState() => _SalesReportsState();
}

class _SalesReportsState extends State<SalesReports> {
  ReportBloc reportBloc = ReportBloc();
  SalesReportBloc salesReportBloc = SalesReportBloc();
  int _currentSortColumn = 0;
  bool _isAscending = true;
  bool isSearching = false;
  bool isCanExport = false;
  ProfileDB profile = ProfileDB();
  List<SalesTransactionModel> listTransactionForPDF = [];
  late Future getReportTransaction;
  DateTimeRange pickedDateTime = DateTimeRange(
      start: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day
      ),
      end: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day));
  late var selectedDateString =
      "${pickedDateTime.start.year}-${pickedDateTime.start.month}-${pickedDateTime.start.day}";
  late var selectedToDateString =
      "${pickedDateTime.end.year}-${pickedDateTime.end.month}-${pickedDateTime.end.day}";
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
    isSearching = false;
    pickedDateTime = await DateTimeRange(
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

  List<HeadColumnModel> _headColumnModel = [
    HeadColumnModel(key: "1", name: "Tanggal Invoice", ischecked: false),
    HeadColumnModel(key: "2", name: "Nama Barang", ischecked: false),
    HeadColumnModel(key: "3", name: "Kode Transaksi", ischecked: false),
    HeadColumnModel(key: "4", name: "Qty", ischecked: false),
    HeadColumnModel(key: "5", name: "Satuan", ischecked: false),
    HeadColumnModel(key: "6", name: "Harga Jual", ischecked: false),
    HeadColumnModel(key: "8", name: "Total", ischecked: false),
    HeadColumnModel(key: "9", name: "Profit", ischecked: false),
    HeadColumnModel(key: "10", name: "action", ischecked: false),
  ];

  Widget layoutEmptyDataTable() {
    return Card(
      color: Colors.lightBlueAccent,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
            child: Text(
          "There are no Transaction",
          style: TextStyle(color: Colors.white),
        )),
      ),
    );
  }

  Widget loadingData(context) => Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );

  Widget transactionDataSource(context) => Container(
        width: double.infinity,
        child: FutureBuilder(
            future: salesReportBloc.futureProductReceivings(
                selectedDateString, selectedToDateString),
            builder: (BuildContext ctx, AsyncSnapshot<List<SalesTransactionModel>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                    child: Center(child: CircularProgressIndicator()));
              } else if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  if (snapshot.data?.length == 0){
                    isCanExport = false;
                    return Center(child: Text('Data kosong'));
                  }  else {
                  isCanExport = true;
                listTransactionForPDF = [];
                listTransactionForPDF.addAll(snapshot.data!);
                return PaginatedDataTable(
                  sortColumnIndex: _currentSortColumn,
                  sortAscending: _isAscending,
                  columnSpacing: 0,
                  horizontalMargin: 0,
                  rowsPerPage: 20,
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
                  source: SalesReportDataSource(
                      context, snapshot.data!),
                );
                  }
                } else {
                  return Text("Data kosong");
                }
              } else {
                return Text("Data kosong");
              }
            }),
      );

  @override
  void initState() {
    reportBloc.init();
    ProfileBloc().getProfile().then((value) async {
      profile = value;
      print('profile merchantName : ${profile.merchantName}');
    });

    super.initState();
  }

  @override
  void dispose() {
    reportBloc.close();
    salesReportBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return StreamBuilder<String>(
        stream: reportBloc.streamReportView,
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.data == "")
            return ReportsMerchant();
          else
            return SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 8, bottom: 8),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                reportBloc.setToReportView("");
                              },
                              icon: Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                                size: 16.0,
                              ),
                              label: Text("Back"),
                              style: ElevatedButton.styleFrom(
                                  textStyle: TextStyle(color: Colors.white),
                                  padding: EdgeInsets.only(
                                      left: 20, right: 20, top: 15, bottom: 15),
                                  primary: Color(0xff3498db)),
                            ),
                            Container(
                                margin: EdgeInsets.only(left: 12),
                                child: Text(
                                  'Laporan Penjualan',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 24),
                                ))
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(bottom: 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text('Periode'),
                                    Padding(
                                      padding: EdgeInsets.only(left: 8, right: 8),
                                      child: Container(
                                          width: SizeConfig.screenWidth * 0.15,
                                          child: GestureDetector(
                                            onTap: () => _selectDate(context),
                                            child: AbsorbPointer(
                                              child: TextFormField(
                                                controller: _dateController,
                                                keyboardType: TextInputType.datetime,
                                                style: TextStyle(
                                                    fontSize: 14, color: Colors.black),
                                                decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor: Colors.white,
                                                    isDense: true,
                                                    contentPadding: EdgeInsets.fromLTRB(
                                                        6, 17.0, 6, 17.0),
                                                    // labelStyle: TextStyle(color: Colors.black87),
                                                    //   focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: GlobalColorPalette.colorButtonActive)),
                                                    border: OutlineInputBorder()),
                                              ),
                                            ),
                                          )),
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: () async {
                                        // print('from_date $selectedDateString');
                                        // print('from_date $selectedToDateString');
                                        // await salesReportBloc.futureProductReceivings(selectedDateString, selectedToDateString);
                                        setState(() {
                                          isSearching = true;
                                        });
                                      },
                                      icon: Icon(
                                        Icons.search,
                                        color: Colors.white,
                                        size: 16.0,
                                      ),
                                      label: Text("Cari"),
                                      style: ElevatedButton.styleFrom(
                                          textStyle: TextStyle(color: Colors.white),
                                          padding: EdgeInsets.only(
                                              left: 20, right: 20, top: 15, bottom: 15),
                                          primary: Color(0xff3498db)),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: ElevatedButton.icon(
                                    onPressed: () async {
                                      showDialogExport(context, selectedDateString, selectedToDateString);
                                    },
                                    icon: Icon(
                                      Icons.print,
                                      color: Colors.white,
                                      size: 16.0,
                                    ),
                                    label: Text("Export PDF"),
                                    style: ElevatedButton.styleFrom(
                                        textStyle: TextStyle(color: Colors.white),
                                        padding: EdgeInsets.only(
                                            left: 20, right: 20, top: 15, bottom: 15),
                                        primary: Color(0xff3498db)),
                                  ),
                                )

                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    transactionDataSource(context)
                  ],
                ),
              ),
            );
        });
  }

  showDialogExport(BuildContext context, String startDate, String endDate) {
    BuildContext dialogContext;
    return showDialog(
        context: context,
        builder: (BuildContext ctx) => AlertDialog(
      title: const Text('Perhatian'),
      content: const Text('Anda yakin untuk export laporan kedalam PDF ?'),
      actions: [
        Container(
          margin: EdgeInsets.only(bottom: 8),
          child: TextButton(
            onPressed: () => Navigator.pop(ctx, 'Batalkan'),
            child: const Text('Batalkan'),
          ),
        ),
        TextButton(
          onPressed: () async {
          await PdfInvoiceSales.generate(startDate, endDate, listTransactionForPDF, profile.merchantName ?? "Raja Sembako");
            Navigator.pop(ctx, 'OK');
    },
          child: const Text('OK'),
        ),
      ],
    ));
  }
}
