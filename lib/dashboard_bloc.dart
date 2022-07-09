import 'package:beben_pos_desktop/db/profile_db.dart';
import 'package:beben_pos_desktop/profile/bloc/profile_bloc.dart';
import 'package:rxdart/rxdart.dart';

class DashboardBloc {

  String scanBarcode = "";
  BehaviorSubject<String> scanBarcodeController = new BehaviorSubject();
  Stream<String> get scanBarcodeDashboard => scanBarcodeController.stream;

  ProfileDB profile = ProfileDB();
  BehaviorSubject<ProfileDB> profileController = BehaviorSubject();
  Stream<ProfileDB> get streamProfile => profileController.stream;

  openAddProduct(bool value, String text){
    if(value){
      scanBarcode = text;
      scanBarcodeController.sink.add(scanBarcode);
    }
  }

  getProfileDB() async {
    var db = await ProfileBloc().getProfile();
    profile = db;
    profileController.sink.add(profile);
  }

  Future<String> getMerchantName() async {
    var db = await ProfileBloc().getProfile();
    profile = db;
    return profile.merchantName!;
  }

  close(){
    scanBarcodeController.close();
    profileController.close();
  }
}