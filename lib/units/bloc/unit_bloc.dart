import 'dart:convert';

import 'package:beben_pos_desktop/db/units_db.dart';
import 'package:beben_pos_desktop/receivings/model/price_list_model.dart';
import 'package:beben_pos_desktop/units/model/units_model.dart';
import 'package:beben_pos_desktop/units/provider/unit_provider.dart';
import 'package:hive/hive.dart';
import 'package:rxdart/rxdart.dart';

class UnitBloc {
  List<UnitsModel> listUnits = [];
  List<PriceList> listPrice = [];

  BehaviorSubject<List<UnitsModel>> listUnitsController =
      new BehaviorSubject<List<UnitsModel>>();

  Stream<List<UnitsModel>> get streamListUnits => listUnitsController.stream;

  BehaviorSubject<List<PriceList>> listPriceController =
      new BehaviorSubject<List<PriceList>>();

  Stream<List<PriceList>> get streamListPrice => listPriceController.stream;

  Future getUnitList() async {
    listUnits.clear();
    listUnits.addAll(await futureUnitList());
    listUnitsController.sink.add(listUnits);
  }

  Future<List<UnitsModel>> futureUnitList() async {
    List<UnitsModel> listUnits = [];
    listUnits.addAll(await UnitProvider.getListUnits());
    listUnits.sort((idA, idB) => idA.id!.compareTo(idB.id!));
    return listUnits;
  }

  initUnitsList() async {
    List<UnitsModel> unitsDB = await futureUnitListDB();
    if (unitsDB.length > 0) {
      print("UNIT LIST DB");
      getUnitListDB();
    } else {
      print("UNIT LIST API");
      getUnitList();
    }
  }

  saveUnitsToDB(UnitsModel unitsModel) async {
    var box = await Hive.openBox<UnitsDB>("units_db");
    var units = UnitsDB(
      id: unitsModel.id,
      name: unitsModel.name,
      description: unitsModel.description,
      createdAt: unitsModel.createdAt,
      updatedAt: unitsModel.updatedAt,
    );
    box.add(units);
  }

  getUnitListDB() async {
    listUnits.clear();
    listUnits.addAll(await futureUnitListDB());
    listUnitsController.sink.add(listUnits);
  }

  Future<List<UnitsModel>> futureUnitListDB() async {
    List<UnitsModel> unitsList = [];
    final box = await Hive.openBox<UnitsDB>("units_db");
    List<UnitsDB> unitsDB = box.values.toList();
    for (UnitsDB units in unitsDB) {
      unitsList.add(UnitsModel(
          id: units.id,
          name: units.name,
          description: units.description,
          createdAt: units.createdAt,
          updatedAt: units.updatedAt));
    }
    unitsList.sort((idA, idB) => idA.id!.compareTo(idB.id!));
    return unitsList;
  }

  sortUnits(int columnIndex, bool _sortAscending) async {
    List<UnitsModel> list = listUnits;
    if (_sortAscending == true) {
      if (columnIndex == 0)
        list.sort((idA, idB) => idA.id!.compareTo(idB.id!));
      else if (columnIndex == 1)
        list.sort((idA, idB) =>
            idA.name!.toLowerCase().compareTo(idB.name!.toLowerCase()));
      else if (columnIndex == 2)
        list.sort((idA, idB) => idA.description!
            .toLowerCase()
            .compareTo(idB.description!.toLowerCase()));
      else if (columnIndex == 3)
        list.sort((idA, idB) => idA.updatedAt!.compareTo(idB.updatedAt!));
    } else {
      if (columnIndex == 0)
        list.sort((idA, idB) => idB.id!.compareTo(idA.id!));
      else if (columnIndex == 1)
        list.sort((idA, idB) =>
            idB.name!.toLowerCase().compareTo(idA.name!.toLowerCase()));
      else if (columnIndex == 2)
        list.sort((idA, idB) => idB.description!
            .toLowerCase()
            .compareTo(idA.description!.toLowerCase()));
      else if (columnIndex == 3)
        list.sort((idA, idB) => idB.updatedAt!.compareTo(idA.updatedAt!));
    }
    return list;
  }

  searchPriceList(String search) async {
    List<PriceList> list = listPrice;
    list = list.where((element) {
      return jsonEncode(element).toLowerCase().contains(search.toLowerCase());
    }).toList();
    print("listPrice ${jsonEncode(listPrice)}");
    print("list ${jsonEncode(list)}");
    listPriceController.sink.add(list);
  }

  initPriceList(List<PriceList> list) async {
    listPrice = list;
    listPriceController.sink.add(listPrice);
  }

  searchUnitsList(String search) async {
    List<UnitsModel> listSearch = listUnits;
    listSearch = listSearch.where((element) {
      return jsonEncode(element).toLowerCase().contains(search.toLowerCase());
    }).toList();
    listUnitsController.sink.add(listSearch);
  }

  init() {
    listUnitsController.sink.add(listUnits);
    listPriceController.sink.add(listPrice);
  }

  close() {
    listUnitsController.close();
    listPriceController.close();
  }
}
