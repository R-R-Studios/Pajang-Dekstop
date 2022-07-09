
import 'package:beben_pos_desktop/model/head_column_model.dart';
import 'package:beben_pos_desktop/reports/datasource/merchant_transaction_data_source.dart';
import 'package:beben_pos_desktop/reports/model/report_merchant_transaction_model.dart';
import 'package:beben_pos_desktop/utils/global_color_palette.dart';
import 'package:beben_pos_desktop/utils/size_config.dart';
import 'package:flutter/material.dart';

import 'bloc/report_bloc.dart';
import 'reports_merchant.dart';

class MerchantTransactionReport extends StatefulWidget {
  const MerchantTransactionReport({Key? key}) : super(key: key);

  @override
  _MerchantTransactionReportState createState() => _MerchantTransactionReportState();
}

class _MerchantTransactionReportState extends State<MerchantTransactionReport> {
  ReportBloc _reportBloc = ReportBloc();
  int _currentSortColumn = 0;
  bool _isAscending = true;
  DateTimeRange pickedDateTime = DateTimeRange(
      start: DateTime(2020, 1, 1),
      end: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day));
  late var selectedDateString =
      "${pickedDateTime.start.year}/${pickedDateTime.start.month}/${pickedDateTime.start.day} - ${pickedDateTime.end.year}/${pickedDateTime.end.month}/${pickedDateTime.end.day}";
  late TextEditingController _dateController =
  TextEditingController(text: selectedDateString);

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

  List<HeadColumnModel> _headColumnModel = [
    HeadColumnModel(key: "2", name: "Merchant", ischecked: false),
    HeadColumnModel(key: "3", name: "Last Stock", ischecked: false),
    HeadColumnModel(key: "4", name: "Current Stock", ischecked: false),
    HeadColumnModel(key: "5", name: "Currnet Price", ischecked: false),
    HeadColumnModel(key: "6", name: "Sale Price", ischecked: false),
    HeadColumnModel(key: "7", name: "Qty", ischecked: false),
    HeadColumnModel(key: "8", name: "Total Amount", ischecked: false),
    HeadColumnModel(key: "9", name: "Created At", ischecked: false),
  ];

  Widget transactionDataSource(context) => Container(
    width: double.infinity,
    child: StreamBuilder(
        stream: _reportBloc.streamMerchantTransactionReport,
        builder: (context, AsyncSnapshot<List<ReportMerchantTransactionModel>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data?.length == 0)
              // return layoutEmptyDataTable();
              return PaginatedDataTable(
                sortColumnIndex: _currentSortColumn,
                sortAscending: _isAscending,
                columnSpacing: 0,
                horizontalMargin: 0,
                rowsPerPage: snapshot.data?.length == 0 ? 1 : 5,
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
                source: MerchantTransactionDataSource(
                    context,
                    snapshot.data!),
              );
            else
              return PaginatedDataTable(
                sortColumnIndex: _currentSortColumn,
                sortAscending: _isAscending,
                columnSpacing: 0,
                horizontalMargin: 0,
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
                source: MerchantTransactionDataSource(
                    context,
                    snapshot.data!),
              );
          } else {
            return Text("Data kosong");
          }
        }),
  );

  @override
  void initState() {
    // TODO: implement initState
    _reportBloc.initReportMerchant();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _reportBloc.close();
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
          else
            return Container(
              margin: EdgeInsets.all(12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 8,bottom: 12),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Row(
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
                            label: Text("Back"),
                            style: ElevatedButton.styleFrom(
                                textStyle: TextStyle(color: Colors.white),
                                padding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
                                primary: Color(0xff3498db)),
                          ),
                          Container(
                              margin: EdgeInsets.only(left: 12),
                              child: Text('Report Merchant Transactions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),))
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
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: SizeConfig.screenWidth * 0.2,
                              child: TextFormField(
                                maxLines: 1,
                                style: TextStyle(fontSize: 14, height: 1),
                                decoration: new InputDecoration(
                                  fillColor: Colors.white,
                                  isDense: true,
                                  contentPadding: EdgeInsets.fromLTRB(6, 18.0, 6, 18.0),
                                  filled: true,
                                  prefixIcon: Icon(Icons.search),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: GlobalColorPalette.colorButtonActive, width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                                  ),
                                  hintText: 'Cari',
                                ),
                                onChanged: (String value){

                                },
                                onFieldSubmitted: (String value){

                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Container(
                                  width: SizeConfig.screenWidth * 0.15,
                                  child: GestureDetector(
                                    onTap: () => _selectDate(context),
                                    child: AbsorbPointer(
                                      child: TextFormField(
                                        controller: _dateController,
                                        keyboardType: TextInputType.datetime,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black),
                                        decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white,
                                            isDense: true,
                                            contentPadding: EdgeInsets.fromLTRB(6, 17.0, 6, 17.0),
                                            // labelStyle: TextStyle(color: Colors.black87),
                                            //   focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: GlobalColorPalette.colorButtonActive)),
                                            border: OutlineInputBorder()),
                                      ),
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  transactionDataSource(context)
                ],
              ),
            );
        });
  }
}
