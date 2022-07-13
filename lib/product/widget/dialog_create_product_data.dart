import 'package:beben_pos_desktop/product/bloc/product_bloc.dart';
import 'package:beben_pos_desktop/product/model/create_product_model.dart';
import 'package:beben_pos_desktop/product/model/units_model.dart';
import 'package:beben_pos_desktop/utils/global_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dialog_product_units.dart';

class DialogCreateProductData extends StatefulWidget {
  const DialogCreateProductData({Key? key, this.barcode = ""})
      : super(key: key);

  final String? barcode;

  @override
  _DialogCreateProductDataState createState() =>
      _DialogCreateProductDataState();
}

class _DialogCreateProductDataState extends State<DialogCreateProductData> {
  var _formKey = GlobalKey<FormState>();
  TextEditingController _productNameController = TextEditingController();
  TextEditingController _productCodeController = TextEditingController();
  TextEditingController _productBarCodeController = TextEditingController();
  TextEditingController _productSalePriceController = TextEditingController();
  TextEditingController _productOriginalPriceController =
      TextEditingController();
  TextEditingController _productTotalStockController = TextEditingController();
  TextEditingController _productUnitsController = TextEditingController();
  TextEditingController _productDescriptionController = TextEditingController();
  bool isDone = false;
  UnitsModel selectedUnits = new UnitsModel();
  ProductBloc productBloc = ProductBloc();
  CreateProductModel createProductModel = CreateProductModel();

  clearForm() {
    _productNameController.text = "";
    _productCodeController.text = "";
    _productBarCodeController.text = "";
    _productSalePriceController.text = "";
    _productOriginalPriceController.text = "";
    _productTotalStockController.text = "";
    _productUnitsController.text = "";
    _productDescriptionController.text = "";
    selectedUnits = new UnitsModel();
  }

  @override
  void initState() {
    // TODO: implement initState
    _productBarCodeController.text = widget.barcode ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Container(
          width: 500,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Buat Produk"),
              IconButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  tooltip: "Tutup",
                  padding: EdgeInsets.all(0),
                  icon: Icon(Icons.close))
            ],
          ),
        ),
        content: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 12, right: 12, top: 10, bottom: 10),
            child: Form(
              key: _formKey,
              // autovalidateMode: AutovalidateMode.onUserInteraction,
              child: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 200,
                            child: Text("Nama Produk"),
                          ),
                          Container(
                            width: 300,
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Nama Produk',
                                border: OutlineInputBorder(),
                              ),
                              controller: _productNameController,
                              enabled: true,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Masukan nama produk';
                                }
                                return null;
                              },
                              onChanged: (newText) {
                                if (newText.length > 0) {
                                  setState(() {
                                    isDone = true;
                                  });
                                } else {
                                  setState(() {
                                    isDone = false;
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Text("Kode Produk"),
                            width: 200,
                          ),
                          Container(
                            width: 300,
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Kode Produk',
                                border: OutlineInputBorder(),
                              ),
                              controller: _productCodeController,
                              enabled: true,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Masukan kode produk';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Text("Barcode Produk"),
                            width: 200,
                          ),
                          Container(
                            width: 300,
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Barcode Produk',
                                border: OutlineInputBorder(),
                              ),
                              controller: _productBarCodeController,
                              enabled: true,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Masukan barcode produk';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 200,
                            child: Text("Harga Beli Produk"),
                          ),
                          Container(
                            width: 300,
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Harga Beli Produk',
                                border: OutlineInputBorder(),
                              ),
                              controller: _productOriginalPriceController,
                              enabled: true,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Masukan Harga Beli Produk';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 200,
                            child: Text("Harga Jual Produk"),
                          ),
                          Container(
                            width: 300,
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Harga Jual Produk',
                                border: OutlineInputBorder(),
                              ),
                              controller: _productSalePriceController,
                              enabled: true,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Masukan Harga Jual Produk';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 200,
                            child: Text("Total Stock"),
                          ),
                          Container(
                            width: 300,
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Total Stock',
                                border: OutlineInputBorder(),
                              ),
                              controller: _productTotalStockController,
                              enabled: true,
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              inputFormatters: [
                                // FilteringTextInputFormatter.digitsOnly,
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d+\.?\d{0,2}')),
                              ],
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Masukan jumal total stock';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 200,
                            child: Text("Satuan produk"),
                          ),
                          Container(
                            width: 300,
                            child: TextFormField(
                              readOnly: true,
                              decoration: InputDecoration(
                                labelText: 'pilih satuan produk',
                                border: OutlineInputBorder(),
                              ),
                              controller: _productUnitsController,
                              enabled: true,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Pilih satuan produk';
                                }
                                return null;
                              },
                              onTap: () {
                                openDialogUnits(context);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Text("Description"),
                            width: 200,
                          ),
                          Container(
                            width: 300,
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Deskripsi',
                                border: OutlineInputBorder(),
                              ),
                              controller: _productDescriptionController,
                              enabled: true,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Masukan Deskripsi produk';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () async {
                          var form = _formKey.currentState;
                          if (form != null && form.validate()) {
                            var name = _productNameController.text;
                            var code = _productCodeController.text;
                            var barCode = _productBarCodeController.text;
                            var originPrice =
                                _productOriginalPriceController.text;
                            var salePrice = _productSalePriceController.text;
                            var totalStock = _productTotalStockController.text;
                            var description =
                                _productDescriptionController.text;
                            var unitsName = _productUnitsController.text;

                            double totalStockProduct = double.parse(totalStock);
                            double originPriceProduct =
                                double.parse(originPrice);
                            double salePriceProduct = double.parse(salePrice);

                            bool isSuccess = false;
                            await productBloc
                                .requestCreateMerchantProduct(
                                    name,
                                    code,
                                    barCode,
                                    description,
                                    true,
                                    selectedUnits.id!,
                                    totalStockProduct,
                                    totalStockProduct,
                                    originPriceProduct,
                                    salePriceProduct)
                                .then((value) async {
                              isSuccess = value;
                              GlobalFunctions.logPrint(
                                  "Status Request Create Merchant Transaction",
                                  '$value');
                              clearForm();
                            });
                            Navigator.pop(context, isSuccess);
                          }
                        },
                        child: Text("Simpan"),
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
          ),
        ));
  }

  openDialogUnits(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return DialogProductUnits(selectedUnits);
        }).then((value) async {
      if (value != null) selectedUnits = value;
      _productUnitsController.text = selectedUnits.name!;
    });
  }
}
