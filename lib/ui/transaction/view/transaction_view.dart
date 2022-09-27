import 'package:beben_pos_desktop/component/component.dart';
import 'package:beben_pos_desktop/model/head_column_model.dart';
import 'package:beben_pos_desktop/ui/transaction/cubit/transaction_cubit.dart';
import 'package:beben_pos_desktop/ui/transaction/datasource/data_source_transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/app/constant.dart';
import '../model/transaction.dart';

class TransactionView extends StatelessWidget {

  TransactionView({ Key? key }) : super(key: key);

  final List<HeadColumnModel> _headColumnModel = [
    HeadColumnModel(key: "1", name: "No", ischecked: false),
    HeadColumnModel(key: "2", name: "No Order", ischecked: false),
    HeadColumnModel(key: "3", name: "Customer", ischecked: false),
    HeadColumnModel(key: "4", name: "Tipe", ischecked: false),
    HeadColumnModel(key: "5", name: "Pembayaran", ischecked: false),
    HeadColumnModel(key: "6", name: "Total Transaksi", ischecked: false),
    HeadColumnModel(key: "7", name: "Status", ischecked: false),
    HeadColumnModel(key: "8", name: "Aksi", ischecked: false),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionCubit, TransactionState>(
      builder: (context, state) {
        if (state is TransactionLoading) {
          return Center(child: CupertinoActivityIndicator());
        } else if (state is TransactionLoaded) {
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
                // Row(
                //   mainAxisSize: MainAxisSize.min,
                //   children: [
                //     Component.text("Transaksi", fontSize: 17, colors: Colors.black),
                //     const Spacer(),
                //     InkWell(
                //       onTap: (){
                //         // routePush(DeliveryFormView(), RouterType.material);
                //       },
                //       child: Card(
                //         color: Colors.green,
                //         child: Padding(
                //           padding: const EdgeInsets.all(8.0),
                //           child: Row(
                //             children: [
                //               Icon(Icons.add, color: Colors.white),
                //               const SizedBox(width: 5,),
                //               Component.text("Tambah", colors: Colors.white),
                //             ],
                //           ),
                //         ),
                //       ),
                //     ),
                //     const SizedBox(width: 10,),
                //     Card(
                //       color: Colors.red,
                //       child: Padding(
                //         padding: const EdgeInsets.all(8.0),
                //         child: Row(
                //           children: [
                //             Icon(Icons.delete, color: Colors.white),
                //             const SizedBox(width: 5,),
                //             Component.text("Hapus", colors: Colors.white),
                //           ],
                //         ),
                //       ),
                //     )
                //   ],
                // ),
                const SizedBox(height: 20,),
                PaginatedDataTable(
                  header: Text("Transaksi"),
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
                  source: DataSourceTransaction(list: state.listTransaction),
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