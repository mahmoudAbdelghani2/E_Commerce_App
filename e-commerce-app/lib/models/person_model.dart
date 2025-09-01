import 'dart:convert';

import 'package:e_commerce_app/models/adress_model.dart';

class PersonModel {
  final String id;
  final String name;
  final String email;
  final String? username;
  final int? age;
  final String? phoneNumber;
  final String? imageUrl;
  final String? gender;
  final List<AddressModel> addresses;

  PersonModel({
    required this.id,
    required this.name,
    required this.email,
    this.username,
    this.age,
    this.phoneNumber,
    this.imageUrl,
    this.gender,
    this.addresses = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'username': username,
      'age': age,
      'phoneNumber': phoneNumber,
      'imageUrl': imageUrl,
      'gender': gender,
      'addresses': addresses.map((addr) => addr.toJson()).toList(),
    };
  }

  factory PersonModel.fromMap(Map<String, dynamic> map) {
    List<AddressModel> addrList = [];
    if (map['addresses'] != null) {
      addrList = List<AddressModel>.from(
        (map['addresses'] as List).map(
          (addr) => AddressModel.fromJson(addr),
        ),
      );
    }
    
    return PersonModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      username: map['username'],
      age: map['age'],
      phoneNumber: map['phoneNumber'],
      imageUrl: map['imageUrl'],
      gender: map['gender'],
      addresses: addrList,
    );
  }

  String toJson() => json.encode(toMap());

  factory PersonModel.fromJson(String source) =>
      PersonModel.fromMap(json.decode(source));
}

