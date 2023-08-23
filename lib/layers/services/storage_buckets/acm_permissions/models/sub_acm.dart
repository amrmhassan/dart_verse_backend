import '../constants/default_permissions.dart';
import 'acm_permission.dart';

class SubACM {
  final String subPath;
  final List<ACMPermission> permissions;

  const SubACM(
    this.subPath, {
    this.permissions = defaultAcmPermissions,
  });

  Map<String, dynamic> toJSON() {
    return {
      'sub_path': subPath,
      'permissions': permissions.map((e) => e.toJSON()).toList(),
    };
  }

  static SubACM fromJson(Map<String, dynamic> obj) {
    List permissions = obj['permissions'];
    var tPermissions =
        permissions.map((e) => ACMPermission.fromJson(e)).toList();
    return SubACM(obj['sub_path'], permissions: tPermissions);
  }
}
