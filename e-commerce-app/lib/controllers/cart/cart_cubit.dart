import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce_app/controllers/cart/cart_state.dart';
import 'package:e_commerce_app/models/product_model.dart';

class CartCubit extends Cubit<CartState> {
  final List<ProductModel> _cart = [];
  final double _taxPerItem = 4.00;
  
  CartCubit() : super(CartInitial());

  void loadCart() {
    emit(CartLoading());
    try {
      emit(CartLoaded(getCartItems()));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  List<ProductModel> getCartItems() => List.unmodifiable(_cart);
  
  bool isInCart(ProductModel product) {
    return _cart.any((p) => p.id == product.id);
  }

  void addToCart(ProductModel product) {
    emit(CartLoading());
    try {
      int index = _cart.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        _cart[index] = _cart[index].copyWith(quantity: _cart[index].quantity + 1);
      } else {
        _cart.add(product.copyWith(quantity: 1));
      }
      emit(CartLoaded(getCartItems()));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  void removeFromCart(ProductModel product) {
    emit(CartLoading());
    try {
      _cart.removeWhere((p) => p.id == product.id);
      emit(CartLoaded(getCartItems()));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  void increaseQuantity(ProductModel product) {
    emit(CartLoading());
    try {
      int index = _cart.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        _cart[index] = _cart[index].copyWith(quantity: _cart[index].quantity + 1);
        emit(CartLoaded(getCartItems()));
      }
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  void decreaseQuantity(ProductModel product) {
    emit(CartLoading());
    try {
      int index = _cart.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        if (_cart[index].quantity > 1) {
          _cart[index] = _cart[index].copyWith(quantity: _cart[index].quantity - 1);
        } else {
          _cart.removeAt(index);
        }
        emit(CartLoaded(getCartItems()));
      }
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  void clearCart() {
    emit(CartLoading());
    try {
      _cart.clear();
      emit(CartLoaded(getCartItems()));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  double getSubtotal() {
    return _cart.fold(0, (sum, item) => sum + ((item.price ?? 0) * item.quantity));
  }

  double getTaxTotal() {
    return _cart.fold(0, (sum, item) => sum + (_taxPerItem * item.quantity));
  }

  double getTotal() {
    return getSubtotal() + getTaxTotal();
  }

  int getItemCount() {
    return _cart.fold(0, (sum, item) => sum + item.quantity);
  }

  double get taxPerItem => _taxPerItem;
}