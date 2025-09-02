// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:e_commerce_app/models/review_model.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'review_state.dart';

class ReviewCubit extends Cubit<ReviewState> {
  ReviewCubit() : super(ReviewInitial());

  Future<void> loadReviews(String productId) async {
    emit(ReviewLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString('reviews_$productId');

      if (saved != null) {
        final data = jsonDecode(saved) as List;
        final reviews = data.map((e) => ReviewModel.fromJson(e)).toList();
        emit(ReviewLoaded(reviews));
      } else {
        emit(ReviewLoaded([]));
      }
    } catch (e) {
      emit(ReviewError("Error: $e"));
    }
  }

  Future<void> addReview(String productId, ReviewModel review) async {
    emit(ReviewLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString('reviews_$productId');

      List<ReviewModel> reviews = [];
      if (saved != null) {
        final data = jsonDecode(saved) as List;
        reviews = data.map((e) => ReviewModel.fromJson(e)).toList();
      }

      final newReview = ReviewModel(
        name: review.name,
        experience: review.experience,
        rating: review.rating,
        timestamp: DateTime.now(),
      );
      reviews.add(newReview);

      final jsonData = jsonEncode(reviews.map((r) => r.toJson()).toList());
      await prefs.setString('reviews_$productId', jsonData);

      emit(ReviewLoaded(reviews));
    } catch (e) {
      emit(ReviewError("Error: $e"));
    }
  }

  double getAverageRating(List<ReviewModel> reviews) {
    if (reviews.isEmpty) return 0;
    final total = reviews.fold(0.0, (sum, r) => sum + r.rating);
    return total / reviews.length;
  }

  ReviewModel? getLatestReview(List<ReviewModel> reviews) {
    if (reviews.isEmpty) return null;
    return reviews.last;
  }
}
