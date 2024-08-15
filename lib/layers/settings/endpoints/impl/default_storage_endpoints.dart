import 'package:dart_verse_backend_new/constants/endpoints_constants.dart';
import 'package:dart_verse_backend_new/layers/settings/endpoints/repo/storage_endpoints.dart';

class DefaultStorageEndpoints implements StorageEndpoints {
  @override
  String delete = EndpointsConstants.deleteFile;

  @override
  String download = EndpointsConstants.downloadFile;

  @override
  String upload = EndpointsConstants.uploadFile;
}
