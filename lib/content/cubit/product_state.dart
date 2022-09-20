part of 'product_cubit.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {

  final List<ProductModel> listProduct;

  ProductLoaded({
    required this.listProduct
  });

  @override
  List<Object> get props => [
    this.listProduct
  ];

}

class ProductAdd extends ProductState {}