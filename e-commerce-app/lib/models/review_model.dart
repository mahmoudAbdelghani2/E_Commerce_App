class ReviewModel {
  final String name;
  final String experience;
  final double rating;
  final DateTime? timestamp;

  ReviewModel({
    required this.name,
    required this.experience,
    required this.rating,
    this.timestamp,
  });

  ReviewModel copyWith({
    String? name,
    String? experience,
    double? rating,
    DateTime? timestamp,
  }) {
    return ReviewModel(
      name: name ?? this.name,
      experience: experience ?? this.experience,
      rating: rating ?? this.rating,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'experience': experience,
      'rating': rating,
      'timestamp': timestamp?.millisecondsSinceEpoch,
    };
  }

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      name: json['name'] ?? '',
      experience: json['experience'] ?? '',
      rating: json['rating']?.toDouble() ?? 0.0,
      timestamp: json['timestamp'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(json['timestamp']) 
          : null,
    );
  }

}