import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../utils/token_manager.dart';
import 'login.dart';
import 'logout.dart';
import 'refresh_token_handler.dart';
import 'register.dart';

class AuthApi {
  Db dbRef;
  TokenManager tokenManager;
  AuthApi({this.dbRef, this.tokenManager});

  Handler get authRoute {
    final auth = Router();
    auth.post(
        "/login</|.*>", loginHandler(db: dbRef, tokenManager: tokenManager));
    auth.post("/register</|.*>", registerHandler(db: dbRef));
    auth.post("/logout</|.*>", logoutHandler(tokenManager: tokenManager));
    auth.get("/refreshtoken</|.*>",
        refreshTokenHandler(tokenManager: tokenManager, db: dbRef));

    return auth;
  }
}
