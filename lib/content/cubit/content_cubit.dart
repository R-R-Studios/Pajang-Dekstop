import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'content_state.dart';

enum ContentMenu {initial, banner, product, bank, employee, discount}

class ContentCubit extends Cubit<ContentState> {

  ContentCubit() : super(ContentInitial());

  navgation(ContentMenu contentMenu) {
    switch (contentMenu) {
      case ContentMenu.initial:
        emit(ContentInitial());
        break;
      case ContentMenu.banner:
        emit(ContentBanner());
        break;
      case ContentMenu.product:
        emit(ContentProduct());
        break;
      case ContentMenu.bank:
        emit(ContentBank());
        break;  
      case ContentMenu.employee:
        emit(ContentEmployee());
        break;  
      case ContentMenu.discount:
        emit(ContentDiscount());
        break;  
      default:
    }
  }

}
