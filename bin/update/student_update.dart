import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';

import '../model/auth/response_model.dart';

Handler studentUpdatehandler({Db db}) => (Request req) async {
      final _i = await req.readAsString();
      if (_i == null || _i == "") {
        return Response(400,
            body: ResponseModel(
                    status: 400, message: "invalid body parameters", data: null)
                .toJson()
                .toString());
      }
      final _body = json.decode(_i);
      final _auth = (req.context['authDetails'] as JWT);
      final _email = _auth.subject;

      if (_auth == null || _email == null) {
        return Response(400,
            body: ResponseModel(
                    status: 400,
                    message: "invalid token parameters",
                    data: null)
                .toJson()
                .toString());
      }
      var dbRef = db.collection("students");
      var _studentCheck =
          await dbRef.findOne(where.eq("email", _email.toString()));

      if (_studentCheck == null) {
        return Response(400,
            body: ResponseModel(
                    status: 400, message: "invalid student", data: null)
                .toJson()
                .toString());
      }
      final _input = _body;
      print("input is ${_input}");
      if (_input["currentclass"] != null) {
        await dbRef.updateOne(where.eq('email', '${_email}'),
            modify.set('currentclass', _input['currentclass']));
      }
      if (_input["guardian"] != null) {
        await dbRef.updateOne(where.eq('email', '${_email}'),
            modify.set('guardian', _input['guardian']));
      }
      var _RstudentCheck =
          await dbRef.findOne(where.eq("email", _email.toString()));
      return Response(200,
          body: ResponseModel(
                  status: 201, message: "successful", data: _RstudentCheck)
              .toJson()
              .toString());
    };
