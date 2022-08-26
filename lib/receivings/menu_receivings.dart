import 'dart:convert';
import 'package:beben_pos_desktop/core/core.dart';
import 'package:beben_pos_desktop/dashboard_bloc.dart';
import 'package:beben_pos_desktop/model/head_column_model.dart';
import 'package:beben_pos_desktop/product/bloc/product_bloc.dart';
import 'package:beben_pos_desktop/product/widget/dialog_create_product_data.dart';
import 'package:beben_pos_desktop/receivings/bloc/receivings_bloc.dart';
import 'package:beben_pos_desktop/receivings/model/cart_receivings_model.dart';
import 'package:beben_pos_desktop/receivings/model/price_list_model.dart';
import 'package:beben_pos_desktop/receivings/model/product_receivings_model.dart';
import 'package:beben_pos_desktop/receivings/widget/dialog_find_product.dart';
import 'package:beben_pos_desktop/units/widget/dialog_find_units.dart';
import 'package:beben_pos_desktop/utils/global_color_palette.dart';
import 'package:beben_pos_desktop/utils/global_functions.dart';
import 'package:beben_pos_desktop/utils/global_widget.dart';
import 'package:beben_pos_desktop/utils/printerservice/printer_service_custom.dart';
import 'package:beben_pos_desktop/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MenuReceivings extends StatefulWidget {
  MenuReceivings(this.dashboardBloc);
  final DashboardBloc dashboardBloc;
  @override
  _MenuReceivingsState createState() => _MenuReceivingsState();
}

class _MenuReceivingsState extends State<MenuReceivings> {
  String receivingsScreen = "receivings_screen";

  List<String> _receivingsMode = ["Receive", "Return"];
  String _selectedReceivingsMode = "Receive";

  ReceivingsBloc receivingsBloc = ReceivingsBloc();

  List<HeadColumnModel> _headColumnModel = [
    HeadColumnModel(key: "1", name: "Barcode", ischecked: false),
    HeadColumnModel(key: "2", name: "Nama Produk", ischecked: false),
    HeadColumnModel(key: "3", name: "Satuan", ischecked: false),
    HeadColumnModel(key: "4", name: "Harga Beli", ischecked: false),
    HeadColumnModel(key: "4", name: "Harga Jual", ischecked: false),
    HeadColumnModel(key: "5", name: "Jumlah", ischecked: false),
    HeadColumnModel(key: "6", name: "Total", ischecked: false),
    HeadColumnModel(key: "7", name: "Hapus", ischecked: false),
    // HeadColumnModel(key: "6", name: "Date", ischecked: false),
  ];

  List<CartReceivingsModel> _cartReceivings = [];
  List<CartReceivingsModel> cartStruct = [];

  String keySearch = "";

  var productSelectedInput = ProductReceivingsModel();

  int _currentSortColumn = 0;
  bool _isAscending = true;
  bool _isSortProduct = false;
  bool _isSearchProduct = false;

  GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

  List<ProductReceivingsModel> listProductReceivings = [];
  List<ProductReceivingsModel> listProduct = [];

  bool isStruct = true;
  TextEditingController scanController = TextEditingController();
  FocusNode scanFocusNode = FocusNode();
  FocusNode saveFocusNode = FocusNode();

  double totalPrice = 0;
  double totalBelanja = 0;
  double customerMoney = 0;
  String kembalian = "0";

  String trxCode = "";

  String typePrice = "0";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initProductReceivings();
    // scanFocusNode.requestFocus();
    // CartReceivingsModel cart = CartReceivingsModel.fromJson(jsonDecode(
    //     "{\"id\":64,\"name\":\"Gudang Garam Filter 12\",\"code\":\"12FIM\",\"barcode\":\"RDSR001\",\"description\":\"Gudang Garam Filter 12 Batang\",\"unit_id\":2,\"sale_price\":380000,\"original_price\":380000,\"unit\":\"Slop\",\"qty\":10,\"total\":\"3800000\"}"));
    // for (int i = 0; i < 5; i++) {
    //   receivingsBloc.addCartReceivings(cart);
    // }
    receivingsBloc.isStructController.listen((value) {
      setState(() async {
        isStruct = value;
      });
    });
  }

  Future<List<CartReceivingsModel>> getProductSearch(String text) async {
    List<CartReceivingsModel> list = [];
    list.clear();
    if (text.isNotEmpty) {
      _cartReceivings.forEach((element) {
        if (element.name!.toLowerCase().contains(text.toLowerCase()) ||
            element.code!.toLowerCase().contains(text.toLowerCase()) ||
            element.barcode!.toLowerCase().contains(text.toLowerCase())) {
          list.add(element);
        }
      });
    } else {
      list.addAll(_cartReceivings);
    }
    _isSearchProduct = false;
    if (list.length == 0) {
      list.add(CartReceivingsModel());
    }
    return list;
  }

  FocusNode _keyboardFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
        color: Colors.grey[100],
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          // layoutReceivingsMode(),
                          layoutFindOrScanProduct(),
                          layoutDataTable(),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Column(
                          children: [
                            _selectSupplier(),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }

  Widget layoutReceivingsMode() => Card(
        color: Colors.grey[300],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        "Receivings Mode",
                        style: TextStyle(fontSize: 12),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Container(
                          color: Colors.white,
                          width: 150,
                          height: 30,
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                                fillColor: Colors.white,
                                hoverColor: Colors.white,
                                contentPadding:
                                    EdgeInsets.fromLTRB(12, 0, 6, 0),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(2)))),
                            value: _selectedReceivingsMode,
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(color: Colors.black, fontSize: 12),
                            onChanged: (String? data) {
                              setState(() {
                                _selectedReceivingsMode = data!;
                              });
                            },
                            items: _receivingsMode
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      );

  _showCreateProduct(String barcode, BuildContext context) async {
    await showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return DialogCreateProductData(barcode: barcode,);
        }).then((value) async {
      GlobalFunctions.logPrint("request Create Merchant Product", '$value');
      if (value){
        ProductBloc().refreshProduct();
      }
    });
  }

  Widget layoutFindOrScanProduct() {
    return Card(
      color: Colors.grey[400],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "Cari atau Scan Produk",
                        style: TextStyle(fontSize: 12),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 8),
                        width: MediaQuery.of(context).size.width * 0.20,
                        child: TextFormField(
                          enabled: true,
                          focusNode: scanFocusNode,
                          autofocus: true,
                          readOnly: false,
                          style: TextStyle(fontSize: 12, height: 1),
                          controller: scanController,
                          textInputAction: TextInputAction.search,
                          onChanged: (code){
                            print("code $code");
                            // FocusScope.of(context).requestFocus(myFocusNode);
                          },
                          onFieldSubmitted: (value){
                            String bcode = value;
                            scanController.text = "";
                            ProductReceivingsModel scan = listProduct.firstWhere((element) => element.barcode!.toLowerCase().contains(value.toLowerCase()),
                                orElse:() => ProductReceivingsModel());
                            FocusScope.of(context).requestFocus(scanFocusNode);
                            if(scan.id == null){
                              GlobalWidget().dialogProductNotFound(context).then((value) {
                                print("openAddProduct $value");
                                if(value){
                                  _showCreateProduct(bcode, context);
                                }
                              });
                              return;
                            }
                            // var scan = listProduct.first;
                            setState(() {
                              productSelectedInput = scan;
                            });
                            scanController.text = "";
                            var isFromPO = _cartReceivings.any((element) => element.isFromPO == true);
                            if(isFromPO){
                              GlobalFunctions.showToast("Tidak bisa menambahkan produk ketika transaksi PO");
                              return;
                            }
                            if(productSelectedInput.priceList!.length > 1){
                              if(scanController.text.length > 3)
                              showDialogFindUnit(productSelectedInput.priceList!, context);
                            }else{
                              PriceList unitPrice = productSelectedInput.priceList!.first;
                              addProductToCart(unitPrice);
                            }
                          },
                          onTap: () {
                            showDialogFindProduct(context);
                          },
                          decoration: new InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            isDense: true,
                            contentPadding:
                            EdgeInsets.fromLTRB(6.0, 18.0, 6.0, 18.0),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.black, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.grey, width: 1.0),
                            ),
                            hintText: 'Cari Produk',
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          FocusScope.of(context).requestFocus(scanFocusNode);
                          receivingsBloc.refreshProduct();
                        },
                        tooltip: "Refresh Data",
                        icon: Icon(Icons.refresh),
                        color: Colors.lightBlue,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        icon: Icon(
                          Icons.apps,
                          color: Colors.white,
                          size: 18.0,
                        ),
                        label: Text(
                          'Masukan Kode Transaksi PO',
                          style: TextStyle(fontSize: 12),
                        ),
                        onPressed: () {
                          setState(() {
                            trxCode = "";
                          });
                          dialogInpuTransaksiPO();
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.lightBlue,
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(2.0),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  dialogInpuTransaksiPO() {
    showDialog(
        context: context,
        builder: (BuildContext c) {
          // return AlertDialog(
          //   contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          //   titlePadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          //   title: Container(
          //     width: MediaQuery.of(context).size.width * 0.3,
          //     color: Colors.blueAccent[400],
          //     child: Row(
          //       mainAxisSize: MainAxisSize.max,
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         Padding(
          //           padding: const EdgeInsets.all(24.0),
          //           child: Text(
          //             "Cari Transaksi PO",
          //             style: TextStyle(
          //                 fontSize: 14,
          //                 fontWeight: FontWeight.bold,
          //                 color: Colors.white),
          //           ),
          //         ),
          //         IconButton(
          //           onPressed: () {
          //             Navigator.pop(c, null);
          //           },
          //           padding: EdgeInsets.only(right: 24.0),
          //           tooltip: "Close",
          //           icon: Icon(Icons.close),
          //           color: Colors.white,
          //         ),
          //       ],
          //     ),
          //   ),
          //   content: Container(
          //     padding: EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 8),
          //     width: MediaQuery.of(context).size.width * 0.29,
          //     child: TextFormField(
          //       maxLines: 1,
          //       autofocus: true,
          //       focusNode: FocusNode(),
          //       style: TextStyle(fontSize: 12, height: 1),
          //       decoration: new InputDecoration(
          //         fillColor: Colors.white,
          //         isDense: true,
          //         contentPadding: EdgeInsets.fromLTRB(6, 18.0, 6, 18.0),
          //         filled: true,
          //         focusedBorder: OutlineInputBorder(
          //           borderSide: BorderSide(color: Colors.black, width: 1.0),
          //         ),
          //         enabledBorder: OutlineInputBorder(
          //           borderSide: BorderSide(color: Colors.grey, width: 1.0),
          //         ),
          //         hintText: 'Masukan Kode Transaksi PO',
          //       ),
          //       onFieldSubmitted: (String val) {
          //         Navigator.pop(c);
          //         setState(() {
          //           trxCode = val;
          //         });
          //         onSearchTransactionPO(val, c);
          //       },
          //     ),
          //   ),
          // );

          return Dialog(
            backgroundColor: Colors.lightBlue,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Container(
                    width: SizeConfig.screenWidth * 0.4,
                    child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Cari Transaksi PO",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.pop(c, null);
                              },
                              tooltip: "Close",
                              icon: Icon(Icons.close),
                              color: Colors.white,
                            ),
                          ],
                        ),
                  ),
                ),
            Container(
              color: Colors.white,
              margin: EdgeInsets.only(bottom: 24),
              width: SizeConfig.screenWidth * 0.4,
                  child: TextFormField(
                    maxLines: 1,
                    autofocus: true,
                    focusNode: FocusNode(),
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
                      hintText: 'Masukan Kode Transaksi PO',
                    ),
                    onFieldSubmitted: (String val) {
                      Navigator.pop(c);
                      setState(() {
                        trxCode = val;
                      });
                      onSearchTransactionPO(val, c);
                    },
                  ),
                ),
                ],
              ),
            ),
          );
        });
  }

  Widget layoutDataTable() {
    return Card(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.55,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: StreamBuilder(
              stream: receivingsBloc.streamListCartModel,
              builder:
                  (ctx, AsyncSnapshot<List<CartReceivingsModel>> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.length > 0) {
                    _cartReceivings = snapshot.data!;
                    List<DataColumn> columns = [];
                    for (final header in _headColumnModel) {
                      double width = 0;
                      if (header.name == "Barcode") {
                        width = MediaQuery.of(ctx).size.width * 0.075;
                      } else if (header.name == "Nama Produk") {
                        width = MediaQuery.of(ctx).size.width * 0.08;
                      } else if (header.name == "Satuan") {
                        width = MediaQuery.of(ctx).size.width * 0.05;
                      } else if (header.name == "Harga Beli") {
                        width = MediaQuery.of(ctx).size.width * 0.075;
                      } else if (header.name == "Harga Jual") {
                        width = MediaQuery.of(ctx).size.width * 0.07;
                      } else if (header.name == "Jumlah") {
                        width = MediaQuery.of(ctx).size.width * 0.04;
                      } else if (header.name == "Total") {
                        width = MediaQuery.of(ctx).size.width * 0.075;
                      } else if (header.name == "Hapus") {
                        width = MediaQuery.of(ctx).size.width * 0.04;
                      }
                      columns.add(DataColumn(
                        label: Container(
                          width: width,
                          child: Text(
                            header.name!,
                          ),
                        ),
                        tooltip: header.name,
                      ));
                    }
                    return DataTable(
                      columnSpacing: MediaQuery.of(ctx).size.width * 0.014,
                      horizontalMargin: 25,
                      showBottomBorder: false,
                      columns: columns,
                      rows: <DataRow>[
                        for (int i = 0; i < _cartReceivings.length; i++)
                          getDataRowIndex(i, _cartReceivings, ctx)
                      ],
                    );
                  } else {
                    return layoutEmptyDataTable();
                  }
                } else {
                  return layoutEmptyDataTable();
                }
              }),
        ),
      ),
    );
  }

  DataRow getDataRowIndex(int index, List<CartReceivingsModel> list, ctx) {
    // TextEditingController _priceController = TextEditingController();
    // TextEditingController _qtyController = TextEditingController();
    // _priceController.text = list[index].price.toString();
    // _qtyController.text = list[index].qty.toString();
    return DataRow.byIndex(index: index, cells: [
      DataCell(
        Container(
          width: MediaQuery.of(ctx).size.width * 0.075,
          child: Text(list[index].barcode == null ? "-" : list[index].barcode!),
        ),
      ),
      DataCell(
        Container(
          width: MediaQuery.of(ctx).size.width * 0.1,
          child: Text(list[index].name == null ? "-" : list[index].name!),
        ),
      ),
      DataCell(
        Container(
          width: MediaQuery.of(ctx).size.width * 0.05,
          child:
              Text(list[index].unitName == null ? "-" : list[index].unitName!),
        ),
      ),
      DataCell(
        Container(
          width: MediaQuery.of(ctx).size.width * 0.075,
          child: Text(
            list[index].originalPrice == null
                ? Core.converNumeric("0")
                : Core.converNumeric(list[index].originalPrice.toString()),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      DataCell(
        Container(
          width: MediaQuery.of(ctx).size.width * 0.07,
          child: Center(
            child: TextFormField(
              key: Key(list[index].salePrice.toString()),
              focusNode: list[index].focusPrice,
              autofocus: true,
              style: TextStyle(fontSize: 12, height: 1),
              initialValue: list[index].salePrice == null
                  ? "0"
                  : Core.convertToDouble(list[index].salePrice.toString()),
              onChanged: (String value) {
                receivingsBloc.updatePriceProduct(
                    index, value.isNotEmpty ? double.parse(value) : 0);
              },
              onEditingComplete: () {
                FocusScope.of(context).unfocus();
                FocusScope.of(context).requestFocus(saveFocusNode);
              },
              onFieldSubmitted: (value) {
                FocusScope.of(context).unfocus();
                FocusScope.of(context).requestFocus(saveFocusNode);
              },
              decoration: new InputDecoration(
                prefix: Text("Rp. ", style: TextStyle(fontSize: 12, height: 1)),
                prefixStyle:
                    TextStyle(fontSize: 12, height: 1, color: Colors.black),
                fillColor: Colors.white,
                filled: true,
                isDense: true,
                contentPadding: EdgeInsets.fromLTRB(6.0, 18.0, 6.0, 18.0),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1.0),
                ),
                hintText: "0",
              ),
            ),
          ),
        ),
      ),
      !list[index].isFromPO ? DataCell(
        Container(
          width: MediaQuery.of(ctx).size.width * 0.03,
          child: Center(
            child: TextFormField(
              key: Key(list[index].qty.toString()),
              focusNode: list[index].focusQty,
              style: TextStyle(fontSize: 12, height: 1),
              initialValue: Core.convertToDouble("${list[index].qty ?? 0}"),
              onChanged: (String value) {
                receivingsBloc.updateQtyProduct(
                    index,  value.isNotEmpty ? double.parse(value) : 0);
              },
              onFieldSubmitted: (value) {
                FocusScope.of(ctx).unfocus();
                saveFocusNode.requestFocus();
              },

              decoration: new InputDecoration(
                fillColor: Colors.white,
                filled: true,
                isDense: true,
                contentPadding: EdgeInsets.fromLTRB(6.0, 18.0, 6.0, 18.0),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1.0),
                ),
                hintText: "0",
              ),
            ),
          ),
        ),
      ) :
      DataCell(
        Container(
          width: MediaQuery.of(ctx).size.width * 0.04,
          child: Text(
            "${list[index].qty ?? 0}",
            textAlign: TextAlign.center,
          ),
        ),
      ),
      DataCell(
        StreamBuilder(
          stream: receivingsBloc.streamTotalPrice,
          builder: (context, AsyncSnapshot<List<double>> snapshot) {
            if (snapshot.hasData) {
              return Container(
                width: MediaQuery.of(context).size.width * 0.075,
                child:
                    Text(Core.converNumeric("${snapshot.data?[index] ?? 0}")),
              );
            } else {
              return Container(
                width: MediaQuery.of(context).size.width * 0.08,
                child: Text("Rp. 0"),
              );
            }
          },
        ),
      ),
      DataCell(
          !list[index].isFromPO ? IconButton(
            autofocus: false,
            iconSize: MediaQuery.of(ctx).size.width * 0.018,
            color: Colors.blue,
            onPressed: () {
              setState(() {
                // list.removeAt(index);
                receivingsBloc.deleteProduct(index);
                // print("DELETE RECEIVINGS $index");
              });
            },
            icon: Icon(Icons.delete_outline_sharp),
          ) : Center(
            child: Text("-"),
          ),
      ),
    ]);
  }

  Widget layoutEmptyDataTable() {
    return Card(
      color: Colors.lightBlueAccent,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
            child: Text(
          "Tidak ada Produk di keranjang.",
          style: TextStyle(color: Colors.white),
        )),
      ),
    );
  }

  Widget _selectSupplier() {
    return Container(
      child: Card(
        color: Colors.grey[500],
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // _selectCustomerRequired(),
              // _spacer(),
              // Divider(
              //   height: 1,
              //   color: Colors.black,
              // ),
              // _spacer(),
              StreamBuilder(
                stream: receivingsBloc.streamSumTotalQty,
                builder: (context, AsyncSnapshot<double> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data! > 0) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          StreamBuilder(
                            stream: receivingsBloc.streamSumTotalProduct,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Expanded(
                                  child: Text("Jumlah ${snapshot.data} Produk")
                                );
                              } else {
                                return Text("Kosong");
                              }
                            }),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text("${snapshot.data}")
                            )
                          )
                        ],
                      );
                    } else {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(child: Text("Jumlah 0 Produk")),
                          Expanded(
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text("0")))
                        ],
                      );
                    }
                  } else {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(child: Text("Jumlah 0 Produk")),
                        Expanded(
                            child: Align(
                                alignment: Alignment.centerRight,
                                child: Text("0")))
                      ],
                    );
                  }
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(child: Text("Subtotal")),
                  Expanded(
                      child: StreamBuilder(
                    stream: receivingsBloc.streamSumSubTotal,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                                Core.converNumeric(snapshot.data.toString())));
                      } else {
                        return Align(
                            alignment: Alignment.centerRight, child: Text("0"));
                      }
                    },
                  ))
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Divider(
                  height: 1,
                  color: Colors.black,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                      child: Text(
                    "Total",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  )),
                  Expanded(
                      child: StreamBuilder(
                          stream: receivingsBloc.streamSumTotalPayment,
                          builder: (context, AsyncSnapshot<double> snapshot) {
                            if (snapshot.hasData) {
                              totalBelanja = snapshot.data ?? 0;
                              return Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(Core.converNumeric(
                                      snapshot.data.toString())));
                            } else {
                              return Align(
                                  alignment: Alignment.centerRight,
                                  child: Text("Rp. 0"));
                            }
                          }))
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton.icon(
                      icon: Icon(
                        Icons.perm_contact_calendar_rounded,
                        color: Colors.white,
                        size: 18.0,
                      ),
                      focusNode: saveFocusNode,
                      autofocus: false,
                      label: Text(
                        'Simpan Penerimaan',
                        style: TextStyle(fontSize: 12),
                      ),
                      onPressed: () {
                          setState(() {
                            customerMoney = 0;
                          });

                          if (_cartReceivings.length > 0) {
                            List<CartReceivingsModel> validateList = _cartReceivings.where((element) => element.originalPrice! > element.salePrice!).toList();
                            if (validateList.length == 0){
                              dialogSaveConfirmation2();
                            } else {
                              GlobalFunctions.showSnackBarWarning("Masih ada produk dengan harga jual melebihi harga beli, mohon di check kembali");
                            }
                          } else {
                            GlobalFunctions.showSnackBarWarning("Tidak ada Produk di keranjang");
                          }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.lightBlue,
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(2.0),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future createReceivingsV2(List<CartReceivingsModel> cartReceivings) async {
    // GlobalFunctions.dismisLoading();
    receivingsBloc
        .requestSaveReceivings(cartReceivings, trxCode)
        .then((value) async {
          if((value.meta.code??1000) < 300){
            await PrinterServiceCustom.printReceivings(cartReceivings, totalBelanja, trxCode);
          //   await PrinterManager()
          //       .printReceivingsStructV2(
          //       cartReceivings, totalBelanja, trxCode)
          //       .then((value) {
          //     PrinterManager().printerCommand(value);
          //   });
            receivingsBloc.deleteAll();
            ProductBloc().refreshProduct();
          }
    });
  }

  Future createReceivings(List<CartReceivingsModel> cartReceivings) async {
    // GlobalFunctions.dismisLoading();
    receivingsBloc
        .requestSaveReceivings(cartReceivings, trxCode)
        .then((value) async {
      await PrinterServiceCustom.printReceivings(cartReceivings, totalBelanja, trxCode);
      // await PrinterManager()
      //     .printReceivingsStruct(
      //         cartReceivings, totalBelanja, customerMoney, kembalian, trxCode)
      //     .then((value) {
      //   PrinterManager().printerCommand(value);
      // });
      receivingsBloc.deleteAll();
      ProductBloc().refreshProduct();
    });
  }

  void initProductReceivings() async {
    listProduct = await receivingsBloc.futureProductReceivings(typePrice: typePrice);
    print("listProduct ${listProduct.length}");
  }

  searchProductScan() {
    print("searchProductScan");
    FocusScope.of(context).requestFocus(scanFocusNode);
  }

  void showDialogFindUnit(List<PriceList> priceList, BuildContext context) {
    print("showFindUnit ${jsonEncode(productSelectedInput)}");
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext c) {
          return DialogFindUnits(priceList);
        }).then((value) {
      setState(() {
        if (value != null) {
          PriceList unitPrice = value;
          var cart = CartReceivingsModel(
              id: productSelectedInput.id,
              name: productSelectedInput.name,
              code: productSelectedInput.code,
              barcode: productSelectedInput.barcode,
              description: productSelectedInput.description,
              unitId: unitPrice.unitList!.id,
              originalPrice: double.parse(unitPrice.salePrice!),
              salePrice: double.parse(unitPrice.salePrice!),
              unitName: unitPrice.unitList!.name,
              qty: 1,
              total: unitPrice.salePrice??"0");
          print("productSelectedInput ${jsonEncode(cart)}");
          receivingsBloc.addCartReceivings(cart);
          // receivingsBloc.addProduct(productSelectedInput);
        } else {
          FocusScope.of(context).requestFocus(scanFocusNode);
        }
      });
    });
  }

  void addProductToCart(PriceList unitPrice) {
    var cart = CartReceivingsModel(
        id: productSelectedInput.id,
        name: productSelectedInput.name,
        code: productSelectedInput.code,
        barcode: productSelectedInput.barcode,
        description: productSelectedInput.description,
        unitId: unitPrice.unitList!.id,
        originalPrice: double.parse(unitPrice.salePrice??"0"),
        salePrice: double.parse(unitPrice.salePrice??"0"),
        unitName: unitPrice.unitList!.name,
        qty: 1,
        total: unitPrice.salePrice??"0");
    setState(() {
      receivingsBloc.addCartReceivings(cart);
      print("_cartReceivings ${jsonEncode(_cartReceivings)}");
    });
  }

  void showDialogFindProduct(BuildContext context) {
    print("productSelectedInput 1 ${productSelectedInput.toJson()}");
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext c) {
          return DialogFindProductReceivings(listProduct, typePrice);
        }).then((value) {
      if (value != null) {
        setState(() {
          productSelectedInput = value;
          showDialogFindUnit(productSelectedInput.priceList!, context);
        });
      } else {
        FocusScope.of(context).requestFocus(scanFocusNode);
      }
    });
  }

  void onSearchTransactionPO(String value, BuildContext dialogContext) {
    receivingsBloc.searchTransactionPO(value).then((value) {
      receivingsBloc.deleteAll();
      List<CartReceivingsModel> listCart = value;
      for (CartReceivingsModel cart in listCart) {
        cart.isFromPO = true;
        receivingsBloc.addCartReceivings(cart);
      }
    });
  }

  dialogSaveConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return Dialog(
          child: Container(
            width: SizeConfig.screenWidth * 0.7,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Konfirmasi Penerimaan?",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 10),
                  child: Text("Pastikan penerimaan anda sudah benar"),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (_cartReceivings.length > 0) {
                            print(
                                "createReceivings ${jsonEncode(_cartReceivings)}");
                            cartStruct.clear();
                            cartStruct.addAll(_cartReceivings);
                            createReceivings(cartStruct)
                                .then((value) => Navigator.pop(ctx));
                          }
                        });
                      },
                      child: Text(
                        "Simpan",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.lightBlue,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                      },
                      child: Text(
                        "Batal",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(primary: Colors.lightBlue),
                    )
                  ],
                )
              ],
            ),
          ),
        );
        // return AlertDialog(
        //   content: Column(
        //     mainAxisSize: MainAxisSize.min,
        //     children: [
        //       Text(
        //         "Konfirmasi Penerimaan?",
        //         style: TextStyle(fontWeight: FontWeight.bold),
        //       ),
        //       Padding(
        //         padding: const EdgeInsets.only(top: 8.0, bottom: 10),
        //         child: Text("Pastikan penerimaan anda sudah benar"),
        //       ),
        //       Row(
        //         mainAxisSize: MainAxisSize.max,
        //         mainAxisAlignment: MainAxisAlignment.spaceAround,
        //         children: [
        //           ElevatedButton(
        //             onPressed: () {
        //               setState(() {
        //                 if (_cartReceivings.length > 0) {
        //                   print(
        //                       "createReceivings ${jsonEncode(_cartReceivings)}");
        //                   cartStruct.clear();
        //                   cartStruct.addAll(_cartReceivings);
        //                   createReceivings(cartStruct)
        //                       .then((value) => Navigator.pop(ctx));
        //                 }
        //               });
        //             },
        //             child: Text(
        //               "Simpan",
        //               style: TextStyle(color: Colors.white),
        //             ),
        //             style: ElevatedButton.styleFrom(
        //               primary: Colors.lightBlue,
        //             ),
        //           ),
        //           ElevatedButton(
        //             onPressed: () {
        //               Navigator.pop(ctx);
        //             },
        //             child: Text(
        //               "Batal",
        //               style: TextStyle(color: Colors.white),
        //             ),
        //             style: ElevatedButton.styleFrom(primary: Colors.lightBlue),
        //           )
        //         ],
        //       )
        //     ],
        //   ),
        // );
      },
    );
  }

  Widget dialogViewTotal(BuildContext ctx, FocusNode dialogFocusSave) {
    return Padding(
      padding: EdgeInsets.all(14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Jumlah ${receivingsBloc.totalProduct} Produk"),
                Text("${receivingsBloc.totalQty} Qty"),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 4),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Belanja",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text("${Core.converNumeric(receivingsBloc.total.toString())}"),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Divider(
              height: 1,
              color: Colors.black,
            ),
          ),
          StreamBuilder<double>(
              stream: receivingsBloc.streamTotalBayar,
              builder: (context, snapshot) {
                double totalBayar = 0;
                if (snapshot.hasData) {
                  totalBayar = snapshot.data ?? 0;
                } else {
                  totalBayar = 0;
                }
                return Padding(
                  padding: const EdgeInsets.only(
                      top: 4, left: 8, right: 8, bottom: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Bayar",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text("${Core.converNumeric(totalBayar.toString())}"),
                    ],
                  ),
                );
              }),
          StreamBuilder<String>(
              stream: receivingsBloc.streamKembalian,
              builder: (context, snapshot) {
                kembalian = "0";
                if (snapshot.hasData) {
                  kembalian = "${snapshot.data ?? 0}";
                } else {
                  kembalian = "0";
                }
                return Padding(
                  padding: const EdgeInsets.only(
                      top: 4.0, left: 8, right: 8, bottom: 16),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Kembalian",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text("${Core.converNumeric(kembalian)}"),
                    ],
                  ),
                );
              }),
          TextFormField(
            onChanged: (newInput) {
              receivingsBloc.sumTotalKembalian(
                  receivingsBloc.total, double.parse(newInput));
              customerMoney = double.parse(newInput);
            },
            keyboardType: TextInputType.text,
            autofocus: true,
            style: TextStyle(fontSize: 14, height: 1),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Mohon isi pembayaran terlebih dahulu';
              }
              return null;
            },
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[0-9.,]+')),
            ],
            onFieldSubmitted: (String val) {
              dialogFocusSave.requestFocus();
            },
            decoration: new InputDecoration(
              fillColor: Colors.white,
              filled: true,
              isDense: true,
              prefixIcon: Icon(
                Icons.shopping_cart,
                color: Colors.lightBlue[800],
              ),
              contentPadding: EdgeInsets.fromLTRB(6.0, 18.0, 6.0, 18.0),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 0.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
              ),
              hintText: 'Total Bayar',
            ),
          ),
        ],
      ),
    );
  }

  void dialogSaveConfirmation2() {
    FocusNode dialogSaveFocus = FocusNode();
    showCupertinoDialog(
        context: context,
        builder: (BuildContext ctx) {
          return Dialog(
            child: Container(
              width: SizeConfig.screenWidth * 0.6,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    color: Colors.lightBlue,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Konfirmasi penerimaan barang",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.pop(ctx);
                            },
                            tooltip: "Close",
                            icon: Icon(Icons.close),
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                  dialogViewConfirmation(ctx, dialogSaveFocus),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                        },
                        style: TextButton.styleFrom(shadowColor: Colors.grey),
                        child: Container(
                          width: SizeConfig.blockSizeHorizontal * 12,
                          height: 30,
                          child: Center(
                            child: Text(
                              "Batal",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.lightBlue),
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        focusNode: dialogSaveFocus,
                        onPressed: () {
                          // procesReceivings(ctx);
                          procesReceivingsV2(ctx);

                        },
                        style: ElevatedButton.styleFrom(primary: Colors.lightBlue),
                        child: Container(
                          width: SizeConfig.blockSizeHorizontal * 12,
                          height: 30,
                          child: Center(
                            child: Text(
                              "Simpan",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  )
                ],
              ),
            ),
          );
          // return AlertDialog(
          //   actionsAlignment: MainAxisAlignment.spaceEvenly,
          //   actionsPadding: EdgeInsets.zero,
          //   contentPadding: EdgeInsets.zero,
          //   titlePadding: EdgeInsets.zero,
          //   title: Column(
          //     mainAxisSize: MainAxisSize.min,
          //     children: [
          //       Container(
          //         color: Colors.lightBlue,
          //         child: Padding(
          //           padding: const EdgeInsets.all(12.0),
          //           child: Row(
          //             mainAxisSize: MainAxisSize.max,
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             children: [
          //               Text(
          //                 "Konfirmasi penerimaan barang",
          //                 style: TextStyle(
          //                     fontSize: 14,
          //                     fontWeight: FontWeight.bold,
          //                     color: Colors.white),
          //               ),
          //               IconButton(
          //                 onPressed: () {
          //                   Navigator.pop(ctx);
          //                 },
          //                 tooltip: "Close",
          //                 icon: Icon(Icons.close),
          //                 color: Colors.white,
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          //   content: dialogViewConfirmation(ctx, dialogSaveFocus),
          //   actions: [
          //     TextButton(
          //       onPressed: () {
          //         Navigator.pop(ctx);
          //       },
          //       style: TextButton.styleFrom(shadowColor: Colors.grey),
          //       child: Container(
          //         width: SizeConfig.blockSizeHorizontal * 12,
          //         height: 30,
          //         child: Center(
          //           child: Text(
          //             "Batal",
          //             textAlign: TextAlign.center,
          //             style: TextStyle(color: Colors.lightBlue),
          //           ),
          //         ),
          //       ),
          //     ),
          //     ElevatedButton(
          //       focusNode: dialogSaveFocus,
          //       onPressed: () {
          //         // procesReceivings(ctx);
          //         procesReceivingsV2(ctx);
          //
          //       },
          //       style: ElevatedButton.styleFrom(primary: Colors.lightBlue),
          //       child: Container(
          //         width: SizeConfig.blockSizeHorizontal * 12,
          //         height: 30,
          //         child: Center(
          //           child: Text(
          //             "Simpan",
          //             textAlign: TextAlign.center,
          //             style: TextStyle(color: Colors.white),
          //           ),
          //         ),
          //       ),
          //     ),
          //   ],
          // );
        });
  }

  dialogInputNominal() {
    var _formKey = GlobalKey<FormState>();
    customerMoney = 0;
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(16),
            titlePadding: EdgeInsets.zero,
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
                          "Masukan Pembayaran",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                          },
                          tooltip: "Close",
                          icon: Icon(Icons.close),
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            content: Container(
                width: SizeConfig.screenWidth * 0.2,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Form(
                      key: _formKey,
                      child: TextFormField(
                        onChanged: (newInput) {
                          customerMoney = double.parse(newInput);
                        },
                        keyboardType: TextInputType.number,
                        autofocus: true,
                        style: TextStyle(fontSize: 14, height: 1),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Mohon isi pembayaran terlebih dahulu';
                          }
                          return null;
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp('[0-9.,]+')),
                        ],
                        decoration: new InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          isDense: true,
                          prefixIcon: Icon(
                            Icons.shopping_cart,
                            color: Colors.lightBlue[800],
                          ),
                          contentPadding:
                              EdgeInsets.fromLTRB(6.0, 18.0, 6.0, 18.0),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 0.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0),
                          ),
                          hintText: 'Total Pembayaran',
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 12),
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (customerMoney < totalBelanja) {
                            double minus = totalBelanja - customerMoney;
                            GlobalFunctions.showSnackBarWarning(
                                "Uang Customer Kurang ${Core.converNumeric("$minus")}");
                          } else {
                            Navigator.pop(ctx);
                            print(
                                "createReceivings ${jsonEncode(_cartReceivings)}");
                            cartStruct.clear();
                            cartStruct.addAll(_cartReceivings);
                            createReceivings(cartStruct);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: GlobalColorPalette.colorButtonActive,
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(4.0),
                          ),
                        ),
                        child: Text(
                          'Simpan Penerimaan',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                )),
          );
        });
  }

  Widget dialogViewConfirmation(BuildContext ctx, FocusNode dialogSaveFocus) {
    return Container(
      width: SizeConfig.blockSizeHorizontal * 30,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Pastikan produk yang diterima sudah sesuai, simpan penerimaan produk?",
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void procesReceivings(BuildContext ctx) {
    print("customer money $customerMoney price $totalBelanja");
    if (customerMoney < totalBelanja) {
      double minus = totalBelanja - customerMoney;
      GlobalFunctions.showSnackBarWarning(
          "Uang Customer Kurang ${Core.converNumeric("$minus")}");
    } else {
      Navigator.pop(ctx);
      print("createReceivings ${jsonEncode(_cartReceivings)}");
      cartStruct.clear();
      cartStruct.addAll(_cartReceivings);
      createReceivingsV2(cartStruct);
    }
  }
  void procesReceivingsV2(BuildContext ctx) {
    Navigator.pop(ctx);
    print("createReceivings ${jsonEncode(_cartReceivings)}");
    cartStruct.clear();
    cartStruct.addAll(_cartReceivings);
    createReceivingsV2(cartStruct);
  }
}

class ScanIntent extends Intent {}

class DialogProductIntent extends Intent {}
