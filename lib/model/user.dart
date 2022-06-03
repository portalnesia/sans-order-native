import 'dart:convert';

class User {
  final String? name;
  final String? username;
  final String? picture;
  final String? email;
  final int? id;

  const User({
    this.name,
    this.username,
    this.picture,
    this.email,
    this.id
  });

  @override
  String toString() {
    Map<String,dynamic> json = {
      'name': name,
      'username': username,
      'picture': picture,
      'email': email,
      'id': id
    };
    return jsonEncode(json);
  }

  static User fromLogin(String jsonString) {
    Map<String,dynamic> json = jsonDecode(jsonString);

    return User(
      email: json['email'],
      name: json['name'],
      username: json['username'],
      picture: json['picture'],
      id: json['sub']
    );
  }

  static User fromString(String jsonString) {
    Map<String,dynamic> json = jsonDecode(jsonString);

    return User(
      email: json['email'],
      name: json['name'],
      username: json['username'],
      picture: json['picture'],
      id: json['id']
    );
  }
}