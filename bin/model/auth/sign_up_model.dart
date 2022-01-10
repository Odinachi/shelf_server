class SignUpModel {
  SignUpModel({
    this.firstname,
    this.lastname,
    this.gender,
    this.age,
    this.email,
    this.username,
    this.password,
    this.accountType,
    this.salt,
  });

  String firstname;
  String lastname;
  String gender;
  String age;
  String email;
  String username;
  String password;
  int accountType;
  String salt;

  SignUpModel copyWith(
          {String firstname,
          String lastname,
          String gender,
          String age,
          String email,
          String username,
          String password,
          int accountType,
          String salt}) =>
      SignUpModel(
        firstname: firstname ?? this.firstname,
        lastname: lastname ?? this.lastname,
        gender: gender ?? this.gender,
        age: age ?? this.age,
        email: email ?? this.email,
        username: username ?? this.username,
        password: password ?? this.password,
        accountType: accountType ?? this.accountType,
        salt: salt ?? this.salt,
      );

  factory SignUpModel.fromJson(Map<String, dynamic> json) => SignUpModel(
      firstname: json["firstname"] == null ? null : json["firstname"],
      lastname: json["lastname"] == null ? null : json["lastname"],
      gender: json["gender"] == null ? null : json["gender"],
      age: json["age"] == null ? null : json["age"],
      email: json["email"] == null ? null : json["email"],
      username: json["username"] == null ? null : json["username"],
      password: json["password"] == null ? null : json["password"],
      accountType: json["account-type"] == null ? null : json["account-type"],
      salt: json['salt'] == null ? null : json["salt"]);

  Map<String, dynamic> toJson() => {
        "firstname": firstname == null ? null : firstname,
        "lastname": lastname == null ? null : lastname,
        "gender": gender == null ? null : gender,
        "age": age == null ? null : age,
        "email": email == null ? null : email,
        "username": username == null ? null : username,
        "password": password == null ? null : password,
        "account-type": accountType == null ? null : accountType,
        "salt": salt == null ? null : salt
      };
}
