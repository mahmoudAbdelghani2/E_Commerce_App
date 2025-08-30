class Person {
  static final Person _instance = Person._internal();

  String uid = '';
  String name = '';
  String username = '';
  int? age;
  String email = '';
  String? phoneNumber;
  String? imageUrl;

  factory Person() {
    return _instance;
  }

  Person._internal();

  Person.fromJson(Map<String, dynamic> json)
      : uid = json['uid'],
        name = json['name'],
        username = json['username'],
        age = json['age'],
        email = json['email'],
        phoneNumber = json['phoneNumber'],
        imageUrl = json['imageUrl'];

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'username': username,
      'age': age,
      'email': email,
      'phoneNumber': phoneNumber,
      'imageUrl': imageUrl,
    };
  }

  // يمكنك إضافة دالة لتحديث البيانات من JSON
  void updateFromJson(Map<String, dynamic> json) {
    uid = json['uid'] ?? uid;
    name = json['name'] ?? name;
    username = json['username'] ?? username;
    age = json['age'] ?? age;
    email = json['email'] ?? email;
    phoneNumber = json['phoneNumber'] ?? phoneNumber;
    imageUrl = json['imageUrl'] ?? imageUrl;
  }
}
