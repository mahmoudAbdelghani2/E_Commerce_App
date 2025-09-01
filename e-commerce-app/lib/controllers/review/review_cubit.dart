import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:e_commerce_app/models/review_model.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'review_state.dart';

class ReviewCubit extends Cubit<ReviewState> {
  ReviewCubit() : super(ReviewInitial());

  // Load all reviews for a specific product
  Future<void> loadReviews(String productId) async {
    try {
      emit(ReviewLoading());
      
      final prefs = await SharedPreferences.getInstance();
      final reviewsJson = prefs.getString('reviews_$productId');
      
      if (reviewsJson != null && reviewsJson.isNotEmpty) {
        final reviewsData = jsonDecode(reviewsJson) as List;
        final reviews = reviewsData.map((item) => ReviewModel.fromJson(item)).toList();
        emit(ReviewLoaded(reviews));
      } else {
        // No reviews yet
        emit(ReviewLoaded([]));
      }
    } catch (e) {
      emit(ReviewError('Error loading reviews: $e'));
    }
  }

  // Add a new review
  Future<void> addReview(String productId, ReviewModel review) async {
    try {
      emit(ReviewLoading());
      
      final prefs = await SharedPreferences.getInstance();
      final reviewsJson = prefs.getString('reviews_$productId');
      
      List<ReviewModel> reviews = [];
      if (reviewsJson != null && reviewsJson.isNotEmpty) {
        final reviewsData = jsonDecode(reviewsJson) as List;
        reviews = reviewsData.map((item) => ReviewModel.fromJson(item)).toList();
      }
      
      // Add the new review with current timestamp
      final reviewWithTimestamp = ReviewModel(
        name: review.name,
        experience: review.experience,
        rating: review.rating,
        timestamp: DateTime.now(),
      );
      reviews.add(reviewWithTimestamp);
      
      // Save back to storage
      final updatedJson = jsonEncode(reviews.map((r) => r.toJson()).toList());
      await prefs.setString('reviews_$productId', updatedJson);
      
      emit(ReviewLoaded(reviews));
    } catch (e) {
      emit(ReviewError('Error adding review: $e'));
    }
  }

  // Get average rating for a product
  double getAverageRating(List<ReviewModel> reviews) {
    if (reviews.isEmpty) {
      return 0.0;
    }
    
    final totalRating = reviews.fold(0.0, (sum, review) => sum + review.rating);
    return totalRating / reviews.length;
  }
  
  // Get most recent review
  ReviewModel? getLatestReview(List<ReviewModel> reviews) {
    if (reviews.isEmpty) {
      return null;
    }
    
    return reviews.last; // Assuming last added review is the most recent
  }
}
