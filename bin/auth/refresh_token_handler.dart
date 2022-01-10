import 'dart:convert';

import 'package:shelf/shelf.dart';

import '../model/auth/response_model.dart';
import '../utils/constant.dart';
import '../utils/token_manager.dart';

Handler refreshTokenHandler({TokenManager tokenManager}) =>
    (Request req) async {
      final payload = await req.readAsString();
      final payloadMap = json.decode(payload);

      final token = verifyJwt(payloadMap['refreshToken']);
      if (token == null) {
        return Response(400, body: 'Refresh token is not valid.');
      }

      final dbToken = await tokenManager.getRefreshToken(token.jwtId);
      if (dbToken == null) {
        return Response(400, body: 'Refresh token is not recognised.');
      }

      final oldJwt = token;
      try {
        await tokenManager.removeRefreshToken((token).jwtId);

        final tokenPair = await tokenManager.createTokenPair(oldJwt.subject);
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
