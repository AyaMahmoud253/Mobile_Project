class User {
  String? id;
  String? name;
  String? gender;
  String? email;
  String? level;
  String? password;
  String? confirmPassword;

  User({
    this.id,
    this.name,
    this.gender,
    this.email,
    this.level,
    this.password,
    this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      //'id': id,
      'name': name,
      'gender': gender,
      'email': email,
      'level': level,
      'password': password,
      'confirmPassword': confirmPassword,
    };
  }
}
