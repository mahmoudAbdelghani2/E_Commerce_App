// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:e_commerce_app/controllers/ButtomNav/bottomNav_cubit.dart';
import 'package:e_commerce_app/controllers/cart/cart_cubit.dart';
import 'package:e_commerce_app/controllers/cart/cart_state.dart';
import 'package:e_commerce_app/controllers/review/review_cubit.dart';
import 'package:e_commerce_app/models/product_model.dart';
import 'package:e_commerce_app/models/review_model.dart';
import 'package:e_commerce_app/utils/app_colors.dart';
import 'package:e_commerce_app/views/screens/review_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailsScreen extends StatefulWidget {
  final ProductModel product;
  const DetailsScreen({super.key, required this.product});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ReviewCubit>().loadReviews(widget.product.id.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBackground,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: const Color(0xFFF5F6FA),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        leadingWidth: 56,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: const Color(0xFFF5F6FA),
              child: IconButton(
                icon: const Icon(Icons.shopping_cart, color: Colors.black),
                onPressed: () {
                  BlocProvider.of<BottomNavCubit>(context).changeTab(2);
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 220,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: (widget.product.images != null && widget.product.images!.isNotEmpty)
                      ? Image.network(
                          widget.product.images!.first,
                          width: double.infinity,
                          height: 220,
                          fit: BoxFit.cover,
                        )
                      : Container(color: Colors.grey[200]),
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Title",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondaryText,
                    ),
                  ),
                  Spacer(),
                  Text(
                    "Price",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    widget.product.title!,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryText,
                    ),
                  ),
                  Spacer(),
                  Text(
                    "\$${widget.product.price}",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryText,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.product.images!.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      child: Image.network(
                        widget.product.images![index],
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Size",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondaryText,
                    ),
                  ),
                  Spacer(),
                  Text(
                    "Guide Size",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryText,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSizeGuide("S"),
                  _buildSizeGuide("M"),
                  _buildSizeGuide("L"),
                  _buildSizeGuide("XL"),
                  _buildSizeGuide("2XL"),
                ],
              ),
              SizedBox(height: 8),
              Text(
                "Description",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryText,
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 8),
              Text(
                widget.product.description!,
                style: TextStyle(fontSize: 19, color: AppColors.secondaryText),
              ),
              SizedBox(height: 8),
              Text(
                "Reviews",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryText,
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 8),
              // Reviews section with navigation to all reviews
              BlocBuilder<ReviewCubit, ReviewState>(
                builder: (context, state) {
                  if (state is ReviewLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ReviewLoaded) {
                    final reviews = state.reviews.toList();
                    final reviewCubit = context.read<ReviewCubit>();
                    
                    return Column(
                      children: [
                        // Header with reviews count and navigation
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${reviews.length} Reviews",
                              style: const TextStyle(
                                fontSize: 16,
                                color: AppColors.primaryText,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ReviewScreen(
                                      productId: widget.product.id.toString(),
                                    ),
                                  ),
                                ).then((_) {
                                  // Refresh reviews when returning from reviews screen
                                  context.read<ReviewCubit>().loadReviews(widget.product.id.toString());
                                });
                              },
                              child: const Text(
                                "See All",
                                style: TextStyle(
                                  color: Colors.purple,
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        if (reviews.isEmpty)
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.rate_review_outlined, color: Colors.grey),
                                const SizedBox(width: 8),
                                const Expanded(
                                  child: Text(
                                    "No reviews yet for this product",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ReviewScreen(
                                          productId: widget.product.id.toString(),
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text("Add Review"),
                                ),
                              ],
                            ),
                          )
                        else
                          _buildLatestReviewCard(reviews.last, reviewCubit.getAverageRating(reviews)),
                      ],
                    );
                  }
                  
                  return const SizedBox();
                },
              ),
              SizedBox(height: 8),
              ListTile(
                title: Text("Total Price"),
                subtitle: Text("with VAT,SD"),
                trailing: Text(
                  "\$${widget.product.price}",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryText,
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: BlocBuilder<CartCubit, CartState>(
                  builder: (context, state) {
                    final cartCubit = context.read<CartCubit>();
                    final isInCart = cartCubit.isInCart(widget.product);

                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isInCart ? Colors.red : Colors.purple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {
                        if (isInCart) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Removed from Cart"),
                                content: Text(
                                  "Are you sure you want to remove this item from the cart?",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      context.read<CartCubit>().removeFromCart(
                                        widget.product,
                                      );
                                      Navigator.of(context).pop();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          behavior: SnackBarBehavior.floating,
                                          elevation: 5,
                                          content: Text(
                                            "Product removed from cart!",
                                          ),
                                          duration: Duration(milliseconds: 1250),
                                        ),
                                      );
                                    },
                                    child: Text("Yes"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("No"),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          context.read<CartCubit>().addToCart(widget.product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              action: SnackBarAction(
                                label: "Undo",
                                onPressed: () {
                                  context.read<CartCubit>().removeFromCart(
                                    widget.product,
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                      elevation: 5,
                                      content: Text(
                                        "Product removed from cart!",
                                      ),
                                      duration: Duration(milliseconds: 1250),
                                    ),
                                  );
                                },
                              ),
                              elevation: 5,
                              content: Text(
                                "Product added to cart successfully!",
                              ),
                            ),
                          );
                        }
                        setState(() {}); // Force UI update
                      },
                      child: Text(
                        isInCart ? "Remove from cart" : "Add to cart",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildSizeGuide(String size) {
  return Container(
    width: 70,
    height: 70,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Color(0xFFF5F6FA),
    ),
    child: Center(
      child: Text(
        size,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryText,
        ),
        textAlign: TextAlign.center,
      ),
    ),
  );
}

Widget _buildLatestReviewCard(ReviewModel review, double averageRating) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.grey[100],
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // User avatar
            CircleAvatar(
              backgroundColor: Colors.purple[100],
              child: Text(
                review.name[0].toUpperCase(),
                style: TextStyle(
                  color: Colors.purple[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            
            // User name
            Expanded(
              child: Text(
                review.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            
            // Rating
            _buildStarRating(review.rating),
          ],
        ),
        
        const SizedBox(height: 8),
        
        // Review text
        Text(
          review.experience,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 14,
          ),
        ),
      ],
    ),
  );
}

Widget _buildStarRating(double rating) {
  return Row(
    children: List.generate(5, (index) {
      if (index < rating.floor()) {
        // Full star
        return Icon(Icons.star, color: Colors.orange[400], size: 16);
      } else if (index < rating.ceil() && rating.floor() != rating.ceil()) {
        // Half star
        return Icon(Icons.star_half, color: Colors.orange[400], size: 16);
      } else {
        // Empty star
        return Icon(Icons.star_border, color: Colors.orange[400], size: 16);
      }
    }),
  );
}
