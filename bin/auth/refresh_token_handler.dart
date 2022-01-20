import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';

import '../model/auth/response_model.dart';
import '../utils/constant.dart';
import '../utils/token_manager.dart';

Handler refreshTokenHandler({Db db, TokenManager tokenManager}) =>
    (Request req) async {
      final payload = await req.readAsString();
      final payloadMap = json.decode(payload);
      var tokenRef = db.collection("tokens");
      final token = verifyJwt(payloadMap['refreshToken']);
      if (token == null) {
        return Response(400,
            body: ResponseModel(
                    status: 400, message: "invalid Refresh token", data: null)
                .toJson()
                .toString());
      }

      final dbToken = await tokenManager.getRefreshToken(
          id: payloadMap['refreshToken'], db: tokenRef);
      if (dbToken == null) {
        return Response(400,
            body: ResponseModel(
                    status: 400,
                    message: "refresh token is not recognized",
                    data: null)
                .toJson()
                .toString());
      }

      final oldJwt = token;

      try {
        await tokenManager.removeRefreshToken(id: (token).jwtId, db: tokenRef);

        final tokenPair = await tokenManager.createTokenPair(
            userId: oldJwt.subject, db: tokenRef, email: (token).subject);
        return Response(200,
            body: ResponseModel(
                    status: 200,
                    message: "token refreshed",
                    data: tokenPair.toJson())
                .toJson()
                .toString());
      } catch (e) {
        return Response(400,
            body: ResponseModel(
                    status: 400,
                    message: "could not refresh token because $e",
                    data: null)
                .toJson()
                .toString());
      }
    };
