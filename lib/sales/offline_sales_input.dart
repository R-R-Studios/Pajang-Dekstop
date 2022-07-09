
import 'dart:collection';

import 'package:beben_pos_desktop/db/transaction_failed_db.dart';
import 'package:beben_pos_desktop/sales/bloc/sales_bloc.dart';
import 'package:beben_pos_desktop/sales/widget/dialog_create_transaction.dart';
import 'package:beben_pos_desktop/utils/size_config.dart';
import 'package:flutter/material.dart';

import '../db/merchant_product_db.dart';

class OfflineSalesInput extends StatefulWidget {
  const OfflineSalesInput({Key? key}) : super(key: key);

  @override
  _OfflineSalesInputState createState() => _OfflineSalesInputState();
}

class _OfflineSalesInputState extends State<OfflineSalesInput> {

  SalesBloc salesBloc = SalesBloc();

  @override
  void initState() {
    // TODO: implement initState
    salesBloc.selectTransaction();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    salesBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(
                      Icons.perm_contact_calendar_rounded,
                      color: Colors.white,
                      size: 18.0,
                    ),
                    label: Text(
                      'Create Transaction',
                      style: TextStyle(fontSize: 14),
                    ),
                    onPressed: () async {
                      // showDialog(
                      //     context: context,
                      //     barrierDismissible: true,
                      //     builder: (BuildContext c) {
                      //       return DialogCreateTransaction(salesBloc.addTransactionFailed);
                      //     });
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.lightBlue,
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(2.0),
                      ),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  icon: Icon(
                    Icons.print,
                    color: Colors.white,
                    size: 18.0,
                  ),
                  label: Text(
                    'Cetak Transaksi',
                    style: TextStyle(fontSize: 14),
                  ),
                  onPressed: () async {
                    salesBloc.requestAsyncTransaction();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.lightBlue,
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(2.0),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              child: StreamBuilder(
                  stream: salesBloc.streamTransactionList,
                  builder: (context, AsyncSnapshot<List<TransactionFailedDB>> snapshot) {
                    if (!snapshot.hasData) {return Container();}
                    if (snapshot.hasData){
                      print('punya data 2 -> ${snapshot.data!.length}');
                      return ListView.builder(
                         physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true, //Optional
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, int index){
                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Text('Transaksi : ${snapshot.data![index].date}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                                        Row(
                                          children: [
                                            // snapshot.data![index].status == "Failed" ?
                                            // Text('${snapshot.data![index].status}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.red)) :
                                            // Text('${snapshot.data![index].status}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green)),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                IconButton(
                                                  icon: const Icon(Icons.close),
                                                  color: Colors.red,
                                                  iconSize: 16,
                                                  onPressed: () {
                                                    salesBloc.deleteTransactionAndProductTransaction(index, snapshot.data![index].id!);
                                                  },
                                                ),
                                                Text('Delete ?', style: TextStyle(color: Colors.red),)
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: snapshot.data![index].productList!.length,
                                        itemBuilder: (context, int indexProduct){
                                          return InkWell(
                                            onTap: () {
                                              for (final data in snapshot.data![index].productList!){
                                                print('add to product -> ${snapshot.data![index].productList!.length}');
                                                print('add to product qty -> ${snapshot.data![index].productList![indexProduct].quantity}');
                                                MerchantProductDB merchantProduct = MerchantProductDB(
                                                    id: data.productId,
                                                    name: data.itemName,
                                                    barcode: data.item,
                                                    currentPrice: data.price.toString(),
                                                    salePrice: data.price.toString(),
                                                    qty: data.quantity.toString()
                                                );
                                                salesBloc.addProduct(merchantProduct);
                                              }
                                            },
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text('(${snapshot.data![index].productList![indexProduct].item}) ${snapshot.data![index].productList![indexProduct].itemName} '
                                                    'x ${snapshot.data![index].productList![indexProduct].quantity}',
                                                    style: TextStyle(fontSize: 12)),
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 4.0),
                                                  child: Text('Rp ${snapshot.data![index].productList![indexProduct].total}',
                                                      style: TextStyle(fontSize: 12)),
                                                ),
                                              ],
                                            ),
                                          );
                                        })
                                  ],
                                ),
                              ),
                            );
                          });
                    } else {
                      return Text('Kosong');
                    }
                  }
              ),
            )
          ],
        ),
      ),
    );
  }
}
