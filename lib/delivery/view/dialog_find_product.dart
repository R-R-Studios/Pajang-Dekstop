import 'package:beben_pos_desktop/utils/size_config.dart';
import 'package:flutter/material.dart';

class DialogListTransaction extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    AlertDialog alertDialog = AlertDialog(
      contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      titlePadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      title: Container(
        width: SizeConfig.screenWidth * 0.5,
        color: Colors.blueAccent[400],
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                "Cari Produk",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.pop(context, null);
              },
              padding: EdgeInsets.only(right: 24.0),
              tooltip: "Tutup",
              icon: Icon(Icons.close),
              color: Colors.white,
            ),
          ],
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: 8, bottom: 8),
              width: SizeConfig.screenWidth * 0.49,
              child: Focus(
                autofocus: true,
                child: TextFormField(
                  autofocus: true,
                  // focusNode: searchFocus,
                  maxLines: 1,
                  style: TextStyle(fontSize: 12, height: 1),
                  decoration: new InputDecoration(
                    fillColor: Colors.white,
                    isDense: true,
                    contentPadding: EdgeInsets.fromLTRB(6, 18.0, 6, 18.0),
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    hintText: 'Cari Produk',
                  ),
                  onChanged: (String val) {
                    // receivingsBloc.searchProductReceivings(val);
                  },
                ),
              ),
            ),
            // Container(
            //   height: 300,
            //   width: SizeConfig.screenWidth * 0.49,
            //   child: StreamBuilder(
            //     stream: receivingsBloc.streamProductReceivings,
            //     builder: (BuildContext context, AsyncSnapshot<List<ProductReceivingsModel>> snapshot) {
            //       return Container();
            //     // if(snapshot.hasData){
            //     //   listProduct = snapshot.data!;
            //     // }else{
            //     //   listProduct = [ProductReceivingsModel()];
            //     // }
            //     // return ListView.builder(
            //     //   shrinkWrap: true,
            //     //   itemCount: listProduct.length,
            //     //   itemBuilder: (BuildContext context, int index) {
            //     //     return ListTile(
            //     //       contentPadding: EdgeInsets.only(left: 8, right: 8),
            //     //       title: Row(
            //     //         mainAxisSize: MainAxisSize.max,
            //     //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     //         children: [
            //     //           Text("${listProduct[index].barcode != null ? listProduct[index].barcode : "-"}"),
            //     //           Text("${listProduct[index].name != null ? listProduct[index].name : "Product Tidak Ditemukan"}")
            //     //         ],
            //     //       ),
            //     //       onTap: () {
            //     //         Navigator.pop(context, listProduct[index].id != null ? listProduct[index] : null);
            //     //       },
            //     //     );
            //     //   },);
            //   },
            //   ),
            // ),
          ],
        ),
      ),
    );
    return alertDialog;
  }
}
