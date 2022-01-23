import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';

import '../model/auth/response_model.dart';
import '../utils/token_manager.dart';

Handler meHandler({Db db, TokenManager tokenManager}) => (
      Request request,
    ) async {
      final _auth = (request.context['authDetails'] as JWT);
      print("header is ${_auth}");
      if (_auth == null) {
        return Response(400,
            body: ResponseModel(
                    status: 400,
                    message: "invalid token parameters",
                    data: null)
                .toJson()
                .toString());
      }
      final _email = _auth.subject;
      if (_email == null) {
        return Response(400,
            body: ResponseModel(
                    status: 400,
                    message: "invalid token parameters",
                    data: null)
                .toJson()
                .toString());
      }

      var dbRef = db.collection("users");
      var _userCheck =
          await dbRef.findOne(where.eq("email", _email.toString()));

      if (_userCheck == null) {
        return Response(400,
            body:
                ResponseModel(status: 400, message: "invalid User", data: null)
                    .toJson()
                    .toString());
      }

      return Response(200,
          body: ResponseModel(
                  status: 200, message: "successfully", data: _userCheck)
              .toJson()
              .toString());
    };
