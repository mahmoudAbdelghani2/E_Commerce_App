import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce_app/models/review_model.dart';
import 'package:e_commerce_app/services/firestore_service.dart';

part 'review_state.dart';

class ReviewCubit extends Cubit<ReviewState> {
  final FirestoreService _firestore;
  ReviewCubit(this._firestore) : super(ReviewInitial());

  Future<void> loadReviews(String productId) async {
    emit(ReviewLoading());
    try {
      final reviews = await _firestore.fetchReviews(productId);
      emit(ReviewLoaded(reviews));
    } catch (e) {
      emit(ReviewError("Error loading reviews: $e"));
    }
  }

  Future<void> addReview(String productId, ReviewModel review) async {
    emit(ReviewLoading());
    try {
      await _firestore.addReview(productId, review);
      final updatedReviews = await _firestore.fetchReviews(productId);
      emit(ReviewLoaded(updatedReviews));
    } catch (e) {
      emit(ReviewError("Error adding review: $e"));
    }
  }

  double getAverageRating(List<ReviewModel> reviews) {
    if (reviews.isEmpty) return 0;
    final total = reviews.fold(0.0, (sum, r) => sum + r.rating);
    return total / reviews.length;
  }

  ReviewModel? getLatestReview(List<ReviewModel> reviews) {
    if (reviews.isEmpty) return null;
    return reviews.first;
  }
}
