import 'package:beben_pos_desktop/component/component.dart';
import 'package:beben_pos_desktop/content/model/employee.dart';
import 'package:beben_pos_desktop/core/app/color_palette.dart';
import 'package:beben_pos_desktop/core/app/constant.dart';
import 'package:beben_pos_desktop/core/util/core_function.dart';
import 'package:beben_pos_desktop/delivery/bloc/delivery_bloc.dart';
import 'package:beben_pos_desktop/delivery/model/operational.dart';
import 'package:beben_pos_desktop/delivery/model/vehicle.dart';
import 'package:beben_pos_desktop/delivery/view/dialog_find.dart';
import 'package:beben_pos_desktop/model/head_column_model.dart';
import 'package:beben_pos_desktop/ui/transaction/model/merchant_transaction.dart';
import 'package:beben_pos_desktop/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nav_router/nav_router.dart';

class DeliveryFormView extends StatelessWidget {

  DeliveryFormView({ Key? key }) : super(key: key);

  final DeliveryBloc deliveryBloc = new DeliveryBloc();

  final List<HeadColumnModel> _headColumnTransaction = [
    HeadColumnModel(key: "2", name: "No Order", ischecked: false),
    HeadColumnModel(key: "3", name: "Customer", ischecked: false),
    HeadColumnModel(key: "4", name: "Tipe", ischecked: false),
    HeadColumnModel(key: "5", name: "Pembayaran", ischecked: false),
    HeadColumnModel(key: "6", name: "Total Transaksi", ischecked: false),
    HeadColumnModel(key: "7", name: "Aksi", ischecked: false),
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

  void showDialogFind(FeatureType featureType) {
    showDialog(
      context: navGK.currentContext!,
      barrierDismissible: true,
      builder: (BuildContext c) {
        return DialogFind(featureType: featureType,);
      }).then((value) {
      if (value != null) {
        switch (featureType) {
          case FeatureType.transaction:
            deliveryBloc.addTransaction(value);
            break;
          case FeatureType.vehicle:
            deliveryBloc.addVehicle(value);
            break;
          case FeatureType.employee:
            deliveryBloc.addEmployee(value);
            break;
          default:
        }
      } else {
        // FocusScope.of(context).requestFocus(scanFocusNode);
      }
    });
  }

  void dialogCreateOperational(){
    final TextEditingController priceController = TextEditingController();
    final TextEditingController descController = TextEditingController();
    showDialog(
      context: navGK.currentContext!, 
      builder: (BuildContext context){
        return AlertDialog(
          title: Container(
            width: 500,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Tambah Operatonal"),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  tooltip: "Tutup",
                  padding: EdgeInsets.all(0),
                  icon: Icon(Icons.close)
                )
              ],
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20,),
              Component.text("Deksripsi"),
              const SizedBox(height: 10,),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Deskripsi',
                  border: OutlineInputBorder(),
                ),
                controller: descController,
                enabled: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Masukan deskripsi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20,),
              Component.text("Perkiraan Harga"),
              const SizedBox(height: 10,),
              TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: InputDecoration(
                  labelText: 'perkiraan harga',
                  border: OutlineInputBorder(),
                ),
                controller: priceController,
                enabled: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Masukan No Telepon';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20,),
              InkWell(
                  onTap: (){
                    Navigator.of(context).pop();
                    deliveryBloc.addOperational(Operational(
                      price: priceController.text,
                      desc: descController.text
                    ));
                  },
                  child: Card(
                    color: Colors.green,
                    child: Container(
                      alignment: Alignment.center,
                      width: SizeConfig.blockSizeHorizontal * 60,
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                      child: Component.text("Tambah", colors: Colors.white,),
                    ),
                  ),
                ),
            ],
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
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
              Container(
                color: ColorPalette.grey,
                width: SizeConfig.blockSizeHorizontal * 100,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Component.text("Transaksi", fontSize: 17, colors: ColorPalette.black),
                    const SizedBox(width: 50,),
                    ElevatedButton(
                      onPressed: () {
                        showDialogFind(FeatureType.transaction);
                      },
                      child: Text("Tambah Transaksi"),
                      style: ElevatedButton.styleFrom(
                        textStyle: TextStyle(color: Colors.white),
                        padding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
                        primary: Color(0xff3498db)
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20,),
              Container(
                width: SizeConfig.blockSizeHorizontal * 100,
                child: StreamBuilder<List<MerchantTransaction>>(
                  stream: deliveryBloc.merchantTransaction,
                  initialData: [],
                  builder: (BuildContext context, AsyncSnapshot<List<MerchantTransaction>> snapshot) {
                    if(snapshot.data!.isNotEmpty) {
                      return DataTable(
                        columnSpacing: 0, 
                        rows: snapshot.data!.asMap().map((i, transaction) => MapEntry(i, DataRow(
                          cells: [
                            DataCell(Text(transaction.transactionCode.toString()),),
                            DataCell(Text(transaction.userName.toString())),
                            DataCell(Text(transaction.typeName.toString())),
                            DataCell(Text(transaction.cardNumber.toString())),
                            DataCell(Text(CoreFunction.moneyFormatter(transaction.valueDocument.toString()))),
                            DataCell(
                              ElevatedButton.icon(
                                onPressed: (){
                                  deliveryBloc.deleteTransaction(i);
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
                        ))).values.toList(),
                        showCheckboxColumn: false,
                        columns: <DataColumn>[
                          for (final header in _headColumnTransaction)
                            DataColumn(
                              label: Text(header.name!),
                              tooltip: header.name,
                            ),
                        ],
                      );
                    } else {
                      return Center(
                        child: Container(
                          height: 50,
                          width: SizeConfig.blockSizeHorizontal * 100,
                          color: ColorPalette.blue1,
                          alignment: Alignment.center,
                          child: Component.text("Belum ada Transaksi", fontSize: 17, colors: ColorPalette.white),
                        ),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 20,),
              Container(
                color: ColorPalette.grey,
                width: SizeConfig.blockSizeHorizontal * 100,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Component.text("Kendaraan", fontSize: 17, colors: ColorPalette.black),
                    const SizedBox(width: 50,),
                    ElevatedButton(
                      onPressed: () {
                        showDialogFind(FeatureType.vehicle);
                      },
                      child: Text("Tambah Kendaraan"),
                      style: ElevatedButton.styleFrom(
                        textStyle: TextStyle(color: Colors.white),
                        padding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
                        primary: Color(0xff3498db)
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20,),
              Container(
                width: SizeConfig.blockSizeHorizontal * 100,
                child: StreamBuilder<List<Vehicle>>(
                  stream: deliveryBloc.vehicleController,
                  initialData: [],
                  builder: (BuildContext context, AsyncSnapshot<List<Vehicle>> snapshot) {
                    if(snapshot.data!.isNotEmpty) {
                      return DataTable(
                        rows: snapshot.data!.asMap().map((i, vehicle) => MapEntry(i, DataRow(
                          cells: [
                            DataCell(Text(vehicle.nopol.toString())),
                            DataCell(Text(vehicle.merk.toString())),
                            DataCell(Text(vehicle.description.toString())),
                            DataCell(
                              ElevatedButton.icon(
                                onPressed: (){
                                  deliveryBloc.deleteVehicle(i);
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
                        ))).values.toList(),
                        showCheckboxColumn: false,
                        columns: <DataColumn>[
                          for (final header in _headColumnVehichle)
                            DataColumn(
                              label: Text(header.name!),
                              tooltip: header.name,
                            ),
                        ],
                      );
                    } else {
                      return Center(
                        child: Container(
                          height: 50,
                          width: SizeConfig.blockSizeHorizontal * 100,
                          color: ColorPalette.blue1,
                          alignment: Alignment.center,
                          child: Component.text("Belum ada Kendaraan", fontSize: 17, colors: ColorPalette.white)
                        ),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 20,),
              Container(
                color: ColorPalette.grey,
                width: SizeConfig.blockSizeHorizontal * 100,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Component.text("Karyawan", fontSize: 17, colors: ColorPalette.black),
                    const SizedBox(width: 50,),
                    ElevatedButton(
                      onPressed: () {
                        showDialogFind(FeatureType.employee);
                      },
                      child: Text("Tambah Transaksi"),
                      style: ElevatedButton.styleFrom(
                        textStyle: TextStyle(color: Colors.white),
                        padding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
                        primary: Color(0xff3498db)
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20,),
              Container(
                width: SizeConfig.blockSizeHorizontal * 100,
                child: StreamBuilder<List<Employee>>(
                  stream: deliveryBloc.employeeController,
                  initialData: [],
                  builder: (BuildContext context, AsyncSnapshot<List<Employee>> snapshot) {
                    if(snapshot.data!.isNotEmpty) {
                      return DataTable(
                        rows: snapshot.data!.asMap().map((i, employee) => MapEntry(i, DataRow(
                          cells: [
                            DataCell(Text(employee.name.toString())),
                            DataCell(Text(employee.jobDesk.toString())),
                            DataCell(Text(employee.phoneNumber.toString())),
                            DataCell(
                              ElevatedButton.icon(
                                onPressed: (){
                                  deliveryBloc.deleteEmploye(i);
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
                        ))).values.toList(),
                        showCheckboxColumn: false,
                        columns: <DataColumn>[
                          for (final header in _headColumnEmployee)
                            DataColumn(
                              label: Text(header.name!),
                              tooltip: header.name,
                            ),
                        ],
                      );
                    } else {
                      return Center(
                        child: Container(
                          height: 50,
                          width: SizeConfig.blockSizeHorizontal * 100,
                          color: ColorPalette.blue1,
                          alignment: Alignment.center,
                          child: Component.text("Belum ada Karyawan", fontSize: 17, colors: ColorPalette.white)
                        ),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 20,),
              Container(
                color: ColorPalette.grey,
                width: SizeConfig.blockSizeHorizontal * 100,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Component.text("Operasional", fontSize: 17, colors: ColorPalette.black),
                    const SizedBox(width: 50,),
                    ElevatedButton(
                      onPressed: () {
                        dialogCreateOperational();
                      },
                      child: Text("Tambah Operasional"),
                      style: ElevatedButton.styleFrom(
                        textStyle: TextStyle(color: Colors.white),
                        padding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
                        primary: Color(0xff3498db)
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20,),
              Container(
                width: SizeConfig.blockSizeHorizontal * 100,
                child: StreamBuilder<List<Operational>>(
                  stream: deliveryBloc.operatioalController,
                  initialData: [],
                  builder: (BuildContext context, AsyncSnapshot<List<Operational>> snapshot) {
                    if(snapshot.data!.isNotEmpty) {
                      return DataTable(
                        columnSpacing: 0, 
                        rows: snapshot.data!.asMap().map((i, operational) => MapEntry(i, DataRow(
                          cells: [
                            DataCell(Text(operational.desc.toString())),
                            DataCell(Text(operational.price.toString())),
                            DataCell(
                              ElevatedButton.icon(
                                onPressed: (){
                                  deliveryBloc.deleteOperational(i);
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
                        ))).values.toList(),
                        showCheckboxColumn: false,
                        columns: <DataColumn>[
                          for (final header in _headColumnOperational)
                            DataColumn(
                              label: Text(header.name!),
                              tooltip: header.name,
                            ),
                        ],
                      );
                    } else {
                      return Center(
                        child: Container(
                          height: 50,
                          width: SizeConfig.blockSizeHorizontal * 100,
                          color: ColorPalette.blue1,
                          alignment: Alignment.center,
                          child: Component.text("Belum ada Operasional", fontSize: 17, colors: ColorPalette.white)
                        ),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 20,),
              Container(
                margin: const EdgeInsets.only(bottom: 50),
                width: SizeConfig.blockSizeHorizontal * 100,
                child: ElevatedButton(
                  onPressed: () {
                    deliveryBloc.onCreateDelivery();
                  },
                  child: Text("Buat Pengiriman"),
                  style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(color: Colors.white),
                    padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
                    primary: ColorPalette.primary
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}