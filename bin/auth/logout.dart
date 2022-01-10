import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shelf/shelf.dart';

import '../model/auth/response_model.dart';
import '../utils/token_manager.dart';

Handler logoutHandler({TokenManager tokenManager}) => (
      Request request,
    ) async {
      final auth = request.context['authDetails'];
      if (auth == null) {
        return Response(400,
            body: ResponseModel(
                    status: 400, message: "invalid request", data: null)
                .toJson()
                .toString());
      }
      try {
        await tokenManager.removeRefreshToken((auth as JWT).jwtId);
      } catch (e) {
        return Response(500,
            body: ResponseModel(
                    status: 500,
                    message: "could not log you out because  $e",
                    data: null)
                .toJson()
                .toString());
      }

      return Response(200,
          body: ResponseModel(
                  status: 200, message: "logout successfully", data: null)
              .toJson()
              .toString());
    };
