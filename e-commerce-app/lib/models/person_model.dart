class Person {
  String name;
  String username;
  int? age;
  String email;
  String password;
  String? phoneNumber;

  Person({
    required this.name,
    required this.username,
    this.age,
    required this.email,
    required this.password,
    this.phoneNumber,
  });

  Person.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        username = json['username'],
        age = json['age'],
        email = json['email'],
        password = json['password'],
        phoneNumber = json['phoneNumber'];

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'username': username,
      'age': age,
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
    };
  }
}