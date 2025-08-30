import 'package:e_commerce_app/controllers/wishlist/wishlist_cubit.dart';
import 'package:e_commerce_app/controllers/wishlist/wishlist_state.dart';
import 'package:e_commerce_app/models/product_model.dart';
import 'package:e_commerce_app/utils/app_colors.dart';
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
      child: Stack(
        children: [
          BlocBuilder<WishlistCubit, WishlistState>(
            builder: (context, state) {
              return Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: IconButton(
                  icon: Icon(
                    widget.product.isAddedToWishlist
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: widget.product.isAddedToWishlist
                        ? Colors.green
                        : Colors.grey,
                  ),
                  onPressed: () {
                    //ToDo Show snackbar
                    widget.product.isAddedToWishlist
                        ? context.read<WishlistCubit>().removeFromWishlist(
                            widget.product,
                          )
                        : context.read<WishlistCubit>().addToWishlist(
                            widget.product,
                          );
                  },
                ),
              );
            },
          ),
          Card(
            color: AppColors.cardBackground,
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  widget.product.image!,
                  fit: BoxFit.cover,
                  height: 150,
                  width: 150,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.product.title!,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('\$${widget.product.price}'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
