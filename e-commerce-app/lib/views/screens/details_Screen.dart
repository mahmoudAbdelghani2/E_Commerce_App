import 'package:e_commerce_app/controllers/cart/cart_cubit.dart';
import 'package:e_commerce_app/controllers/cart/cart_state.dart';
import 'package:e_commerce_app/models/product_model.dart';
import 'package:e_commerce_app/utils/app_colors.dart';
import 'package:e_commerce_app/views/screens/cart_screen.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
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
                onPressed: () => Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (context) => CartScreen())),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.network(
                widget.product.image!,
                height: 300,
                fit: BoxFit.cover,
              ),
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
                style: TextStyle(fontSize: 16, color: AppColors.secondaryText),
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
              //ToDo Review's section
              Container(color: Colors.red, width: double.infinity, height: 50),
              //ToDo Review's section
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
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonInSubmit,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {
                        context.read<CartCubit>().addToCart(widget.product);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            action: SnackBarAction(
                              label: "Undo",
                              onPressed: () {
                                context.read<CartCubit>().removeFromCart(widget.product);
                              },
                            ),
                            elevation: 5,
                            content: Text("Product added to cart successfully!"),
                          ),
                        );
                      },
                      child: Text(
                        "Add to cart",
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
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.grey[200],
    ),
    child: Text(
      size,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.primaryText,
      ),
      textAlign: TextAlign.center,
    ),
  );
}
