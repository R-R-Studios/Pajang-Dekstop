import 'package:beben_pos_desktop/component/component.dart';
import 'package:beben_pos_desktop/content/cubit/bank_cubit.dart';
import 'package:beben_pos_desktop/content/cubit/employee_cubit.dart';
import 'package:beben_pos_desktop/content/datasource/data_source_employee.dart';
import 'package:beben_pos_desktop/core/app/constant.dart';
import 'package:beben_pos_desktop/model/head_column_model.dart';
import 'package:beben_pos_desktop/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nav_router/nav_router.dart';

class EmployeeView extends StatelessWidget {

  final VoidCallback callback;

  EmployeeView({ required this.callback, Key? key }) : super(key: key);

  final List<HeadColumnModel> _headColumnModel = [
    HeadColumnModel(key: "1", name: "No", ischecked: false),
    HeadColumnModel(key: "2", name: "Nama", ischecked: false),
    HeadColumnModel(key: "3", name: "Job Desk", ischecked: false),
    HeadColumnModel(key: "4", name: "Phone Number", ischecked: false),
  ];

  dialogCreate(currentContext){
    final TextEditingController bankController = TextEditingController();
    final TextEditingController nameAccountController = TextEditingController();
    final TextEditingController noAccountController = TextEditingController();
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
                Text("Buat Bank"),
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
              Component.text("Bank"),
              const SizedBox(height: 10,),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Bank',
                  border: OutlineInputBorder(),
                ),
                controller: bankController,
                enabled: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Masukan Bank';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20,),
              Component.text("Nama Pemilik Rekening"),
              const SizedBox(height: 10,),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Pemilik Rekening',
                  border: OutlineInputBorder(),
                ),
                controller: nameAccountController,
                enabled: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Masukan Nama Pemilik Rekening';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20,),
              Component.text("No Rekening"),
              const SizedBox(height: 10,),
              TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: InputDecoration(
                  labelText: 'No Rekening',
                  border: OutlineInputBorder(),
                ),
                controller: noAccountController,
                enabled: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Masukan No Rekening';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20,),
              InkWell(
                  onTap: (){
                    Navigator.of(context).pop();
                    BlocProvider.of<BankCubit>(currentContext).creteBank(bankController.text, nameAccountController.text, noAccountController.text);
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
    return BlocBuilder<EmployeeCubit, EmployeeState>(
      builder: (context, state) {
        if (state is EmployeeLoading) {
          return Center(child: CupertinoActivityIndicator());
        } else if (state is EmployeeLoaded) {
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
                    Component.text("Bank Anda", fontSize: 17, colors: Colors.black),
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
                    const SizedBox(width: 10,),
                    Card(
                      color: Colors.red,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.white),
                            const SizedBox(width: 5,),
                            Component.text("Hapus", colors: Colors.white),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20,),
                PaginatedDataTable(
                  header: Text("Bank"),
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
                  source: DataSourceEmployee(list: state.listEmployee),
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