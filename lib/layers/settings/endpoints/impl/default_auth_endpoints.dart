import '../../../../constants/endpoints_constants.dart';
import '../repo/auth_endpoints.dart';

class DefaultAuthEndpoints implements AuthEndpoints {
  @override
  String login = EndpointsConstants.login;

  @override
  String register = EndpointsConstants.register;
  @override
  String verifyEmail = EndpointsConstants.verifyEmail;
  @override
  String getVerificationEmail = EndpointsConstants.getVerificationEmail;

  @override
  String changePassword = EndpointsConstants.changePassword;

  @override
  String forgetPassword = EndpointsConstants.forgetPassword;

  @override
  String deleteUserData = EndpointsConstants.deleteUserData;

  @override
  String fullyDeleteUser = EndpointsConstants.fullyDeleteUser;

  @override
  String logout = EndpointsConstants.logout;

  @override
  String logoutFromAllDevices = EndpointsConstants.logoutFromAllDevices;

  @override
  String updateUserData = EndpointsConstants.updateUserData;
}
