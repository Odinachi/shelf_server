import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';

import '../model/auth/response_model.dart';

Handler teacherUpdatehandler({Db db}) => (Request req) async {
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
      var dbRef = db.collection("teachers");
      var _teacherCheck =
          await dbRef.findOne(where.eq("email", _email.toString()));

      if (_teacherCheck == null) {
        return Response(400,
            body: ResponseModel(
                    status: 400, message: "invalid teacher", data: null)
                .toJson()
                .toString());
      }
      final _input = _body;
      if (_input["subject"] != null) {
        await dbRef.updateOne(where.eq('email', '${_email}'),
            modify.set('subject', _input['subject']));
      }
      if (_input["currentclass"] != null) {
        await dbRef.updateOne(where.eq('email', '${_email}'),
            modify.set('currentclass', _input['currentclass']));
      }
      var _RteacherCheck =
          await dbRef.findOne(where.eq("email", _email.toString()));
      return Response(200,
          body: ResponseModel(
                  status: 201, message: "successful", data: _RteacherCheck)
              .toJson()
              .toString());
    };
