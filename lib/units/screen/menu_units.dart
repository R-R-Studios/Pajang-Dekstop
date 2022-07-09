import 'dart:convert';

import 'package:beben_pos_desktop/core/core.dart';
import 'package:beben_pos_desktop/db/product_model_db.dart';
import 'package:beben_pos_desktop/model/head_column_model.dart';
import 'package:beben_pos_desktop/product/bloc/product_bloc.dart';
import 'package:beben_pos_desktop/units/bloc/unit_bloc.dart';
import 'package:beben_pos_desktop/units/datasource/data_source_units.dart';
import 'package:beben_pos_desktop/units/model/units_model.dart';
import 'package:beben_pos_desktop/units/provider/unit_provider.dart';
import 'package:beben_pos_desktop/utils/global_functions.dart';
import 'package:hive/hive.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MenuUnits extends StatefulWidget {
  @override
  _MenuUnitsState createState() => _MenuUnitsState();
}

class _MenuUnitsState extends State<MenuUnits> {
  List<HeadColumnModel> _headColumnModel = [
    HeadColumnModel(key: "1", name: "ID", ischecked: false),
    HeadColumnModel(key: "2", name: "Name", ischecked: false),
    HeadColumnModel(key: "3", name: "Description", ischecked: false),
    HeadColumnModel(key: "4", name: "Date", ischecked: false)
  ];

  String displayAutoCompleteSearch(UnitsModel units) => units.name!;

  List<String> _exportMap = [
    "JSON",
    "XML",
    "CSV",
    "TXT",
    "SQL",
    "MS-EXCEL",
    "PDF"
  ];

  int _currentSortColumn = 0;
  bool _isSortAscending = false;
  bool _isSearchProduct = false;

  List<UnitsModel> _unitsModel = [];

  UnitBloc unitBloc = UnitBloc();
  bool isRefresh = false;

  String keySearch = "";

  DateTimeRange pickedDateTime = DateTimeRange(
      start: DateTime(2020, 1, 1),
      end: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day));
  late var selectedDateString =
      "${pickedDateTime.start.year}/${pickedDateTime.start.month}/${pickedDateTime.start.day} - ${pickedDateTime.end.year}/${pickedDateTime.end.month}/${pickedDateTime.end.day}";
  late TextEditingController _dateController =
      TextEditingController(text: selectedDateString);
  TextEditingController _productNameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _searchController = TextEditingController();
  UnitsModel newUnits = UnitsModel();
  var _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    unitBloc.initUnitsList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: EdgeInsets.all(10),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.only(right: 5, left: 5),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 5),
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    _showCreateProduct();
                                  },
                                  icon: Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 24.0,
                                  ),
                                  label: Text("New Units"),
                                  style: ElevatedButton.styleFrom(
                                      textStyle: TextStyle(color: Colors.white),
                                      padding: EdgeInsets.only(
                                          left: 20,
                                          right: 20,
                                          top: 15,
                                          bottom: 15),
                                      primary: Color(0xff3498db)),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 5),
                                child: ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.download,
                                    color: Colors.white,
                                    size: 24.0,
                                  ),
                                  label: Text("Import"),
                                  style: ElevatedButton.styleFrom(
                                      textStyle: TextStyle(color: Colors.white),
                                      padding: EdgeInsets.only(
                                          left: 20,
                                          right: 20,
                                          top: 15,
                                          bottom: 15),
                                      primary: Color(0xff3498db)),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 10, right: 5, left: 5),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //Delete & Email
                            Container(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(right: 5),
                                    child: ElevatedButton.icon(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                        size: 24.0,
                                      ),
                                      label: Text("Delete"),
                                      style: ElevatedButton.styleFrom(
                                          textStyle:
                                              TextStyle(color: Colors.white),
                                          padding: EdgeInsets.only(
                                              left: 20,
                                              right: 20,
                                              top: 15,
                                              bottom: 15),
                                          primary: Color(0xff3498db)),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 5),
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        if (!isRefresh) {
                                          isRefresh = true;
                                          unitBloc.getUnitList().then((value) {

                                            isRefresh = false;
                                          });
                                        }
                                      },
                                      icon: Icon(
                                        Icons.refresh,
                                        color: Colors.white,
                                        size: 24.0,
                                      ),
                                      label: Text("Refresh"),
                                      style: ElevatedButton.styleFrom(
                                          textStyle:
                                              TextStyle(color: Colors.white),
                                          padding: EdgeInsets.only(
                                              left: 20,
                                              right: 20,
                                              top: 15,
                                              bottom: 15),
                                          primary: Color(0xff3498db)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                      padding: EdgeInsets.only(right: 5),
                                      child: Container(
                                        width: 200,
                                        // child: Autocomplete<UnitsModel>(
                                        //   fieldViewBuilder: (
                                        //       BuildContext context,
                                        //       TextEditingController fieldTextEditingController,
                                        //       FocusNode fieldFocusNode,
                                        //       VoidCallback onFieldSubmitted
                                        //   ){
                                        //     return TextField(
                                        //       controller: fieldTextEditingController,
                                        //       focusNode: fieldFocusNode,
                                        //         style: TextStyle(
                                        //               fontSize: 14, color: Colors.blue),
                                        //     decoration: InputDecoration(
                                        //           border: OutlineInputBorder(),
                                        //           labelText: "Search"),
                                        //     );
                                        //   },
                                        //   displayStringForOption: (UnitsModel units) => units.name!,
                                        //   optionsBuilder: (TextEditingValue textEditingValue) {
                                        //     if (textEditingValue.text == '') {
                                        //       return  Iterable<UnitsModel>.empty();
                                        //     }
                                        //     return _unitsModel.where((element) {
                                        //       return element.name!.toLowerCase().contains(textEditingValue.text.toLowerCase());
                                        //     });
                                        //   },
                                        //   onSelected: (UnitsModel units){
                                        //     onSearchProduct(units.name!);
                                        //   },
                                        // ),
                                      // )
                                      child: TextField(
                                        controller: _searchController,
                                        onChanged: (value) {
                                          onSearchProduct(value);
                                        },
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.blue),
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: "Search"),
                                      )),
                                      ),
                                  PopupMenuButton(
                                    tooltip: "Filter Field",
                                    icon: Icon(Icons.grid_view_sharp),
                                    itemBuilder: (BuildContext context) =>
                                        <PopupMenuEntry>[
                                      for (final model in _headColumnModel)
                                        PopupMenuItem(
                                          child: StatefulBuilder(
                                            builder: (_context, _setState) =>
                                                CheckboxListTile(
                                              activeColor: Colors.black,
                                              value: model.ischecked,
                                              onChanged: (value) {
                                                _setState(() {
                                                  model.ischecked = value!;
                                                });
                                              },
                                              title: Text(model.name!),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  PopupMenuButton(
                                    tooltip: "Export Data",
                                    icon: Icon(Icons.file_upload_sharp),
                                    itemBuilder: (BuildContext context) =>
                                        <PopupMenuEntry>[
                                      for (final export in _exportMap)
                                        PopupMenuItem(
                                          child: StatefulBuilder(
                                            builder: (_context, _setState) =>
                                                ListTile(
                                              title: Text(export,
                                                  style:
                                                      TextStyle(fontSize: 14)),
                                              onTap: () {
                                                _setState(() {});
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 10),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        StreamBuilder(
                            stream: unitBloc.streamListUnits,
                            builder: (BuildContext context,
                                AsyncSnapshot<List<UnitsModel>> snapshot) {
                              if (snapshot.hasData) {
                                print("DATA UNITS HASDATA ${snapshot.hasData}");
                                if (snapshot.data!.length > 0) {
                                  print(
                                      "DATA UNITS LENGT ${snapshot.data!.length}");
                                  _unitsModel = snapshot.data!;
                                } else {
                                  _unitsModel = [UnitsModel()];
                                }
                                return dataTable();
                              } else {
                                print("DATA UNITS HASDATA ${snapshot.hasData}");
                                return Center(
                                    child: CupertinoActivityIndicator());
                              }
                            })
                      ],
                    ),
                  )
                ])));
  }

  Widget dataTable() {
    return PaginatedDataTable(
      header: Text("Units"),
      sortColumnIndex: _currentSortColumn,
      sortAscending: _isSortAscending,
      columnSpacing: 0,
      horizontalMargin: 0,
      rowsPerPage: _unitsModel.length > 5 ? 5 : _unitsModel.length,
      columns: <DataColumn>[
        for (final header in _headColumnModel)
          DataColumn(
              label: Text(header.name!),
              tooltip: header.name,
              onSort: (columnIndex, _sortAscending) {
                setState(() {
                  _currentSortColumn = columnIndex;
                  _isSortAscending = _sortAscending;
                  unitBloc.sortUnits(_currentSortColumn, _isSortAscending);
                });
              }),
        DataColumn(label: Center(child: Text(""))),
        DataColumn(label: Text("")),
        DataColumn(label: Text("")),
      ],
      source: DataSourceUnits(context, _unitsModel),
    );
  }

  _selectDate(BuildContext context) async {
    final DateTimeRange? dateTime = await showDateRangePicker(
        context: context,
        initialEntryMode: DatePickerEntryMode.inputOnly,
        initialDateRange: pickedDateTime,
        firstDate: DateTime(2020),
        // locale: Locale(_languageCode),
        lastDate: DateTime.now());
    setState(() {
      pickedDateTime = DateTimeRange(
          start: DateTime(
              dateTime!.start.year, dateTime.start.month, dateTime.start.day),
          end: DateTime(
              dateTime.end.year, dateTime.end.month, dateTime.end.day));
      selectedDateString =
          "${pickedDateTime.start.year}/${pickedDateTime.start.month}/${pickedDateTime.start.day} - ${pickedDateTime.end.year}/${pickedDateTime.end.month}/${pickedDateTime.end.day}";
      _dateController.text = selectedDateString;
    });
  }

  void _showCreateProduct() {
    showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
              title: Container(
                width: 500,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("New Units"),
                    IconButton(
                        onPressed: () {
                          Navigator.pop(dialogContext, false);
                        },
                        tooltip: "Close",
                        padding: EdgeInsets.all(0),
                        icon: Icon(Icons.close))
                  ],
                ),
              ),
              content: Padding(
                padding: const EdgeInsets.only(
                    left: 15, right: 15, top: 10, bottom: 10),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 15),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.only(right: 15),
                              width: 200,
                              child: Text("Units Name"),
                            ),
                            Container(
                              width: 300,
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Units Name',
                                  border: OutlineInputBorder(),
                                ),
                                controller: _productNameController,
                                enabled: true,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Enter Units Name';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 15),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.only(right: 15),
                              child: Text("Description"),
                              width: 200,
                            ),
                            Container(
                              width: 300,
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Description',
                                  border: OutlineInputBorder(),
                                ),
                                controller: _descriptionController,
                                enabled: true,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Enter Description';
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
                          onPressed: () {
                            var form = _formKey.currentState;
                            if (form != null && form.validate()) {
                              var name = _productNameController.text;
                              var description = _descriptionController.text;
                              _clearForm();
                              newUnits = UnitsModel(
                                  description: description, name: name);
                              dismissCreateProduct(dialogContext).then((value) {
                                print(
                                    "POST PRODUCT ${DateTime.now().millisecond}");
                                _postCreateUnits(newUnits);
                                // .then((value) {
                                // _postCreateProduct(newProduct);
                                // });
                              });
                              // _postCreateProduct(newProduct);
                            }
                          },
                          child: Text("Submit"),
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
              ));
        });
  }

  _postCreateUnits(UnitsModel productModel) {
    // ProductBloc()
    //     .createProduct(CreateProductModel(product: productModel))
    //     .then((value) {
    //   setState(() {
    //     _isSortProduct = false;
    //   });
    //   refreshProductData();
    // });
    //   Navigator.pop(context);
    // });
  }

  void _clearForm() {
    _productNameController.clear();
    _descriptionController.clear();
  }

  Future dismissCreateProduct(BuildContext dialogContext) async {
    Navigator.pop(dialogContext);
  }

  onSearchProduct(String text) {
    unitBloc.searchUnitsList(text);
    // Future.delayed(Duration(seconds: 3), () {
    //   if (text.length > 4) {
    //     _isSearchProduct = true;
    //     keySearch = text;
    //     refreshProductData();
    //   } else if (keySearch.length > 4 && text.length < 5) {
    //     _isSearchProduct = false;
    //     keySearch = text;
    //     refreshProductData();
    //   }
    // });
  }
}
