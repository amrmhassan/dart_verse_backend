import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dart_verse/layers/settings/app/app.dart';

import '../models/jwt_payload.dart';

class JWTController {
  final App _app;

  const JWTController(this._app);

  Future<String> createJwtAndSave({
    required String id,
    required String email,
    required Function({required String id, required String jwt}) saveJwt,
  }) async {
    var key = _app.authSettings.jwtSecretKey;
    JWTPayloadModel jwtPayload = JWTPayloadModel(
      id: id,
      email: email,
      createdAt: DateTime.now().toIso8601String(),
      ip: null,
      other: {},
    );
    var jwt = JWT(jwtPayload.toJson());
    String signedJWT = jwt.sign(
      key,
      expiresIn: _app.authSettings.authExpireAfter,
      algorithm: _app.authSettings.jwtAlgorithm,
    );
    await saveJwt(id: id, jwt: signedJWT);
    return signedJWT;
  }

  // Future<void> _saveJWT({
  //   required String id,
  //   required String jwt,
  // }) async {
  //   try {
  //     var selector = where.eq(ModelFields.id, id);
  //     var update = modify.push(ModelFields.activeTokens, jwt);
  //     await _authCollections.activeJWTs.updateOne(
  //       selector,
  //       update,
  //       upsert: true,
  //     );
  //   } catch (e) {
  //     logger.e(e);
  //     throw DBWriteException('failed to save active jwt');
  //   }
  // }
}
