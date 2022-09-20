
import 'package:beben_pos_desktop/product/bloc/product_bloc.dart';
import 'package:beben_pos_desktop/product/model/units_model.dart';
import 'package:beben_pos_desktop/utils/global_color_palette.dart';
import 'package:beben_pos_desktop/utils/size_config.dart';
import 'package:flutter/material.dart';

class DialogProductUnits extends StatefulWidget {
  const DialogProductUnits({Key? key}) : super(key: key);

  @override
  _DialogProductUnitsState createState() => _DialogProductUnitsState();
}

class _DialogProductUnitsState extends State<DialogProductUnits> {

  bool canSearch = false;
  ProductBloc productBloc = ProductBloc();
  List<UnitsModel> unitsModelList = [];

  @override
  void initState() {
    // TODO: implement initState
    canSearch = true;
    productBloc.initUnits();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    productBloc.close();
    super.dispose();
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
                    "Satuan produk",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {

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
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 8),
              width: SizeConfig.screenWidth * 0.49,
              child: TextFormField(
                maxLines: 1,
                autofocus: true,
                // focusNode: scanFocusNode,
                // controller: scanController,
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
                  hintText: 'Cari satuan produk',
                ),
                onFieldSubmitted: (String val){

                },
                onChanged: (String val) {
                  onSearchChange(val);
                },
              ),
            ),
            Container(
                height: 300,
                width: SizeConfig.screenWidth * 0.49,
                child: canSearch
                    ? buildListProductMerchant(context)
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
    );
    return alertDialog;
  }

  onSearchChange(String query) {
    productBloc.searchUnit(query);
    // productBloc.findProductByNameOrBarcode(context, query);
    // if (_debouncer?.isActive ?? false) _debouncer?.cancel();
    // _debouncer = Timer(const Duration(milliseconds: 1000), () {
    //   print('on progress');
    //   setState(() {
    //     canSearch = true;
    //     searchText = query;
    //   });
    // });
  }

  Widget buildListProductMerchant(BuildContext context) {
    return StreamBuilder(
        stream: productBloc.streamUnitsList,
        builder: (context, AsyncSnapshot<List<UnitsModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData) {
            return Center(
              child: Text("Data Kosong"),
            );
          } else {
            unitsModelList.clear();
            unitsModelList.addAll(snapshot.data!);
            return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      ListTile(
                        contentPadding:
                        EdgeInsets.only(left: 8, right: 8),
                        title: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Text("${snapshot.data![index].name}"),
                            Text("${snapshot.data![index].description}"),
                          ],
                        ),
                        onTap: () {
                          Navigator.pop(context, snapshot.data![index]);
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
