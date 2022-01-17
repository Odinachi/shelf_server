import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../utils/constant.dart';
import '../utils/token_manager.dart';
import 'guardian_update.dart';
import 'student_update.dart';
import 'teacher_update.dart';

class UpdateApi {
  Db dbRef;
  TokenManager tokenManager;
  UpdateApi({this.dbRef, this.tokenManager});

  Handler get authRoute {
    final auth = Router();

    //1. student 2. guardian 3. teachers
    auth.post("/1</|.*>", studentUpdatehandler(db: dbRef));
    auth.post("/2</|.*>", guardianUpdatehandler(db: dbRef));
    auth.post("/3</|.*>", teacherUpdatehandler(db: dbRef));

    final _handler =
        Pipeline().addMiddleware(checkAuthorization()).addHandler((auth));

    return _handler;
  }
}
