import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/product_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> uploadProductsFromJson() async {
    try {
      final String response = await rootBundle.loadString('assets/json/ecommerce_products.json');
      final List<dynamic> data = json.decode(response);

      for (var item in data) {
        final product = ProductModel.fromJson(item as Map<String, dynamic>);
        final docRef = _firestore.collection('products').doc(product.id.toString());

        final map = {
          'id': product.id,
          'title': product.title,
          'price': product.price,
          'description': product.description,
          'category': product.category,
          'image': product.image,
          'brand': product.brand,
          'rating': product.rating != null
              ? {'rate': product.rating!.rate, 'count': product.rating!.count}
              : null,
        }..removeWhere((k, v) => v == null);

        await docRef.set(map);

        final images = (item['images'] as List?)?.map((e) => e.toString()).toList() ?? [];
        for (final img in images) {
          await docRef.collection('product_images').add({'image': img});
        }
      }

      if (kDebugMode) debugPrint('Products uploaded successfully');
    } catch (e) {
      if (kDebugMode) debugPrint('Error uploading products: $e');
    }
  }

  Future<List<ProductModel>> getProducts() async {
    final snapshot = await _firestore.collection('products').get();
    return snapshot.docs.map((d) => ProductModel.fromJson(d.data())).toList();
  }

  Future<ProductModel?> getProductById(String id) async {
    final snap = await _firestore.collection('products').doc(id).get();
    if (!snap.exists) return null;
    return ProductModel.fromJson(snap.data()!);
  }

  Future<Map<String, dynamic>?> getProductWithDetails(String id) async {
    final docRef = _firestore.collection('products').doc(id);
    final snap = await docRef.get();
    if (!snap.exists || snap.data() == null) return null;

    final product = {...snap.data()!, 'docId': snap.id};

    final imgsSnap = await docRef.collection('product_images').get();
    final images = imgsSnap.docs.map((d) => d.data()).toList();

    final reviewsSnap = await docRef.collection('reviews').orderBy('createdAt', descending: true).get();
    final reviews = reviewsSnap.docs.map((d) => d.data()).toList();

    return {'product': product, 'images': images, 'reviews': reviews};
  }
}
