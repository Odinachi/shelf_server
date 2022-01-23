import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dart_dotenv/dart_dotenv.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shelf/shelf.dart';

import '../model/auth/response_model.dart';

final ip = '0.0.0.0';
final dotEnv = DotEnv(filePath: '.env').getDotEnv();
final port = int.parse(Platform.environment['PORT'] ?? '8080');
final issuer = 'Issuer247Hash256';
final secret = '23408080822222fffgbhhhh';
final jsonHeaders = {HttpHeaders.contentTypeHeader: ContentType.json.mimeType};

hashPassword({String password, String salt}) {
  var codec = Utf8Codec();
  var key = codec.encode(password);
  var saltBytes = codec.encode(salt);
  var hmacSha256 = Hmac(sha256, key);
  var digest = hmacSha256.convert(saltBytes);
  return digest.toString();
}

String generateJwt(
  String subject, {
  String jwtId,
  Duration expiry = const Duration(minutes: 30),
}) {
  final jwt = JWT(
    {
      'iat': DateTime.now().millisecondsSinceEpoch,
      'id': 123,
      'server': {
        'id': '3e4fc296',
        'loc': 'euw-2',
      }
    },
    subject: subject,
    issuer: issuer,
    jwtId: jwtId,
  );
  return jwt.sign(SecretKey(secret), expiresIn: expiry);
}

dynamic verifyJwt(String token) {
  try {
    final jwt = JWT.verify(token, SecretKey(secret));
    return jwt;
  } on FormatException catch (e) {
    return null;
  } on JWTParseError catch (e) {
    return null;
  } on JWTUndefinedError catch (e) {
    return null;
  } on JWTInvalidError catch (e) {
    return null;
  } on JWTExpiredError {
    // TODO Handle error
    return null;
  } on JWTError catch (err) {
    return null;
    // TODO Handle error
  }
}

Middleware HandleAuth() => (Handler innerHandler) => (Request request) async {
      final authHeader = request.headers['authorization'];
      var token, jwt;
      if (authHeader != null && authHeader.startsWith("Bearer ")) {
        token = authHeader.substring(7);
        jwt = verifyJwt(token);
      }
      final updatedRequest = request.change(context: {"authDetails": jwt});
      return await innerHandler(updatedRequest);
    };

Middleware checkAuthorization() => createMiddleware(
      requestHandler: (Request request) {
        if (request.context['authDetails'] == null) {
          return Response(400,
              body: ResponseModel(
                      status: 400, message: "unAuthorized", data: null)
                  .toJson()
                  .toString());
        }
        return null;
      },
    );
Middleware handleCors() {
  const corsHeaders = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE',
    'Access-Control-Allow-Headers': 'Origin, Content-Type',
  };

  return createMiddleware(
    requestHandler: (Request request) {
      if (request.method == 'OPTIONS') {
        return Response.ok('', headers: corsHeaders);
      }
      return null;
    },
    responseHandler: (Response response) {
      return response.change(headers: corsHeaders);
    },
  );
}
