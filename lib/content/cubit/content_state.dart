part of 'content_cubit.dart';

abstract class ContentState extends Equatable {

  const ContentState();

  @override
  List<Object> get props => [];
}

class ContentInitial extends ContentState {}

class ContentBanner extends ContentState {}

class ContentProduct extends ContentState {}

class ContentBank extends ContentState {}

class ContentEmployee extends ContentState {}
