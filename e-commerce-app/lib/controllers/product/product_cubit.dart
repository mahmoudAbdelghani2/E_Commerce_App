import 'package:e_commerce_app/controllers/product/product_state.dart';
import 'package:e_commerce_app/services/firestore_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit() : super(ProductInitial()) {
    // Load products from Firestore when the cubit is created
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    emit(ProductLoading());
    try {
      final products = await FirestoreService().getProducts();
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError("Error loading products: $e"));
    }
  }
}
