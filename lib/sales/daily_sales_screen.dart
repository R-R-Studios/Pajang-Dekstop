import 'package:beben_pos_desktop/model/head_column_model.dart';
import 'package:beben_pos_desktop/sales/datasource/daily_sales_data_source.dart';
import 'package:flutter/material.dart';

import 'model/daily_sales_model.dart';

class DailySalesScreen extends StatefulWidget {
  const DailySalesScreen({Key? key}) : super(key: key);

  @override
  _DailySalesScreenState createState() => _DailySalesScreenState();
}

class _DailySalesScreenState extends State<DailySalesScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentSortColumn = 0;
  bool _isAscending = true;
  List<DailySalesModel> _dailySalesList = [];

  List<HeadColumnModel> _checkboxModel = [
    HeadColumnModel(key: "1", name: "Id", ischecked: false),
    HeadColumnModel(key: "2", name: "Time", ischecked: false),
    HeadColumnModel(key: "3", name: "Customer", ischecked: false),
    HeadColumnModel(key: "4", name: "Amount Due", ischecked: false),
    HeadColumnModel(key: "5", name: "Amount Tendered", ischecked: false),
    HeadColumnModel(key: "6", name: "Change Due", ischecked: false),
    HeadColumnModel(key: "7", name: "Type", ischecked: false),
    HeadColumnModel(key: "8", name: "Invoice", ischecked: false),
  ];

  Widget productPaginateData() => Container(
        width: double.infinity,
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
                  label: Text(
                    header.name!,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
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
          source: DailySalesDataSource(context, _dailySalesList, _formKey),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Container(
          child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            child: Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 5),
                    child: TextButton.icon(
                      onPressed: () {
                        print('Clicked Sales Register');
                      },
                      icon: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 24.0,
                      ),
                      label: Text("Sales Register"),
                      style: TextButton.styleFrom(
                          backgroundColor: Color(0xff3498db),
                          padding: EdgeInsets.only(
                              left: 16, right: 16, top: 12, bottom: 12),
                          primary: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: TextButton.icon(
                      onPressed: () {},
                      icon: Icon(
                        Icons.print,
                        color: Colors.white,
                        size: 24.0,
                      ),
                      label: Text("Print"),
                      style: TextButton.styleFrom(
                          backgroundColor: Color(0xff3498db),
                          padding: EdgeInsets.only(
                              left: 16, right: 16, top: 12, bottom: 12),
                          primary: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
