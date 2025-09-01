// ignore_for_file: use_build_context_synchronously
import 'package:e_commerce_app/controllers/ButtomNav/bottomNav_cubit.dart';
import 'package:e_commerce_app/controllers/auth/auth_cubit.dart';
import 'package:e_commerce_app/controllers/product/product_cubit.dart';
import 'package:e_commerce_app/controllers/product/product_state.dart';
import 'package:e_commerce_app/utils/app_colors.dart';
import 'package:e_commerce_app/views/screens/open_screen.dart';
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
              padding: const EdgeInsets.only(bottom: 16),
              decoration: const BoxDecoration(
                gradient: AppColors.mainGradient,
              ),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16, top: 16),
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: IconButton(
                            icon: const Icon(Icons.close, size: 20, color: Colors.white),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const CircleAvatar(
                              radius: 30,
                              backgroundImage: AssetImage('assets/images/cr7.jpg'),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Mrh Raju',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Row(
                                  children: const [
                                    Text(
                                      'Verified Profile',
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                    SizedBox(width: 5),
                                    Icon(
                                      Icons.check_circle,
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.buttonInSubmit.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.brightness_2_outlined,
                      color: AppColors.buttonInSubmit,
                    ),
                  ),
                  title: const Text(
                    'Dark Mode',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  trailing: Switch(
                    value: false,
                    onChanged: (_) {},
                    activeColor: AppColors.buttonInSubmit,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                tileColor: Colors.grey.shade50,
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.buttonInSubmit.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.info_outline, color: AppColors.buttonInSubmit),
                ),
                title: const Text(
                  'Account Information',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                onTap: () {
                  BlocProvider.of<BottomNavCubit>(context).changeTab(3);
                  Navigator.of(context).pop();
                },
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                tileColor: Colors.grey.shade50,
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.buttonInSubmit.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.lock_outline, color: AppColors.buttonInSubmit),
                ),
                title: const Text(
                  'Password',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                tileColor: Colors.grey.shade50,
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.buttonInSubmit.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.shopping_bag_outlined, color: AppColors.buttonInSubmit),
                ),
                title: const Text(
                  'Orders',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                onTap: () {
                  BlocProvider.of<BottomNavCubit>(context).changeTab(2);
                  Navigator.of(context).pop();
                },
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                tileColor: Colors.grey.shade50,
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.buttonInSubmit.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.credit_card_outlined, color: AppColors.buttonInSubmit),
                ),
                title: const Text(
                  'My Cards',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                tileColor: Colors.grey.shade50,
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.buttonInSubmit.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.favorite_border_outlined, color: AppColors.buttonInSubmit),
                ),
                title: const Text(
                  'Wishlist',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                onTap: () {
                  BlocProvider.of<BottomNavCubit>(context).changeTab(1);
                  Navigator.of(context).pop();
                },
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                tileColor: Colors.grey.shade50,
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.buttonInSubmit.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.settings_outlined, color: AppColors.buttonInSubmit),
                ),
                title: const Text(
                  'Settings',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                tileColor: Colors.red.shade50,
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.logout, color: Colors.red[400]),
                ),
                title: Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.red[400],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  context.read<AuthCubit>().logOut();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const OpenScreen()),
                    (route) => false,
                  );
                },
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
                                    childAspectRatio: 0.7,
                                    crossAxisSpacing: 8.0,
                                    mainAxisSpacing: 8.0,
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
