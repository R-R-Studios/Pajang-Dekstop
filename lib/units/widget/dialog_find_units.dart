import 'dart:convert';

import 'package:beben_pos_desktop/core/core.dart';
import 'package:beben_pos_desktop/db/product_model_db.dart';
import 'package:beben_pos_desktop/product/model/product_model.dart';
import 'package:beben_pos_desktop/receivings/bloc/receivings_bloc.dart';
import 'package:beben_pos_desktop/receivings/model/price_list_model.dart';
import 'package:beben_pos_desktop/receivings/model/product_receivings_model.dart';
import 'package:beben_pos_desktop/receivings/model/unit_list_model.dart';
import 'package:beben_pos_desktop/units/model/units_model.dart';
import 'package:beben_pos_desktop/units/bloc/unit_bloc.dart';
import 'package:beben_pos_desktop/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogFindUnits extends StatefulWidget {
  DialogFindUnits(this.priceList);

  final List<PriceList> priceList;

  @override
  _DialogFindUnitsState createState() => _DialogFindUnitsState();
}

class _DialogFindUnitsState extends State<DialogFindUnits> {
  UnitBloc unitBloc = UnitBloc();
  late List<PriceList> priceList = widget.priceList;

  String search = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    unitBloc.initPriceList(priceList);
    // unitBloc.initUnitsList();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    AlertDialog alertDialog = AlertDialog(
      contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      titlePadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      title: Container(
        width: SizeConfig.screenWidth * 0.3,
        color: Colors.blueAccent[400],
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                "Cari Satuan",
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
              width: SizeConfig.screenWidth * 0.29,
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
                  hintText: 'Cari Satuan',
                ),
                onChanged: (String val) {
                  onSearchUnit(val);
                },
              ),
            ),
            Container(
              height: 300,
              width: SizeConfig.screenWidth * 0.29,
              child: StreamBuilder(
                stream: unitBloc.streamListPrice,
                builder: (context, AsyncSnapshot<List<PriceList>> snapshot) {
                  List<PriceList> list = [];
                  if(snapshot.hasData){
                    list = snapshot.data!;
                  }else{
                    list = [PriceList()];
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: list.length,
                    itemBuilder: (BuildContext context, int index) {
                      UnitList unit = list[index].unitList != null ? list[index].unitList! : UnitList();
                      return ListTile(
                        contentPadding: EdgeInsets.only(left: 8, right: 8),
                        title: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("${unit.name != null ? unit.name : "Units Tidak tersedia"}"),
                            Text(Core.converNumeric(list[index].salePrice != null ? double.parse(list[index].salePrice!).toInt().toString() : ""))
                          ],
                        ),
                        onTap: () {
                          Navigator.pop(context, list[index]);
                        },
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
    return alertDialog;
  }

  onSearchUnit(String val) {
    if(val.isEmpty){
      print("onSearchUnit $val isEmpty");
      unitBloc.initPriceList(priceList);
    }else{
      print("onSearchUnit $val isNotEmpty");
      unitBloc.searchPriceList(val);
    }

  }
}
