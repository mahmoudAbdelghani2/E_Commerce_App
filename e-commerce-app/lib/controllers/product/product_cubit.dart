import 'package:e_commerce_app/controllers/product/product_state.dart';
import 'package:e_commerce_app/models/product_model.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit() : super(ProductInitial());

  Future<void> fetchProducts() async {
    try {
      emit(ProductLoading());
      // Load products from the local JSON file
      final String response =
          await rootBundle.loadString('assets/json/ecommerce_products.json');
      final data = await json.decode(response) as List;
      final products =
          data.map((product) => ProductModel.fromJson(product)).toList();
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}

