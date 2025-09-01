// ignore_for_file: use_build_context_synchronously
import 'package:e_commerce_app/controllers/ButtomNav/bottomNav_cubit.dart';
import 'package:e_commerce_app/controllers/product/product_cubit.dart';
import 'package:e_commerce_app/controllers/product/product_state.dart';
import 'package:e_commerce_app/utils/app_colors.dart';
import 'package:e_commerce_app/views/widgets/grid_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  String? _selectedBrand;

  @override
  void initState() {
    super.initState();
    context.read<ProductCubit>().fetchProducts();
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          BlocBuilder<BottomNavCubit, int>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: IconButton(
                  icon: const Icon(Icons.shopping_cart, color: Colors.black),
                  onPressed: () {
                    context.read<BottomNavCubit>().changeTab(2);
                  },
                ),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button in circle
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios, size: 18),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.green[100],
                        child: const CircleAvatar(
                          radius: 28,
                          backgroundImage: NetworkImage(
                            'https://i.pravatar.cc/150?img=11',
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Mrh Raju',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: const [
                              Text(
                                'Verified Profile',
                                style: TextStyle(color: Colors.grey),
                              ),
                              SizedBox(width: 5),
                              Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 14,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text('3 Orders'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.brightness_2_outlined),
              title: const Text(
                'Dark Mode',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              trailing: Switch(
                value: false,
                onChanged: (_) {},
                activeColor: Colors.purple,
              ),
            ),
            ListTile(
              leading: Icon(Icons.info_outline),
              title: TextButton(
                onPressed: () {
                  BlocProvider.of<BottomNavCubit>(context).changeTab(3);
                },
                child: Text(
                  'Account Information',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
            // Password
            ListTile(
              leading: Icon(Icons.lock_outline),
              title: Text(
                'Password',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            // Order
            ListTile(
              leading: Icon(Icons.shopping_bag_outlined),
              title: TextButton(
                onPressed: () {
                  BlocProvider.of<BottomNavCubit>(context).changeTab(2);
                },
                child: Text(
                  'Order',
                  style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
            // My Cards
            ListTile(
              leading: Icon(Icons.credit_card_outlined),
              title: Text(
                'My Cards',
                style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
                textAlign: TextAlign.start,
              ),
            ),
            // Wishlist
            ListTile(
              leading: Icon(Icons.favorite_border_outlined),
              title: TextButton(
                onPressed: () {
                  BlocProvider.of<BottomNavCubit>(context).changeTab(1);
                },
                child: Text(
                  'WishList',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ),
            // Settings
            ListTile(
              leading: Icon(Icons.settings_outlined),
              title: Text(
                'Settings',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(height: 100),
            // Logout button
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red[400]),
              title: Text(
                'Logout',
                style: TextStyle(
                  color: Colors.red[400],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: BlocBuilder<ProductCubit, ProductState>(
          builder: (context, state) {
            if (state is ProductLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProductError) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is ProductLoaded) {
              final allProducts = state.products;
              final List<String> brands = ["Nike", "Adidas", "Puma", "Others"];

              final searchFiltered = _searchText.isEmpty
                  ? allProducts
                  : allProducts
                        .where(
                          (p) => (p.title ?? '').toLowerCase().contains(
                            _searchText.toLowerCase(),
                          ),
                        )
                        .toList();

              final List<dynamic> brandFiltered;
              if (_selectedBrand == null) {
                brandFiltered = searchFiltered;
              } else if (_selectedBrand == 'Others') {
                final mainBrands = ["Nike", "Adidas", "Puma"];
                brandFiltered = searchFiltered
                    .where((p) => !mainBrands.contains(p.brand))
                    .toList();
              } else {
                brandFiltered = searchFiltered
                    .where((p) => p.brand == _selectedBrand)
                    .toList();
              }

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<ProductCubit>().fetchProducts();
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    const Text(
                      "Hello",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryText,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "Welcome to Laza",
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.secondaryText,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(child: _search(_searchController)),
                        const SizedBox(width: 12),
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: AppColors.buttonSelectedInSignUp,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.mic, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Text(
                          "Choose Brand",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryText,
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _selectedBrand = null;
                            });
                          },
                          child: const Text(
                            "View All",
                            style: TextStyle(
                              fontSize: 18,
                              color: AppColors.secondaryText,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: brands
                            .map((brand) => _brandButton(brand))
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: brandFiltered.isEmpty
                          ? const Center(child: Text('No products found.'))
                          : GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.8,
                                  ),
                              itemCount: brandFiltered.length,
                              itemBuilder: (context, index) {
                                return GridWidget(
                                  product: brandFiltered[index],
                                );
                              },
                            ),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(child: Text('Failed to load products'));
            }
          },
        ),
      ),
    );
  }

  Widget _brandButton(String brandName) {
    final isSelected = _selectedBrand == brandName;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _selectedBrand = brandName;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected
              ? AppColors.buttonSelectedInSignUp
              : Color(0xffF5F6FA),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          brandName,
          style: TextStyle(color: isSelected ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}

Widget _search(TextEditingController searchController) {
  return TextFormField(
    controller: searchController,
    decoration: const InputDecoration(
      prefixIcon: Icon(Icons.search, color: Colors.grey),
      hintText: 'Search...',
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        borderSide: BorderSide.none,
      ),
      focusColor: Colors.blue,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        borderSide: BorderSide(color: Colors.blue),
      ),
      filled: true,
      fillColor: Color(0xffF5F6FA),
    ),
  );
}
