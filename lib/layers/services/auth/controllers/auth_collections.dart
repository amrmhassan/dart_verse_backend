// import 'package:dart_verse_backend/services/db_manager/db_service.dart';
// import 'package:dart_verse_backend/settings/app/app.dart';
// import 'package:mongo_dart/mongo_dart.dart';

// class AuthCollections {
//   final App _app;
//   final DbService _dbService;
//   const AuthCollections(this._app, this._dbService);
//   DbCollection get auth => DbCollection(
//         _dbService.getMongoDB,
//         _app.authSettings.collectionName,
//       );

//   DbCollection get activeJWTs => DbCollection(
//         _dbService.getMongoDB,
//         _app.authSettings.activeJWTCollName,
//       );
//   DbCollection get usersData => DbCollection(
//         _dbService.getMongoDB,
//         _app.userDataSettings.collectionName,
//       );
// }
