import 'package:beben_pos_desktop/component/component.dart';
import 'package:beben_pos_desktop/core/app/constant.dart';
import 'package:beben_pos_desktop/delivery/provider/delivery_provider.dart';
import 'package:beben_pos_desktop/delivery/view/delivery_form_view.dart';
import 'package:beben_pos_desktop/model/head_column_model.dart';
import 'package:beben_pos_desktop/ui/delivery/cubit/delivery_cubit.dart';
import 'package:beben_pos_desktop/ui/delivery/datasource/data_source_delivery.dart';
import 'package:beben_pos_desktop/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nav_router/nav_router.dart';

class DeliveryView extends StatelessWidget {
  
  DeliveryView({ Key? key }) : super(key: key);

  final List<HeadColumnModel> _headColumnModel = [
    HeadColumnModel(key: "1", name: "No", ischecked: false),
    HeadColumnModel(key: "2", name: "No Pengiriman", ischecked: false),
    HeadColumnModel(key: "3", name: "Kendaraan", ischecked: false),
    HeadColumnModel(key: "3", name: "Supir", ischecked: false),
    HeadColumnModel(key: "4", name: "Total Kuantitas", ischecked: false),
    HeadColumnModel(key: "4", name: "Tanggal", ischecked: false),
    HeadColumnModel(key: "4", name: "Aksi", ischecked: false),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeliveryCubit, DeliveryState>(
      builder: (context, state) {
        if (state is DeliveryLoading) {
          return Center(child: CupertinoActivityIndicator());
        } else if (state is DeliveryLoaded) {
          return Padding(
            padding: Constant.paddingScreen,
            child: ListView(
              children: [
                const SizedBox(height: 20,),
                // Row(
                //   children: [
                //     ElevatedButton.icon(
                //       onPressed: callback,
                //       icon: Icon(
                //         Icons.arrow_back,
                //         color: Colors.white,
                //         size: 16.0,
                //       ),
                //       label: Text("Back"),
                //       style: ElevatedButton.styleFrom(
                //         textStyle: TextStyle(color: Colors.white),
                //         padding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
                //         primary: Color(0xff3498db)
                //       ),
                //     ),
                //   ],
                // ),
                const SizedBox(height: 20,),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Component.text("Pengiriman", fontSize: 17, colors: Colors.black),
                    const Spacer(),
                    InkWell(
                      onTap: (){
                        routePush(DeliveryFormView(), RouterType.material);
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
                  header: Text("Pengiriman Pesanan"),
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
                  source: DataSourceDelivery(list: state.listDelivery),
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