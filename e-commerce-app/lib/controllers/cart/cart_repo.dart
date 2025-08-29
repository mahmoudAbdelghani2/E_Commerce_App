import 'package:e_commerce_app/models/product_model.dart';

class CartRepository {
  final List<ProductModel> _cart = [];

  List<ProductModel> getCartItems() => List.unmodifiable(_cart);

  void addToCart(ProductModel product) {
    if (!_cart.any((p) => p.id == product.id)) {
      _cart.add(product);
    }
  }

  void removeFromCart(ProductModel product) {
    _cart.removeWhere((p) => p.id == product.id);
  }

  void clearCart() {
    _cart.clear();
  }
}
