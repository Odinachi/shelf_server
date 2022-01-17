class Student {
  Student(
      {this.firstname,
      this.lastname,
      this.gender,
      this.age,
      this.guardian,
      this.registrar,
      this.currentclass,
      this.email});

  String firstname;
  String lastname;
  String gender;
  String age;
  String email;
  String guardian;
  String registrar;
  String currentclass;

  factory Student.fromJson(Map<String, dynamic> json) => Student(
        email: json["email"] == null ? null : json["email"],
        firstname: json["firstname"] == null ? null : json["firstname"],
        lastname: json["lastname"] == null ? null : json["lastname"],
        gender: json["gender"] == null ? null : json["gender"],
        age: json["age"] == null ? null : json["age"],
        guardian: json["guardian"] == null ? null : json["guardian"],
        registrar: json["registrar"] == null ? null : json["registrar"],
        currentclass:
            json["currentclass"] == null ? null : json["currentclass"],
      );

  Map<String, dynamic> toJson() => {
        "firstname": firstname == null ? null : firstname,
        "lastname": lastname == null ? null : lastname,
        "gender": gender == null ? null : gender,
        "age": age == null ? null : age,
        "guardian": guardian == null ? null : guardian,
        "registrar": registrar == null ? null : registrar,
        "currentclass": currentclass == null ? null : currentclass,
        "email": email == null ? null : email,
      };
}

// Map<String, dynamic> map = {
//   "firstname": "string",
//   "lastname": "",
//   "gender": "",
//   "age": "",
//   "guardian": "",
//   "registrar": "",
//   "currentclass": ""
// };
