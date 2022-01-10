import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';

import '../model/auth/response_model.dart';
import '../model/auth/sign_up_model.dart';
import '../model/auth/signin_model.dart';
import '../utils/constant.dart';
import '../utils/token_manager.dart';

var uuid = Uuid();

Handler loginHandler({Db db, TokenManager tokenManager}) {
  return (Request req) async {
    var value = await req.readAsString();

    if (value == "" || value == null) {
      return Response(400,
          body:
              ResponseModel(status: 400, message: "invalid request", data: null)
                  .toJson()
                  .toString());
    }
    var inputData = SignInModel.fromJson(json.decode(value));
    if ((inputData.username == null || inputData.username.length < 2) &&
        (inputData.email == null || inputData.email.length < 2)) {
      return Response(400,
          body: ResponseModel(
                  status: 400,
                  message: "input valid username/email",
                  data: null)
              .toJson()
              .toString());
    }
    if (inputData.password == null || inputData.password.length < 2) {
      return Response(400,
          body: ResponseModel(
                  status: 400, message: "input a valid passwords", data: null)
              .toJson()
              .toString());
    }

    var dbRef = db.collection("users");

    var mailCheck = await dbRef.findOne(where.eq("email", inputData.email));
    var usernameCheck =
        await dbRef.findOne(where.eq("username", inputData.username));

    if (mailCheck != null) {
      var response = mailCheck;
      SignUpModel user = SignUpModel(
          firstname: response['firstname'],
          lastname: response['lastname'],
          email: response['email'],
          salt: response['salt'],
          password: response['password'],
          gender: response['gender'],
          age: response['age'],
          accountType: response['account-type']);
      var verifyPassword =
          hashPassword(password: inputData.password, salt: user.salt);
      if (verifyPassword == user.password) {
        final _userId = (mailCheck["_id"] as ObjectId).toHexString();
        try {
          final tokenPair = await tokenManager.createTokenPair(_userId);
          return Response(200,
              body: ResponseModel(
                      status: 200,
                      message: "login successful",
                      data: tokenPair.toJson())
                  .toJson()
                  .toString(),
              headers: jsonHeaders);
        } catch (e) {
          return Response(500,
              body: ResponseModel(
                      status: 500,
                      message: "could not log you in because $e",
                      data: null)
                  .toJson()
                  .toString());
        }
      } else {
        return Response(400,
            body: ResponseModel(
                    status: 400, message: "invalid password", data: null)
                .toJson()
                .toString());
      }
    } else if (usernameCheck != null) {
      var response = usernameCheck;
      SignUpModel user = SignUpModel(
          firstname: response['firstname'],
          lastname: response['lastname'],
          email: response['email'],
          salt: response['salt'],
          password: response['password'],
          gender: response['gender'],
          age: response['age'],
          accountType: response['account-type']);
      var verifyPassword =
          hashPassword(password: inputData.password, salt: user.salt);
      if (verifyPassword == user.password) {
        final _userId = (usernameCheck["_id"] as ObjectId).toHexString();
        try {
          final tokenPair = await tokenManager.createTokenPair(_userId);
          return Response(200,
              body: ResponseModel(
                      status: 200,
                      message: "login successful",
                      data: tokenPair.toJson())
                  .toJson()
                  .toString(),
              headers: jsonHeaders);
        } catch (e) {
          return Response(500,
              body: ResponseModel(
                      status: 500,
                      message: "could not log you in because $e",
                      data: null)
                  .toJson()
                  .toString());
        }
      } else {
        return Response(400,
            body: ResponseModel(
                    status: 400, message: "invalid password", data: null)
                .toJson()
                .toString());
      }
    } else {
      return Response(400,
          body: ResponseModel(
                  status: 400,
                  message: "login doesn't match our record",
                  data: null)
              .toJson()
              .toString());
    }
  };
}
