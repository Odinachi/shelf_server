class SignInModel {
  SignInModel({
    this.email,
    this.username,
    this.password,
  });

  String email;
  String username;
  String password;

  factory SignInModel.fromJson(Map<String, dynamic> json) => SignInModel(
        email: json["email"] == null ? null : json["email"],
        username: json["username"] == null ? null : json["username"],
        password: json["password"] == null ? null : json["password"],
      );

  Map<String, dynamic> toJson() => {
        "email": email == null ? null : email,
        "username": username == null ? null : username,
        "password": password == null ? null : password,
      };
}
