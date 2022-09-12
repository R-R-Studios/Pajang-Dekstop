import 'package:beben_pos_desktop/ui/transaction/cubit/transaction_detail_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionDetailView extends StatelessWidget {
  const TransactionDetailView({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Transaksi"),
      ),
      body: BlocBuilder<TransactionDetailCubit, TransactionDetailState>(
        builder: (context, state) {
          return Container();
        },
      ),
    );
  }
}