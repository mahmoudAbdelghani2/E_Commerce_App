class AddressModel {
  final String name;
  final String country;
  final String city;
  final String phoneNumber;
  final String address;
  final bool isPrimary;

  AddressModel({
    required this.name,
    required this.country,
    required this.city,
    required this.phoneNumber,
    required this.address,
    required this.isPrimary,
  });

  AddressModel copyWith({
    String? name,
    String? country,
    String? city,
    String? phoneNumber,
    String? address,
    bool? isPrimary,
  }) {
    return AddressModel(
      name: name ?? this.name,
      country: country ?? this.country,
      city: city ?? this.city,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      isPrimary: isPrimary ?? this.isPrimary,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'country': country,
      'city': city,
      'phoneNumber': phoneNumber,
      'address': address,
      'isPrimary': isPrimary,
    };
  }

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      name: json['name'] ?? '',
      country: json['country'] ?? '',
      city: json['city'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      address: json['address'] ?? '',
      isPrimary: json['isPrimary'] ?? false,
    );
  }

}