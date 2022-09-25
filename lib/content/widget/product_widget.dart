import 'package:beben_pos_desktop/content/model/product_detail_response.dart';
import 'package:beben_pos_desktop/core/app/color_palette.dart';
import 'package:beben_pos_desktop/core/util/core_function.dart';
import 'package:beben_pos_desktop/utils/size_config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nav_router/nav_router.dart';

import '../../component/component.dart';

class ProductWidget {

  static dialogDetail(ProductDetailResponse productDetailResponse){
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
                Text("Detail Product"),
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
            width: 700,
            // width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CachedNetworkImage(
                      imageUrl: productDetailResponse.product?.listImage?.first ?? "",
                      height: SizeConfig.blockSizeHorizontal * 20,
                      width: SizeConfig.blockSizeHorizontal * 25  ,
                      fit: BoxFit.fill,
                    ),
                    const SizedBox(width: 10,),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Component.text(
                          productDetailResponse.product?.name ?? "",
                          fontWeight: FontWeight.w700, 
                          fontSize: 15, 
                          colors: ColorPalette.black
                        ),
                        const SizedBox(height: 10,),
                        Component.text(
                          productDetailResponse.product?.barcode ?? "",
                          fontSize: 15, 
                          colors: ColorPalette.black
                        ),
                        const SizedBox(height: 10,),
                        Component.text(
                          productDetailResponse.product?.description ?? "",
                          maxLines: 10,
                          fontSize: 13, 
                          colors: ColorPalette.black
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 50,),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Component.text(
                            "Stock",
                            fontWeight: FontWeight.w700, 
                            fontSize: 15, 
                            colors: ColorPalette.black
                          ),
                          const SizedBox(height: 10,),
                          Component.text(
                            "Stock Awal          :   ${productDetailResponse.merchantProductStocks?.first.firstStock ?? "" }",
                            fontSize: 13, 
                            colors: ColorPalette.black
                          ),
                          const SizedBox(height: 10,),
                          Component.text(
                            "Stock Transaksi  :   ${productDetailResponse.merchantProductStocks?.first.trxStock ?? "" }",
                            fontSize: 13, 
                            colors: ColorPalette.black
                          ),
                          const SizedBox(height: 10,),
                          Component.text(
                            "Stock Akhir         :   ${productDetailResponse.merchantProductStocks?.first.lastStock ?? "" }",
                            fontSize: 13, 
                            colors: ColorPalette.black
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10,),
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Component.text(
                            "Harga",
                            fontWeight: FontWeight.w700, 
                            fontSize: 15, 
                            colors: ColorPalette.black
                          ),
                          const SizedBox(height: 10,),
                          Component.text(
                            "Harga Beli  :   ${CoreFunction.moneyFormatter(productDetailResponse.merchantProductPrices?.first.currentPrice ?? "" )}",
                            fontSize: 13, 
                            colors: ColorPalette.black
                          ),
                          const SizedBox(height: 10,),
                          Component.text(
                            "Harga Jual  :   ${CoreFunction.moneyFormatter(productDetailResponse.merchantProductPrices?.first.salePrice ?? "" )}",
                            fontSize: 13, 
                            colors: ColorPalette.black
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // Component.text("No Pengiriman", fontWeight: FontWeight.w700, fontSize: 15, colors: ColorPalette.black),
                // const SizedBox(height: 10,),
                // Component.text(delivery.orderNumber ?? "", fontSize: 15),
                // const SizedBox(height: 20,),
                // Component.text("Description", fontWeight: FontWeight.w700, fontSize: 15, colors: ColorPalette.black),
                // const SizedBox(height: 10,),
                // Component.text(delivery.description ?? ""),
                // const SizedBox(height: 20,),
                // Component.text("Tanggal di buat", fontWeight: FontWeight.w700, fontSize: 15, colors: ColorPalette.black),
                // const SizedBox(height: 10,),
                // Component.text(delivery.createdAt ?? ""),
                // const SizedBox(height: 20,),
                // Component.text("Transaksi", fontWeight: FontWeight.w700, fontSize: 15, colors: ColorPalette.black),
                // const SizedBox(height: 10,),
                // Flexible(
                //   child: ListView.builder(
                //     shrinkWrap: true,
                //     scrollDirection: Axis.vertical,
                //     itemCount: listDetail.length,
                //     physics: const NeverScrollableScrollPhysics(),
                //     itemBuilder: (BuildContext context, int index) {
                //       return Column(
                //         mainAxisSize: MainAxisSize.min,
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           Component.text(listDetail[index].transactionCode ?? ""),
                //         ],
                //       );
                //     },
                //   ),
                // ),
                // const SizedBox(height: 10,),
                // Component.text(
                //   "Total Transaksi : ${CoreFunction.moneyFormatter(listDetail.first.totalAmountTransaction)}", 
                //   fontWeight: FontWeight.w300, 
                //   colors: ColorPalette.black
                // ),
                // const SizedBox(height: 20,),
                // Component.text("Kendaraan", fontWeight: FontWeight.w700, fontSize: 15, colors: ColorPalette.black),
                // const SizedBox(height: 10,),
                // Row(
                //   children: [
                //     Component.text("Merk"),
                //     const SizedBox(width: 10,),
                //     Component.text(listDetail.first.nameVehicle ?? ""),
                //   ],
                // ),Row(
                //   children: [
                //     Component.text("Nopol"),
                //     const SizedBox(width: 10,),
                //     Component.text(listDetail.first.nopolVehicle?? ""),
                //   ],
                // ),
                // const SizedBox(height: 50,),
                // InkWell(
                //     onTap: (){
                //       Navigator.of(context).pop();
                //       // BlocProvider.of<EmployeeCubit>(currentContext).creteEmployee(nameController.text, phoneController.text, jobController.text);
                //     },
                //     child: Card(
                //       color: Colors.red,
                //       child: Container(
                //         alignment: Alignment.center,
                //         width: SizeConfig.blockSizeHorizontal * 60,
                //         padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                //         child: Component.text("Batalkan", colors: Colors.white,),
                //       ),
                //     ),
                //   ),
              ],
            ),
          ),
        );
      }
    );
  }

}