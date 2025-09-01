import 'package:e_commerce_app/models/product_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'wishlist_state.dart';

class WishlistCubit extends Cubit<WishlistState> {
  final List<ProductModel> _wishlist = [];

  WishlistCubit() : super(WishlistInitial());

  void loadWishlist() {
    emit(WishlistLoading());
    try {
      emit(WishlistLoaded(List.unmodifiable(_wishlist)));
    } catch (e) {
      emit(WishlistError(e.toString()));
    }
  }

  void addToWishlist(ProductModel product) {
    if (!isInWishlist(product)) {
      // Update the product's wishlist status before adding
      product.isAddedToWishlist = true;
      _wishlist.add(product);
    }
    emit(WishlistLoaded(List.unmodifiable(_wishlist)));
  }

  void removeFromWishlist(ProductModel product) {
    // Update the product's wishlist status before removing
    product.isAddedToWishlist = false;
    _wishlist.removeWhere((p) => p.id == product.id);
    emit(WishlistLoaded(List.unmodifiable(_wishlist)));
  }
  
  // Check if a product is in the wishlist by ID
  bool isInWishlist(ProductModel product) {
    return _wishlist.any((p) => p.id == product.id);
  }
  
  // Synchronize product's wishlist status with the actual wishlist
  void syncWishlistStatus(List<ProductModel> products) {
    for (var product in products) {
      product.isAddedToWishlist = isInWishlist(product);
    }
  }

  void clearWishlist() {
    _wishlist.clear();
    emit(WishlistLoaded([]));
  }
}
