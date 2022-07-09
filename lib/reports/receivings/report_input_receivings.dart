import 'dart:convert';

import 'package:beben_pos_desktop/db/product_model_db.dart';
import 'package:beben_pos_desktop/db/product_receivings_db.dart';
import 'package:beben_pos_desktop/db/profile_db.dart';
import 'package:beben_pos_desktop/profile/bloc/profile_bloc.dart';
import 'package:beben_pos_desktop/receivings/bloc/receivings_bloc.dart';
import 'package:beben_pos_desktop/receivings/model/product_receivings_model.dart';
import 'package:beben_pos_desktop/reports/bloc/report_bloc.dart';
import 'package:beben_pos_desktop/reports/receivings/bloc/report_receivings_bloc.dart';
import 'package:beben_pos_desktop/reports/receivings/model/report_receivings_model.dart';
import 'package:beben_pos_desktop/reports/receivings/model/search_report_receivings.dart';
import 'package:beben_pos_desktop/reports/receivings/report_receivings.dart';
import 'package:beben_pos_desktop/utils/global_functions.dart';
import 'package:beben_pos_desktop/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReportInputReceivings extends StatefulWidget {
  ReportInputReceivings(this.reportBloc);

  final ReportBloc reportBloc;

  @override
  _ReportInputReceivingsState createState() => _ReportInputReceivingsState();
}

class _ReportInputReceivingsState extends State<ReportInputReceivings> {
  DateTimeRange pickedDateTime = DateTimeRange(
      start: DateTime(2021, 10, 1),
      end: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day));

  late var selectedDateString =
      "${pickedDateTime.start.year}/${pickedDateTime.start.month}/${pickedDateTime.start.day} - ${pickedDateTime.end.year}/${pickedDateTime.end.month}/${pickedDateTime.end.day}";

  late var startDate =
      "${pickedDateTime.start.year}-${pickedDateTime.start.month}-${pickedDateTime.start.day}";
  late var endDate =
      "${pickedDateTime.end.year}-${pickedDateTime.end.month}-${pickedDateTime.end.day}";

  late TextEditingController _dateController =
      TextEditingController(text: selectedDateString);

  List<ProductReceivingsModel> _productReceivings = [];
  List<ProductReceivingsModel> baseProduct = [];

  bool isAllProduct = true;
  bool isAllUnit = false;

  bool isSearchReportReceivings = false;

  ProductReceivingsModel selectedProduct = ProductReceivingsModel();
  late ReportBloc reportBloc = widget.reportBloc;

  List<ReportReceivingsModel> listReport = [];

  ProfileDB profile = ProfileDB();

  final TextEditingController _controllerAutoComplete = TextEditingController();
  final FocusNode _focusAutoComplete = FocusNode();
  final GlobalKey _autocompleteKey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ProfileBloc().getProfile().then((value) {
      profile = value;
    });
    setState(() {
      isSearchReportReceivings = false;
    });
    reportBloc.streamSearchReportReceivings.listen((event) {
      viewSearchState(event);
    });
    getProductReportReceivings();
  }

  viewSearchState(bool value) {
    setState(() {
      isSearchReportReceivings = value;
      if (value = true) {
        print("is null");
        selectedProduct = ProductReceivingsModel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return !isSearchReportReceivings
        ? Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            reportBloc.setToReportView("");
                          });
                        },
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 16.0,
                        ),
                        style: ElevatedButton.styleFrom(
                            textStyle: TextStyle(color: Colors.white),
                            padding: EdgeInsets.only(
                                left: 20, right: 20, top: 15, bottom: 15),
                            primary: Color(0xff3498db)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          "Laporan Penerimaan",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, bottom: 8, top: 14),
                  child: Row(
                    children: [
                      Text(
                        "Periode : ",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 6, right: 6),
                        child: Container(
                            width: SizeConfig.screenWidth * 0.125,
                            child: GestureDetector(
                              onTap: () => _selectDate(context),
                              child: AbsorbPointer(
                                child: TextFormField(
                                  controller: _dateController,
                                  keyboardType: TextInputType.datetime,
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black),
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      isDense: true,
                                      contentPadding:
                                          EdgeInsets.fromLTRB(8, 14.0, 8, 14.0),
                                      // labelStyle: TextStyle(color: Colors.black87),
                                      //   focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: GlobalColorPalette.colorButtonActive)),
                                      border: OutlineInputBorder()),
                                ),
                              ),
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: ElevatedButton(
                              onPressed: () {
                                print("Controller ${_controllerAutoComplete.text}");
                                ReportReceivingsBloc().searchReportReceivings("${profile.merchantId}", _controllerAutoComplete.text, startDate, endDate).then((value) {
                                  setState(() {
                                    listReport = value;
                                    if(listReport.length > 0){
                                      isSearchReportReceivings = true;
                                    }else{
                                      GlobalFunctions.showSnackBarWarning("Laporan Tidak Ditemukan");
                                    }
                                  });
                                });
                              },
                              child: Text("Cari"),
                              style: ElevatedButton.styleFrom(
                                  textStyle: TextStyle(color: Colors.white),
                                  padding: EdgeInsets.only(
                                      left: 20, right: 20, top: 15, bottom: 15),
                                  primary: Color(0xff3498db)),
                            )),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, bottom: 8),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: Row(
                        children: [
                          Text(
                            "Semua Produk : ",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Checkbox(
                            value: isAllProduct,
                            onChanged: (bool? value) {
                              setState(() {
                                _controllerAutoComplete.text = "";
                                selectedProduct = ProductReceivingsModel();
                                isAllProduct = value!;
                              });
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                !isAllProduct ? autoCompleteProduct() : Container(),
              ],
            ),
          )
        : ReportReceivings(
            SearchReportReceivings(selectedDateString, selectedProduct),
            reportBloc,
            listReport);
  }

  Widget autoCompleteProduct() {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Row(
        children: [
          Text(
            "Nama Produk : ",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          // _oldAutoComplete(),
          _newAutoComplete(),
        ],
      ),
    );
  }

  _selectDate(BuildContext context) async {
    final DateTimeRange? dateTime = await showDateRangePicker(
            context: context,
            initialEntryMode: DatePickerEntryMode.inputOnly,
            initialDateRange: pickedDateTime,
            firstDate: DateTime(2021),
            // locale: Locale(_languageCode),
            lastDate: DateTime.now())
        .then((value) {});
    if (dateTime != null) {
      setState(() {
        pickedDateTime = DateTimeRange(
            start: DateTime(
                dateTime.start.year, dateTime.start.month, dateTime.start.day),
            end: DateTime(
                dateTime.end.year, dateTime.end.month, dateTime.end.day));
        startDate =
            "${pickedDateTime.start.year}-${pickedDateTime.start.month}-${pickedDateTime.start.day}";
        endDate =
            "${pickedDateTime.end.year}-${pickedDateTime.end.month}-${pickedDateTime.end.day}";
        selectedDateString =
            "${pickedDateTime.start.year}-${pickedDateTime.start.month}-${pickedDateTime.start.day} - ${pickedDateTime.end.year}-${pickedDateTime.end.month}-${pickedDateTime.end.day}";
        _dateController.text = selectedDateString;
      });
    }
  }

  void getProductReportReceivings() async {
    baseProduct = await reportBloc.initProductReportReceivings();
    _productReceivings = baseProduct;
  }

  Future<List<ProductReceivingsModel>> onSearchProductReportReceivings(
      textEditingValue) async {
    List<ProductReceivingsModel> list =
        await reportBloc.initProductReportReceivings();
    _productReceivings = list.where((element) {
      return element.name!
          .toLowerCase()
          .contains(textEditingValue.text.toLowerCase());
    }).toList();
    return _productReceivings;
  }

  Widget _oldAutoComplete() {
    return Container(
      width: 200,
      child: Autocomplete<ProductReceivingsModel>(
        fieldViewBuilder: (BuildContext context,
            TextEditingController fieldTextEditingController,
            FocusNode fieldFocusNode,
            VoidCallback onFieldSubmitted) {
          return TextFormField(
            controller: fieldTextEditingController,
            focusNode: fieldFocusNode,
            onFieldSubmitted: (value) {
              onFieldSubmitted();
            },
            style: TextStyle(fontSize: 14, color: Colors.black),
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                isDense: true,
                contentPadding: EdgeInsets.fromLTRB(8, 14.0, 8, 14.0),
                // labelStyle: TextStyle(color: Colors.black87),
                //   focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: GlobalColorPalette.colorButtonActive)),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black))),
          );
        },
        displayStringForOption: (ProductReceivingsModel product) =>
            product.name!,
        optionsViewBuilder: (context,
            AutocompleteOnSelected<ProductReceivingsModel> onSelected,
            Iterable<ProductReceivingsModel> options) {
          return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4.0,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.3,
                    maxWidth: MediaQuery.of(context).size.width * 0.15,
                  ),
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _productReceivings.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            onSelected(_productReceivings[index]);
                          },
                          child: ListTile(
                            title: Text(_productReceivings[index].name!),
                          ),
                        );
                      }),
                ),
              ));
        },
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text == '') {
            return Iterable<ProductReceivingsModel>.empty();
          }
          _productReceivings = baseProduct.where((element) {
            return element.name!
                .toLowerCase()
                .contains(textEditingValue.text.toLowerCase());
          }).toList();
          return _productReceivings;
        },
        onSelected: (ProductReceivingsModel product) {
          selectedProduct = product;
          print("ProductReceivingsModel Selected ${jsonEncode(product)}");
        },
      ),
    );
  }

  Widget _newAutoComplete() {
    return Container(
      width: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _controllerAutoComplete,
            focusNode: _focusAutoComplete,
            style: TextStyle(fontSize: 14, color: Colors.black),
            onFieldSubmitted: (String value) {
              RawAutocomplete.onFieldSubmitted<String>(_autocompleteKey);
            },
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                isDense: true,
                contentPadding: EdgeInsets.fromLTRB(8, 14.0, 8, 14.0),
                // labelStyle: TextStyle(color: Colors.black87),
                //   focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: GlobalColorPalette.colorButtonActive)),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black))),
          ),
          RawAutocomplete(
              key: _autocompleteKey,
              textEditingController: _controllerAutoComplete,
              focusNode: _focusAutoComplete,
              displayStringForOption: (ProductReceivingsModel product) =>
                  product.name!,
              optionsViewBuilder: (context,
                  AutocompleteOnSelected<ProductReceivingsModel> onSelected,
                  Iterable<ProductReceivingsModel> options) {
                return Align(
                    alignment: Alignment.topLeft,
                    child: Material(
                      elevation: 4.0,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.3,
                          maxWidth: MediaQuery.of(context).size.width * 0.15,
                        ),
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _productReceivings.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  onSelected(_productReceivings[index]);
                                },
                                child: ListTile(
                                  title:
                                      Text(_productReceivings[index].name!),
                                ),
                              );
                            }),
                      ),
                    ));
              },
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text == '') {
                  return Iterable<ProductReceivingsModel>.empty();
                }
                _productReceivings = baseProduct.where((element) {
                  return element.name!
                      .toLowerCase()
                      .contains(textEditingValue.text.toLowerCase());
                }).toList();
                return _productReceivings;
              },
              onSelected: (ProductReceivingsModel product) {
                selectedProduct = product;
                print(
                    "ProductReceivingsModel Selected ${jsonEncode(product)}");
              })
        ],
      ),
    );
  }
}
