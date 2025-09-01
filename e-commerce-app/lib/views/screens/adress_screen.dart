import 'package:e_commerce_app/controllers/adress/adress_cubit.dart';
import 'package:e_commerce_app/models/adress_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdressScreen extends StatefulWidget {
  final AddressModel? existingAddress;
  
  const AdressScreen({
    super.key,
    this.existingAddress,
  });

  @override
  State<AdressScreen> createState() => _AdressScreenState();
}

class _AdressScreenState extends State<AdressScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers for text fields
  late TextEditingController _nameController;
  late TextEditingController _countryController;
  late TextEditingController _cityController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _addressController;
  bool _isPrimary = true; // Always primary as we only support one address for now

  @override
  void initState() {
    super.initState();
    
    // Initialize controllers with existing address data or empty strings
    _nameController = TextEditingController(text: widget.existingAddress?.name ?? '');
    _countryController = TextEditingController(text: widget.existingAddress?.country ?? '');
    _cityController = TextEditingController(text: widget.existingAddress?.city ?? '');
    _phoneNumberController = TextEditingController(text: widget.existingAddress?.phoneNumber ?? '');
    _addressController = TextEditingController(text: widget.existingAddress?.address ?? '');
    _isPrimary = widget.existingAddress?.isPrimary ?? true;
    
    // Load address data if not provided
    if (widget.existingAddress == null) {
      context.read<AdressCubit>().loadAddress();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _countryController.dispose();
    _cityController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _saveAddress() {
    if (_formKey.currentState!.validate()) {
      final addressModel = AddressModel(
        name: _nameController.text,
        country: _countryController.text,
        city: _cityController.text,
        phoneNumber: _phoneNumberController.text,
        address: _addressController.text,
        isPrimary: _isPrimary,
      );
      
      context.read<AdressCubit>().saveAddress(addressModel);
      Navigator.pop(context, addressModel);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Address',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 20,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocConsumer<AdressCubit, AdressState>(
        listener: (context, state) {
          if (state is AdressError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is AdressLoaded && state.address != null) {
            // If address loaded and we're not in edit mode (no existing address),
            // populate the fields
            if (widget.existingAddress == null) {
              final loadedAddress = state.address as AddressModel;
              _nameController.text = loadedAddress.name;
              _countryController.text = loadedAddress.country;
              _cityController.text = loadedAddress.city;
              _phoneNumberController.text = loadedAddress.phoneNumber;
              _addressController.text = loadedAddress.address;
              _isPrimary = loadedAddress.isPrimary;
            }
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  const Text(
                    'Name',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Enter your name',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Country and City in a row
                  Row(
                    children: [
                      // Country
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Country',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _countryController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[200],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                                hintText: 'Your country',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Required';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(width: 16),
                      
                      // City
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'City',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _cityController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[200],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                                hintText: 'Your city',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Required';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Phone Number
                  const Text(
                    'Phone Number',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _phoneNumberController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Your phone number',
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  const Text(
                    'Address',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Enter your address',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your address';
                      }
                      return null;
                    },
                    maxLines: 2,
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Save as primary address
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Save as primary address',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      Switch(
                        value: _isPrimary,
                        onChanged: (value) {
                          setState(() {
                            _isPrimary = value;
                          });
                        },
                        activeColor: Colors.green,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Save Address button
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF9775FA),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: _saveAddress,
                      child: const Text(
                        'Save Address',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
                ),
            ),
          );
        },
      ),
    );
  }
}