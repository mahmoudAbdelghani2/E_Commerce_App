import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:e_commerce_app/controllers/auth/auth_cubit.dart';
import 'package:e_commerce_app/controllers/auth/auth_states.dart';
import 'package:e_commerce_app/models/adress_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  // يجيب العنوان من الذاكرة أو يستخدم العنوان الرئيسي من قائمة عناوين المستخدم
  Future<void> loadAddress({BuildContext? context}) async {
    try {
      emit(AdressLoading());
      
      // جلب العنوان من الذاكرة المحلية
      final prefs = await SharedPreferences.getInstance();
      final addressJson = prefs.getString('user_address');
      
      if (addressJson != null && addressJson.isNotEmpty) {
        // لو فيه عنوان متخزن، هنحوله لكائن ونستخدمه
        final addressData = jsonDecode(addressJson);
        final address = AddressModel.fromJson(addressData);
        emit(AdressLoaded(address));
      } 
      // لو مفيش عنوان متخزن وعندنا context
      else if (context != null) {
        // هنشوف المستخدم وعناوينه
        final authCubit = context.read<AuthCubit>();
        
        // بنتأكد إن المستخدم مسجل دخول
        if (authCubit.state is Authenticated) {
          final user = (authCubit.state as Authenticated).user;
          
          // لو عنده عناوين
          if (user.addresses.isNotEmpty) {
            // بندور على العنوان الأساسي الأول
            AddressModel primaryAddress;
            
            try {
              primaryAddress = user.addresses.firstWhere(
                (address) => address.isPrimary == true,
              );
            } catch (e) {
              // لو مفيش عنوان أساسي بناخد أول عنوان
              primaryAddress = user.addresses.first;
            }
            
            emit(AdressLoaded(primaryAddress));
            
            // كمان بنخزن العنوان ده للاستخدام بعد كده
            await saveAddress(primaryAddress);
            return;
          }
        }
        
        // مفيش عنوان متخزن ومفيش عنوان للمستخدم
        emit(AdressLoaded(null));
      } else {
        // مفيش عنوان متخزن ومفيش context متاح
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
