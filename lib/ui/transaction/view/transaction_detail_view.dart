import 'package:beben_pos_desktop/component/component.dart';
import 'package:beben_pos_desktop/core/fireship/fireship_palette.dart';
import 'package:beben_pos_desktop/core/util/core_function.dart';
import 'package:beben_pos_desktop/ui/transaction/cubit/transaction_detail_cubit.dart';
import 'package:beben_pos_desktop/utils/size_config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
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
          if (state is TransactionDetailLoaded) {
            return ListView(
              children: [

                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      // onTap: () =>
                          // routePush(DetailMitraView(), RouterType.cupertino),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Component.text(
                            "PO Number : ${state.transactionDetail.id}",
                            colors: FireshipPalette.green,
                            fontSize: 14,
                          ),
                          Component.text(
                            "Tanggal : ${state.transactionDetail.createdAt}",
                            fontSize: 12
                          ),
                        ],
                      ),
                    ),
                    Component.divider(),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Component.text(
                          "Detail Produk",
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          colors: FireshipPalette.green3
                        ),
                        SizedBox(height: 10),
                        Flexible(
                          child: ListView.builder(
                            itemCount: state.transactionDetail.merchantTransactionDetails!.length,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                padding: const EdgeInsets.all(5.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: state.transactionDetail.merchantTransactionDetails![index].merchantProductPrice!.merchantProduct!.product!.name ?? "",
                                      height: SizeConfig.blockSizeHorizontal * 20,
                                      width: SizeConfig.blockSizeHorizontal * 20,
                                      fit: BoxFit.cover,
                                      placeholder: (context, string) => CupertinoActivityIndicator(),
                                      errorWidget: (context, string, e) => Image.asset(
                                        "assets/icon/default_image.png",
                                        height: SizeConfig.blockSizeHorizontal * 10,
                                        fit: BoxFit.cover
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Component.text(
                                            state.transactionDetail.merchantTransactionDetails![index].merchantProductPrice!.merchantProduct!.product!.name ?? "",
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            maxLines: 5,
                                          ),
                                          Component.text(
                                            "${CoreFunction.moneyFormatter(state.transactionDetail.merchantTransactionDetails![index].merchantProductPrice!.currentPrice ?? "")}}",
                                            fontSize: 12
                                          )
                                        ],
                                      ),
                                    ),
                                    Spacer(),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                      //   Component.textDefault(
                                      //       "${state.de.products![index].qtyTrx} ${state.responseDetailOrder.products![index].unitName}",
                                      //       fontWeight: FontWeight.bold,
                                      //       fontSize: 12),
                                      //   Component.text(
                                      //       CoreFunction.moneyFormatter(state
                                      //           .responseDetailOrder
                                      //           .products![index]
                                      //           .subAmount),
                                      //       fontSize: 12),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                    Component.divider(),
                    // Column(
                    //   mainAxisSize: MainAxisSize.min,
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     Component.textDefault("Total Akumulasi",
                    //         fontWeight: FontWeight.bold,
                    //         fontSize: 14,
                    //         colors: FireshipPalette.green3),
                    //     SizedBox(height: 10),
                    //     Row(
                    //       mainAxisSize: MainAxisSize.min,
                    //       children: [
                    //         Column(
                    //           crossAxisAlignment: CrossAxisAlignment.start,
                    //           children: [
                    //             Component.textDefault("Total Produk",
                    //                 fontSize: 12),
                    //             Component.textDefault("Total Kuantitas",
                    //                 fontSize: 12),
                    //             Component.textDefault("Total PPN",
                    //                 fontSize: 12),
                    //             Component.text("Total Pembayaran",
                    //                 fontSize: 12)
                    //           ],
                    //         ),
                    //         Spacer(),
                    //         Column(
                    //           crossAxisAlignment: CrossAxisAlignment.end,
                    //           children: [
                    //             Component.textDefault(
                    //                 state.responseDetailOrder.totalProduct
                    //                     .toString(),
                    //                 fontSize: 12),
                    //             Component.textDefault(
                    //                 state.responseDetailOrder.totalQuantity
                    //                     .toString(),
                    //                 fontSize: 12),
                    //             Component.textDefault(
                    //               CoreFunction.moneyFormatter(
                    //                 state.responseDetailOrder.totalTax,
                    //               ),
                    //               fontSize: 12,
                    //             ),
                    //             Component.text(
                    //                 CoreFunction.moneyFormatter(
                    //                     state.responseDetailOrder.grandTotal),
                    //                 fontSize: 12)
                    //           ],
                    //         ),
                    //       ],
                    //     ),
                    //   ],
                    // ),
                    Component.divider(),
                    SizedBox(height: 10),
                    Component.text(
                      "Detail Pengiriman",
                      colors: FireshipPalette.green,
                      textAlign: TextAlign.start,
                      fontSize: 18,
                    ),
                    SizedBox(height: 10),
                    // Consumer<CartNotifer>(
                    //   builder: (BuildContext context, value, Widget? child) {
                    //     return Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         // Component.text(carStockNotifer.address!.name!),
                    //         Component.text(
                    //             state.responseDetailOrder.ownerAddress!,
                    //             fontSize: 12),
                    //         Component.textDefault(
                    //             state.responseDetailOrder.detailAddress!,
                    //             fontSize: 12),
                    //         Component.textDefault(
                    //             "(${state.responseDetailOrder.postalCode ?? ""})",
                    //             fontSize: 12)
                    //       ],
                    //     );
                    //   },
                    // ),
                    SizedBox(height: 10),
                    Component.divider(),
                    SizedBox(height: 10),
                    Component.text(
                      "Status Pemesanan",
                      colors: FireshipPalette.green,
                      textAlign: TextAlign.start,
                      fontSize: 14
                    ),
                    // Flexible(
                    //   child: OrderTimeLines(
                    //       listTimeline: state.responseDetailOrder.timelines!),
                    // ),
                    SizedBox(
                      height: 20,
                    ),
              ],
            );
          } else {
            return CupertinoActivityIndicator();
          }
        },
      ),
    );
  }
}