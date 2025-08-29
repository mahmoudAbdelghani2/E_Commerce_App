import 'package:e_commerce_app/models/product_model.dart';

abstract class CartState {}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<ProductModel> cartItems;
  CartLoaded(this.cartItems);
}

class CartError extends CartState {
  final String message;
  CartError(this.message);
}
