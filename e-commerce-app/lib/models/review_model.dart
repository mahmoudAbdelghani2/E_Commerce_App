import 'package:cloud_firestore/cloud_firestore.dart';

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

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'experience': experience,
      'rating': rating,
      'timestamp': timestamp != null 
          ? Timestamp.fromDate(timestamp!) 
          : FieldValue.serverTimestamp(),
    };
  }

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      name: json['name'] ?? '',
      experience: json['experience'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      timestamp: json['timestamp'] is Timestamp
          ? (json['timestamp'] as Timestamp).toDate()
          : null,
    );
  }
}
