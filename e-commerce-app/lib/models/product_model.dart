class ProductModel {
  int? id;
  String? title;
  double? price;
  String? description;
  String? category;
  String? brand;
  String? image;
  List<String>? images; // Added this field
  Rating? rating;

  bool isAddedToCart;
  bool isAddedToWishlist;
  int quantity;

  ProductModel({
    this.id,
    this.title,
    this.price,
    this.description,
    this.category,
    this.brand,
    this.image,
    this.images, // Added to constructor
    this.rating,
    this.isAddedToCart = false,
    this.isAddedToWishlist = false,
    this.quantity = 1,
  });

  ProductModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        price = (json['price'] is int)
            ? (json['price'] as int).toDouble()
            : (json['price'] as num?)?.toDouble(),
        description = json['description'],
        category = json['category'],
        brand = json['brand'],
        image = json['image'],
        images = json['images'] != null ? List<String>.from(json['images']) : null, // Added parsing
        rating = json['rating'] != null ? Rating.fromJson(json['rating']) : null,
        isAddedToCart = json['isAddedToCart'] ?? false,
        isAddedToWishlist = json['isAddedToWishlist'] ?? false,
        quantity = json['quantity']?.toInt() ?? 1;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'brand': brand,
      'image': image,
      'images': images, // Added to JSON
      'rating': rating?.toJson(),
      'isAddedToCart': isAddedToCart,
      'isAddedToWishlist': isAddedToWishlist,
      'quantity': quantity,
    };
  }

  ProductModel copyWith({
    int? id,
    String? title,
    double? price,
    String? description,
    String? category,
    String? brand,
    String? image,
    List<String>? images, // Added to copyWith
    Rating? rating,
    bool? isAddedToCart,
    bool? isAddedToWishlist,
    int? quantity,
  }) {
    return ProductModel(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      description: description ?? this.description,
      category: category ?? this.category,
      brand: brand ?? this.brand,
      image: image ?? this.image,
      images: images ?? this.images, // Added to copyWith
      rating: rating ?? this.rating,
      isAddedToCart: isAddedToCart ?? this.isAddedToCart,
      isAddedToWishlist: isAddedToWishlist ?? this.isAddedToWishlist,
      quantity: quantity ?? this.quantity,
    );
  }
}

class Rating {
  double? rate;
  int? count;

  Rating({this.rate, this.count});

  Rating.fromJson(Map<String, dynamic> json)
      : rate = (json['rate'] is int)
            ? (json['rate'] as int).toDouble()
            : (json['rate'] as num?)?.toDouble(),
        count = json['count'];

  Map<String, dynamic> toJson() {
    return {
      'rate': rate,
      'count': count,
    };
  }
}