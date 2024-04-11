class User {
  final String id;
  final String username;
  final String email;
  final String password;

  User(this.id, this.username, this.email, this.password);

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        username = json['username'],
        email = json['email'],
        password = json['password'];
}
