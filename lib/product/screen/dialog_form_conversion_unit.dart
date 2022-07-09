import 'dart:convert';

import 'package:beben_pos_desktop/core/fireship/fireship_box.dart';
import 'package:beben_pos_desktop/customer/model/customer_model.dart';
import 'package:beben_pos_desktop/db/product_model_db.dart';
import 'package:beben_pos_desktop/db/unit_conversions_db.dart';
import 'package:beben_pos_desktop/product/bloc/product_bloc.dart';
import 'package:beben_pos_desktop/product/model/product_model.dart';
import 'package:beben_pos_desktop/utils/global_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

class DialogFormConversionUnit extends StatefulWidget {
  final ProductModel productModel;

  DialogFormConversionUnit(this.productModel, {Key? key}) : super(key: key);

  @override
  _DialogFormConversionUnitState createState() =>
      _DialogFormConversionUnitState();
}

class _DialogFormConversionUnitState extends State<DialogFormConversionUnit> {
  var _formKey = GlobalKey<FormState>();
  late ProductModel productModel = widget.productModel;
  double convertPerParent = 1;
  var unit = UnitConversionDB();
  var controllerChildUnit = TextEditingController();
  var controllerHargaJual = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    initUnits();
    super.initState();
  }

  initUnits() async {
    var boxProduct = await Hive.openBox<ProductModelDB>("product_db");
    var boxUnitConv =
        await Hive.openBox<UnitConversionDB>(FireshipBox.BOX_UNIT_CONVERSION);
    List<UnitConversionDB> unitConv = boxUnitConv.values.toList();
    ProductModelDB productToDb =
        ProductModelDB.fromJson(jsonDecode(jsonEncode(productModel.product)));
    productToDb.unitsName = productModel.product?.unit;
    productToDb.unitsId = productModel.product?.unitId;
    var productListDB = boxProduct.values.toList();
    int indexProduct = productListDB.indexWhere((element) {
      bool productIdCheck = element.productId == productToDb.productId;
      bool unitIdCheck = element.unitsId == productToDb.unitsId;
      var unitName = element.unitsName ?? "";
      var dbUnitName = productToDb.unitsName ?? "";
      bool unitNameCheck =
          unitName.toLowerCase().contains(dbUnitName.toLowerCase());
      return productIdCheck && unitIdCheck && unitNameCheck;
    });
    var product = productListDB.elementAt(indexProduct);
    print("Product ${jsonEncode(product)}");
    setState(() {
      unit = unitConv.firstWhere((element) {
        var parentId = element.parent?.id ?? 0;
        return parentId == product.unitsId;
      }, orElse: () {
        return UnitConversionDB();
      });
    });

    double checkStock = double.parse(product.stock ?? "0") - convertPerParent;

    if (checkStock < 1) {
      GlobalFunctions.showSnackBarWarning("Produk tidak dapat di konversi");
      return;
    }

    if (unit.id == null) {
      GlobalFunctions.showSnackBarWarning("Produk tidak dapat di konversi");
      return;
    }
  }

  // late int _rbValue = widget._customerModel.gender;
  @override
  Widget build(BuildContext context) {
    AlertDialog alertDialog = AlertDialog(
        title: Container(
          width: 500,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Konversi Unit"),
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  tooltip: "Close",
                  padding: EdgeInsets.all(0),
                  icon: Icon(Icons.close))
            ],
          ),
        ),
        content: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 15),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            "Satuan Awal",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 15),
                    child: Text("Nama Unit : ${unit.parent?.name ?? "-"}"),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 30),
                    child:
                        Text("Stock Sisa : ${productModel.product?.lastStock ?? "0"}"),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 15),
                    child: Text(
                      "Konversi Satuan Ke :",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 15),
                    child: Text("Nama Unit : ${unit.child?.name ?? "-"}"),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text("Unit yang di konversi : "),
                        ),
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                              controller: controllerChildUnit,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                              ],
                              decoration: InputDecoration(
                                labelText: "Unit yang di konversi",
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "${unit.valueUnitParent ?? 0} ${unit.parent?.name ?? "-"} = ${unit.valueUnitChild ?? 0} ${unit.child?.name ?? "-"}";
                                } else {
                                  if(value != "."){
                                    double val = double.parse(value);
                                    double lastStock =
                                    double.parse(productModel.product?.lastStock ?? "0");
                                    if (val > lastStock) {
                                      return "Maksimal konversi stock adalah ${productModel.product?.lastStock ?? "0"}";
                                    }
                                  }
                                }
                              }),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text("/ ${unit.parent?.name??"-"}"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text("Harga Jual : "),
                        ),
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                              controller: controllerHargaJual,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                labelText: "Harga Jual",
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Atur harga jual";
                                }
                              }),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () async {
                        await ProductBloc().procesUnitConversionV2(
                            productModel, double.parse(controllerChildUnit.text), double.parse(controllerHargaJual.text));
                        Navigator.pop(context);
                      },
                      child: Text("Simpan Konversi"),
                      style: ElevatedButton.styleFrom(
                          textStyle: TextStyle(color: Colors.white),
                          padding: EdgeInsets.only(
                              left: 20, right: 20, top: 15, bottom: 15),
                          primary: Color(0xff3498db)),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
    return alertDialog;
  }
}
