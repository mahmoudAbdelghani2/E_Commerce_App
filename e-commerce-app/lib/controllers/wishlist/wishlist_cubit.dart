import 'package:e_commerce_app/controllers/wishlist/wishlist_state.dart';
import 'package:e_commerce_app/models/product_model.dart';
import 'package:e_commerce_app/services/firestore_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WishlistCubit extends Cubit<WishlistState> {
  final FirestoreService _firestore;
  final String userId;

  WishlistCubit(this._firestore, this.userId) : super(WishlistInitial());

  Future<void> loadWishlist() async {
    emit(WishlistLoading());
    try {
      final wishlist = await _firestore.fetchWishlist(userId);
      emit(WishlistLoaded(wishlist));
    } catch (e) {
      emit(WishlistError(e.toString()));
    }
  }

  Future<void> addToWishlist(ProductModel product) async {
    try {
      await _firestore.addToWishlist(userId, product);
      await loadWishlist(); // عشان نرجّع الستيت الجديد
    } catch (e) {
      emit(WishlistError(e.toString()));
    }
  }

  Future<void> removeFromWishlist(ProductModel product) async {
    try {
      await _firestore.removeFromWishlist(userId, product.id.toString());
      await loadWishlist();
    } catch (e) {
      emit(WishlistError(e.toString()));
    }
  }

  Future<void> clearWishlist() async {
    try {
      await _firestore.clearWishlist(userId);
      emit(WishlistLoaded([]));
    } catch (e) {
      emit(WishlistError(e.toString()));
    }
  }

  bool isInWishlist(ProductModel product, List<ProductModel> wishlist) {
    return wishlist.any((p) => p.id == product.id);
  }
}
