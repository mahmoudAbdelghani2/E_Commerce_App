import 'package:e_commerce_app/controllers/product/product_state.dart';
import 'package:e_commerce_app/services/firestore_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductCubit extends Cubit<ProductState> {
  final FirestoreService _firestore;

  ProductCubit(this._firestore) : super(ProductInitial());

  Future<void> fetchProducts({bool force = false}) async {
    if (!force && state is ProductLoaded) return;

    emit(ProductLoading());
    try {
      final products = await _firestore.fetchProducts();
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError("Error: $e"));
    }
  }
}
