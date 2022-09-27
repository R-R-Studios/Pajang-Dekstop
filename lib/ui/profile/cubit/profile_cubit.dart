
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../provider/profile_provider.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial()){
    onGetProfile();
  }

  onGetProfile() async {
    await ProfileProvider.profile();
  }
}
