import 'package:e_commerce_app/controllers/cart/cart_cubit.dart';
import 'package:e_commerce_app/controllers/cart/cart_state.dart';
import 'package:e_commerce_app/models/product_model.dart';
import 'package:e_commerce_app/utils/app_colors.dart';
import 'package:e_commerce_app/views/screens/details_Screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListWidget extends StatefulWidget {
  final ProductModel product;
  const ListWidget({super.key, required this.product});

  @override
  State<ListWidget> createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ListWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DetailsScreen(product: widget.product),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.all(8.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: AppColors.primaryBackground,
        elevation: 8,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.network(
                widget.product.image!,
                fit: BoxFit.cover,
                height: 80,
                width: 80,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.title!,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryText,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "\$${widget.product.price} (-\$4.00 Tax)",
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.secondaryText,
                      ),
                    ),
                    SizedBox(height: 4),
                    BlocBuilder<CartCubit, CartState>(
                      builder: (context, state) {
                        return Row(
                          children: [
                            IconButton(
                          onPressed: () {
                            context.read<CartCubit>().decreaseQuantity(widget.product);
                          },
                          icon: Icon(
                            Icons.remove_circle_outline,
                            color: AppColors.primaryText,
                          ),
                          constraints: BoxConstraints(minWidth: 36, minHeight: 36),
                          padding: EdgeInsets.zero,
                        ),
                            SizedBox(width: 4),
                            Text(
                            "${widget.product.quantity}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                            IconButton(
                          onPressed: () {
                            context.read<CartCubit>().increaseQuantity(widget.product);
                          },
                          icon: Icon(
                            Icons.add_circle_outline,
                            color: AppColors.primaryText,
                          ),
                          constraints: BoxConstraints(minWidth: 36, minHeight: 36),
                          padding: EdgeInsets.zero,
                        ),
                            SizedBox(width: 4),
                            Spacer(),
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: () {
                                context.read<CartCubit>().removeFromCart(
                                  widget.product,
                                );
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/**
 * ListTile(
        leading: 
        title:
        subtitle: 
        trailing: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              return Row(
                children: [
                  Spacer(),
                  
                ],
              );
            },
          ),
        ),
      ),
 */
