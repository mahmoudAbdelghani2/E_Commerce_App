import 'package:e_commerce_app/controllers/wishlist/wishlist_repo.dart';
import 'package:e_commerce_app/models/product_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'wishlist_state.dart';

class WishlistCubit extends Cubit<WishlistState> {
  final WishlistRepository _repository;

  WishlistCubit(this._repository) : super(WishlistInitial());

  void loadWishlist() {
    emit(WishlistLoading());
    try {
      final items = _repository.getWishlistItems();
      emit(WishlistLoaded(items));
    } catch (e) {
      emit(WishlistError(e.toString()));
    }
  }

  void addToWishlist(ProductModel product) {
    _repository.addToWishlist(product);
    emit(WishlistLoaded(_repository.getWishlistItems()));
  }

  void removeFromWishlist(ProductModel product) {
    _repository.removeFromWishlist(product);
    emit(WishlistLoaded(_repository.getWishlistItems()));
  }

  void clearWishlist() {
    _repository.clearWishlist();
    emit(WishlistLoaded([]));
  }
}
