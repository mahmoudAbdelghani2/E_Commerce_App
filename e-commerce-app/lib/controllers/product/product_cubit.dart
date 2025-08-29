import 'package:e_commerce_app/controllers/product/product_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepository _repository;

  ProductCubit(this._repository) : super(ProductInitial());

  Future<void> fetchProducts() async {
    emit(ProductLoading());
    try {
      final products = await _repository.getProducts();
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}
