import 'package:e_commerce_app/controllers/cart/cart_repo.dart';
import 'package:e_commerce_app/models/product_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final CartRepository _repository;

  CartCubit(this._repository) : super(CartInitial());

  void loadCart() {
    emit(CartLoading());
    try {
      final items = _repository.getCartItems();
      emit(CartLoaded(items));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  void addToCart(ProductModel product) {
    _repository.addToCart(product);
    emit(CartLoaded(_repository.getCartItems()));
  }

  void removeFromCart(ProductModel product) {
    _repository.removeFromCart(product);
    emit(CartLoaded(_repository.getCartItems()));
  }

  void clearCart() {
    _repository.clearCart();
    emit(CartLoaded([]));
  }
}
