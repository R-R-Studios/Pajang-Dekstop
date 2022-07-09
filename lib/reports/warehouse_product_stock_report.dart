
import 'package:beben_pos_desktop/reports/reports_merchant.dart';
import 'package:flutter/material.dart';

import 'bloc/report_bloc.dart';

class WarehouseProductStockReport extends StatefulWidget {
  const WarehouseProductStockReport({Key? key}) : super(key: key);

  @override
  _WarehouseProductStockReportState createState() => _WarehouseProductStockReportState();
}

class _WarehouseProductStockReportState extends State<WarehouseProductStockReport> {
  ReportBloc _reportBloc = ReportBloc();
  @override
  Widget build(BuildContext context) {
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
                    padding: EdgeInsets.only(top: 8,bottom: 8),
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
                                padding: EdgeInsets.only(
                                    left: 20, right: 20, top: 15, bottom: 15),
                                primary: Color(0xff3498db)),
                          ),
                          Container(
                              margin: EdgeInsets.only(left: 12),
                              child: Text('Report Warehouse Product Stock', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),))
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 8),
                    child: TextFormField(
                      maxLines: 1,
                      style: TextStyle(fontSize: 12, height: 1),
                      decoration: new InputDecoration(
                        fillColor: Colors.white,
                        isDense: true,
                        contentPadding: EdgeInsets.fromLTRB(6, 18.0, 6, 18.0),
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        hintText: 'Cari Produk',
                      ),
                      onChanged: (String value){

                      },
                      onFieldSubmitted: (String value){

                      },
                    ),
                  ),

                ],
              ),
            );
        });
  }
}
