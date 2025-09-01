import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:e_commerce_app/models/adress_model.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'adress_state.dart';

class AdressCubit extends Cubit<AdressState> {
  AdressCubit() : super(AdressInitial());

  // Save address to SharedPreferences
  Future<void> saveAddress(AddressModel address) async {
    try {
      emit(AdressLoading());
      
      final prefs = await SharedPreferences.getInstance();
      final addressJson = jsonEncode(address.toJson());
      
      await prefs.setString('user_address', addressJson);
      
      emit(AdressLoaded(address));
    } catch (e) {
      emit(AdressError('Error saving address: $e'));
    }
  }

  // Load address from SharedPreferences
  Future<void> loadAddress() async {
    try {
      emit(AdressLoading());
      
      final prefs = await SharedPreferences.getInstance();
      final addressJson = prefs.getString('user_address');
      
      if (addressJson != null && addressJson.isNotEmpty) {
        final addressData = jsonDecode(addressJson);
        final address = AddressModel.fromJson(addressData);
        emit(AdressLoaded(address));
      } else {
        // No address saved yet
        emit(AdressLoaded(null));
      }
    } catch (e) {
      emit(AdressError('Error loading address: $e'));
    }
  }

  // Update existing address
  Future<void> updateAddress(AddressModel address) async {
    try {
      emit(AdressLoading());
      
      final prefs = await SharedPreferences.getInstance();
      final addressJson = jsonEncode(address.toJson());
      
      await prefs.setString('user_address', addressJson);
      
      emit(AdressLoaded(address));
    } catch (e) {
      emit(AdressError('Error updating address: $e'));
    }
  }

  // Delete address
  Future<void> deleteAddress() async {
    try {
      emit(AdressLoading());
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_address');
      
      emit(AdressLoaded(null));
    } catch (e) {
      emit(AdressError('Error deleting address: $e'));
    }
  }
}
