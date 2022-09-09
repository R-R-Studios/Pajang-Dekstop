import 'package:beben_pos_desktop/component/component.dart';
import 'package:beben_pos_desktop/content/model/employee.dart';
import 'package:beben_pos_desktop/core/app/constant.dart';
import 'package:beben_pos_desktop/delivery/model/order_delivery.dart';
import 'package:beben_pos_desktop/delivery/model/vehicle.dart';
import 'package:beben_pos_desktop/delivery/source/source_transaction.dart';
import 'package:beben_pos_desktop/model/head_column_model.dart';
import 'package:beben_pos_desktop/utils/size_config.dart';
import 'package:flutter/material.dart';

class DeliveryFormView extends StatelessWidget {

  DeliveryFormView({ Key? key }) : super(key: key);

  final List<HeadColumnModel> _headColumnTransaction = [
    HeadColumnModel(key: "1", name: "ID", ischecked: false),
    HeadColumnModel(key: "2", name: "Kode Transaksi", ischecked: false),
    HeadColumnModel(key: "3", name: "Kuantitas", ischecked: false),
    HeadColumnModel(key: "4", name: "Jumlah Total", ischecked: false),
    HeadColumnModel(key: "5", name: "Tanggal Di Buat", ischecked: false),
    HeadColumnModel(key: "6", name: "Aksi", ischecked: false),
  ];
  
  final List<HeadColumnModel> _headColumnVehichle = [
    HeadColumnModel(key: "1", name: "Nopol", ischecked: false),
    HeadColumnModel(key: "2", name: "Merk", ischecked: false),
    HeadColumnModel(key: "3", name: "Deskripsi", ischecked: false),
    HeadColumnModel(key: "4", name: "Aksi", ischecked: false),
  ];

  final List<HeadColumnModel> _headColumnEmployee = [
    HeadColumnModel(key: "1", name: "Nama Karyawan", ischecked: false),
    HeadColumnModel(key: "2", name: "Pekerjaan", ischecked: false),
    HeadColumnModel(key: "3", name: "Nomor Telepon", ischecked: false),
    HeadColumnModel(key: "4", name: "Aksi", ischecked: false),
  ];

  final List<HeadColumnModel> _headColumnOperational = [
    HeadColumnModel(key: "1", name: "Harga", ischecked: false),
    HeadColumnModel(key: "2", name: "Keterangan", ischecked: false),
    HeadColumnModel(key: "3", name: "Aksi", ischecked: false),
  ];

  List<OrderDelivery> listTransaction = [
    OrderDelivery(
      date: DateTime.now().toString(),
      id: "1",
      kuantitas: "20",
      total: "900000",
      transactionCode: "SEL-200000"
    ),
    OrderDelivery(
      date: DateTime.now().toString(),
      id: "1",
      kuantitas: "20",
      total: "900000",
      transactionCode: "SEL-200000"
    ),
  ];

  List<Vehicle> listVehicle = [
    Vehicle(
      nopol: "D 3283 ADE",
      deskripsi: "Motor Nmax",
      merk: "Yamaha"
    ),
    Vehicle(
      nopol: "D 3283 ADE",
      deskripsi: "Motor Nmax",
      merk: "Yamaha"
    ),
    Vehicle(
      nopol: "D 3283 ADE",
      deskripsi: "Motor Nmax",
      merk: "Yamaha"
    ),
  ];

  List<Employee> listEmployee = [
    Employee(
      
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: Constant.paddingScreen,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20,),
              ElevatedButton.icon(
                onPressed: (){
                  Navigator.of(context).pop();
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
                  primary: Color(0xff3498db)
                ),
              ),
              const SizedBox(height: 20,),
              Component.text("Form Delivery", fontSize: 17, colors: Colors.black),
              const SizedBox(height: 50,),
              ElevatedButton(
                onPressed: () {
                  // showDetailTransaction(row.transactionCode ?? "0", row.date ?? "-");
                },
                child: Text("Tambah Daftar Transaksi"),
                style: ElevatedButton.styleFrom(
                  textStyle: TextStyle(color: Colors.white),
                  padding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
                  primary: Color(0xff3498db)
                ),
              ),
              const SizedBox(height: 20,),
              Container(
                width: SizeConfig.blockSizeHorizontal * 100,
                child: DataTable(
                  rows: listTransaction.map((transaction) => DataRow(
                    cells: [
                      DataCell(Text(transaction.transactionCode.toString())),
                      DataCell(Text(transaction.transactionCode.toString())),
                      DataCell(Text(transaction.total.toString())),
                      DataCell(Text(transaction.total.toString())),
                      DataCell(Text(transaction.date.toString())),
                      DataCell(
                        ElevatedButton.icon(
                          onPressed: (){
                            Navigator.of(context).pop();
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 16.0,
                          ),
                          label: Text("Hapus"),
                          style: ElevatedButton.styleFrom(
                            textStyle: TextStyle(color: Colors.white),
                            padding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
                            primary: Colors.red
                          ),
                        ),
                      )
                    ]
                  )).toList(),
                  // header: Text("Daftar Transaksi"),
                  
                  // columnSpacing: 0,
                  // horizontalMargin: 30,
                  showCheckboxColumn: false,
                  columns: <DataColumn>[
                    for (final header in _headColumnTransaction)
                      DataColumn(
                        label: Text(header.name!),
                        tooltip: header.name,
                      ),
                  ],
                  // source: SourceTransaction(list: listTransaction),
                ),
              ),
              const SizedBox(height: 20,),
              ElevatedButton(
                onPressed: () {
                  // showDetailTransaction(row.transactionCode ?? "0", row.date ?? "-");
                },
                child: Text("Daftar Kendaraan"),
                style: ElevatedButton.styleFrom(
                  textStyle: TextStyle(color: Colors.white),
                  padding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
                  primary: Color(0xff3498db)
                ),
              ),
              const SizedBox(height: 20,),
              Container(
                width: SizeConfig.blockSizeHorizontal * 100,
                child: DataTable(
                  rows: listVehicle.map((vehichle) => DataRow(
                    cells: [
                      DataCell(Text(vehichle.nopol.toString())),
                      DataCell(Text(vehichle.merk.toString())),
                      DataCell(Text(vehichle.deskripsi.toString())),
                      DataCell(
                        ElevatedButton.icon(
                          onPressed: (){
                            Navigator.of(context).pop();
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 16.0,
                          ),
                          label: Text("Hapus"),
                          style: ElevatedButton.styleFrom(
                            textStyle: TextStyle(color: Colors.white),
                            padding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
                            primary: Colors.red
                          ),
                        ),
                      )
                    ]
                  )).toList(),
                  showCheckboxColumn: false,
                  columns: <DataColumn>[
                    for (final header in _headColumnVehichle)
                      DataColumn(
                        label: Text(header.name!),
                        tooltip: header.name,
                      ),
                  ],
                  // source: SourceTransaction(list: listTransaction),
                ),
              ),
              const SizedBox(height: 20,),
              ElevatedButton(
                onPressed: () {
                  // showDetailTransaction(row.transactionCode ?? "0", row.date ?? "-");
                },
                child: Text("Daftar karyawan"),
                style: ElevatedButton.styleFrom(
                  textStyle: TextStyle(color: Colors.white),
                  padding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
                  primary: Color(0xff3498db)
                ),
              ),
              const SizedBox(height: 20,),
              Container(
                width: SizeConfig.blockSizeHorizontal * 100,
                child: DataTable(
                  rows: listVehicle.map((vehichle) => DataRow(
                    cells: [
                      DataCell(Text(vehichle.nopol.toString())),
                      DataCell(Text(vehichle.merk.toString())),
                      DataCell(Text(vehichle.deskripsi.toString())),
                      DataCell(
                        ElevatedButton.icon(
                          onPressed: (){
                            Navigator.of(context).pop();
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 16.0,
                          ),
                          label: Text("Hapus"),
                          style: ElevatedButton.styleFrom(
                            textStyle: TextStyle(color: Colors.white),
                            padding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
                            primary: Colors.red
                          ),
                        ),
                      )
                    ]
                  )).toList(),
                  showCheckboxColumn: false,
                  columns: <DataColumn>[
                    for (final header in _headColumnVehichle)
                      DataColumn(
                        label: Text(header.name!),
                        tooltip: header.name,
                      ),
                  ],
                  // source: SourceTransaction(list: listTransaction),
                ),
              ),
              const SizedBox(height: 20,),
              ElevatedButton(
                onPressed: () {
                  // showDetailTransaction(row.transactionCode ?? "0", row.date ?? "-");
                },
                child: Text("Operasional"),
                style: ElevatedButton.styleFrom(
                  textStyle: TextStyle(color: Colors.white),
                  padding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
                  primary: Color(0xff3498db)
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}