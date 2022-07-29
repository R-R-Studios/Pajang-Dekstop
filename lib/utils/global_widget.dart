import 'package:flutter/material.dart';

class GlobalWidget {
  Future<bool> dialogProductNotFound(
    BuildContext context,
  ) async {
    bool isAddedProduct = false;
    await showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            titlePadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.symmetric(vertical: 50),
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Product tidak ditemukan"),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(ctx, true);
                      // GlobalFunctions.showSnackBarWarning("Produk tidak ditemukan");
                    },
                    child: Text("Tambah Product?"),
                  )
                ],
              ),
            ),
          );
        }).then((value) {
      if (value != null) {
        isAddedProduct = value;
      }
    });
    return isAddedProduct;
  }
}
