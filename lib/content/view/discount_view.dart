import 'package:beben_pos_desktop/component/component.dart';
import 'package:beben_pos_desktop/content/cubit/discount_cubit.dart';
import 'package:beben_pos_desktop/content/datasource/data_source_discount.dart';
import 'package:beben_pos_desktop/content/model/discount.dart';
import 'package:beben_pos_desktop/core/app/constant.dart';
import 'package:beben_pos_desktop/model/head_column_model.dart';
import 'package:beben_pos_desktop/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nav_router/nav_router.dart';

class DiscountScreen extends StatelessWidget {

  final VoidCallback callback;

  DiscountScreen({ required this.callback, Key? key }) : super(key: key);

  final List<HeadColumnModel> _headColumnModel = [
    HeadColumnModel(key: "1", name: "No", ischecked: false),
    HeadColumnModel(key: "2", name: "Nama", ischecked: false),
    HeadColumnModel(key: "3", name: "Diskon", ischecked: false),
    HeadColumnModel(key: "4", name: "Tipe", ischecked: false),
    HeadColumnModel(key: "4", name: "Deskripsi", ischecked: false),
    HeadColumnModel(key: "4", name: "Status", ischecked: false),
    HeadColumnModel(key: "5", name: "Aksi", ischecked: false),
  ];

  dialogCreate(currentContext){
    final TextEditingController nameAccountController = TextEditingController();
    final TextEditingController minumDiscount = TextEditingController();
    final TextEditingController maxDiscount = TextEditingController();
    final TextEditingController amountController = TextEditingController();
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
                Text("Tambah Diskon"),
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
              Component.text("Nama Diskon"),
              const SizedBox(height: 10,),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Nama Diskon',
                  border: OutlineInputBorder(),
                ),
                controller: nameAccountController,
                enabled: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Masukan Nama DIskon';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20,),
              Component.text("Mininum Discount"),
              const SizedBox(height: 10,),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Minimum Discount',
                  border: OutlineInputBorder(),
                ),
                controller: minumDiscount,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly
                ],
                enabled: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Masukan Minimum Discount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20,),
              Component.text("Maximum Diskon"),
              const SizedBox(height: 10,),
              TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: InputDecoration(
                  labelText: 'Maximum Diskon',
                  border: OutlineInputBorder(),
                ),
                controller: maxDiscount,
                enabled: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Masukan Maximum Diskon';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20,),
              Component.text("Value Diskon"),
              const SizedBox(height: 10,),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Value Diskon',
                  border: OutlineInputBorder(),
                ),
                controller: amountController,
                enabled: true,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly
                ],
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Masukan Value Discount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20,),
              Component.text("Deskripsi"),
              const SizedBox(height: 10,),
              TextFormField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Deskripsi Diskon',
                  border: OutlineInputBorder(),
                ),
                controller: descController,
                enabled: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Masukan Deskripsi Diskon';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20,),
              InkWell(
                  onTap: (){
                    Navigator.of(context).pop();
                    BlocProvider.of<DiscountCubit>(currentContext).creteDiscount(
                      Discount(
                        amount: int.parse(amountController.text),
                        description: descController.text,
                        isActive: true,
                        kind: "1",
                        types: "1",
                        maximumAmount: int.parse(maxDiscount.text),
                        minimumAmount: int.parse(minumDiscount.text),
                        name: nameAccountController.text
                      )
                    );
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
    return BlocBuilder<DiscountCubit, DiscountState>(
      builder: (context, state) {
        if (state is DiscountLoading) {
          return Center(child: CupertinoActivityIndicator());
        } else if (state is DiscountLoaded) {
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
                    Component.text("Diskon Anda", fontSize: 17, colors: Colors.black),
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
                  header: Text("Diskon"),
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
                  source: DataSourceDiscount(list: state.listDiscount),
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