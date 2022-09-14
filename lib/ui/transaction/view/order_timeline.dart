// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:pajang_customer/core/core.dart';
// import 'package:pajang_customer/ui/component/component.dart';
// import 'package:pajang_customer/ui/transaction/model/response_detail_order.dart';

// import '../model/timelines.dart';

// class OrderTimeLines extends StatelessWidget {
//   final List<Timelines> listTimeline;

//   const OrderTimeLines({required this.listTimeline, Key? key})
//       : super(key: key);

//   String descriptionStatus(String statusCode) {
//     switch (statusCode) {
//       case "2":
//         return "Pembayaran anda telah di konfirmasi oleh admin";
//       case "3":
//         return "Pesanan sedang dalam antrian untuk di kemas";
//       case "4":
//         return "Barang sedang di proses untuk di kemas dalam gudang kami";
//       case "5":
//         return "Driver sedang mengantarkan pesananan anda ke alamat tujuan";
//       case "9":
//         return "Pesanan anda telah selesai, terima kasih telah berbelanja di L-Center";
//       default:
//         return "";
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (listTimeline.isNotEmpty)
//       return ListView.builder(
//           itemCount: listTimeline.length,
//           padding: EdgeInsets.symmetric(vertical: 10),
//           shrinkWrap: true,
//           physics: NeverScrollableScrollPhysics(),
//           itemBuilder: (context, index) {
//             String day = CoreFunction.convertDayToBahasa(DateFormat('EEEE')
//                 .format(DateFormat('dd-MM-yyyy HH-mm-SS')
//                     .parse(listTimeline[index].date!)));
//             String time = DateFormat('HH:mm').format(
//                 DateFormat('dd-MM-yyyy HH-mm-SS')
//                     .parse(listTimeline[index].date!));
//             String date = DateFormat('dd-MM-yyyy').format(
//                 DateFormat('dd-MM-yyyy HH-mm-SS')
//                     .parse(listTimeline[index].date!));
//             CoreFunction.logPrint("Date", day);
//             return Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Component.textDefault("$day \n $date \n $time",
//                     fontSize: 11, maxLines: 3),
//                 SizedBox(
//                   width: 10,
//                 ),
//                 Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(Icons.circle, color: FireshipPalette.green),
//                     Container(
//                       height: 80,
//                       width: 1,
//                       color: FireshipPalette.grey,
//                     )
//                   ],
//                 ),
//                 SizedBox(width: 10),
//                 Card(
//                   elevation: 0,
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Component.textBold(listTimeline[index].statusName!,
//                           fontSize: 13),
//                       SizedBox(
//                         height: 5,
//                       ),
//                       Container(
//                           width: SizeConfig.blockSizeHorizontal * 50,
//                           child: Component.textDefault(
//                               descriptionStatus(
//                                   listTimeline[index].statusCode!),
//                               maxLines: 10,
//                               fontSize: 12))
//                     ],
//                   ),
//                 ),
//               ],
//             );
//           });
//     else
//       return Component.textBold("Menunggu Konfirmasi Admin", fontSize: 12);
//   }
// }
