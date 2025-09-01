part of 'review_cubit.dart';

@immutable
sealed class ReviewState {}

final class ReviewInitial extends ReviewState {}

final class ReviewLoading extends ReviewState {}

final class ReviewLoaded extends ReviewState {
  final List<dynamic> reviews;
  
  ReviewLoaded(this.reviews);
}

final class ReviewError extends ReviewState {
  final String message;
  
  ReviewError(this.message);
}
