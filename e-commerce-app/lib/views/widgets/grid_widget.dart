// ignore_for_file: deprecated_member_use

import 'package:e_commerce_app/controllers/wishlist/wishlist_cubit.dart';
import 'package:e_commerce_app/controllers/wishlist/wishlist_state.dart';
import 'package:e_commerce_app/models/product_model.dart';
import 'package:e_commerce_app/views/screens/details_Screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GridWidget extends StatefulWidget {
  final ProductModel product;
  const GridWidget({super.key, required this.product});

  @override
  State<GridWidget> createState() => _GridWidgetState();
}

class _GridWidgetState extends State<GridWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => DetailsScreen(product: widget.product),
            ),
          );
        },
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image with wishlist button overlay
              Stack(
                children: [
                  // Product Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      widget.product.image!,
                      fit: BoxFit.cover,
                      height: 180,
                      width: double.infinity,
                      alignment: Alignment.topCenter,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return SizedBox(
                          height: 180,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.purple.shade300,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return SizedBox(
                          height: 180,
                          width: double.infinity,
                          child: Center(
                            child: Icon(
                              Icons.broken_image,
                              size: 60,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  
                  // Wishlist heart button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: BlocBuilder<WishlistCubit, WishlistState>(
                      builder: (context, state) {
                        // Check real-time wishlist status
                        final wishlistCubit = context.read<WishlistCubit>();
                        final isInWishlist = wishlistCubit.isInWishlist(widget.product);
                        if (widget.product.isAddedToWishlist != isInWishlist) {
                          widget.product.isAddedToWishlist = isInWishlist;
                        }
                        return CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.white.withOpacity(0.8),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: Icon(
                              widget.product.isAddedToWishlist
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: widget.product.isAddedToWishlist
                                  ? Colors.purple
                                  : Colors.grey,
                              size: 24,
                            ),
                            onPressed: () {
                              if (widget.product.isAddedToWishlist) {
                                context
                                    .read<WishlistCubit>()
                                    .removeFromWishlist(widget.product);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        behavior: SnackBarBehavior.floating,

                                        elevation: 5,
                                        content: Text(
                                          "Product removed from wishlist!",
                                        ),
                                      ),
                                    );
                              } else {
                                context
                                    .read<WishlistCubit>()
                                    .addToWishlist(widget.product);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        elevation: 5,
                                        content: Text(
                                          "Product added to wishlist!",
                                        ),
                                      ),
                                    );
                              }
                              setState(() {}); // Force UI update
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 4),
                child: Text(
                  widget.product.title!,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '\$${widget.product.price}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
