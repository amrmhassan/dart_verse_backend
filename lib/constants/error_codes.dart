class ErrorCodes {
  //? global request
  static const String badRequestBody = 'bad-request-body';
  //? app error codes
  static const String noDbSettingsCode = 'no-db-settings-provided';
  static const String noMongoDbProvider = 'no-mongo-db-provider';
  static const String noMemoryDbProvider = 'no-memory-db-provider';
  static const String noAuthSettings = 'no-auth-settings-provided';
  static const String noServerSettings = 'no-server-settings-provided';
  static const String noUserDataSettings = 'no-user-data-settings-provided';
  static const String noEmailSettings = 'no-email-settings-provided';
  //? server error codes
  static const String noRouterSet = 'no-router-set';
  static const String requestBoyError = 'bad-body-provided';
  static const String noAuthServerSettings = 'no-auth-server-settings';
  //? user data error codes
  static const String userDataAuthService =
      'user-data-service-depend-on-auth-service';
  //? db error codes
  static const String dbReadCode = 'db-read-error';
  static const String dbWriteCode = 'db-write-error';
  static const String dbDeleteCode = 'db-delete-error';
  static const String dbDocValidation = 'db-doc-validation';
  static const String mongoDbNotInitialized = 'mongo-db-not-initialized';
  static const String dbNotConnoted = 'db-not-connected';
  static const String dbAlreadyConnoted = 'db-already-connected';
  static const String docNotFound = 'doc-not-found';
  static const String mongoDbNotConnected = 'mongo-db-not-connected';
  //? auth errors
  static const String duplicateEmail = 'duplicate-email-register';
  static const String noUserRegistered = 'no-user-registered';
  static const String invalidPassword = 'invalid-password-login';
  static const String activeJwtExceed = 'many-active-sessions';
  static const String noAuthHeaderProvided = 'no-auth-header';
  static const String authHeaderNotValid = 'auth-header-not-valid';
  static const String jwtNotValid = 'jwt-not-valid';
  static const String jwtAccessNotAllowed = 'jwt-access-not-allowed';
  static const String jwtEmailVerifyExpired = 'jwt-email-verify-expired';
  static const String userNotFoundToVerify = 'user-not-found-to-verify';
  static const String userNotFound = 'user-not-found';
  static const String noAppIdProvided = 'no-app-id-provided';
  static const String notAuthorizedAppId = 'not-authorized-appid';
  static const String userEmailNotVerified = 'user-email-not-verified';

  //? email errors
  static const String emailTemplateFileNotFound =
      'email-template-file-not-found';
  //? email verification errors
  static const String failedToVerify = 'failed-to-verify';
  static const String earlyEmailVerification = 'early-email-verification';
  static const String userAlreadyVerified = 'user-already-verified';

  //? storage errors
  static const String storageBucketNameInvalid = 'storage-bucket-name-invalid';
  static const String storageBucketPathInvalid = 'storage-bucket-path-invalid';
  static const String noStorageSettingsProvided = 'no-storage-settings';
  static const String noBucketFound = 'no-bucket-found';
  static const String refNotFound = 'ref-not-found';
  static const String fileNotFound = 'file-not-found';
  static const String folderNotFound = 'folder-not-found';
  static const String storageServiceNotInit = 'storage-service-not-init';
  static const String storageBucketPathChange =
      'storage-bucket-exists-with-different-path';
  static const String refNotEmpty = 'ref-not-empty';
  static const String invalidBucketEditing = 'invalid-bucket-editing';
  static const String bucketNotInitiated = 'bucket-not-initiated';

  //? auth server errors
  static const String noAuthServerProvided = 'no-auth-server-provided';
  //? db server errors
  static const String noDbServerProvided = 'no-db-server-provided';
  //? app check
  static const String notAuthorizedApiKey = 'not-authorized-api-key';
  static const String notValidApiKey = 'not-valid-api-key';
  static const String appCheckNotProvided = 'app-check-not-provided';
}
