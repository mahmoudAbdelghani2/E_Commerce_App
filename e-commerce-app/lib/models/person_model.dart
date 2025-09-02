import 'dart:convert';

class PersonModel {
  final String id;
  final String name;
  final String email;
  final String? username;
  final int? age;
  final String? phoneNumber;
  final String? imageUrl;
  final String? gender;

  PersonModel({
    required this.id,
    required this.name,
    required this.email,
    this.username,
    this.age,
    this.phoneNumber,
    this.imageUrl,
    this.gender,
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
    };
  }

  factory PersonModel.fromMap(Map<String, dynamic> map) {
    return PersonModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      username: map['username'],
      age: map['age'],
      phoneNumber: map['phoneNumber'],
      imageUrl: map['imageUrl'],
      gender: map['gender'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PersonModel.fromJson(String source) => PersonModel.fromMap(json.decode(source));
}

