
import 'package:beben_pos_desktop/product/bloc/product_bloc.dart';
import 'package:beben_pos_desktop/product/model/product_model.dart';
import 'package:beben_pos_desktop/receivings/bloc/receivings_bloc.dart';
import 'package:beben_pos_desktop/receivings/model/product_receivings_model.dart';
import 'package:beben_pos_desktop/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogFindProduct extends StatefulWidget {
  @override
  _DialogFindProductState createState() => _DialogFindProductState();
}

class _DialogFindProductState extends State<DialogFindProduct> {
  String search = "";
  ReceivingsBloc receivingsBloc = ReceivingsBloc();
  late List<ProductReceivingsModel> listProduct = [];

  @override
  void initState() {
    // TODO: implement initState
    receivingsBloc.futureProductReceivings();
    // ProductBloc().refreshProduct();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    receivingsBloc.close();
    super.dispose();
  }

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
                "Find Product",
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
              tooltip: "Close",
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
              child: TextFormField(
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
                  receivingsBloc.productListDB(val);
                },
              ),
            ),
            Container(
                height: 300,
                width: SizeConfig.screenWidth * 0.49,
                child: StreamBuilder(
                    stream: receivingsBloc.streamProductReceivings,
                    builder: (context, AsyncSnapshot<List<ProductReceivingsModel>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting){
                        return Center(child: CupertinoActivityIndicator());
                      } else if (snapshot.hasData) {
                        if(snapshot.data!.length > 0){
                          listProduct = snapshot.data!;
                        }else{
                          listProduct = [];
                        }
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: listProduct.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                contentPadding: EdgeInsets.only(left: 8, right: 8),
                                title: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("${listProduct[index].name != null ? listProduct[index].name : "Product Tidak Ditemukan"}"),
                                    Text("${listProduct[index].barcode != null ? listProduct[index].barcode : "-"}"),
                                  ],
                                ),
                                onTap: () {
                                  Navigator.pop(context, listProduct[index].id != null ? listProduct[index] : null);
                                },
                              );
                            });
                      }else{
                        return Center(child: Text("Product Kosong"));
                      }
                    }
                )
            )
          ],
        ),
      ),
    );
    return alertDialog;
  }
}