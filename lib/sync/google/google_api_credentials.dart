// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:googleapis_auth/auth_io.dart';
//
// class Credentials {
//   final AccessToken token;
//   final String refreshToken;
//
//   Credentials(this.token, this.refreshToken);
// }
//
// class CredentialsStore {
//   static const KEY_TYPE = "type";
//   static const KEY_DATA = "data";
//   static const KEY_EXPIRY = "expiry";
//   static const KEY_REFRESH_TOKEN = "refreshToken";
//
//   final storage = FlutterSecureStorage();
//
//   Future write(Credentials credentials) async {
//     await storage.write(key: KEY_TYPE, value: credentials.token.type);
//     await storage.write(key: KEY_DATA, value: credentials.token.data);
//     await storage.write(
//         key: KEY_EXPIRY, value: credentials.token.expiry.toString());
//     await storage.write(
//         key: KEY_REFRESH_TOKEN, value: credentials.refreshToken);
//   }
//
//   Future<Credentials> read() async {
//     var type = await storage.read(key: KEY_TYPE);
//     var data = await storage.read(key: KEY_DATA);
//     var expiryString = await storage.read(key: KEY_EXPIRY);
//     var expiry = expiryString == null ? null : DateTime.tryParse(expiryString);
//     var refreshToken = await storage.read(key: KEY_REFRESH_TOKEN);
//
//     if (type == null ||
//         data == null ||
//         expiry == null ||
//         refreshToken == null) {
//       return null;
//     }
//     return Credentials(AccessToken(type, data, expiry), refreshToken);
//   }
//
//   Future delete() async {
//     await storage.delete(key: KEY_TYPE);
//     await storage.delete(key: KEY_DATA);
//     await storage.delete(key: KEY_EXPIRY);
//     await storage.delete(key: KEY_REFRESH_TOKEN);
//   }
// }
