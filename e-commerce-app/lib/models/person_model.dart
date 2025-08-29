class Person {
  String uid;
  String name;
  String username;
  int? age;
  String email;
  String? phoneNumber;
  String? imageUrl;

  Person({
    required this.uid,
    required this.name,
    required this.username,
    this.age,
    required this.email,
    this.phoneNumber,
    this.imageUrl,
  });

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
}
