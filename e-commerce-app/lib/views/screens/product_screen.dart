import 'package:e_commerce_app/controllers/product/product_cubit.dart';
import 'package:e_commerce_app/controllers/product/product_state.dart';
import 'package:e_commerce_app/views/widgets/grid_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final cubit = BlocProvider.of<ProductCubit>(context);
    cubit.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductLoaded) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                ),
                itemCount: state.products.length,
                itemBuilder: (context, index) {
                  return GridWidget(product: state.products[index]);
                },
              ),
            );
          } else if (state is ProductError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return const Center(child: Text('Failed to load products'));
          }
        },
      ),
    );
  }
}
