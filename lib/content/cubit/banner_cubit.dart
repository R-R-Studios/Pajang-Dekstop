import 'package:beben_pos_desktop/content/model/banner_create.dart';
import 'package:beben_pos_desktop/content/provider/content_provider.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'banner_state.dart';

class BannerCubit extends Cubit<BannerState> {

  BannerCubit() : super(BannerInitial()){
    onGetBanner();
  }

  onGetBanner() async {
    await ContentProvider.bannerList();
    await ContentProvider.employeeList();
  }

  create(BannerCreate bannerCreate) async {
    await ContentProvider.bannerCreate(bannerCreate);
  }

}
