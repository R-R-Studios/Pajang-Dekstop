import 'dart:convert';

import 'package:beben_pos_desktop/core/fireship/fireship_box.dart';
import 'package:beben_pos_desktop/units/bloc/unit_bloc.dart';
import 'package:beben_pos_desktop/db/unit_conversions_db.dart';
import 'package:beben_pos_desktop/units/model/units_model.dart';
import 'package:beben_pos_desktop/service/dio_client.dart';
import 'package:beben_pos_desktop/service/dio_service.dart';
import 'package:hive/hive.dart';

class UnitProvider {
  static Future<List<UnitsModel>> getListUnits() async {
    List<UnitsModel> listUnits = [];
    await DioService.checkConnection(
            tryAgainMethod: getListUnits, isUseBearer: true)
        .then((value) async {
      var dio = DioClient(value);
      var list = await dio.getListUnits();
      if (list.meta.code! < 300) {
        for (var i = 0; i < list.data.length; i++) {
          String encode = jsonEncode(list.data[i]);
          listUnits.add(UnitsModel.fromJson(jsonDecode(encode)));
        }
      }
    });
    List<UnitsModel> unitsDB = await UnitBloc().futureUnitListDB();
    for (int i = 0; i < listUnits.length; i++) {
      var check =
          unitsDB.where((element) => element.id == listUnits[i].id).toList();
      if (check.length < 1) {
        await UnitBloc().saveUnitsToDB(listUnits[i]);
      }
    }

    return listUnits;
  }

  static Future<List<UnitConversionDB>> getUnitConversion() async {
    var box =
        await Hive.openBox<UnitConversionDB>(FireshipBox.BOX_UNIT_CONVERSION);
    List<UnitConversionDB> listUnits = [];
    await DioService.checkConnection(
            showMessage: false,
            tryAgainMethod: getUnitConversion,
            isUseBearer: true)
        .then((value) async {
      var dio = DioClient(value);
      var list = await dio.getUnitConversion();
      if (list.meta.code! < 300) {
        for (int i = 0; i < list.data.length; i++) {
          UnitConversionDB unitConversion =
              UnitConversionDB.fromJson(jsonDecode(jsonEncode(list.data[i])));
          listUnits.add(unitConversion);
        }
        box.addAll(listUnits);
        print("db ${jsonEncode(box.values.toList())}");
      }
    });

    return listUnits;
  }
}
