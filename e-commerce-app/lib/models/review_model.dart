class ReviewModel {
  final String name;
  final String experience;
  final double rating;

  ReviewModel({
    required this.name,
    required this.experience,
    required this.rating,
  });

  ReviewModel copyWith({
    String? name,
    String? experience,
    double? rating,
  }) {
    return ReviewModel(
      name: name ?? this.name,
      experience: experience ?? this.experience,
      rating: rating ?? this.rating,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'experience': experience,
      'rating': rating,
    };
  }

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      name: json['name'] ?? '',
      experience: json['experience'] ?? '',
      rating: json['rating']?.toDouble() ?? 0.0,
    );
  }

}