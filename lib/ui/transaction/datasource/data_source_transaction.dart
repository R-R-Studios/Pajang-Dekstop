import 'dart:convert';

import 'package:beben_pos_desktop/component/component.dart';
import 'package:beben_pos_desktop/core/app/color_palette.dart';
import 'package:beben_pos_desktop/core/fireship/fireship_encrypt.dart';
import 'package:beben_pos_desktop/core/util/core_function.dart';
import 'package:beben_pos_desktop/ui/transaction/cubit/transaction_detail_cubit.dart';
import 'package:beben_pos_desktop/ui/transaction/model/merchant_transaction.dart';
import 'package:beben_pos_desktop/ui/transaction/model/transaction_detail.dart';
import 'package:beben_pos_desktop/ui/transaction/provider/transaction_provider.dart';
import 'package:beben_pos_desktop/ui/transaction/view/transaction_detail_view.dart';
import 'package:beben_pos_desktop/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nav_router/nav_router.dart';

class DataSourceTransaction extends DataTableSource {

  final List<MerchantTransaction> list;

  DataSourceTransaction({required this.list});

  int _selectedCount = 0;

  dialogDetail(TransactionDetailResponse transactionDetailResponse) {
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
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Component.text("No Transaksi", fontWeight: FontWeight.w700, fontSize: 15, colors: ColorPalette.black),
                  const SizedBox(height: 10,),
                  Component.text(transactionDetailResponse.transactionCode.toString(), fontSize: 15),
                  const SizedBox(height: 20,),
                  Component.text("Tanggal di buat", fontWeight: FontWeight.w700, fontSize: 15, colors: ColorPalette.black),
                  const SizedBox(height: 10,),
                  Component.text(transactionDetailResponse.createdAt ?? ""),
                  const SizedBox(height: 20,),
                  Component.text("Pembeli", fontWeight: FontWeight.w700, fontSize: 15, colors: ColorPalette.black),
                  const SizedBox(height: 10,),
                  Component.text(transactionDetailResponse.user?.name ?? ""),
                  const SizedBox(height: 20,),
                  Component.text("Pesanan", fontWeight: FontWeight.w700, fontSize: 15, colors: ColorPalette.black),
                  const SizedBox(height: 10,),
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: transactionDetailResponse.merchantTransactionDetails?.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Component.text(transactionDetailResponse.merchantTransactionDetails?[index].merchantProductPrice?.merchantProduct?.product?.name ?? ""),
                                  const Spacer(),
                                  Component.text("x1")
                                ],
                              ),
                              const SizedBox(height: 10,),
                              Component.text(CoreFunction.moneyFormatter(transactionDetailResponse.merchantTransactionDetails?[index].merchantProductPrice?.currentPrice ?? "")),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Component.text("Total Pesanan        : ${transactionDetailResponse.subAmount}"),
                  const SizedBox(height: 10,),
                  Component.text("Total Tax                 : ${transactionDetailResponse.valueTax}"),
                  const SizedBox(height: 10,),
                  Component.text("Total Pembayaran  : ${transactionDetailResponse.valueDocument}"),
                  const SizedBox(height: 20,),
                  Component.text("Alamat", fontWeight: FontWeight.w700, fontSize: 15, colors: ColorPalette.black),
                  const SizedBox(height: 10,),
                  Component.text(transactionDetailResponse.userAddress?.address ?? ""),
                  const SizedBox(height: 20,),
                  Component.text("Status", fontWeight: FontWeight.w700, fontSize: 15, colors: ColorPalette.black),
                  const SizedBox(height: 10,),
                  Component.text(transactionDetailResponse.status?.name ?? ""),
                  const SizedBox(height: 20,),

                  const SizedBox(height: 50,),
                  if (transactionDetailResponse.status?.code == "1") InkWell(
                    onTap: () async {
                      Navigator.of(context).pop();
                      var key = FireshipCrypt().encrypt(jsonEncode({'id': transactionDetailResponse.id.toString()}), await FireshipCrypt().getPassKeyPref());
                      await TransactionProvider.transactionAccept(key);
                    },
                    child: Card(
                      color: ColorPalette.primary,
                      child: Container(
                        alignment: Alignment.center,
                        width: SizeConfig.blockSizeHorizontal * 60,
                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                        child: Component.text("Terima Pesanan", colors: Colors.white,),
                      ),
                    ),
                  ),
                  if (transactionDetailResponse.status?.code == "1") InkWell(
                    onTap: () async {
                      Navigator.of(context).pop();
                      var key = FireshipCrypt().encrypt(jsonEncode({'id': transactionDetailResponse.id.toString()}), await FireshipCrypt().getPassKeyPref());
                      await TransactionProvider.transactionCancel(key);
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
        DataCell(Text("${row.transactionCode ?? ""}")),
        DataCell(Text("${row.userName ?? ""}")),
        DataCell(Text("${row.typeName}")),
        DataCell(Text("${row.paymentName ?? ""}")),
        DataCell(Text("${CoreFunction.moneyFormatter(row.valueDocument)}")),
        DataCell(Text("${row.statusName ?? ""}")),
        DataCell(
          ElevatedButton.icon(
            onPressed: () async {
              var detail = await TransactionProvider.transactionDetail(row.id.toString());
              dialogDetail(detail);
            },
            icon: Icon(
              Icons.arrow_forward_ios,
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
