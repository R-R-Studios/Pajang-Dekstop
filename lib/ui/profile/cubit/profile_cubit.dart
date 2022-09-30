
import 'package:beben_pos_desktop/ui/profile/model/repsonse_profile.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../provider/profile_provider.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileLoading()){
    onGetProfile();
  }

  onGetProfile() async {
    emit(ProfileLoaded(responseprofile: await ProfileProvider.profile()));
  }
}
