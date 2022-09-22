import 'package:beben_pos_desktop/core/app/color_palette.dart';
import 'package:beben_pos_desktop/core/util/core_function.dart';
import 'package:beben_pos_desktop/delivery/model/delivery.dart';
import 'package:beben_pos_desktop/delivery/model/delivery_detail.dart';
import 'package:beben_pos_desktop/delivery/provider/delivery_provider.dart';
import 'package:beben_pos_desktop/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:nav_router/nav_router.dart';

import '../../../component/component.dart';

class DataSourceDelivery extends DataTableSource {

  final List<Delivery> list;

  DataSourceDelivery({required this.list});

  int _selectedCount = 0;

  dialogDetail(Delivery delivery, List<DeliveryDetail> listDetail){
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
                Text("Detail Pengiriman"),
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
          content: Container(
            height: 500,
            width: 500,
            // width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Component.text("No Pengiriman", fontWeight: FontWeight.w700, fontSize: 15, colors: ColorPalette.black),
                const SizedBox(height: 10,),
                Component.text(delivery.orderNumber ?? "", fontSize: 15),
                const SizedBox(height: 20,),
                Component.text("Description", fontWeight: FontWeight.w700, fontSize: 15, colors: ColorPalette.black),
                const SizedBox(height: 10,),
                Component.text(delivery.description ?? ""),
                const SizedBox(height: 20,),
                Component.text("Tanggal di buat", fontWeight: FontWeight.w700, fontSize: 15, colors: ColorPalette.black),
                const SizedBox(height: 10,),
                Component.text(delivery.createdAt ?? ""),
                const SizedBox(height: 20,),
                Component.text("Transaksi", fontWeight: FontWeight.w700, fontSize: 15, colors: ColorPalette.black),
                const SizedBox(height: 10,),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: listDetail.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Component.text(listDetail[index].transactionCode ?? ""),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10,),
                Component.text(
                  "Total Transaksi : ${CoreFunction.moneyFormatter(listDetail.first.totalAmountTransaction)}", 
                  fontWeight: FontWeight.w300, 
                  colors: ColorPalette.black
                ),
                const SizedBox(height: 20,),
                Component.text("Kendaraan", fontWeight: FontWeight.w700, fontSize: 15, colors: ColorPalette.black),
                const SizedBox(height: 10,),
                Row(
                  children: [
                    Component.text("Merk"),
                    const SizedBox(width: 10,),
                    Component.text(listDetail.first.nameVehicle ?? ""),
                  ],
                ),Row(
                  children: [
                    Component.text("Nopol"),
                    const SizedBox(width: 10,),
                    Component.text(listDetail.first.nopolVehicle?? ""),
                  ],
                ),
                const SizedBox(height: 50,),
                InkWell(
                    onTap: (){
                      Navigator.of(context).pop();
                      // BlocProvider.of<EmployeeCubit>(currentContext).creteEmployee(nameController.text, phoneController.text, jobController.text);
                    },
                    child: Card(
                      color: Colors.red,
                      child: Container(
                        alignment: Alignment.center,
                        width: SizeConfig.blockSizeHorizontal * 60,
                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                        child: Component.text("Batalkan", colors: Colors.white,),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      }
    );
  }

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= list.length) return null;
    final row = list[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(
          Text("${index + 1}")
        ),
        DataCell(Text("${row.orderNumber ?? ""}")),
        DataCell(Text("${row.vehicle!.nopol}")),
        DataCell(Text("${row.employee!.name}")),
        DataCell(Text("${row.totalAmount ?? ""}")),
        DataCell(Text("${row.createdAt ?? ""}")),
        DataCell(
          ElevatedButton.icon(
            onPressed: () async {
              var details = await DeliveryProvider.deliveryDetail(row.id!);
              dialogDetail(row, details);
            },
            icon: Icon(
              Icons.arrow_forward,
              color: Colors.white,
              size: 16.0,
            ),
            label: Text("Detail"),
            style: ElevatedButton.styleFrom(
              textStyle: TextStyle(color: Colors.white),
              padding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
              primary: Color(0xff3498db)
            ),
          ),
        ),
      ],
    );
  }

  @override
  int get rowCount => list.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;
}
