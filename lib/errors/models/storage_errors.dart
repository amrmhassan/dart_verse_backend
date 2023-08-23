// ignore_for_file: overridden_fields

import 'dart:io';

import 'package:dart_verse/constants/error_codes.dart';

import '../serverless_exception.dart';

class StorageException extends ServerLessException {
  @override
  String message;
  @override
  String code;

  @override
  int errorCode;
  StorageException(
    this.message,
    this.code, {
    this.errorCode = 500,
  }) : super(
          code,
          errorCode: errorCode,
        );
}

//? storage errors
class StorageBucketNameException extends StorageException {
  StorageBucketNameException([String? msg])
      : super(
          'storage bucket name invalid, must only contain numbers and letters and not exceed 50 letters: ${msg ?? ''}',
          ErrorCodes.storageBucketNameInvalid,
        );
}

class StorageBucketFolderPathException extends StorageException {
  StorageBucketFolderPathException([String? msg])
      : super(
          'please enter a valid folder path: ${msg ?? ''}',
          ErrorCodes.storageBucketPathInvalid,
        );
}

class BucketNotCreatedException extends StorageException {
  BucketNotCreatedException([String? msg])
      : super(
          'storage bucket wasn\'t created! please create it first: ${msg ?? ''}',
          ErrorCodes.storageBucketPathInvalid,
        );
}

class DuplicateBucketPathException extends StorageException {
  DuplicateBucketPathException([String? msg])
      : super(
          'duplicate bucket path: ${msg ?? ''}',
          ErrorCodes.storageBucketPathInvalid,
        );
}

class DuplicateBucketNameException extends StorageException {
  DuplicateBucketNameException([String? msg])
      : super(
          'duplicate bucket name: ${msg ?? ''}',
          ErrorCodes.storageBucketNameInvalid,
        );
}

class NoStorageSettingsProvided extends StorageException {
  NoStorageSettingsProvided()
      : super(
          'no storage settings provided in the app',
          ErrorCodes.noStorageSettingsProvided,
        );
}

class NoBucketException extends StorageException {
  NoBucketException(String? name)
      : super(
          'please provide a valid bucket name or don\'t provide any name for using the default bucket: $name',
          ErrorCodes.noBucketFound,
          errorCode: 404,
        );
}

class BadStorageBodyException extends StorageException {
  BadStorageBodyException(String msg)
      : super(
          'bad body for storage options: $msg',
          ErrorCodes.badRequestBody,
          errorCode: HttpStatus.badRequest,
        );
}

class FileNotFound extends StorageException {
  FileNotFound(String msg)
      : super(
          'file not found: $msg',
          ErrorCodes.noBucketFound,
          errorCode: HttpStatus.notFound,
        );
}

class RefNotFound extends StorageException {
  RefNotFound(String bucketName, String ref)
      : super(
          'path not found for this ref:BucketName: $bucketName\nRef: $ref',
          ErrorCodes.refNotFound,
          errorCode: HttpStatus.notFound,
        );
}

class StorageServiceNotInitializedException extends StorageException {
  StorageServiceNotInitializedException()
      : super(
          'storage service not initialized call init()',
          ErrorCodes.storageServiceNotInit,
          errorCode: HttpStatus.internalServerError,
        );
}

class StorageBucketExistsException extends StorageException {
  StorageBucketExistsException(String name)
      : super(
          'storage bucket ($name) already exists with different path',
          ErrorCodes.storageBucketPathChange,
          errorCode: HttpStatus.internalServerError,
        );
}
