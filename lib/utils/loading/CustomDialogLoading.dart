// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class CustomLoading {
//
//   CustomLoading._privateConstructor();
//   static final CustomLoading _instance = CustomLoading._privateConstructor();
//   factory CustomLoading() {
//     return _instance;
//   }
//
//   GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();
//
//   dismisCustomLoading(){
//     if(navKey.currentContext != null){
//       Navigator.pop(navKey.currentContext!);
//     }
//   }
//
//   showCustomLoading() {
//     showDialog(
//       context: navKey.currentContext!,
//       barrierDismissible: false,
//       builder: (BuildContext c) {
//         return Container(
//           child: AlertDialog(
//             key: navKey,
//             contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
//             titlePadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
//             content: Container(
//               width: 100,
//               height: 200,
//               child: Center(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.max,
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     CupertinoActivityIndicator(radius: 30,),
//                     Text("Mohon Tunggu...")
//                   ],
//                 )
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
