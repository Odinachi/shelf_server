import 'package:dart_dotenv/dart_dotenv.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

import 'auth/auth.dart';
import 'update/update.dart';
import 'utils/constant.dart';
import 'utils/token_manager.dart';

void main(List<String> args) async {
  final tokenService = TokenManager();
  final dotEnv = DotEnv(filePath: '.env').getDotEnv();
  var _db = Db('${dotEnv['DATABASEURL']}');
  await _db.open();
  print("db connection open");

  final _router = Router();
  _router.mount(
      "/auth", AuthApi(dbRef: _db, tokenManager: tokenService).authRoute);
  _router.mount(
      "/update", UpdateApi(dbRef: _db, tokenManager: tokenService).authRoute);

  final _handler = Pipeline()
      .addMiddleware(handleCors())
      .addMiddleware(logRequests())
      .addMiddleware(HandleAuth())
      .addHandler(_router);

  final server = await serve(_handler, ip, port);
  print('Server listening on port  ${server.port}');
}
