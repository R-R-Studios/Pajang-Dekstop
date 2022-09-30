part of 'profile_cubit.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoaded extends ProfileState {
  
  final Responseprofile responseprofile;

  ProfileLoaded({
    required this.responseprofile
  });

  @override
  List<Object> get props => [
    responseprofile
  ];

}

class ProfileLoading extends ProfileState {}
