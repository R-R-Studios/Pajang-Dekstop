import 'package:beben_pos_desktop/core/core.dart';
import 'package:beben_pos_desktop/db/merchant_product_db.dart';
import 'package:beben_pos_desktop/db/transaction_failed_db.dart';
import 'package:beben_pos_desktop/sales/bloc/sales_bloc.dart';
import 'package:beben_pos_desktop/utils/global_color_palette.dart';
import 'package:beben_pos_desktop/utils/size_config.dart';
import 'package:flutter/material.dart';

import 'dialog_create_transaction.dart';

class DialogListTransaction extends StatefulWidget {
  const DialogListTransaction(this.deleteAll, {Key? key}) : super(key: key);

  final dynamic deleteAll;

  @override
  _DialogListTransactionState createState() => _DialogListTransactionState();
}

class _DialogListTransactionState extends State<DialogListTransaction> {
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
    return AlertDialog(
      contentPadding: EdgeInsets.all(16),
      titlePadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: GlobalColorPalette.colorButtonActive,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Data Transaksi",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ElevatedButton.icon(
                          icon: Icon(
                            Icons.perm_contact_calendar_rounded,
                            color: Colors.white,
                            size: 18.0,
                          ),
                          label: Text(
                            'Transaksi Manual',
                            style: TextStyle(fontSize: 14),
                          ),
                          onPressed: () async {
                            Navigator.pop(context);
                            widget.deleteAll();
                            showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (BuildContext c) {
                                  // salesBloc.addTransactionFailed
                                  return DialogCreateTransaction();
                                });
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
                        onPressed: () {
                          salesBloc.requestAsyncTransaction();
                        },
                        icon: Icon(
                          Icons.shopping_cart_rounded,
                          color: Colors.white,
                          size: 16.0,
                        ),
                        label: Text('Sinkronkan Transaksi'),
                        style: ElevatedButton.styleFrom(
                            textStyle: TextStyle(color: Colors.white),
                            padding: EdgeInsets.only(
                                left: 14, right: 14, top: 14, bottom: 14),
                            primary: Color(0xff3498db)),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        tooltip: "Close",
                        icon: Icon(Icons.close),
                        color: Colors.white,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Container(
          height: SizeConfig.screenHeight * 0.8,
          width: SizeConfig.screenWidth * 0.8,
          child: StreamBuilder(
              stream: salesBloc.streamTransactionList,
              builder:
                  (context, AsyncSnapshot<List<TransactionFailedDB>> snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }
                if (snapshot.hasData) {
                  if (snapshot.data!.length == 0) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Image.asset('assets/images/ic_sales.png'),
                          onPressed: () {},
                        ),
                        Container(
                          child: Text('Tidak ada transaksi'),
                        ),
                      ],
                    );
                  }
                  return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true, //Optional
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, int index) {
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Type : ${snapshot.data![index].type}',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'Transaksi : ${snapshot.data![index].date}',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                            'Total Transaksi  : ${Core.converNumeric(snapshot.data![index].totalPriceTransaction.toString()) }'),
                                        Text(
                                            'Total Pembayaran : Rp ${Core.converNumeric(snapshot.data![index].totalPaymentCustomer.toString())}'),
                                        Text(
                                            'Total kembalian  : Rp ${Core.converNumeric(snapshot.data![index].totalMoneyChanges.toString())}'),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        // snapshot.data![index].status == "Failed" ?
                                        // Text('${snapshot.data![index].status}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.red)) :
                                        // Text('${snapshot.data![index].status}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green)),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.close),
                                              color: Colors.red,
                                              iconSize: 16,
                                              onPressed: () {
                                                salesBloc
                                                    .deleteTransactionAndProductTransaction(
                                                        index,
                                                        snapshot
                                                            .data![index].id!);
                                              },
                                            ),
                                            Text(
                                              'Delete ?',
                                              style:
                                                  TextStyle(color: Colors.red),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: snapshot
                                        .data![index].productList!.length,
                                    itemBuilder: (context, int indexProduct) {
                                      return InkWell(
                                        onTap: () {
                                          for (final data in snapshot
                                              .data![index].productList!) {
                                            print('add to product -> ${snapshot.data![index].productList!.length}');
                                            print('add to product qty -> ${snapshot.data![index].productList![indexProduct].quantity}');
                                            MerchantProductDB merchantProduct =
                                                MerchantProductDB(
                                              id: data.productId,
                                              name: data.itemName,
                                              barcode: data.item,
                                              currentPrice:
                                                  data.price.toString(),
                                              salePrice: data.price.toString(),
                                              qty: data.quantity.toString(),
                                              unitId: data.unitId,
                                              unitName:
                                                  data.unitName.toString(),
                                            );
                                            salesBloc
                                                .addProduct(merchantProduct);
                                          }
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                                '(${snapshot.data![index].productList![indexProduct].item}) ${snapshot.data![index].productList![indexProduct].itemName} '
                                                'x ${snapshot.data![index].productList![indexProduct].quantity} qty',
                                                style: TextStyle(fontSize: 12)),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 4.0),
                                              child: Text(
                                                  '${Core.converNumeric(snapshot.data![index].productList![indexProduct].total.toString())}',
                                                  style:
                                                      TextStyle(fontSize: 12)),
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
                  return Text('Tidak ada transaksi');
                }
              }),
        ),
      ),
    );
  }
}
