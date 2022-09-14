import 'package:beben_pos_desktop/component/component.dart';
import 'package:beben_pos_desktop/content/cubit/vehicle_cubit.dart';
import 'package:beben_pos_desktop/core/app/constant.dart';
import 'package:beben_pos_desktop/model/head_column_model.dart';
import 'package:beben_pos_desktop/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nav_router/nav_router.dart';

import '../datasource/data_source_Vehicle.dart';

class VehicleScreen extends StatelessWidget {

  final VoidCallback callback;

  VehicleScreen({ required this.callback, Key? key }) : super(key: key);

  final List<HeadColumnModel> _headColumnModel = [
    HeadColumnModel(key: "1", name: "No", ischecked: false),
    HeadColumnModel(key: "2", name: "Nopol", ischecked: false),
    HeadColumnModel(key: "3", name: "Merk", ischecked: false),
    HeadColumnModel(key: "4", name: "Deskripsi", ischecked: false),
    HeadColumnModel(key: "5", name: "Aksi", ischecked: false),
  ];

  dialogCreate(currentContext){
    final TextEditingController nopolController = TextEditingController();
    final TextEditingController merkAccountController = TextEditingController();
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
                Text("Tambah Kendaraan"),
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
              Component.text("Nopol"),
              const SizedBox(height: 10,),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Nopol',
                  border: OutlineInputBorder(),
                ),
                controller: nopolController,
                enabled: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Masukan Nopol';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20,),
              Component.text("Merk Kendaraan"),
              const SizedBox(height: 10,),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Merk',
                  border: OutlineInputBorder(),
                ),
                controller: merkAccountController,
                enabled: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Masukan Merk Kendaraan';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20,),
              Component.text("Desc"),
              const SizedBox(height: 10,),
              TextFormField(
                keyboardType: TextInputType.text,
                minLines: 3,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Deskripsi',
                  border: OutlineInputBorder(),
                ),
                controller: descController,
                enabled: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Masukan Deksripsi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20,),
              InkWell(
                  onTap: (){
                    Navigator.of(context).pop();
                    BlocProvider.of<VehicleCubit>(currentContext).creteVehicle(nopolController.text, merkAccountController.text, descController.text);
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
    return BlocBuilder<VehicleCubit, VehicleState>(
      builder: (context, state) {
        if (state is VehicleLoading) {
          return Center(child: CupertinoActivityIndicator());
        } else if (state is VehicleLoaded) {
          return Padding(
            padding: Constant.paddingScreen,
            child: ListView(
              children: [
                const SizedBox(height: 20,),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: callback,
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
                  ],
                ),
                const SizedBox(height: 20,),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Component.text("Vehicle Anda", fontSize: 17, colors: Colors.black),
                    const Spacer(),
                    InkWell(
                      onTap: (){
                        dialogCreate(context);
                      },
                      child: Card(
                        color: Colors.green,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(Icons.add, color: Colors.white),
                              const SizedBox(width: 5,),
                              Component.text("Tambah", colors: Colors.white),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20,),
                PaginatedDataTable(
                  header: Text("Vehicle"),
                  columnSpacing: 0,
                  horizontalMargin: 30,
                  showCheckboxColumn: false,
                  columns: <DataColumn>[
                    for (final header in _headColumnModel)
                      DataColumn(
                        label: Text(header.name!),
                        tooltip: header.name,
                      ),
                  ],
                  source: DataSourceVehicle(list: state.listVehicle),
                )
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}