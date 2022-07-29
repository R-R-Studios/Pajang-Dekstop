import 'dart:convert';

import 'package:beben_pos_desktop/core/fireship/fireship_box.dart';
import 'package:beben_pos_desktop/core/fireship/fireship_encrypt.dart';
import 'package:beben_pos_desktop/db/product_model_db.dart';
import 'package:beben_pos_desktop/db/unit_conversions_db.dart';
import 'package:beben_pos_desktop/product/model/create_product_model.dart';
import 'package:beben_pos_desktop/product/model/product_data.dart';
import 'package:beben_pos_desktop/product/model/product_model.dart';
import 'package:beben_pos_desktop/product/model/request_create_product_merchant.dart';
import 'package:beben_pos_desktop/product/model/units_model.dart';
import 'package:beben_pos_desktop/product/provider/product_provider.dart';
import 'package:beben_pos_desktop/units/provider/unit_provider.dart';
import 'package:beben_pos_desktop/utils/global_functions.dart';
import 'package:hive/hive.dart';
import 'package:rxdart/rxdart.dart';

class ProductBloc {
  List<ProductModel> listProduct = [];
  List<UnitsModel> unitsModelList = [];

  BehaviorSubject<List<ProductModel>> listProductController =
      new BehaviorSubject<List<ProductModel>>();

  Stream<List<ProductModel>> get streamListProduct =>
      listProductController.stream;

  BehaviorSubject<List<UnitsModel>> listUnitsController =
      new BehaviorSubject<List<UnitsModel>>();

  Stream<List<UnitsModel>> get streamUnitsList => listUnitsController.stream;

  Future<List<UnitsModel>> initUnits() async => await getListUnitsData();

  getListUnitsData() async {
    unitsModelList = await ProductProvider.getListProductUnits();
    listUnitsController.sink.add(unitsModelList);
    GlobalFunctions.logPrint("Total Data Produk bloc", unitsModelList.length);
    return unitsModelList;
  }

  refreshProductDB() async {
    List<ProductModelDB> listDB = [];
    var box = await Hive.openBox<ProductModelDB>("product_db");
    listDB = box.values.toList();
    listProduct.clear();
    for (var db in listDB) {
      var product = ProductModel(
        product: ProductData(
          salePrice: db.salePrice,
          originalPrice: db.originalPrice,
          code: db.code,
          name: db.name,
          barcode: db.barcode,
          createdAt: db.createdAt,
          description: db.description,
          unitId: db.unitsId,
          lastStock: db.stock,
          productId: db.productId,
          unit: db.unitsName,
        ),
      );
      listProduct.add(product);
    }
    listProductController.sink.add(listProduct);
  }

// >>>>>>> odonDev
  refreshProduct() async {
    listProduct.clear();
    listProduct = await ProductProvider.refreshProduct();
    listProductController.sink.add(listProduct);
    await Hive.deleteBoxFromDisk(FireshipBox.BOX_UNIT_CONVERSION);
    UnitProvider.getUnitConversion();
  }

  initProductList() async {
    // List<ProductModelDB> productDB = await getProductListDB();
    // if (productDB.length > 0) {
    // for (ProductModelDB products in productDB) {
    //   print("initProductList ${products.createdAt}");
    //   print("initProductList ${products.toJson()}");
    //   listProduct.add(
    //     ProductModel(
    //         product: ProductData(
    //             productId: products.productId,
    //             name: products.name,
    //             code: products.code,
    //             barcode: products.barcode,
    //             description: products.description,
    //             createdAt: products.createdAt,
    //             originalPrice: products.originalPrice,
    //             salePrice: products.salePrice,
    //             lastStock: products.stock,
    //             unit: products.unitsName,
    //             unitId: products.unitsId
    //         )
    //     ),
    //   );
    // }
    await refreshProduct();
    //   print("GET UNITS FROM DB ${listProduct.length}");
    // } else {
    //   listProduct.addAll(await ProductProvider.listProduct());
    //   print("GET UNITS FROM API ${listProduct.length}");
    // }
    listProduct.sort((idA, idB) {
      int productA = idA.product?.productId ?? 0;
      int productB = idB.product?.productId ?? 0;
      return productA.compareTo(productB);
    });
    listProductController.sink.add(listProduct);
  }

  Future createProduct(CreateProductModel productModel) async {
    var key = FireshipCrypt().encrypt(
        jsonEncode(productModel), await FireshipCrypt().getPassKeyPref());
    await ProductProvider.createProduct(BodyEncrypt(key, key).toJson());
  }

  updateProductToDB(ProductModel productModel) async {
    print("updateProductToDB ${productModel.product?.createdAt}");
    var box = await Hive.openBox<ProductModelDB>("product_db");
    List<ProductModelDB> list = box.values.toList();
    int i = list
        .indexWhere((element) => element.id == productModel.product?.productId);
    var product = ProductModelDB(
        id: productModel.product?.productId,
        name: productModel.product?.name,
        code: productModel.product?.code,
        barcode: productModel.product?.barcode,
        description: productModel.product?.description,
        createdAt: productModel.product?.createdAt,
        stock: productModel.product?.lastStock == null
            ? "0"
            : productModel.product?.lastStock.toString(),
        originalPrice: productModel.product?.originalPrice == null
            ? "0"
            : productModel.product?.originalPrice.toString(),
        unitsName: productModel.product?.unit,
        salePrice: productModel.product?.salePrice == null
            ? "0"
            : productModel.salePrice.toString());
    box.putAt(i, product);
    print("Update Product ${jsonEncode(box.getAt(i))}");
  }

  saveProductToDB(ProductModel productModel) async {
    var box = await Hive.openBox<ProductModelDB>("product_db");
    print("productModel.product?.createdAt ${productModel.product?.createdAt}");
    var product = ProductModelDB(
        id: productModel.product?.productId,
        name: productModel.product?.name,
        code: productModel.product?.code,
        barcode: productModel.product?.barcode,
        description: productModel.product?.description,
        createdAt: productModel.product?.createdAt,
        stock: productModel.product?.lastStock == null
            ? "0"
            : productModel.product?.lastStock.toString(),
        originalPrice: productModel.product?.originalPrice == null
            ? "0"
            : productModel.product?.originalPrice.toString(),
        unitsName: productModel.product?.unit,
        salePrice: productModel.salePrice == null
            ? "0"
            : productModel.salePrice.toString());
    box.add(product);
  }

  Future<List<ProductModelDB>> getProductListDB() async {
    List<ProductModelDB> _productListDB = <ProductModelDB>[];
    final box = await Hive.openBox<ProductModelDB>("product_db");
    _productListDB = box.values.toList();
    if (_productListDB.length > 0) {
      _productListDB
          .sort((idA, idB) => idA.productId ?? 0.compareTo(idB.productId ?? 0));
    }
    return _productListDB;
  }

  searchProduct(String search) async {
    List<ProductModel> list = listProduct;
    list = list.where(
      (element) {
        return jsonEncode(element).toLowerCase().contains(search.toLowerCase());
      },
    ).toList();
    print("ON SEARCH PRODUCT ${list.length}");
    listProductController.sink.add(list);
  }

  searchUnit(String search) async {
    List<UnitsModel> list = unitsModelList;
    list = list.where((element) {
      return jsonEncode(element).toLowerCase().contains(search.toLowerCase());
    }).toList();
    listUnitsController.sink.add(list);
  }

  sortProduct(int columnIndex, bool _sortAscending) async {
    print("sortProduct $columnIndex $_sortAscending");
    List<ProductModel> list = listProduct;
    switch (columnIndex) {
      case 0:
        list.sort((idA, idB) {
          int productA = idA.product?.productId ?? 0;
          int productB = idB.product?.productId ?? 0;
          if (_sortAscending) {
            return productA.compareTo(productB);
          } else {
            return productB.compareTo(productA);
          }
        });
        break;
      case 1:
        list.sort((idA, idB) {
          var pA = idA.product?.name ?? "".toLowerCase();
          var pB = idB.product?.name ?? "".toLowerCase();
          return _sortAscending ? pA.compareTo(pB) : pB.compareTo(pA);
        });
        break;
      case 2:
        list.sort((idA, idB) {
          var pA = idA.product?.unit ?? "".toLowerCase();
          var pB = idB.product?.unit ?? "".toLowerCase();
          return _sortAscending ? pA.compareTo(pB) : pB.compareTo(pA);
        });
        break;
      case 3:
        list.sort((idA, idB) {
          var pA = idA.product?.code ?? "".toLowerCase();
          var pB = idB.product?.code ?? "".toLowerCase();
          return _sortAscending ? pA.compareTo(pB) : pB.compareTo(pA);
        });
        break;
      case 4:
        list.sort((idA, idB) {
          var pA = idA.product?.barcode ?? "".toLowerCase();
          var pB = idB.product?.barcode ?? "".toLowerCase();
          return _sortAscending ? pA.compareTo(pB) : pB.compareTo(pA);
        });
        break;
      case 5:
        list.sort((idA, idB) {
          double pA = double.parse(idA.product?.originalPrice ?? "0");
          double pB = double.parse(idB.product?.originalPrice ?? "0");
          return _sortAscending ? pA.compareTo(pB) : pB.compareTo(pA);
        });
        break;
      case 6:
        list.sort((idA, idB) {
          double pA = double.parse(idA.product?.salePrice ?? "0");
          double pB = double.parse(idB.product?.salePrice ?? "0");
          return _sortAscending ? pA.compareTo(pB) : pB.compareTo(pA);
        });
        break;
      case 7:
        list.sort((idA, idB) {
          double pA = double.parse(idA.product?.lastStock ?? "0");
          double pB = double.parse(idB.product?.lastStock ?? "0");
          return _sortAscending ? pA.compareTo(pB) : pB.compareTo(pA);
        });
        break;
      case 8:
        list.sort((idA, idB) {
          var pA = idA.product?.description ?? "".toLowerCase();
          var pB = idB.product?.description ?? "".toLowerCase();
          return _sortAscending ? pA.compareTo(pB) : pB.compareTo(pA);
        });
        break;
      case 9:
        list.sort((idA, idB) {
          var pA = idA.product?.createdAt ?? "".toLowerCase();
          var pB = idB.product?.createdAt ?? "".toLowerCase();
          return _sortAscending ? pA.compareTo(pB) : pB.compareTo(pA);
        });
        break;
    }
    listProduct = list;
    listProductController.sink.add(listProduct);
  }

  Future<bool> checkUnitConversionV2(ProductModel productModel) async {
    bool canUnitConversion = false;
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
    var unit = unitConv.firstWhere((element) {
      var parentId = element.parent?.id ?? 0;
      return parentId == product.unitsId;
    }, orElse: () {
      return UnitConversionDB();
    });

    if (unit.id == null) {
      canUnitConversion = false;
    } else {
      canUnitConversion = true;
    }
    return canUnitConversion;
  }

  Future<void> procesUnitConversionV2(ProductModel productModel,
      double convertPerParent, double hargaJual) async {
    print("========= procesUnitConversion =========");
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
    var unit = unitConv.firstWhere((element) {
      var parentId = element.parent?.id ?? 0;
      return parentId == product.unitsId;
    }, orElse: () {
      return UnitConversionDB();
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

    int parentId = unit.parent?.id ?? 0;
    String parentName = unit.parent?.name ?? "".toLowerCase();

    bool isParent = parentId == product.unitsId &&
        parentName.contains(product.unitsName ?? "".toLowerCase());
    if (isParent) {
      double stockProduct = double.parse(product.stock ?? "0");
      double valueChild = double.parse("${unit.valueUnitChild ?? 0}");

      double convertedStock = double.parse("${stockProduct * valueChild}");
      double lastConvertStockProduct = convertedStock;
      print("convertedStock $convertedStock");

      double qtyConvert = valueChild * convertPerParent;

      lastConvertStockProduct = convertedStock - qtyConvert;
      print("lastStockProduct $lastConvertStockProduct");

      double deconvertedStock = lastConvertStockProduct / valueChild;
      print("deconvertedStock $deconvertedStock");

      String sDecStock = deconvertedStock.toString();

      String lastParentStock = sDecStock.split(".")[0];
      print("lastParentStock $lastParentStock -- lastChildStock $qtyConvert");

      var updateProduct = product;
      updateProduct.stock = sDecStock;

      double oriPrice = double.parse("${product.salePrice}");

      double originPrice = oriPrice / valueChild;

      String salePrice = "$hargaJual";

      boxProduct.putAt(indexProduct, updateProduct);

      var newChildProduct = ProductModelDB(
          productId: product.productId,
          unitsName: unit.child?.name ?? "-",
          unitsId: unit.child?.id ?? 0,
          stock: "$qtyConvert",
          description: product.description,
          barcode: product.barcode,
          name: product.name,
          code: product.code,
          originalPrice: "$originPrice",
          salePrice: salePrice,
          createdAt: product.createdAt);
      var isHaveProduct = productListDB.where((element) {
        var checkProductId = element.productId == newChildProduct.productId;
        var checkUnitsId = element.unitsId == newChildProduct.unitsId;
        var checkUnitsName = element.unitsName == newChildProduct.unitsName;
        return checkProductId && checkUnitsId && checkUnitsName;
      });
      if (isHaveProduct.length > 0) {
        var index = productListDB.indexWhere((element) {
          var checkProductId = element.productId == newChildProduct.productId;
          var checkUnitsId = element.unitsId == newChildProduct.unitsId;
          var checkUnitsName = element.unitsName == newChildProduct.unitsName;
          return checkProductId && checkUnitsId && checkUnitsName;
        });
        var updateProduct = productListDB.elementAt(index);
        double lastStock =
            double.parse(updateProduct.stock ?? "0") + qtyConvert;
        updateProduct.stock = "$lastStock";
        updateProduct.salePrice = "$salePrice";
        boxProduct.put(index, updateProduct);
        print("HaveProduct true");
      } else {
        print("HaveProduct false");
        boxProduct.add(newChildProduct);
      }
    }
  }

  close() {
    listProductController.close();
    listUnitsController.close();
  }

  Future<bool> requestCreateMerchantProduct(
      String productName,
      String productCode,
      String productBarcode,
      String productDesc,
      bool isActive,
      int productUnitId,
      double productStock,
      double productCurrentStock,
      double currentPrice,
      double salePrice) async {
    bool isSuccess = false;
    CreateProduct createProduct = CreateProduct(
        name: productName,
        code: productCode,
        barcode: productBarcode,
        description: productDesc,
        isActive: isActive);

    CreateProductStock createProductStock = CreateProductStock(
        unitId: productUnitId,
        trxStock: productStock,
        currentStock: productCurrentStock);

    CreateProductPrice createProductPrice =
        CreateProductPrice(currentPrice: currentPrice, salePrice: salePrice);

    RequestCreateMerchantProduct requestCreateMerchantProduct =
        RequestCreateMerchantProduct(
            product: createProduct,
            productStock: createProductStock,
            productPrice: createProductPrice);
    GlobalFunctions.logPrint(
        "requestMerchantTransaction", jsonEncode(requestCreateMerchantProduct));
    var key = FireshipCrypt().encrypt(jsonEncode(requestCreateMerchantProduct),
        await FireshipCrypt().getPassKeyPref());
    await ProductProvider.requestCreateMerchantProduct(
            BodyEncrypt(key, key).toJson())
        .then((value) async {
      GlobalFunctions.logPrint(
          "Return Status from provider RequestCreateMerchantProduct", '$value');
      if (value) {
        isSuccess = true;
      } else {
        isSuccess = false;
      }
    });
    return isSuccess;
  }
}
