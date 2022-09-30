import 'package:beben_pos_desktop/content/model/brand.dart';
import 'package:beben_pos_desktop/content/model/category.dart';
import 'package:beben_pos_desktop/content/model/employee.dart';
import 'package:beben_pos_desktop/core/app/constant.dart';
import 'package:beben_pos_desktop/delivery/bloc/find_bloc.dart';
import 'package:beben_pos_desktop/delivery/model/vehicle.dart';
import 'package:beben_pos_desktop/ui/transaction/model/merchant_transaction.dart';
import 'package:beben_pos_desktop/utils/size_config.dart';
import 'package:flutter/material.dart';

class DialogFind extends StatefulWidget {

  final FeatureType featureType;

  DialogFind({required this.featureType});

  @override
  State<DialogFind> createState() => _DialogFindState();
}

class _DialogFindState extends State<DialogFind> {

  final FindBloc findBloc = FindBloc();
  bool isSubCategory = false;
  int indexSub = 0;

  @override
  void initState() {
    switch (widget.featureType) {
      case FeatureType.transaction:
        findBloc.getTransaction();
        break;
      case FeatureType.employee:
        findBloc.getEmployee();
        break;
      case FeatureType.vehicle:
        findBloc.getVehicle();
        break;
      case FeatureType.brands:
        findBloc.getBrand();
        break;
      case FeatureType.category:
        findBloc.getCategory();
        break;
      default:
    }
    super.initState();
  }

  String title(){
    switch (widget.featureType) {
      case FeatureType.vehicle:
        return "Kendaraan";
      case FeatureType.transaction:
        return "Transaksi";
      case FeatureType.employee:
        return "Pegawai";
      case FeatureType.brands:
        return "Merk";
      case FeatureType.category:
        return "Category";
      default:
        return "";
    }
  }

  Widget list(){
    switch (widget.featureType) {
      case FeatureType.transaction:
        return Container(
          height: 300,
          width: SizeConfig.screenWidth * 0.49,
          child: StreamBuilder<List<MerchantTransaction>> (
            stream: findBloc.merchantTransaction,
            initialData: [],
            builder: (BuildContext context, AsyncSnapshot<List<MerchantTransaction>> snapshot) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  contentPadding: EdgeInsets.only(left: 8, right: 8),
                  title: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${snapshot.data![index].transactionCode}"),
                      Text("${snapshot.data![index].userName}")
                    ],
                  ),
                  onTap: () {
                    Navigator.pop(context, snapshot.data![index]);
                  },
                );
              },);
          },
          ),
        );
      case FeatureType.vehicle:
        return Container(
          height: 300,
          width: SizeConfig.screenWidth * 0.49,
          child: StreamBuilder<List<Vehicle>> (
            stream: findBloc.vehicleController,
            initialData: [],
            builder: (BuildContext context, AsyncSnapshot<List<Vehicle>> snapshot) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  contentPadding: EdgeInsets.only(left: 8, right: 8),
                  title: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${snapshot.data![index].nopol}"),
                      Text("${snapshot.data![index].merk}")
                    ],
                  ),
                  onTap: () {
                    Navigator.pop(context, snapshot.data![index]);
                  },
                );
              },);
          },
          ),
        );
      case FeatureType.employee:
        return Container(
          height: 300,
          width: SizeConfig.screenWidth * 0.49,
          child: StreamBuilder<List<Employee>> (
            stream: findBloc.employeeController,
            initialData: [],
            builder: (BuildContext context, AsyncSnapshot<List<Employee>> snapshot) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  contentPadding: EdgeInsets.only(left: 8, right: 8),
                  title: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${snapshot.data![index].name}"),
                      Text("${snapshot.data![index].jobDesk}")
                    ],
                  ),
                  onTap: () {
                    Navigator.pop(context, snapshot.data![index]);
                  },
                );
              },);
          },
          ),
        );
      case FeatureType.brands:
        return Container(
          height: 300,
          width: SizeConfig.screenWidth * 0.49,
          child: StreamBuilder<List<Brand>> (
            stream: findBloc.brandController,
            initialData: [],
            builder: (BuildContext context, AsyncSnapshot<List<Brand>> snapshot) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  contentPadding: EdgeInsets.only(left: 8, right: 8),
                  title: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${snapshot.data![index].name}"),
                      Text("${snapshot.data![index].description}")
                    ],
                  ),
                  onTap: () {
                    Navigator.pop(context, snapshot.data![index]);
                  },
                );
              },);
          },
          ),
        );
      case FeatureType.category:
        return Container(
          height: 300,
          width: SizeConfig.screenWidth * 0.49,
          child: StreamBuilder<List<Category>> (
            stream: findBloc.category,
            initialData: [],
            builder: (BuildContext context, AsyncSnapshot<List<Category>> snapshot) {
              if(isSubCategory) {
                return ListView(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton.icon(
                          onPressed: (){
                            setState(() {
                              isSubCategory = false;
                              indexSub = 0;
                            });
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 16.0,
                          ),
                          label: Text("Kembali"),
                          style: ElevatedButton.styleFrom(
                            textStyle: TextStyle(color: Colors.white),
                            padding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
                            primary: Colors.blue
                          ),
                        ),
                      ],
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data![indexSub].subCategory?.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          contentPadding: EdgeInsets.only(left: 8, right: 8),
                          title: Text("${snapshot.data![indexSub].subCategory?[index].name}"),
                          onTap: () {
                            Navigator.pop(context, snapshot.data![indexSub].subCategory?[index]);
                          },
                        );
                      },
                    )
                  ],
                );
              } else {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      contentPadding: EdgeInsets.only(left: 8, right: 8),
                      title: Text("${snapshot.data![index].name}"),
                      onTap: () {
                        if(snapshot.data![index].subCategory!.isNotEmpty){
                          setState(() {
                            isSubCategory = true;
                            indexSub = index;
                          });
                        }
                      },
                    );
                  },
                );
              }
          },
          ),
        );
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    AlertDialog alertDialog = AlertDialog(
      contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      titlePadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      title: Container(
        width: SizeConfig.screenWidth * 0.5,
        color: Colors.blueAccent[400],
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                title(),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.pop(context, null);
              },
              padding: EdgeInsets.only(right: 24.0),
              tooltip: "Tutup",
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
              width: SizeConfig.screenWidth * 0.49,
              child: Focus(
                autofocus: true,
                child: TextFormField(
                  autofocus: true,
                  // focusNode: searchFocus,
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
                    hintText: 'Cari Produk',
                  ),
                  onChanged: (String val) {
                    // receivingsBloc.searchProductReceivings(val);
                  },
                ),
              ),
            ),
            list()
          ],
        ),
      ),
    );
    return alertDialog;
  }
}
