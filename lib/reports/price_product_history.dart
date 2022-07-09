import 'package:beben_pos_desktop/model/head_column_model.dart';
import 'package:beben_pos_desktop/reports/datasource/price_product_history_data_source.dart';
import 'package:beben_pos_desktop/reports/model/price_product_history_model.dart';
import 'package:beben_pos_desktop/reports/reports_merchant.dart';
import 'package:beben_pos_desktop/utils/global_color_palette.dart';
import 'package:beben_pos_desktop/utils/size_config.dart';
import 'package:flutter/material.dart';

import 'bloc/report_bloc.dart';

class PriceProductHistory extends StatefulWidget {
  const PriceProductHistory({Key? key}) : super(key: key);

  @override
  _PriceProductHistoryState createState() => _PriceProductHistoryState();
}

class _PriceProductHistoryState extends State<PriceProductHistory> {
  ReportBloc reportBloc = ReportBloc();
  int _currentSortColumn = 0;
  bool _isAscending = true;
  DateTimeRange pickedDateTime = DateTimeRange(
      start: DateTime(2020, 1, 1),
      end: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day));
  late var selectedDateString =
      "${pickedDateTime.start.year}/${pickedDateTime.start.month}/${pickedDateTime.start.day} - ${pickedDateTime.end.year}/${pickedDateTime.end.month}/${pickedDateTime.end.day}";
  late TextEditingController _dateController =
  TextEditingController(text: selectedDateString);
  List<PriceProductHistoryModel> listPriceProduct = [];

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
    HeadColumnModel(key: "1", name: "ID", ischecked: false),
    HeadColumnModel(key: "2", name: "Product Name", ischecked: false),
    HeadColumnModel(key: "3", name: "Code", ischecked: false),
    HeadColumnModel(key: "4", name: "Barcode", ischecked: false),
    HeadColumnModel(key: "5", name: "Action", ischecked: false)
  ];

  Widget layoutEmptyDataTable() {
    return Card(
      color: Colors.lightBlueAccent,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
            child: Text(
              "There are no history",
              style: TextStyle(color: Colors.white),
            )),
      ),
    );
  }

  Widget productPriceDataSource(context) => Container(
    width: double.infinity,
    child: StreamBuilder(
        stream: reportBloc.streamPriceProductList,
        builder: (context, AsyncSnapshot<List<PriceProductHistoryModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting){
            return CircularProgressIndicator();
          } else if (snapshot.hasData) {
            if(snapshot.data!.length > 0){
              listPriceProduct = snapshot.data!;
            }else{
              listPriceProduct = [PriceProductHistoryModel()];
            }
            return PaginatedDataTable(
              sortColumnIndex: _currentSortColumn,
              sortAscending: _isAscending,
              rowsPerPage: listPriceProduct.length > 5 ? 5 : listPriceProduct.length,
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
                          _isAscending = _sortAscending;
                        });
                      }),
              ],
              source: PriceProductHistoryDataSource(
                  context,
                  listPriceProduct.length > 0 ? listPriceProduct : [PriceProductHistoryModel()]),
            );
          } else {
            return Text("Data kosong");
          }
        }),
  );

  @override
  void initState() {
    // TODO: implement initState
    reportBloc.init();
    List<PriceProductHistoryModel> list = [];
    for(int i = 0; i < 15; i++){
      list.add(PriceProductHistoryModel(
        id: i+1,
        productName: "Product ${i+1}",
        code: "Code ${i+1}",
        barcode: "Barcode ${i+1}"
      ));
    }
    reportBloc.initPriceProductHistory(list);
    super.initState();
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
            return Container(
              margin: EdgeInsets.all(12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 8,bottom: 8),
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
                              child: Text('Report Transactions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),))
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 5, right: 5, top: 5),
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
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
                              setState(() {
                                onSearchPriceProduct(value);
                              });
                            },
                            onFieldSubmitted: (String value){
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  productPriceDataSource(context)
                ],
              ),
            );
        });
  }

  onSearchPriceProduct(String value) {
    reportBloc.onSearchPriceProductHistory(value);
  }
}
