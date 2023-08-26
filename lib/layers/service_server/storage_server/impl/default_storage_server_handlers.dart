import 'dart:async';
import 'dart:io';

import 'package:dart_verse_backend/constants/header_fields.dart';
import 'package:dart_verse_backend/constants/path_fields.dart';
import 'package:dart_verse_backend/errors/models/storage_errors.dart';
import 'package:dart_verse_backend/layers/service_server/storage_server/repo/storage_server_handlers.dart';
import 'package:dart_verse_backend/layers/services/storage_buckets/models/storage_bucket_model.dart';
import 'package:dart_verse_backend/layers/settings/app/app.dart';
import 'package:dart_verse_backend/layers/settings/server_settings/utils/send_response.dart';
import 'package:dart_verse_backend/utils/storage_utils.dart';
import 'package:dart_webcore/dart_webcore/server/impl/request_holder.dart';
import 'package:dart_webcore/dart_webcore/server/impl/response_holder.dart';
import 'package:dart_webcore/dart_webcore/server/repo/passed_http_entity.dart';

import '../../../../errors/models/server_errors.dart';
import '../../../../errors/serverless_exception.dart';

class DefaultStorageServerHandlers implements StorageServerHandlers {
  DefaultStorageServerHandlers({
    required this.app,
  });

  @override
  App app;

  FutureOr<PassedHttpEntity> _wrapper(
    RequestHolder request,
    ResponseHolder response,
    Map<String, dynamic> pathArgs,
    Future Function() method,
  ) async {
    try {
      return await method();
    } on ServerException catch (e) {
      return SendResponse.sendBadBodyErrorToUser(
        response,
        e.message,
        e.code,
        errorCode: e.errorCode,
      );
    } on StorageException catch (e) {
      return SendResponse.sendAuthErrorToUser(
        response,
        e.message,
        e.code,
        errorCode: e.errorCode,
      );
    } on ServerLessException catch (e) {
      return SendResponse.sendOtherExceptionErrorToUser(
        response,
        e.message,
        e.code,
        errorCode: e.errorCode,
      );
    } catch (e) {
      return SendResponse.sendUnknownError(response, null);
    }
  }

  @override
  FutureOr<PassedHttpEntity> delete(
    RequestHolder request,
    ResponseHolder response,
    Map<String, dynamic> pathArgs,
  ) {
    return _wrapper(request, response, pathArgs, () async {
      String? bucketName = request.headers.value(HeaderFields.bucketName);
      StorageBucket? bucket = app.storageSettings.getBucket(bucketName);
      if (bucket == null) {
        throw NoBucketException(bucketName);
      }

      String ref = request.headers.value(HeaderFields.ref) ?? '/';
      StorageBucket refBucket = ref == '/' ? bucket : bucket.ref(ref);
      //! here i should check if this permission is allowed from the refBucket and the operation delete
      // here if allowed just delete the ref
      String? path = refBucket.getRefAbsPath(ref);
      if (path == null) {
        throw RefNotFound(refBucket.name, ref);
      }
      StorageUtils.deleteRef(
        path,
        bucketName: refBucket.name,
        ref: ref,
      );

      return SendResponse.sendDataToUser(response, 'deleted');
    });
  }

  @override
  FutureOr<PassedHttpEntity> download(
    RequestHolder request,
    ResponseHolder response,
    Map<String, dynamic> pathArgs,
  ) {
    return _wrapper(request, response, pathArgs, () async {
      // the download process will be from the link, but the user must be logged in first to access this route
      // so i can check for his permissions
      // but later i will add a public route for downloading files from the server(but protected files will still be protected)
      String fileRef = pathArgs[PathFields.filePath];
      String? bucketName = pathArgs[PathFields.bucketName] == 'null'
          ? null
          : pathArgs[PathFields.bucketName];
      StorageBucket? storageBucket = app.storageSettings.getBucket(bucketName);
      if (storageBucket == null) {
        throw NoBucketException(bucketName);
      }
      String? filePath = storageBucket.getRefAbsPath(fileRef);
      if (filePath == null) {
        throw FileNotFound(fileRef);
      }

      return response.writeFile(filePath);
    });
  }

  // headers
  // bucketName: String
  // allowed: List<Map<String, dynamic>>
  // private: bool

  @override
  FutureOr<PassedHttpEntity> upload(
    RequestHolder request,
    ResponseHolder response,
    Map<String, dynamic> pathArgs,
  ) {
    return _wrapper(request, response, pathArgs, () async {
      // the user will be my frontend package
      // here the user should send the bucket name he wants to save data to
      // if the bucket name is null or not sent then the user will upload or deal with the default bucket
      // if the user user sent bucket not found an error will be returned to the user
      String? bucketName = request.headers.value(HeaderFields.bucketName);
      StorageBucket? bucket = app.storageSettings.getBucket(bucketName);
      String? onFileExist = request.headers.value(HeaderFields.onFileExist);
      bool overrideIfExist = onFileExist == 'override';
      bool throwErrorIfExist = onFileExist == 'error';
      if (onFileExist == 'ignore') {
        overrideIfExist = false;
        throwErrorIfExist = false;
      }

      if (bucket == null) {
        throw NoBucketException(bucketName);
      }

      // then i want to save the uploaded file
      // but now i have a problem
      // the problem is about permissions
      // for the permissions get the permissions from the headers or just let it to be a public file
      // List<ACMPermission>? allowed;
      // try {
      //   allowed = _parseAllowed(request.headers);
      // } catch (e) {
      //   throw BadStorageBodyException(
      //       'allowed must be of type List<Map<String, dynamic>> [{"name":permission_name, "allowed":[list of allowed users or groups ids]}]');
      // }

      // the allowed problem was solved
      // but now i need a way to get the path of the file i want to save like

      String ref = request.headers.value(HeaderFields.ref) ?? '/';
      StorageBucket refBucket = ref == '/' ? bucket : bucket.ref(ref);
      //! here i should check if this permission is allowed from the refBucket and the operation write

      //? bucket permissions will be checked for the refBucket not the original bucket
      //? because the ref might refer to a child bucket inside the original one
      File file;
      file = await request.receiveFile(
        refBucket.folderPath,
        overrideIfExist: overrideIfExist,
        throwErrorIfExist: throwErrorIfExist,
      );

      String downloadEndpoint =
          app.endpoints.storageEndpoints.download.split('/')[1];
      String? fileRef = bucket.getFileRef(file);
      if (fileRef == null) {
        return SendResponse.sendDataToUser(
            response, 'file uploaded to: ${file.path}');
      }
      String downloadLink =
          '${app.backendHost}/$downloadEndpoint/${bucket.name}/$fileRef';
      return SendResponse.sendDataToUser(response, downloadLink);
    });
  }
}

      // List<ACMPermission>? _parseAllowed(HttpHeaders headers) {
      //   String? allowedString = headers.value(HeaderFields.allowed);
      //   if (allowedString == null) return null;
      //   List<dynamic> allowed = json.decode(allowedString);
      //   var res = allowed.map((e) => ACMPermission.fromJson(e)).toList();
      //   return res;

      //   /*
      //   allowed should be on the format
      //   {
      //     'write':[users ids],
      //     'read':[users ids],
      //     'delete':[users ids],
      //     'editPermissions':[users ids],
      //   }
      //   */
      // }
