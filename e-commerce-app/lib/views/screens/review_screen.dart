// ignore_for_file: use_build_context_synchronously

import 'package:e_commerce_app/controllers/review/review_cubit.dart';
import 'package:e_commerce_app/models/review_model.dart';
import 'package:e_commerce_app/utils/app_colors.dart';
import 'package:e_commerce_app/views/screens/add_review.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReviewScreen extends StatefulWidget {
  final String productId;

  const ReviewScreen({super.key, required this.productId});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ReviewCubit>().loadReviews(widget.productId);
  }
  
  String _formatDate(DateTime? timestamp) {
    if (timestamp == null) {
      return "Date unavailable";
    }
    
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    
    return "${timestamp.day} ${months[timestamp.month - 1]}, ${timestamp.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Reviews',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFFF5F6FA),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<ReviewCubit, ReviewState>(
        builder: (context, state) {
          if (state is ReviewLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ReviewError) {
            return Center(child: Text(state.message));
          } else if (state is ReviewLoaded) {
            final reviews = state.reviews.toList();
            if (reviews.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.rate_review_outlined,
                      size: 80,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "No reviews yet for this product",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AddReviewScreen(productId: widget.productId),
                          ),
                        );

                        if (result == true && mounted) {
                          context.read<ReviewCubit>().loadReviews(
                            widget.productId,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonInSubmit,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Be the first to review',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            final reviewCubit = context.read<ReviewCubit>();
            final avgRating = reviewCubit.getAverageRating(reviews);

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Column(
                        children: [
                          Text(
                            '${reviews.length} Reviews',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF3E4249),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Row(
                            children: [
                              _buildStarRating(avgRating),
                              const SizedBox(width: 8),
                              Text(
                                avgRating.toStringAsFixed(1),
                                style: TextStyle(
                                  color: AppColors.buttonInSubmit,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AddReviewScreen(productId: widget.productId),
                            ),
                          );

                          if (result == true) {
                            if (mounted) {
                              context.read<ReviewCubit>().loadReviews(
                                widget.productId,
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.buttonInSubmit,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Add Review'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Expanded(
                    child: ListView.separated(
                      itemCount: reviews.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final review = reviews[index];
                        return _buildReviewItem(review);
                      },
                    ),
                  ),
                ],
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildStarRating(double rating) {
    return Row(
      children: List.generate(5, (index) {
        if (index < rating.floor()) {
          return Icon(Icons.star, color: AppColors.buttonInSubmit, size: 18);
        } else if (index < rating.ceil() && rating.floor() != rating.ceil()) {
          return Icon(Icons.star_half, color: AppColors.buttonInSubmit, size: 18);
        } else {
          return Icon(Icons.star_border, color: AppColors.buttonInSubmit, size: 18);
        }
      }),
    );
  }

  Widget _buildReviewItem(ReviewModel review) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Color(0xFFF5F6FA),
                child: Text(
                  review.name[0].toUpperCase(),
                  style: TextStyle(
                    color: AppColors.buttonInSubmit,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      _formatDate(review.timestamp),
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ),

              Row(
                children: [
                  _buildStarRating(review.rating),
                  const SizedBox(width: 4),
                  Text(
                    review.rating.toStringAsFixed(1),
                    style: TextStyle(
                      color: AppColors.buttonInSubmit,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Review text
          Text(
            review.experience,
            style: TextStyle(color: Colors.grey[700], fontSize: 14),
          ),
        ],
      ),
    );
  }
}
