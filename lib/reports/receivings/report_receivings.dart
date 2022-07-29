import 'package:beben_pos_desktop/reports/bloc/report_bloc.dart';
import 'package:beben_pos_desktop/reports/receivings/model/product_report_receivings_model.dart';
import 'package:beben_pos_desktop/reports/receivings/model/report_receivings_model.dart';
import 'package:beben_pos_desktop/reports/receivings/model/search_report_receivings.dart';
import 'package:flutter/material.dart';

class ReportReceivings extends StatefulWidget {
  ReportReceivings(
      this.searchReportReceivings, this.reportBloc, this.listReport);

  final SearchReportReceivings searchReportReceivings;
  final ReportBloc reportBloc;
  final List<ReportReceivingsModel> listReport;

  @override
  _ReportReceivingsState createState() => _ReportReceivingsState();
}

class _ReportReceivingsState extends State<ReportReceivings> {
  late ReportBloc reportBloc = widget.reportBloc;
  late List<ReportReceivingsModel> listReport = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listReport = widget.listReport;
    listReport.sort((a, b) => a.detail!.tanggal!
        .toLowerCase()
        .compareTo(b.detail!.tanggal!.toLowerCase()));
    print("widget.listReport ${widget.listReport.length}");
    print("listReport ${listReport.length}");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.only(
                top: 16.0, bottom: 8.0, left: 8.0, right: 8.0),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        reportBloc.updateViewReportReceivings(false);
                      });
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
                ),
                Center(
                  child: Text(
                    "Laporan Barang Masuk",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.black,
            thickness: 0.5,
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.7,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  for (ReportReceivingsModel report in listReport)
                    reportUnit(report)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget reportUnit(ReportReceivingsModel report) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            padding: EdgeInsets.only(left: 12, right: 12, top: 10, bottom: 10),
            child: Align(
              alignment: Alignment.topLeft,
              child: Column(
                children: [
                  Row(
                    children: [
                      Text("PERIODE : ${report.detail?.tanggal}",
                          textAlign: TextAlign.start),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        Text("Nama Barang : "),
                        Text("${report.detail?.productName ?? "-"}"),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        Text("Satuan : "),
                        Text(report.detail?.unitName ?? "-"),
                      ],
                    ),
                  ),
                  tableReport(report.product ?? []),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget tableReport(List<ProductReportReceicingsModel> list) {
    list.sort((a, b) =>
        a.tanggalAwal!.toLowerCase().compareTo(b.tanggalAwal!.toLowerCase()));
    int totalReceivings = 0;
    for (ProductReportReceicingsModel product in list) {
      totalReceivings += product.trxStock ?? 0;
    }
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: DataTable(
        columns: tableColumnReport(),
        rows: <DataRow>[
          for (int i = 0; i < list.length; i++)
            DataRow(
              cells: <DataCell>[
                DataCell(Text(list[i].tanggalAwal ?? "-")),
                DataCell(Text("${list[i].merchantProductStocks ?? 0}")),
                DataCell(Text("${list[i].trxStock ?? 0}")),
                DataCell(Text("${list[i].lastStock ?? 0}")),
              ],
            ),
          DataRow(
            cells: <DataCell>[
              DataCell(
                Text(
                  "Total Jumlah Masuk : ",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              DataCell(
                Text(""),
              ),
              DataCell(
                Text(
                  totalReceivings.toString(),
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              DataCell(
                Text(""),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<DataColumn> tableColumnReport() {
    return <DataColumn>[
      DataColumn(
        label: Container(
          width: MediaQuery.of(context).size.width * 0.2,
          child: Text("Tanggal"),
        ),
      ),
      DataColumn(
        label: Container(
          width: MediaQuery.of(context).size.width * 0.2,
          child: Text("Stok Awal"),
        ),
      ),
      DataColumn(
        label: Container(
          width: MediaQuery.of(context).size.width * 0.2,
          child: Text("Jumlah Masuk"),
        ),
      ),
      DataColumn(
        label: Container(
          width: MediaQuery.of(context).size.width * 0.2,
          child: Text("Stok Akhir"),
        ),
      ),
    ];
  }
}
