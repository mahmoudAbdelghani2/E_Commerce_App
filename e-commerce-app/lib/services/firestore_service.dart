import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/product_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// رفع المنتجات من ملف JSON للفايرستور
  Future<void> uploadProductsFromJson() async {
    try {
      // اقرأ ملف JSON من الـ assets
      final String response =
          await rootBundle.loadString('assets/json/ecommerce_products.json');
      final List<dynamic> data = json.decode(response);

      for (var item in data) {
        final product = ProductModel.fromJson(item);
        await _firestore
            .collection('products')
            .doc(product.id.toString()) // خلي id بتاع JSON هو الـ docId
            .set({
          'id': product.id,
          'title': product.title,
          'price': product.price,
          'description': product.description,
          'category': product.category,
          'image': product.image,
          'rating': {
            'rate': product.rating?.rate,
            'count': product.rating?.count,
          }
        });
      }

      debugPrint("Products uploaded successfully!");
    } catch (e) {
      debugPrint("Error uploading products: $e");
    }
  }

  /// جلب كل المنتجات
  Future<List<ProductModel>> getProducts() async {
    try {
      debugPrint("Fetching products from Firestore...");
      final snapshot = await _firestore.collection('products').get();
      debugPrint("Products fetched: ${snapshot.docs.length}");
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return ProductModel.fromJson(data);
      }).toList();
    } catch (e) {
      throw Exception("Error getting products: $e");
    }
  }

  /// جلب منتج واحد بالـ id
  Future<ProductModel?> getProductById(String id) async {
    try {
      final snapshot = await _firestore.collection('products').doc(id).get();
      if (snapshot.exists) {
        return ProductModel.fromJson(snapshot.data()!);
      }
      return null;
    } catch (e) {
      throw Exception("Error getting product: $e");
    }
  }
}
