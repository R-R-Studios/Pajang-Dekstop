import 'package:beben_pos_desktop/core/util/core_function.dart';
import 'package:beben_pos_desktop/ui/transaction/cubit/transaction_detail_cubit.dart';
import 'package:beben_pos_desktop/ui/transaction/model/merchant_transaction.dart';
import 'package:beben_pos_desktop/ui/transaction/view/transaction_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nav_router/nav_router.dart';

import '../model/transaction.dart';

class DataSourceTransaction extends DataTableSource {

  final List<MerchantTransaction> list;

  DataSourceTransaction({required this.list});

  int _selectedCount = 0;


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
        DataCell(
          ElevatedButton.icon(
            onPressed: (){
              routePush(
                BlocProvider(
                  create: (context) => TransactionDetailCubit(merchantTransaction: row),
                  child: TransactionDetailView(),
                )
              );
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
