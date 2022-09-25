import 'dart:io';

import 'package:beben_pos_desktop/component/component.dart';
import 'package:beben_pos_desktop/content/cubit/product_cubit.dart';
import 'package:beben_pos_desktop/content/model/brand.dart';
import 'package:beben_pos_desktop/content/model/category.dart';
import 'package:beben_pos_desktop/core/app/color_palette.dart';
import 'package:beben_pos_desktop/core/app/constant.dart';
import 'package:beben_pos_desktop/core/core.dart';
import 'package:beben_pos_desktop/delivery/view/dialog_find.dart';
import 'package:beben_pos_desktop/product/model/units_model.dart';
import 'package:beben_pos_desktop/product/provider/product_provider.dart';
import 'package:beben_pos_desktop/utils/size_config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nav_router/nav_router.dart';

import '../../product/widget/dialog_product_units.dart';

class ProductScreen extends StatelessWidget {

  final VoidCallback callback;

  ProductScreen({ required this.callback, Key? key }) : super(key: key);

  var _formKey = GlobalKey<FormState>();
  late UnitsModel unitsModel;
  late Brand brand;
  late SubCategory subCategory;
  TextEditingController _productNameController = TextEditingController();
  TextEditingController _productCodeController = TextEditingController();
  TextEditingController _productBarCodeController = TextEditingController();
  TextEditingController _productSalePriceController = TextEditingController();
  TextEditingController _productOriginalPriceController = TextEditingController();
  TextEditingController _productTotalStockController = TextEditingController();
  TextEditingController _productUnitsController = TextEditingController();
  TextEditingController _productMerkController = TextEditingController();
  TextEditingController _productCategoryController = TextEditingController();
  TextEditingController _productDescriptionController = TextEditingController();

  openDialogUnits(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogProductUnits();
      }).then((value) async {
      if (value != null)
        value as UnitsModel;
        unitsModel = value;
        _productUnitsController.text = value.name!;
    });
  }
  
  void showDialogFind(FeatureType featureType) {
    showDialog(
      context: navGK.currentContext!,
      barrierDismissible: true,
      builder: (BuildContext c) {
        return DialogFind(featureType: featureType);
      }).then((value) {
      if (value != null) {
        switch (featureType) {
          case FeatureType.brands:
            value as Brand;
            brand = value;
            _productMerkController.text = value.name!;
            break;
          case FeatureType.category:
            value as SubCategory;
            subCategory = value;
            _productCategoryController.text = value.name!;
            break;
          default:
        }
      } else {
        // FocusScope.of(context).requestFocus(scanFocusNode);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          if(state is ProductLoading){
            return Center(child: CupertinoActivityIndicator());
          } else if (state is ProductLoaded) {
            return Padding(
              padding: Constant.paddingScreen,
              child: ListView(
                children: [
                  const SizedBox(height: 20,),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: callback,
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 16.0,
                        ),
                        label: Text("Back"),
                        style: ElevatedButton.styleFrom(
                          textStyle: TextStyle(color: Colors.white),
                          padding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
                          primary: Color(0xff3498db)
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20,),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Component.text("Product Anda", fontSize: 17, colors: Colors.black),
                      const Spacer(),
                      InkWell(
                        onTap: (){
                          BlocProvider.of<ProductCubit>(context).changeScreen(2);
                        },
                        child: Card(
                          color: Colors.green,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(Icons.add, color: Colors.white),
                                const SizedBox(width: 5,),
                                Component.text("Tambah", colors: Colors.white),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10,),
                      Card(
                        color: Colors.red,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: Colors.white),
                              const SizedBox(width: 5,),
                              Component.text("Hapus", colors: Colors.white),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20,),
                  GridView.builder(
                    itemCount: state.listProduct.length,
                    shrinkWrap: true,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 6,
                      childAspectRatio: (1 / 1.7),
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () async {
                          BlocProvider.of<ProductCubit>(context).onDetailProduct(state.listProduct[index].product!.productId!);
                        },
                        child: Card(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CachedNetworkImage(
                                imageUrl: state.listProduct[index].product?.imageUrl ?? "",
                                fit: BoxFit.fill,
                                height: SizeConfig.blockSizeHorizontal * 15,
                                width: SizeConfig.blockSizeHorizontal * 20,
                                placeholder: (context, string) => CupertinoActivityIndicator(),
                                errorWidget: (context, string, e) => Icon(
                                  Icons.computer, 
                                  color: ColorPalette.primary, 
                                  size: 100,
                                )
                              ),
                              const SizedBox(height: 20,),
                              Component.text(
                                state.listProduct[index].product?.name ?? "",
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                colors: Colors.black
                              ),
                              const SizedBox(height: 10,),
                              Component.text(Core.converNumeric(state.listProduct[index].product!.salePrice.toString())),
                              const SizedBox(height: 10,),
                              Component.text("${state.listProduct[index].product?.lastStock} / ${state.listProduct[index].product?.unit}")
                            ],
                          ),
                        ),
                      );
                    }
                  )
                ],
              ),
            );
          } else if (state is ProductAdd) {
            return Padding(
              padding: Constant.paddingScreen,
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [             
                    const SizedBox(height: 20,),
                    Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: (){
                            BlocProvider.of<ProductCubit>(context).changeScreen(1);
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 16.0,
                          ),
                          label: Text("Back"),
                          style: ElevatedButton.styleFrom(
                            textStyle: TextStyle(color: Colors.white),
                            padding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
                            primary: Color(0xff3498db)
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20,),
                    Padding(
                      padding: EdgeInsets.only(bottom: 25, left: 30, right: 30),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 200,
                            child: Text("Nama Produk"),
                          ),
                          Flexible(
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
                              onChanged: (newText){
                                // if (newText.length > 0){
                                //   setState(() {
                                //     isDone = true;
                                //   });
                                // } else {
                                //   setState(() {
                                //     isDone = false;
                                //   });
                                // }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 25, left: 30, right: 30),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Text("Kode Produk"),
                            width: 200,
                          ),
                          Flexible(
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
                      padding: EdgeInsets.only(bottom: 25, left: 30, right: 30),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Text("Barcode Produk"),
                            width: 200,
                          ),
                          Flexible(
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
                      padding: EdgeInsets.only(bottom: 25, left: 30, right: 30),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 200,
                            child: Text("Harga Beli Produk"),
                          ),
                          Flexible(
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
                      padding: EdgeInsets.only(bottom: 25, left: 30, right: 30),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 200,
                            child: Text("Harga Jual Produk"),
                          ),
                          Flexible(
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
                      padding: EdgeInsets.only(bottom: 25, left: 30, right: 30),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 200,
                            child: Text("Total Stock"),
                          ),
                          Flexible(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Total Stock',
                                border: OutlineInputBorder(),
                              ),
                              controller: _productTotalStockController,
                              enabled: true,
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              inputFormatters: [
                                // FilteringTextInputFormatter.digitsOnly,
                                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
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
                      padding: EdgeInsets.only(bottom: 25, left: 30, right: 30),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 200,
                            child: Text("Satuan produk"),
                          ),
                          Flexible(
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
                              onTap: (){
                                openDialogUnits(context);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 25, left: 30, right: 30),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 200,
                            child: Text("Merk"),
                          ),
                          Flexible(
                            child: TextFormField(
                              readOnly: true,
                              decoration: InputDecoration(
                                labelText: 'pilih merk',
                                border: OutlineInputBorder(),
                              ),
                              controller: _productMerkController,
                              enabled: true,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Pilih merk';
                                }
                                return null;
                              },
                              onTap: (){
                                showDialogFind(FeatureType.brands);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 25, left: 30, right: 30),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 200,
                            child: Text("Category"),
                          ),
                          Flexible(
                            child: TextFormField(
                              readOnly: true,
                              decoration: InputDecoration(
                                labelText: 'pilih Category',
                                border: OutlineInputBorder(),
                              ),
                              controller: _productCategoryController,
                              enabled: true,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Pilih Category';
                                }
                                return null;
                              },
                              onTap: (){
                                showDialogFind(FeatureType.category);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 25, left: 30, right: 30),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Text("Description"),
                            width: 200,
                          ),
                          Flexible(
                            child: TextFormField(
                              maxLines: 5,
                              minLines: 5,
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
                    Padding(
                      padding: EdgeInsets.only(bottom: 25, left: 30, right: 30),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text("Foto"),
                            width: 200,
                          ),
                          Expanded(
                            child: StreamBuilder<List<File?>>(
                              stream: BlocProvider.of<ProductCubit>(context).listImageController.stream,
                              initialData: List.filled(5, null),
                              builder: (BuildContext context, AsyncSnapshot<List<File?>> snapshot) {
                                return GridView.builder(
                                  shrinkWrap: true,
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                    mainAxisSpacing: 10.0,
                                    crossAxisSpacing: 10.0
                                  ),
                                  itemCount: snapshot.data?.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    if (snapshot.data?[index] == null) {
                                      return InkWell(
                                        onTap: () async {
                                          FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
                                          if (result != null) {
                                            BlocProvider.of<ProductCubit>(context).addProductPhoto(File(result.files.single.path!), index);
                                          } else {
                                            
                                          }
                                        },
                                        child: Container(
                                          height: SizeConfig.blockSizeHorizontal * 10,
                                          width: SizeConfig.blockSizeHorizontal * 60,
                                          decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                                            border: Border.all(
                                              width: 1,
                                              color: ColorPalette.grey
                                            )
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              const Icon(Icons.add_a_photo),
                                              const SizedBox(width: 10,),
                                              Component.text("Foto Produk")
                                            ],
                                          ),
                                        ),
                                      );
                                    } else {
                                      return Card(
                                        clipBehavior: Clip.antiAlias,
                                        child: Stack(
                                          children: <Widget>[
                                            Image.file(
                                              snapshot.data![index]!,
                                              height: SizeConfig.blockSizeHorizontal * 20,
                                              width: SizeConfig.blockSizeHorizontal * 60,
                                              fit: BoxFit.fill,
                                            ),
                                            Positioned(
                                              right: 5,
                                              top: 5,
                                              child: InkWell(
                                                child: const Icon(
                                                  Icons.remove_circle,
                                                  size: 20,
                                                  color: Colors.red,
                                                ),
                                                onTap: () {
                                                  BlocProvider.of<ProductCubit>(context).deletePhoto(index);
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20,),
                    ElevatedButton(
                      onPressed: () async {
                        var form = _formKey.currentState;
                        if (form != null && form.validate()) {
                          var name = _productNameController.text;
                          var code = _productCodeController.text;
                          var barCode = _productBarCodeController.text;
                          var originPrice = _productOriginalPriceController.text;
                          var salePrice = _productSalePriceController.text;
                          var totalStock = _productTotalStockController.text;
                          var description = _productDescriptionController.text;
                          var unitsName = _productUnitsController.text;

                          double totalStockProduct = double.parse(totalStock);
                          double originPriceProduct = double.parse(originPrice);
                          double salePriceProduct = double.parse(salePrice);

                          BlocProvider.of<ProductCubit>(context).createProduct(
                            name, code, barCode, description, true,
                            1, totalStockProduct, totalStockProduct,
                            originPriceProduct, salePriceProduct,
                            1, 1
                          );
                        }
                      },
                      child: Text("Simpan"),
                      style: ElevatedButton.styleFrom(
                        textStyle: TextStyle(color: Colors.white),
                        padding: EdgeInsets.only(left: 50, right: 50, top: 20, bottom: 20),
                        primary: Color(0xff3498db)
                      ),
                    ),
                    const SizedBox(height: 20,)
                  ],
                ),
              ),
            );
          } else {
            return Container();
          }
        },
      )
    );
  }
}