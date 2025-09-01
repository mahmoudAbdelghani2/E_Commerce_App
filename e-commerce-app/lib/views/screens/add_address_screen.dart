import 'package:e_commerce_app/models/adress_model.dart';
import 'package:e_commerce_app/utils/app_colors.dart';
import 'package:flutter/material.dart';

class AddAddressScreen extends StatefulWidget {
  final Function(AddressModel) onAddressAdded;
  final bool isFirstAddress;
  
  const AddAddressScreen({
    super.key,
    required this.onAddressAdded,
    this.isFirstAddress = false,
  });

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isPrimary = false;

  @override
  void initState() {
    super.initState();
    if (widget.isFirstAddress) {
      _isPrimary = true;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _saveAddress() {
    if (_formKey.currentState!.validate()) {
      final address = AddressModel(
        name: _nameController.text.trim(),
        address: _addressController.text.trim(),
        city: _cityController.text.trim(),
        country: _countryController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        isPrimary: _isPrimary,
      );

      widget.onAddressAdded(address);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBackground,
        title: Text(
          "Add New Address",
          style: TextStyle(
            color: AppColors.primaryText,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryText),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Enter your address details",
                  style: TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 24),
                
                // Name Field
                _buildTextField(
                  controller: _nameController,
                  label: "Address Name",
                  hint: "E.g. Home, Office, etc.",
                  icon: Icons.bookmark,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter a name for this address";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // Address Field
                _buildTextField(
                  controller: _addressController,
                  label: "Street Address",
                  hint: "Enter your street address",
                  icon: Icons.home,
                  maxLines: 2,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter street address";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // City Field
                _buildTextField(
                  controller: _cityController,
                  label: "City",
                  hint: "Enter your city",
                  icon: Icons.location_city,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter city";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // Country Field
                _buildTextField(
                  controller: _countryController,
                  label: "Country",
                  hint: "Enter your country",
                  icon: Icons.public,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter country";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // Phone Number Field
                _buildTextField(
                  controller: _phoneController,
                  label: "Phone Number",
                  hint: "Enter phone number for this address",
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter phone number";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                
                // Primary Address Switch
                SwitchListTile(
                  title: Text(
                    "Set as primary address",
                    style: TextStyle(
                      color: AppColors.primaryText,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    "This address will be used as your primary address",
                    style: TextStyle(
                      color: AppColors.secondaryText,
                      fontSize: 14,
                    ),
                  ),
                  value: _isPrimary,
                  onChanged: (value) {
                    setState(() {
                      _isPrimary = value;
                    });
                  },
                  activeColor: AppColors.buttonInSubmit,
                  contentPadding: EdgeInsets.zero,
                ),
                const SizedBox(height: 32),
                
                // Save Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _saveAddress,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonInSubmit,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Save Address",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.buttonInSubmit),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.buttonInSubmit, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: validator,
      keyboardType: keyboardType,
      maxLines: maxLines,
    );
  }
}
