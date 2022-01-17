import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';

import '../model/auth/guardian_model.dart';
import '../model/auth/response_model.dart';
import '../model/auth/sign_up_model.dart';
import '../model/auth/student.dart';
import '../model/auth/teacher_model.dart';
import '../utils/constant.dart';
import 'login.dart';

Handler registerHandler({Db db}) {
  return (Request req) async {
    var value = await req.readAsString();
    if (value == "" || value == null) {
      return Response(400,
          body:
              ResponseModel(status: 400, message: "invalid request", data: null)
                  .toJson()
                  .toString());
    }
    var newData = SignUpModel.fromJson(json.decode(value));
    if (newData.firstname == null || newData.firstname.length < 2) {
      return Response(400,
          body: ResponseModel(
                  status: 400, message: "Invalid firstname", data: null)
              .toJson()
              .toString());
    }
    if (newData.accountType == null || newData.accountType > 3) {
      return Response(400,
          body: ResponseModel(
                  status: 400, message: "Invalid account type", data: null)
              .toJson()
              .toString());
    }
    if (newData.lastname == null || newData.lastname.length < 2) {
      return Response(400,
          body: ResponseModel(
                  status: 400, message: "Invalid lastname", data: null)
              .toJson()
              .toString());
    }
    if (newData.age == null || newData.age.length < 2) {
      return Response(400,
          body: ResponseModel(status: 400, message: "Invalid age", data: null)
              .toJson()
              .toString());
    }
    if (newData.email == null || newData.email.length < 2) {
      return Response(400,
          body: ResponseModel(status: 400, message: "Invalid email", data: null)
              .toJson()
              .toString());
    }
    if (newData.password == null || newData.password.length < 6) {
      return Response(400,
          body: ResponseModel(
                  status: 400, message: "Invalid password", data: null)
              .toJson()
              .toString());
    }
    if (newData.gender == null || newData.gender.length < 2) {
      return Response(40,
          body: ResponseModel(
                  status: 400, message: "Invalid invalid gender", data: null)
              .toJson()
              .toString());
    }

    var dbRef = db.collection("users");
    var mailCheck = await dbRef.findOne(where.eq("email", newData.email));
    if (mailCheck != null) {
      return Response(400,
          body: ResponseModel(status: 400, message: "email exist", data: null)
              .toJson()
              .toString());
    }
    var usernameCheck =
        await dbRef.findOne(where.eq("username", newData.username));
    if (usernameCheck != null) {
      return Response(400,
          body:
              ResponseModel(status: 400, message: "username exist", data: null)
                  .toJson()
                  .toString());
    }
    var salt = uuid.v4().toString();
    var password = hashPassword(salt: salt, password: newData.password);
    var _profileId;
    SignUpModel signUpModel = SignUpModel(
        username: newData.username,
        firstname: newData.firstname,
        lastname: newData.lastname,
        email: newData.email,
        salt: salt,
        password: password,
        accountType: newData.accountType,
        age: newData.age,
        gender: newData.gender);
    //1. student 2. guardian 3. teachers

    if (newData.accountType == 1) {
      var sDbRef = db.collection("students");
      Student _student = Student(
          firstname: newData.firstname,
          lastname: newData.lastname,
          gender: newData.gender,
          age: newData.age,
          email: newData.email);
      await sDbRef.insert(_student.toJson());
    } else if (newData.accountType == 2) {
      var gDbRef = db.collection("guardians");
      Guardian _guardian = Guardian(
          firstname: newData.firstname,
          lastname: newData.lastname,
          gender: newData.gender,
          age: newData.age,
          email: newData.email);
      await gDbRef.insert(_guardian.toJson());
    } else {
      var tDbRef = db.collection("teachers");
      Teacher _teacher = Teacher(
          firstname: newData.firstname,
          lastname: newData.lastname,
          age: newData.age,
          gender: newData.gender,
          email: newData.email);
      await tDbRef.insert(_teacher.toJson());
    }
    await dbRef.insert(signUpModel.toJson());
    return Response(200,
        body: ResponseModel(
                status: 201, message: "successful", data: signUpModel.toJson())
            .toJson()
            .toString());
  };
}
