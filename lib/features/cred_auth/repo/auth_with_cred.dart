// // ignore_for_file: unused_local_variable

// import 'dart:convert';
// import 'package:dart_verse_backend/constants/logger.dart';
// import 'package:http/http.dart' as http;

// import 'package:googleapis_auth/auth_io.dart';

// String testAcessToken =
//     'ya29.a0AfB_byBKMIrt2XnCPqkQ9O-NLQVEO8ohaXAzlXQLS45n3w8l3sUXkd4bORKyIILkY04IZfghI6dDOyfUgOgawKtJ62uQChfpsMiQDMCwvKqW3xtqKH0X5qjVhWdvF-VhIZ-QXjweKNxAd--wWMIbhEPkuqWzcOFnrKrV3QaCgYKATMSARESFQHsvYlsJVSfyLmT6kgScLHNllX3tQ0173';

// class AuthWithGoogle {
//   final String clientId;
//   final String clientSecret;
//   final String redirectUrl;

//   const AuthWithGoogle({
//     required this.clientId,
//     required this.clientSecret,
//     required this.redirectUrl,
//   });

//   void test() async {
//     var clientIdActual = ClientId(clientId, clientSecret);
//     final client = await clientViaUserConsent(
//       clientIdActual,
//       ['https://www.googleapis.com/auth/your-scope'],
//       (uri) {},
//     );

//     final credentials = await obtainAccessCredentialsViaUserConsent(
//       clientIdActual,
//       ['https://www.googleapis.com/auth/your-scope'],
//       client,
//       (uri) {},
//     );
//     String? refreshToken = credentials.refreshToken;
//     logger.i(refreshToken);
//   }

//   void run() async {
//     var res = await verifyGoogleAccessToken(testAcessToken);
//     var encoded = json.encode(res);
//     logger.i(encoded);
//     logger.i(res);
//   }

//   void login(String accessToken) async {
//     ClientId clientIdActual = ClientId(clientId, clientSecret);
//     List<String> scopes = ['openid', 'email', 'profile'];
//     final client = await clientViaUserConsent(
//       clientIdActual,
//       scopes,
//       (url) {},
//     );
//   }

//   Future<Map<String, dynamic>?> verifyGoogleAccessToken(
//       String accessToken) async {
//     try {
//       final url =
//           'https://www.googleapis.com/oauth2/v3/tokeninfo?access_token=$accessToken';

//       final response = await http.get(Uri.parse(url));

//       if (response.statusCode == 200) {
//         final responseBody = json.decode(response.body);
//         return responseBody;
//       } else {
//         return null; // Token is not valid.
//       }
//     } catch (e) {
//       //
//     }
//     return null;
//   }
// }
