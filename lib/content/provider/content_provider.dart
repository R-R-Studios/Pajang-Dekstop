import 'package:beben_pos_desktop/content/model/discount.dart';
import 'package:beben_pos_desktop/content/model/employee.dart';
import 'package:beben_pos_desktop/content/model/employee_create.dart';
import 'package:beben_pos_desktop/content/model/merchant_bank.dart';
import 'package:beben_pos_desktop/content/model/bank_create.dart';
import 'package:beben_pos_desktop/content/model/banner_create.dart';
import 'package:beben_pos_desktop/content/model/merchant_banner.dart';
import 'package:beben_pos_desktop/content/model/vehicle_create.dart';
import 'package:beben_pos_desktop/core/fireship/fireship_encrypt.dart';
import 'package:beben_pos_desktop/delivery/model/vehicle.dart';
import 'package:beben_pos_desktop/service/dio_client.dart';
import 'package:beben_pos_desktop/service/dio_service.dart';
import 'package:beben_pos_desktop/utils/global_functions.dart';

class ContentProvider {

  static Future<List<MerchantBanner>> bannerList() async {
    List<MerchantBanner> list = [];
    await DioService.checkConnection(tryAgainMethod: bannerList, isUseBearer: true, showMessage: true).then((value) async {
      DioClient dioClient = DioClient(value);
      var response = await dioClient.bannerList();
      var banner = ResponseBanner.fromJson(response.data);
      list.addAll(banner.banners!);
    });
    return list;
  }

  static Future bannerCreate(BannerCreate bannerCreate) async {
    await DioService.checkConnection(tryAgainMethod: bannerCreate, isUseBearer: true, showMessage: true, isLoading: true).then((value) async {
      DioClient dioClient = DioClient(value);
      var respose = await dioClient.bannerCreate(bannerCreate);
      GlobalFunctions.log("response", respose);
    });
  }

  static Future<List<Employee>> employeeList() async {
    List<Employee> list = [];
    await DioService.checkConnection(tryAgainMethod: employeeList, isUseBearer: true, showMessage: true).then((value) async {
      DioClient dioClient = DioClient(value);
      var response = await dioClient.employeeList();
      for (var item in response.data) {
        list.add(Employee.fromJson(item));
      }
    });
    return list;
  }

  static Future employeeCreate(EmployeeCreate employeeCreate) async {
    await DioService.checkConnection(tryAgainMethod: employeeCreate, isUseBearer: true, showMessage: true).then((value) async {
      DioClient dioClient = DioClient(value);
      var respose = await dioClient.employeeCreate(employeeCreate.toJson());
      // GlobalFunctions.log("response", respose);
    });
  }

  static Future<List<MerchantBank>> bankList() async {
    List<MerchantBank> list = [];
    await DioService.checkConnection(tryAgainMethod: bankList, isUseBearer: true, showMessage: true).then((value) async {
      DioClient dioClient = DioClient(value);
      var response = await dioClient.bankList();
      GlobalFunctions.log("response", response);
      for (var item in response.data) {
        list.add(MerchantBank.fromJson(item));
      }
    });
    return list;
  }

  static Future bankCreate(BankCreate bankCreate) async {
    await DioService.checkConnection(tryAgainMethod: bankCreate, isUseBearer: true, showMessage: true).then((value) async {
      DioClient dioClient = DioClient(value);
      var respose = await dioClient.bankCreate(bankCreate);
      GlobalFunctions.log("response", respose);
    });
  }

  static Future<List<Discount>> discountList() async {
    List<Discount> list = [];
    await DioService.checkConnection(tryAgainMethod: discountList, isUseBearer: true, showMessage: true).then((value) async {
      DioClient dioClient = DioClient(value);
      var response = await dioClient.discountList();
      for (var item in response.data) {
        list.add(Discount.fromJson(item));
      }
    });
    return list;
  }

  static Future discountCreate(BodyEncrypt bodyEncrypt) async {
    await DioService.checkConnection(tryAgainMethod: discountCreate, isUseBearer: true, showMessage: true).then((value) async {
      DioClient dioClient = DioClient(value);
      var respose = await dioClient.discountCreate(bodyEncrypt.toJson());
      GlobalFunctions.log("response", respose);
    });
  }


  static Future veheicleCreate(VehicleCreate vehicleCreate) async {
    await DioService.checkConnection(tryAgainMethod: discountCreate, isUseBearer: true, showMessage: true).then((value) async {
      DioClient dioClient = DioClient(value);
      var respose = await dioClient.vehicleCreate(vehicleCreate.toJson());
      GlobalFunctions.log("response", respose);
    });
  }

  static Future<List<Vehicle>> vehicleList() async {
    List<Vehicle> list = [];
    await DioService.checkConnection(tryAgainMethod: vehicleList, isUseBearer: true, showMessage: true).then((value) async {
      DioClient dioClient = DioClient(value);
      var response = await dioClient.vehicleList();
      for (var item in response.data) {
        list.add(Vehicle.fromJson(item));
      }
    });
    return list;
  }
}