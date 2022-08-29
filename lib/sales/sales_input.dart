import 'dart:convert';
import 'package:beben_pos_desktop/core/core.dart';
import 'package:beben_pos_desktop/core/fireship/fireship_box.dart';
import 'package:beben_pos_desktop/core/util/core_function.dart';
import 'package:beben_pos_desktop/db/product_db.dart';
import 'package:beben_pos_desktop/db/product_model_db.dart';
import 'package:beben_pos_desktop/db/profile_db.dart';
import 'package:beben_pos_desktop/model/head_column_model.dart';
import 'package:beben_pos_desktop/product/bloc/product_bloc.dart';
import 'package:beben_pos_desktop/profile/bloc/profile_bloc.dart';
import 'package:beben_pos_desktop/sales/bloc/sales_bloc.dart';
import 'package:beben_pos_desktop/sales/daily_sales_screen.dart';
import 'package:beben_pos_desktop/sales/model/payment_method.dart';
import 'package:beben_pos_desktop/sales/model/sales_model.dart';
import 'package:beben_pos_desktop/sales/model/tax.dart';
import 'package:beben_pos_desktop/sales/widget/dialog_find_customer.dart';
import 'package:beben_pos_desktop/sales/widget/dialog_find_product.dart';
import 'package:beben_pos_desktop/sales/widget/dialog_list_transaction.dart';
import 'package:beben_pos_desktop/sales/widget/dialog_payment_method.dart';
import 'package:beben_pos_desktop/sales/widget/dialog_transaction.dart';
import 'package:beben_pos_desktop/sales/widget/pdf_sales.dart';
import 'package:beben_pos_desktop/service/dio_service.dart';
import 'package:beben_pos_desktop/utils/global_functions.dart';
import 'package:beben_pos_desktop/utils/printerservice/printer_service_custom.dart';
import 'package:beben_pos_desktop/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'dart:async';

import 'package:nav_router/nav_router.dart';

class SalesInput extends StatefulWidget {
  static final _formKey = new GlobalKey<FormState>();

  const SalesInput({Key? key}) : super(key: key);

  @override
  _SalesInputState createState() => _SalesInputState();
}

class _SalesInputState extends State<SalesInput> {
  final _formKey = GlobalKey<FormState>();
  late Box box = Hive.box(FireshipBox.BOX_PRODUCT);
  List<SalesModel> selectedSalesModels = [];
  bool sort = false;
  SalesBloc salesBloc = SalesBloc();
  ProductBloc productBloc = ProductBloc();
  TextEditingController qtyEditingController = TextEditingController();
  double totalTransactionPrice = 0;
  ProfileBloc _profileBloc = ProfileBloc();
  String salesScreen = "sales_input";
  String merchantName = "";

  List<String> _registerMode = ["Sales Receipt", "Quote", "Invoice", "Return"];
  String selectedRegisterMode = "Sales Receipt";
  String selectedPaymentTypes = "Cash";

  List<HeadColumnModel> _checkboxModel = [
    HeadColumnModel(key: "1", name: "Deleted", ischecked: false),
    HeadColumnModel(key: "2", name: "Item", ischecked: false),
    HeadColumnModel(key: "3", name: "Item Name", ischecked: false),
    HeadColumnModel(key: "4", name: "Satuan", ischecked: false),
    HeadColumnModel(key: "5", name: "Price", ischecked: false),
    HeadColumnModel(key: "6", name: "Quantity", ischecked: false),
    HeadColumnModel(key: "7", name: "Total", ischecked: false),
  ];

  List<String> listTransactionType = ["Penjualan", "Return"];
  String selectedTransactionType = "Penjualan";

  List<String> listPriceTransaction = ["Retail", "E-Commerce", "Agen"];

  //0 Retail, 1 Agen, 2 E-Commerce
  String selectedPriceTransaction = "Retail";

  List<ProductModel> allProducts = [];
  ProductModel productModel = new ProductModel();
  PdfSales pdfSales = PdfSales();
  int _currentSortColumn = 0;
  bool _isAscending = true;

  TextEditingController scanController = TextEditingController();
  FocusNode scanFocusNode = FocusNode();
  FocusNode saveFocusNode = FocusNode();

  String kembalian = "0";
  double customerMoney = 0;

  ProfileDB profile = ProfileDB();

  TextEditingController trxCodeController = TextEditingController();
  FocusNode trxCodeFocus = FocusNode();

  bool isEnabledTrxCode = false;

  Widget layoutTransactionType(context) => Card(
    color: Colors.grey[300],
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            "Tipe Transaksi : ",
            style: TextStyle(fontSize: 14),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Radio<String>(
                  value: listTransactionType[0],
                  groupValue: selectedTransactionType,
                  onChanged: (String? value) {
                    onChangeRadioTypeTransaction(
                        value ?? listTransactionType[0]);
                  },
                ),
                Text(listTransactionType[0]),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Radio<String>(
                    value: listTransactionType[1],
                    groupValue: selectedTransactionType,
                    onChanged: (String? value) {
                      setState(() {
                        onChangeRadioTypeTransaction(
                            value ?? listTransactionType[1]);
                      });
                    }),
                Text(listTransactionType[1]),
                Container(
                    margin: EdgeInsets.only(left: 8),
                    width: MediaQuery.of(context).size.width * 0.20,
                    child: TextFormField(
                      enabled: isEnabledTrxCode,
                      autofocus: true,
                      style: TextStyle(fontSize: 12, height: 1),
                      focusNode: trxCodeFocus,
                      controller: trxCodeController,
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).unfocus();
                        FocusScope.of(context).requestFocus(scanFocusNode);
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
                        hintText: 'Kode Transaksi',
                      ),
                    ))
              ],
            ),
          ),
        ],
      ),
    ),
  );

  onChangeRadioTypePrice(String value) {
    setState(() {
      FocusScope.of(context).requestFocus(scanFocusNode);
      selectedPriceTransaction = value;
      GlobalFunctions.log('Type Transaction', selectedPriceTransaction);
    });
  }

  onChangeRadioTypeTransaction(String value) {
    if (value == listTransactionType[1]) {
      isEnabledTrxCode = true;
      FocusScope.of(context).unfocus();
      FocusScope.of(context).requestFocus(trxCodeFocus);
      selectedTransactionType = value;
    } else {
      isEnabledTrxCode = false;
      trxCodeController.text = "";
      FocusScope.of(context).unfocus();
      FocusScope.of(context).requestFocus(scanFocusNode);
      selectedTransactionType = value;
    }
  }

  void saveTransaction(PaymentMethod paymentMethod) async {
    DioService.dialogLoading();
    bool isConnect = await GlobalFunctions.checkConnectivityApp();
    for (int i = 0; i < 1; i++) {
      print("saveTransaction ${i + 1}");
      if (isConnect) {
        await requestOnlineTransaction(paymentMethod);
      } else {
        await requestOfflineTransaction();
      }
    }
    Navigator.pop(navGK.currentContext!);
    await salesBloc.deleteAll();
  }

  Widget layoutPriceTransaction(context) => Card(
        color: Colors.grey[300],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                "Harga Untuk : ",
                style: TextStyle(fontSize: 14),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Radio<String>(
                      value: listPriceTransaction[0],
                      groupValue: selectedPriceTransaction,
                      onChanged: (String? value) {
                        onChangeRadioTypePrice(
                            value ?? listPriceTransaction[0]);
                      },
                    ),
                    Text(listPriceTransaction[0]),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Radio<String>(
                      value: listPriceTransaction[1],
                      groupValue: selectedPriceTransaction,
                      onChanged: (String? value) {
                        onChangeRadioTypePrice(
                            value ?? listPriceTransaction[1]);
                      },
                    ),
                    Text(listPriceTransaction[1]),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Radio<String>(
                      value: listPriceTransaction[2],
                      groupValue: selectedPriceTransaction,
                      onChanged: (String? value) {
                        onChangeRadioTypePrice(
                            value ?? listPriceTransaction[2]);
                      },
                    ),
                    Text(listPriceTransaction[2]),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Widget _findOrScanItem() => Card(
        key: _formKey,
        color: Colors.grey[500],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _newScanProduct(),
                )
              ],
            ),
          ),
        ),
      );

  Widget _spacer() => SizedBox(height: 8);

  Widget _selectCustomer() => Container(
    child: Card(
      color: Colors.grey[500],
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder(
              stream: salesBloc.streamSumTotalQty,
              builder: (context, AsyncSnapshot<double> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data! > 0) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        StreamBuilder(
                            stream: salesBloc.streamSumTotalProduct,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Expanded(
                                    child: Text(
                                        "Jumlah ${snapshot.data} Produk"));
                              } else {
                                return Text("Kosong");
                              }
                            }),
                        Expanded(
                            child: Align(
                                alignment: Alignment.centerRight,
                                child: Text("${snapshot.data}")))
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
            _spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: StreamBuilder<Tax>(
                    stream: salesBloc.streamTaxValue,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text("PPN (${snapshot.data?.value})%");
                      } else {
                        return Container();
                      }
                    },
                  )
                ),
                Expanded(
                  child: StreamBuilder(
                  stream: salesBloc.streamTax,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      String tax = Core.converNumeric("${Core.convertToDouble("${snapshot.data ?? "0"}")}");
                      return Align(
                        alignment: Alignment.centerRight,
                        child: Text(tax)
                      );
                    } else {
                      return Align(
                        alignment: Alignment.centerRight,
                        child: Text(Core.converNumeric("0"))
                      );
                    }
                  },
                ))
              ],
            ),
            _spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(child: Text("Subtotal")),
                Expanded(
                  child: StreamBuilder(
                  stream: salesBloc.streamSumSubTotal,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      String subtotal = Core.converNumeric(
                          "${Core.convertToDouble("${snapshot.data ?? "0"}")}");
                      return Align(
                          alignment: Alignment.centerRight,
                          child: Text(subtotal));
                    } else {
                      return Align(
                          alignment: Alignment.centerRight,
                          child: Text(Core.converNumeric("0")));
                    }
                  },
                ))
              ],
            ),
            _spacer(),
            Divider(
              height: 1,
              color: Colors.black,
            ),
            _spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                    child: Text(
                  "Total",
                  style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                )),
                Expanded(
                    child: StreamBuilder(
                        stream: salesBloc.streamSumTotalPayment,
                        builder: (context, AsyncSnapshot<double> snapshot) {
                          if (snapshot.hasData) {
                            totalTransactionPrice = snapshot.data!;
                            return Align(
                                alignment: Alignment.centerRight,
                                child: Text(Core.converNumeric(
                                    "${Core.convertToDouble("$totalTransactionPrice")}")));
                          } else {
                            return Align(
                                alignment: Alignment.centerRight,
                                child: Text(Core.converNumeric("0")));
                          }
                        }))
              ],
            ),
            _spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                StreamBuilder(
                  stream: salesBloc.streamListProductModel,
                  builder: (context, AsyncSnapshot<List<ProductModel>> snapshot) {
                    return ElevatedButton.icon(
                      focusNode: saveFocusNode,
                      icon: Icon(
                        Icons.perm_contact_calendar_rounded,
                        color: Colors.white,
                        size: 18.0,
                      ),
                      label: Text(
                        selectedTransactionType == "Return"
                            ? 'Return Transaksi'
                            : 'Proses Transaksi',
                        style: TextStyle(fontSize: 12),
                      ),
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        allProducts.clear();
                        allProducts = [];
                        allProducts.addAll(snapshot.data!);
                        GlobalFunctions.log('sales_input', ': ${allProducts.length}');
                        if (selectedTransactionType == "Return") {
                          if (trxCodeController.text.isNotEmpty) {
                            if (allProducts.length > 0) {
                              dialogSaveReturn();
                            } else {
                              GlobalFunctions.showSnackBarWarning(
                                  "Masukan Produk untuk return transaksi");
                            }
                          } else {
                            GlobalFunctions.showSnackBarWarning(
                                "Masukan kode transaksi untuk return transaksi");
                          }
                        } else {
                          if (allProducts.length > 0){
                            dialogSaveConfirmation2();
                          } else {
                            GlobalFunctions.showSnackBarWarning(
                                "Masukan Produk untuk transaksi");
                          }
                        }
                        // showDialog(
                        //     context: context,
                        //     barrierDismissible: true,
                        //     builder: (BuildContext c) {
                        //       return DialogSaveTransaction("", salesBloc, totalTransactionPrice);
                        //     });
                        // BotToast.showLoading();
                        // GlobalFunctions.showLoading(context);
                        // await SalesBloc().requestMerchantTransaction();
                        // salesBloc.deleteAll();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.lightBlue,
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(2.0),
                        ),
                      ),
                    );
                  }
                ),
              ],
            ),
            // Container(
            //   height: SizeConfig.screenHeight * 0.5,
            //   child: StreamBuilder(
            //     stream: salesBloc.streamTransactionList,
            //     builder: (context, AsyncSnapshot<List<TransactionFailedDB>> snapshot) {
            //       if (snapshot.hasData){
            //         print('load view transaction List');
            //         return ListView.builder(
            //             shrinkWrap: true, //Optional
            //             itemCount: snapshot.data!.length,
            //             itemBuilder: (context, int index){
            //               return Card(
            //                 child: Padding(
            //                   padding: const EdgeInsets.all(12.0),
            //                   child: Column(
            //                     mainAxisSize: MainAxisSize.max,
            //                     mainAxisAlignment: MainAxisAlignment.start,
            //                     crossAxisAlignment: CrossAxisAlignment.start,
            //                     children: [
            //                       Text('Transaksi : ${snapshot.data![index].date}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
            //                       ListView.builder(
            //                           shrinkWrap: true,
            //                           physics: NeverScrollableScrollPhysics(),
            //                           itemCount: snapshot.data![index].productList!.length,
            //                           itemBuilder: (context, int indexProduct){
            //                         return InkWell(
            //                           onTap: () {
            //                             for (final data in snapshot.data![index].productList!){
            //                               print('add to product -> ${snapshot.data![index].productList!.length}');
            //                               print('add to product qty -> ${snapshot.data![index].productList![indexProduct].quantity}');
            //                               MerchantProduct merchantProduct = MerchantProduct(
            //                                   id: data.productId,
            //                                   name: data.itemName,
            //                                   barcode: data.item,
            //                                   currentPrice: data.price.toString(),
            //                                   salePrice: data.price.toString(),
            //                                   qty: data.quantity.toString()
            //                               );
            //                               salesBloc.addProduct(merchantProduct);
            //                             }
            //                           },
            //                           child: Row(
            //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                             mainAxisSize: MainAxisSize.min,
            //                             children: [
            //                               Text('(${snapshot.data![index].productList![indexProduct].item}) ${snapshot.data![index].productList![indexProduct].itemName} '
            //                                   'x ${snapshot.data![index].productList![indexProduct].quantity}',
            //                                 style: TextStyle(fontSize: 10)),
            //                               Text('${snapshot.data![index].productList![indexProduct].total}',
            //                                 style: TextStyle(fontSize: 10)),
            //                               Center(
            //                                 child: IconButton(
            //                                   icon: const Icon(Icons.send),
            //                                   color: Colors.lightBlue,
            //                                   onPressed: () {
            //                                     salesBloc.deleteTransactionAndProductTransaction(index, snapshot.data![index].productList![indexProduct].idTransaction!);
            //                                   },
            //                                 ),
            //                               ),
            //                             ],
            //                           ),
            //                         );
            //                       })
            //                     ],
            //                   ),
            //                 ),
            //               );
            //             });
            //       } else {
            //         return Text('Kosong');
            //       }
            //     }
            //   ),
            // )
          ],
        ),
      ),
    ),
  );

  @override
  void initState() {
    // TODO: implement initState
    _profileBloc.getProfile().then((value) {
      profile = value;
      merchantName = profile.merchantName ?? "";
      GlobalFunctions.log('SalesInput', '${profile.merchantName}');
    });
    sort = false;
    salesBloc.init();
    // qtyEditingController.addListener(() {
    //   print(qtyEditingController.text);
    // });
    super.initState();
  }

  void dialogSaveConfirmation2() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext c) {
        return DialogFindCustomer();
      }).then((user) {
        if (user != null) {
          showCupertinoDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext ctx) {
              return DialogPaymentMethod(
                listPayment: salesBloc.listPayment,
              );
            }).then((value) {
            FocusScope.of(context).requestFocus(scanFocusNode);
            if(value != null) {
              showCupertinoDialog(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext ctx) {
                  return Dialog(
                    backgroundColor: Colors.lightBlue,
                    child: DialogTransaction(
                      paymentMethod: value,
                      totalAmount: salesBloc.totalBelanja,
                      totalProduct: salesBloc.totalProduct,
                      totalQuantity: salesBloc.totalQty,
                      totalTax: salesBloc.totalTax,
                      subTotal: salesBloc.subtotal,
                    )
                  );
                }).then((value) {
                  if(value != null) {
                    value as PaymentMethod;
                    value.endUser = user;
                    FocusScope.of(context).requestFocus(scanFocusNode);
                    saveTransaction(value);
                  }
              });
            }
          });
        }
    });
  }

  void dialogSaveReturn() {
    FocusNode dialogSaveFocus = FocusNode();
    customerMoney = 0;
    salesBloc.sumTotalKembalian(salesBloc.totalBelanja, customerMoney);
    showCupertinoDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext ctx) {
          return Dialog(
            child: Container(
              width: SizeConfig.screenWidth * 0.4,
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
                            "Konfirmasi Return",
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
                  dialogViewReturnConfirmation(),
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
                        onPressed: () async {
                          saveReturn(ctx);
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
          //                 "Konfirmasi Return",
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
          //   content: dialogViewReturnConfirmation(),
          //   actions: [
          //
          //   ],
          // );
        }).then((value) {
      FocusScope.of(context).requestFocus(scanFocusNode);
    });
  }

  void updateView(String nameContainer) {
    setState(() => salesScreen = nameContainer);
  }

  void refresh(String nameContainer) {
    setState(() {
      if (nameContainer == "sales_input")
        salesScreen = "sales_input";
      else
        salesScreen = "daily_sales";
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    salesBloc.close();
    super.dispose();
  }

  FocusNode _keyboardFocus = FocusNode();

  searchProductScan() {
    print("searchProductScan");
    FocusScope.of(context).requestFocus(scanFocusNode);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    if (salesScreen == "sales_input") {
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
                          child: Container(
                              child: Column(
                            children: [
                              // Container(child: getDataProducts(),),
                              Container(child: layoutTransactionType(context)),
                              selectedTransactionType == "Penjualan"
                                  ? Container(
                                      child: layoutPriceTransaction(context))
                                  : Container(),
                              Container(child: _findOrScanItem()),
                              Container(
                                child: productPaginateData(context),
                              )
                            ],
                          ))),
                      Expanded(
                          flex: 1,
                          child: Container(
                              child: Column(
                            children: [
                              _selectCustomer(),
                            ],
                          )))
                    ],
                  ),
                )
              ],
            ),
          ));
    } else {
      return DailySalesScreen();
    }
  }

  Widget productPaginateData(context) => Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.45,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: StreamBuilder(
              stream: salesBloc.streamListProductModel,
              builder: (context, AsyncSnapshot<List<ProductModel>> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data?.length == 0)
                    return layoutEmptyDataTable();
                  else
                    allProducts.clear();
                  allProducts = <ProductModel>[];
                  allProducts.addAll(snapshot.data!);
                  GlobalFunctions.log('sales_input', 'adding data product from stream : ${allProducts.length}');
                  return DataTable(
                    sortColumnIndex: _currentSortColumn,
                    sortAscending: _isAscending,
                    columnSpacing: 0,
                    horizontalMargin: 0,
                    showCheckboxColumn: false,
                    columns: <DataColumn>[
                      for (final header in _checkboxModel)
                        DataColumn(
                            label: Expanded(
                              child: Text(
                                header.name!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ),
                            tooltip: header.name,
                            onSort: (columnIndex, _sortAscending) {
                              setState(() {
                                _currentSortColumn = columnIndex;
                                // if(_currentSortColumn == 0){
                                //   _sortId();
                                // }else if(_currentSortColumn == 1){
                                //   _sortFirstName();
                                // }else if(_currentSortColumn == 2){
                                //   _sortLastName();
                                // }else if(_currentSortColumn == 3){
                                //   _sortEmail();
                                // }else if(_currentSortColumn == 4){
                                //   _sortPhoneNumber();
                                // }else if(_currentSortColumn == 5){
                                //   _sortTotalSpent();
                                // }
                              });
                            }),
                    ],
                    rows: <DataRow>[
                      for (int i = 0; i < allProducts.length; i++)
                        getDataRowIndex(i, allProducts, context)
                    ],
                  );
                } else {
                  return Text("Data kosong");
                }
              }),
        ),
      );

  DataRow getDataRowIndex(int index, List<ProductModel> list, ctx) {
    // TextEditingController _priceController = TextEditingController();
    // TextEditingController _qtyController = TextEditingController();
    // _priceController.text = list[index].price.toString();
    // _qtyController.text = list[index].qty.toString();
    ProductModel row = list[index];
    return DataRow.byIndex(index: index, cells: [
      DataCell(Center(
        child: IconButton(
          tooltip: "Delete Item",
          icon: Icon(Icons.delete),
          iconSize: 16,
          color: Colors.red,
          onPressed: () {
            salesBloc.deleteProduct(index);
          },
        ),
      )),
      DataCell(Center(
        child: Text(
          row.item ?? "-",
          style: TextStyle(fontSize: 12),
        ),
      )),
      DataCell(Center(
        child: Text(
          row.itemName ?? "-",
          style: TextStyle(fontSize: 12),
        ),
      )),
      DataCell(Center(
        child: Text(
          row.unitName ?? "-",
          style: TextStyle(fontSize: 12),
        ),
      )),
      DataCell(Center(
        child: Text(
          '${Core.converNumeric("${Core.convertToDouble("${row.price ?? "0"}")}")}',
          style: TextStyle(fontSize: 12),
        ),
      )),
      DataCell(
        Center(
          child: Container(
            width: MediaQuery.of(ctx).size.width * 0.07,
            child: Center(
              child: TextFormField(
                key: Key(row.quantity.toString()),
                focusNode: row.focusQty,
                style: TextStyle(fontSize: 12, height: 1),
                initialValue: "${Core.convertToDouble("${row.quantity ?? 0}")}",
                onChanged: (String _editQuantity) {
                  CoreFunction.debouncer.debounce(() {       
                    if (_editQuantity.isEmpty){
                      salesBloc.updateItem(index, row, double.parse("0"));
                      salesBloc.updateItemTotalPrice(
                          index, row, double.parse("0"), row.price ?? 0);
                    } else {
                      salesBloc.updateItem(index, row, double.parse(_editQuantity));
                      salesBloc.updateItemTotalPrice(
                          index, row, double.parse(_editQuantity), row.price ?? 0);
                    }
                  });
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
        ),
      ),
      DataCell(
        Center(
          child: StreamBuilder<List<double>>(
              stream: salesBloc.streamTotalPrice,
              builder: (context, snapshot) {
                double totalPrice = 0;
                if (snapshot.hasData) {
                  totalPrice = snapshot.data![index];
                }
                return Text(
                  "${Core.converNumeric("${Core.convertToDouble("$totalPrice")}")}",
                  style: TextStyle(fontSize: 12),
                );
              }),
        ),
      ),
      // DataCell(Center(
      //   child: IconButton(
      //     autofocus: false,
      //     tooltip: "Update Item",
      //     icon: Icon(Icons.update),
      //     iconSize: 16,
      //     color: Colors.blue,
      //     onPressed: () {},
      //   ),
      // )),
      // DataCell(IconButton(
      //   autofocus: false,
      //   iconSize: MediaQuery.of(ctx).size.width * 0.018,
      //   color: Colors.blue,
      //   onPressed: () {
      //     setState(() {
      //       // list.removeAt(index);
      //       receivingsBloc.deleteProduct(index);
      //       // print("DELETE RECEIVINGS $index");
      //     });
      //   },
      //   icon: Icon(Icons.delete_outline_sharp),
      // )),
    ]);
  }

  Widget layoutEmptyDataTable() {
    return Card(
      color: Colors.lightBlueAccent,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
            child: Text(
          "Tidak produk di keranjang",
          style: TextStyle(color: Colors.white),
        )),
      ),
    );
  }

  Widget _oldScanProduct() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "Produk",
              style: TextStyle(fontSize: 12),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 0),
              child: Container(
                width: SizeConfig.screenWidth * 0.2,
                child: GestureDetector(
                  child: InputDecorator(
                    decoration: new InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        isDense: true,
                        contentPadding: EdgeInsets.all(14),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        prefixText: 'Pilih Produk',
                        prefixStyle: TextStyle(fontSize: 12)),
                  ),
                  onTap: () {
                    showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (BuildContext c) {
                          return DialogFindProduct(
                              salesBloc.addProduct, selectedPriceTransaction);
                        });
                  },
                ),
              ),
            ),
          ],
        ),
        Row(children: [
          ElevatedButton.icon(
            icon: Icon(
              Icons.shopping_cart,
              color: Colors.white,
              size: 18.0,
            ),
            label: Text(
              'Sinkronkan Transaksi',
              style: TextStyle(fontSize: 12),
            ),
            onPressed: () async {
              showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext c) {
                    return DialogListTransaction(salesBloc.deleteAll);
                  });
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.lightBlue,
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(2.0),
              ),
            ),
          ),
        ])
      ],
    );
  }

  Widget _newScanProduct() {
    return Row(
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
                autofocus: true,
                readOnly: false,
                style: TextStyle(fontSize: 12, height: 1),
                focusNode: scanFocusNode,
                controller: scanController,
                textInputAction: TextInputAction.search,
                onChanged: (code) {
                  print("code $code");
                },
                onFieldSubmitted: (value) {
                  onSearchChange(value);
                  scanController.text = "";
                  FocusScope.of(context).requestFocus(scanFocusNode);
                },
                onTap: () {
                  showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext c) {
                        return DialogFindProduct(
                            salesBloc.addProduct, selectedPriceTransaction);
                      }).then((value) {
                    scanController.text = "";
                    scanFocusNode.requestFocus();
                  });
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
                  hintText: 'Cari Produk',
                ),
              ),
            ),
          ],
        ),
        ElevatedButton.icon(
          icon: Icon(
            Icons.shopping_cart,
            color: Colors.white,
            size: 18.0,
          ),
          label: Text(
            'Sinkronkan Transaksi',
            style: TextStyle(fontSize: 12),
          ),
          onPressed: () async {
            showDialog(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext c) {
                  return DialogListTransaction(salesBloc.deleteAll);
                });
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.lightBlue,
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(2.0),
            ),
          ),
        ),
      ],
    );
  }

  onSearchChange(String query) {
    salesBloc
        .findProductBarcodeV2(context, query)
        .then((ProductModelDB value) {
          print("ProductModelDB ${jsonEncode(value)}");
      if (value.id == null) {
        GlobalFunctions.showSnackBarWarning("Produk tidak ditemukan");
        return;
      }
      salesBloc.addProductV2(value);
    });
    // if (_debouncer?.isActive ?? false) _debouncer?.cancel();
    // _debouncer = Timer(const Duration(milliseconds: 1000), () {
    //   print('on progress');
    //   setState(() {
    //     canSearch = true;
    //     searchText = query;
    //   });
    // });
  }

  void saveReturn(ctx) async {
    Navigator.pop(ctx);
    await salesBloc
        .requestReturnTransaction(trxCodeController.text)
        .then((value) {
    });
    await salesBloc.deleteAll();
  }

  Future requestOfflineTransaction() async {
    await salesBloc
        .addTransactionFailed(
            totalTransactionPrice, customerMoney, profile.merchantId ?? 0, selectedPriceTransaction)
        .then((value) {
      salesBloc.deleteAll();
      PrinterServiceCustom.printSales(allProducts, totalTransactionPrice, customerMoney, kembalian, "", merchantName);
      // productBloc.refreshProduct();
    });
  }

  Future requestOnlineTransaction(PaymentMethod paymentMethod) async {
    await salesBloc.requestMerchantTransaction(totalTransactionPrice, customerMoney, profile.merchantId ?? 0, selectedPriceTransaction, paymentMethod).then((value) {
        if (value.status!) {
          GlobalFunctions.log('sales_input','status Transaction : ${value.status}');
          GlobalFunctions.log('sales_input','status Transaction code : ${value.transactionCode}');
          GlobalFunctions.log('sales_input','status Request code : ${value.responseCode}');
          if (value.responseCode == '402'){
            // GlobalFunctions.showSnackBarError('Mohon di check kembali stok produk anda');
          } else {
            salesBloc.deleteAll();
            PrinterServiceCustom.printSales(allProducts, totalTransactionPrice, customerMoney, kembalian, value.transactionCode ?? "", merchantName).then((value){
              allProducts = <ProductModel>[];
            });
          }
        }
      },
    );
  }

  Widget dialogViewReturnConfirmation() => Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Text(
          "Apakah anda yakin ingin Return Produk pada transaksi ${trxCodeController.text} ?",
          textAlign: TextAlign.center,
        ),
      );

// openFilePdf(File file) {
//   print('file directory --> ${file.path}');
//   return showDialog(
//     barrierDismissible: false,
//     context: context,
//     builder: (BuildContext context) {
//       return Container(
//           padding: const EdgeInsets.all(16.0),
//           width: 400,
//           color: Colors.red,
//           height: 400,
//           child: SfPdfViewer.file(file)
//       );
//     },
//   );
// }
}
