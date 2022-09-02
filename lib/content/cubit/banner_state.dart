part of 'banner_cubit.dart';

abstract class BannerState extends Equatable {
  const BannerState();

  @override
  List<Object> get props => [];
}

class BannerInitial extends BannerState {}

class BannerLoaded extends BannerState {

  final List<MerchantBanner> list;

  BannerLoaded({
    required this.list
  });

  @override
  List<Object> get props => [list];

}

class BannerEmpty extends BannerState {}

class BannerLoading extends BannerState {}
