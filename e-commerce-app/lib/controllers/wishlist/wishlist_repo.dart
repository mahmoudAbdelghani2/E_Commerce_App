import 'package:e_commerce_app/models/product_model.dart';

class WishlistRepository {
  final List<ProductModel> _wishlist = [];

  List<ProductModel> getWishlistItems() => List.unmodifiable(_wishlist);

  void addToWishlist(ProductModel product) {
    if (!_wishlist.any((p) => p.id == product.id)) {
      _wishlist.add(product);
    }
  }

  void removeFromWishlist(ProductModel product) {
    _wishlist.removeWhere((p) => p.id == product.id);
  }

  void clearWishlist() {
    _wishlist.clear();
  }
}
