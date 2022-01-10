class Teacher {
  Teacher({
    this.firstname,
    this.lastname,
    this.gender,
    this.age,
    this.subject,
    this.currentclass,
  });

  String firstname;
  String lastname;
  String gender;
  String age;
  String subject;
  String currentclass;

  factory Teacher.fromJson(Map<String, dynamic> json) => Teacher(
        firstname: json["firstname"] == null ? null : json["firstname"],
        lastname: json["lastname"] == null ? null : json["lastname"],
        gender: json["gender"] == null ? null : json["gender"],
        age: json["age"] == null ? null : json["age"],
        subject: json["subject"] == null ? null : json["subject"],
        currentclass:
            json["currentclass"] == null ? null : json["currentclass"],
      );

  Map<String, dynamic> toJson() => {
        "firstname": firstname == null ? null : firstname,
        "lastname": lastname == null ? null : lastname,
        "gender": gender == null ? null : gender,
        "age": age == null ? null : age,
        "subject": subject == null ? null : subject,
        "currentclass": currentclass == null ? null : currentclass,
      };
}

// Map<String, dynamic> map = {
//   "firstname": "string",
//   "lastname": "",
//   "gender": "",
//   "age": "",
//   "subject": "",
//   "currentclass": ""
// };
