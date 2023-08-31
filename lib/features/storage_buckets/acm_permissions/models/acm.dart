//! if the allowed is empty then the only one allowed is the bucket creator id
import '../constants/default_permissions.dart';
import 'acm_permission.dart';
import 'sub_acm.dart';

class ACM {
  // permissions of the bucket itself
  final List<ACMPermission> _permissions;
  // permissions of a specific file in that bucket(if empty then all files in the bucket will have the same permissions as the containing bucket)
  final List<SubACM> _subPermissions;

  ACM([
    this._permissions = defaultAcmPermissions,
    this._subPermissions = const [],
  ]);

  Map<String, dynamic> toJSON() {
    return {
      'permissions': _permissions.map((e) => e.toJSON()).toList(),
      'sub_permissions': _subPermissions.map((e) => e.toJSON()).toList(),
    };
  }

  void _editPermissionInfo(String name, List<String> allowed) {
    int index = _permissions.indexWhere((element) => element.name == name);
    ACMPermission newPermission = ACMPermission(name, allowed: allowed);
    _permissions[index] = newPermission;
  }

  void addUser(String name, String userId) {
    var permission = getPermissionInfo(name);
    if (permission == null) return;
    if (permission.allowed.contains(userId)) return;
    return _editPermissionInfo(
      name,
      [...permission.allowed, userId],
    );
  }

  void allowToAllPermission() {
    for (var permission in _permissions) {
      addUser(permission.name, '*');
    }
  }

  // void editSubPermission(String ref) {

  // }

  void allowAllToPermission(String permissionName) {
    var permission = getPermissionInfo(permissionName);
    if (permission == null) return;
    addUser(permissionName, '*');
  }

  void addToAll(String userId) {
    for (var permission in _permissions) {
      addUser(permission.name, userId);
    }
  }

  ACMPermission? getPermissionInfo(String name) {
    return _permissions.cast().firstWhere(
          (element) => element.name == name,
          orElse: () => null,
        );
  }

  static ACM fromJson(Map<String, dynamic> obj) {
    List permissions = obj['permissions'];
    var tPermissions =
        permissions.map((e) => ACMPermission.fromJson(e)).toList();
    List subPermissions = obj['sub_permissions'];
    var tSubPermissions =
        subPermissions.map((e) => SubACM.fromJson(e)).toList();
    return ACM(tPermissions, tSubPermissions);
  }
}
