class Guardian {
  Guardian(
      {this.firstname,
      this.lastname,
      this.gender,
      this.age,
      this.email,
      this.homeaddress,
      this.wards,
      this.workaddress});

  String firstname;
  String lastname;
  String gender;
  String age;
  String email;
  String homeaddress;
  String workaddress;
  List<String> wards;

  factory Guardian.fromJson(Map<String, dynamic> json) => Guardian(
        email: json["email"] == null ? null : json["email"],
        firstname: json["firstname"] == null ? null : json["firstname"],
        lastname: json["lastname"] == null ? null : json["lastname"],
        gender: json["gender"] == null ? null : json["gender"],
        age: json["age"] == null ? null : json["age"],
        homeaddress: json["homeaddress"] == null ? null : json["homeaddress"],
        workaddress: json["workaddress"] == null ? null : json["workaddress"],
        wards: json["wards"] == null ? null : json["wards"],
      );

  Map<String, dynamic> toJson() => {
        "firstname": firstname == null ? null : firstname,
        "lastname": lastname == null ? null : lastname,
        "gender": gender == null ? null : gender,
        "age": age == null ? null : age,
        "homeaddress": homeaddress == null ? null : homeaddress,
        "workaddress": workaddress == null ? null : workaddress,
        "wards": wards == null ? null : wards,
        "email": email == null ? null : email,
      };
}

// Map<String, dynamic> map = {
//   "firstname": "string",
//   "lastname": "",
//   "gender": "",
//   "age": "",
//   "guardian": "",
//   "address": "",
//   "currentclass": ""
// };
