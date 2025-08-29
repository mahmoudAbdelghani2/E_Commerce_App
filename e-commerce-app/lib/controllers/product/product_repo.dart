import 'package:e_commerce_app/models/product_model.dart';
import '../../services/firestore_service.dart';

class ProductRepository {
  final FirestoreService _service;
  ProductRepository(this._service);

  Future<List<ProductModel>> getProducts() async {
    return await _service.getProducts();
  }
}
