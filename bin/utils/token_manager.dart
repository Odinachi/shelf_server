import 'package:mongo_dart/mongo_dart.dart';
import 'package:uuid/uuid.dart';

import 'constant.dart';
import 'token_pair.dart';

class TokenManager {
  TokenManager();

  Future<TokenPair> createTokenPair(
      {String userId, DbCollection db, String email}) async {
    final tokenId = Uuid().v4();
    final token = generateJwt(userId, jwtId: tokenId);

    final refreshTokenExpiry = Duration(days: 3);
    final refreshToken = generateJwt(
      userId,
      jwtId: tokenId,
      expiry: refreshTokenExpiry,
    );
    var hasToken = await db.findOne(where.eq("email", "${email}"));
    if (hasToken != null) {
      await updateRefreshToken(
          id: tokenId,
          token: refreshToken,
          expiry: refreshTokenExpiry,
          db: db,
          email: email);
    } else {
      await addRefreshToken(
          id: tokenId,
          token: refreshToken,
          expiry: refreshTokenExpiry,
          db: db,
          email: email);
    }

    return TokenPair(token, refreshToken);
  }

  Future<void> addRefreshToken(
      {String id,
      String token,
      Duration expiry,
      DbCollection db,
      String email}) async {
    await db.insert(
        {'email': '$email', 'refresh-token': '$token', 'time': DateTime.now()});
  }

  Future<void> updateRefreshToken(
      {String id,
      String token,
      Duration expiry,
      DbCollection db,
      String email}) async {
    var hasToken = await db.findOne(where.eq("email", "${email}"));
    hasToken["refresh-token"] = token;
    hasToken['email'] = email;
    hasToken['time'] = DateTime.now();
    await db.save(hasToken);
  }

  Future<dynamic> getRefreshToken({String id, DbCollection db}) async {
    dynamic _i = await db.findOne(where.eq('refresh-token', '$id'));
    return _i != null ? _i['refresh-token'] : null;
  }

  Future<void> removeRefreshToken({String id, DbCollection db}) async {
    await db.deleteOne(where.eq('refresh-token', '$id'));
  }
}
