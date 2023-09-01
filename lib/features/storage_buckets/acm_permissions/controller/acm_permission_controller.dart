import 'dart:convert';

import 'package:dart_verse_backend/features/storage_buckets/acm_permissions/constants/default_permissions.dart';
import 'package:dart_verse_backend/features/storage_buckets/acm_permissions/models/acm.dart';
import 'package:dart_verse_backend/features/storage_buckets/models/storage_bucket_model.dart';
import 'package:dart_verse_backend/utils/encryption.dart';

class ACMPermissionController {
  final StorageBucket bucket;

  ACMPermissionController(this.bucket) {
    _init();
  }

  late ACM _acm;
  bool isUserAllowed(String permissionName, String userId) {
    var permissionInfo = _acm.getPermissionInfo(permissionName);
    if (permissionInfo == null) return false;
    if (permissionInfo.allowed.contains('*')) return true;
    if (permissionInfo.allowed.contains(userId)) return true;
    if (permissionInfo.allowed.isEmpty && userId == _creatorId) return true;
    return false;
  }

  void addUser(String permissionName, String userId) {
    _acm.addUser(permissionName, userId);
    // save the updated to the acm file again
    _writeAcmFile();
  }

//! i should make a new line in the acm file holding the users who can access any permission in the bucket
  void addUserToAll(String userId) {
    _acm.addToAll(userId);
    _writeAcmFile();
  }

  void allowToAllPermission() {
    _acm.allowToAllPermission();
    _writeAcmFile();
  }

  void allowAllToPermission(String permissionName) {
    _acm.allowAllToPermission(permissionName);
    _writeAcmFile();
  }

  // void editSubPermission(String ref, List<ACMPermission> permissions) {
  //   SubACM subACM = SubACM(ref, permissions: permissions);
  // }

// this will read the content of the file and convert it into acm object
  void _loadAcmPermissions(String fileContent) {
    Map<String, dynamic> acmJson = _getJsonPermissions(fileContent);
    var retrieved = ACM.fromJson(acmJson);
    _acm = retrieved;
  }

  Map<String, dynamic> _getJsonPermissions(String content) {
    return json.decode(content.split(_acmInfoSeparator)[1]);
  }

  String _initAcmObject() {
    String creatorId = bucket.creatorId ?? '';
    _acm = ACM(defaultPermissionsWithCreatorId(creatorId));

    String jsonContent = json.encode(_acm.toJSON());

    return jsonContent;
  }

  void _writeAcmFile() {
    String batchToWrite = _acmHeader + json.encode(_acm.toJSON());
    encryption.encryptAndSave(batchToWrite, _acmPath);
  }

  bool _validAcm() {
    var content = encryption.readEncryptedFile(_acmPath);
    if (content == null) return false;
    // checking the content of the acm file
    var firstLine = content.split('\n').first;
    try {
      if (firstLine != _firstLine) {
        return false;
      }
      _loadAcmPermissions(content);

      return true;
    } catch (e) {
      return false;
    }
  }

  String get _acmPath => '${bucket.folderPath}/$acmFileName';

  // call this only on init constructor
  void _init() {
    bool validAcmFile = _validAcm();
    if (!validAcmFile) {
      String content = _initAcmObject();
      String batchToWrite = _acmHeader + content;
      encryption.encryptAndSave(batchToWrite, _acmPath);
    }
  }

  //? getters
  String get _creatorId => bucket.creatorId ?? '';

  //? acm file headers
  String get _acmHeader =>
      '$_firstLine\ncreator_id#${bucket.creatorId}\nmax_size#${bucket.maxAllowedSize}\n$_acmInfoSeparator\n';

  //? some helpers  statics
  static const String _acmInfoSeparator = '-----------------';
  static const String _firstLine = 'bucket_acm_never_edit';
  static const String acmFileName = '.acm';
  static Encryption encryption =
      Encryption('This is a secret key for the acm file');

  static Map<String, dynamic>? isAcmFileValid(String acmFilePath) {
    var content = encryption.readEncryptedFile(acmFilePath);
    if (content == null) return null;

    try {
      var parts = content.split('\n');
      String firstLine = parts.first;
      String secondLine = parts[1];
      String thirdLine = parts[2];
      int? maxSize = int.tryParse(thirdLine.replaceAll('max_size#', ''));
      String creatorId = secondLine.replaceAll('creator_id#', '');
      if (firstLine != _firstLine) {
        return null;
      }
      var acmJson = json.decode(content.split(_acmInfoSeparator)[1]);
      ACM.fromJson(acmJson);

      return {'creator_id': creatorId, 'max_size': maxSize};
    } catch (e) {
      return null;
    }
  }
}
