import 'dart:async';

import 'package:beben_pos_desktop/db/product_db.dart';
import 'package:beben_pos_desktop/db/product_model_db.dart';
import 'package:beben_pos_desktop/sales/bloc/sales_bloc.dart';
import 'package:beben_pos_desktop/db/merchant_product_db.dart';
import 'package:beben_pos_desktop/utils/global_color_palette.dart';
import 'package:beben_pos_desktop/utils/global_functions.dart';
import 'package:beben_pos_desktop/utils/size_config.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

class DialogFindProduct extends StatefulWidget {
  const DialogFindProduct(this.addProduct, this.type, {Key? key})
      : super(key: key);

  final dynamic addProduct;
  final String type;

  @override
  _DialogFindProductState createState() => _DialogFindProductState();
}

class _DialogFindProductState extends State<DialogFindProduct> {
  bool canSearch = false;
  String searchText = "";
  Timer? _debouncer;
  SalesBloc salesBloc = SalesBloc();
  List<MerchantProductDB> merchantProductData = [];
  List<ProductModelDB> productListDB = [];
  TextEditingController scanController = TextEditingController();
  FocusNode scanFocusNode = FocusNode();

  onSearchChange(String query) {
    print("query $query");
    salesBloc.searchProductMerchant(query);
    // if (_debouncer?.isActive ?? false) _debouncer?.cancel();
    // _debouncer = Timer(const Duration(milliseconds: 1000), () {
    //   print('on progress');
    //   setState(() {
    //     canSearch = true;
    //     searchText = query;
    //   });
    // });
  }

  @override
  void initState() {
    // TODO: implement initState
    canSearch = true;
    salesBloc.getProductMerchant();
    // salesBloc.selectProductMerchant(context, "", widget.type);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    AlertDialog alertDialog = AlertDialog(
      contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      titlePadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: GlobalColorPalette.colorButtonActive,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Produk",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          salesBloc.refreshProduct();
                        },
                        tooltip: "Refresh Data",
                        icon: Icon(Icons.refresh),
                        color: Colors.white,
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
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin:
            EdgeInsets.only(left: 12, right: 12, top: 14, bottom: 8),
            width: SizeConfig.screenWidth * 0.49,
            child: TextFormField(
              maxLines: 1,
              autofocus: true,
              focusNode: scanFocusNode,
              controller: scanController,
              style: TextStyle(fontSize: 12, height: 1),
              decoration: new InputDecoration(
                fillColor: Colors.white,
                isDense: true,
                contentPadding: EdgeInsets.fromLTRB(6, 18.0, 6, 18.0),
                filled: true,
                prefixIcon: Icon(Icons.search),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: GlobalColorPalette.colorButtonActive,
                      width: 1.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1.0),
                ),
                hintText: 'Cari Produk',
              ),
              onFieldSubmitted: (String val) {
                salesBloc
                    .findProductBarcode(context, val)
                    .then((MerchantProductDB value) {
                  if (value.id == null) {
                    GlobalFunctions.showSnackBarWarning(
                        "Produk tidak ditemukan");
                    return;
                  }
                  scanController.text = "";
                  widget.addProduct(value);
                  FocusScope.of(context).unfocus();
                  Navigator.pop(context);
                });
              },
              onChanged: (String val) {
                onSearchChange(val);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Divider(),
          ),
          Container(
            padding: EdgeInsets.all(8),
            width: SizeConfig.screenWidth * 0.49,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex:1,
                  child: Text("Barcode", style: TextStyle(fontWeight: FontWeight.bold),),
                ),
                Expanded(
                  flex:1,
                  child: Text("Nama Produk", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  flex:1,
                  child: Text("Satuan", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Divider(),
          ),
          SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    height: SizeConfig.screenHeight * 0.5,
                    width: SizeConfig.screenWidth * 0.49,
                    child: canSearch
                        ? buildListProductModelDB(context)
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search,
                                size: 18,
                              ),
                              Container(
                                  margin: EdgeInsets.only(left: 8),
                                  child: Text('Cari Produk terlebih dahulu')),
                            ],
                          ))
              ],
            ),
          ),
        ],
      ),
    );
    return alertDialog;
  }

  Widget buildListProductMerchant(BuildContext context) {
    return StreamBuilder(
        stream: salesBloc.streamMerchantProducts,
        builder: (context, AsyncSnapshot<List<MerchantProductDB>> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Text("Data Kosong"),
            );
          } else {
            merchantProductData.clear();
            merchantProductData.addAll(snapshot.data!);
            return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.only(left: 8, right: 8),
                        title: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("${snapshot.data![index].barcode}"),
                            Text("${snapshot.data![index].name}"),
                          ],
                        ),
                        onTap: () {
                          snapshot.data![index].qty = "1";
                          widget.addProduct(snapshot.data![index]);
                          Navigator.pop(context);
                        },
                      ),
                      Divider()
                    ],
                  );
                });
          }
        });
  }

  Widget buildListProductModelDB(BuildContext context) {
    return StreamBuilder(
        stream: salesBloc.streamProductModelDB,
        builder: (context, AsyncSnapshot<List<ProductModelDB>> snapshot) {
          // if (snapshot.connectionState == ConnectionState.waiting) {
          //   return Center(
          //     child: CircularProgressIndicator(),
          //   );
          // }
          if (!snapshot.hasData) {
            return Center(
              child: Text("Data Kosong"),
            );
          } else {
            productListDB.clear();
            productListDB.addAll(snapshot.data ?? []);
            productListDB.sort((idA, idB) => idA.productId ?? 0.compareTo(idB.productId ?? 0));
            return ListView.builder(
                shrinkWrap: true,
                itemCount: productListDB.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.only(left: 8, right: 8),
                        title: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text("${productListDB[index].barcode}"),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text("${productListDB[index].name}"),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text("${productListDB[index].unitsName}"),
                            ),
                          ],
                        ),
                        onTap: () {
                          MerchantProductDB product = MerchantProductDB(
                            id: productListDB[index].productId,
                            salePrice: productListDB[index].salePrice ?? "0",
                            name: productListDB[index].name,
                            barcode: productListDB[index].barcode,
                            qty: "1",
                            unitName: productListDB[index].unitsName,
                            unitId: productListDB[index].unitsId,
                            currentPrice:
                                productListDB[index].originalPrice ?? "0",
                          );
                          // salesBloc.addProduct(product);
                          // snapshot.data![index].stock = "1";
                          widget.addProduct(product);
                          Navigator.pop(context);
                        },
                      ),
                      Divider()
                    ],
                  );
                });
          }
        });
  }
}
