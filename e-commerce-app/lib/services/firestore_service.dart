import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/models/review_model.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:e_commerce_app/models/product_model.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;

  Future<void> addProductsFromJson() async {
    try {
      final jsonStr = await rootBundle.loadString('assets/json/ecommerce_products.json');
      final List data = json.decode(jsonStr);

      for (final item in data) {
        final product = ProductModel.fromJson(item);

        final docRef = _db.collection('products').doc(product.id.toString());
        await docRef.set(product.toJson());

        final images = (item['images'] as List?)?.map((e) => e.toString()).toList() ?? [];
        for (final img in images) {
          await docRef.collection('product_images').add({'image': img});
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ProductModel>> fetchProducts() async {
    final snapshot = await _db.collection('products').get();
    final products = <ProductModel>[];

    for (final doc in snapshot.docs) {
      final product = ProductModel.fromJson(doc.data());

      final imgsSnap = await doc.reference.collection('product_images').get();
      final images = imgsSnap.docs
          .map((d) => d.data()['image'] as String?)
          .whereType<String>()
          .toList();

      if (images.isNotEmpty) {
        product.images = images;
        product.image ??= images.first;
      }

      products.add(product);
    }

    return products;
  }

  Future<void> addReview(String productId, ReviewModel review) async {
  final collectionRef = _db.collection('products').doc(productId).collection('reviews');
  await collectionRef.add(review.toJson()); 
}

Future<List<ReviewModel>> fetchReviews(String productId) async {
  final snapshot = await _db
      .collection('products')
      .doc(productId)
      .collection('reviews')
      .orderBy('timestamp', descending: true)
      .get();

  return snapshot.docs.map((doc) => ReviewModel.fromJson(doc.data())).toList();
}

Future<void> addToWishlist(String userId, ProductModel product) async {
    final docRef = _db
        .collection('users')
        .doc(userId)
        .collection('wishlist')
        .doc(product.id.toString());

    await docRef.set(product.toJson());
  }

  Future<void> removeFromWishlist(String userId, String productId) async {
    final docRef = _db
        .collection('users')
        .doc(userId)
        .collection('wishlist')
        .doc(productId);

    await docRef.delete();
  }

  Future<List<ProductModel>> fetchWishlist(String userId) async {
    final snapshot = await _db
        .collection('users')
        .doc(userId)
        .collection('wishlist')
        .get();

    return snapshot.docs
        .map((doc) => ProductModel.fromJson(doc.data()))
        .toList();
  }

  Future<void> clearWishlist(String userId) async {
    final ref = _db.collection('users').doc(userId).collection('wishlist');
    final snapshot = await ref.get();
    for (final doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }
}
