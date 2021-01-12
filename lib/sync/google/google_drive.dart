// import 'dart:io';
//
// import 'package:googleapis/drive/v3.dart' as drive;
// import 'package:googleapis_auth/auth_io.dart';
// import 'package:http/http.dart';
// import 'package:path/path.dart' as p;
// import 'file:///D:/Development/meissner-marvin/txt/lib/sync/google/google_api_credentials.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// const _clientId = "CLIENT_ID";
// const _clientSecret = "CLIENT_SECRET";
// const _scopes = [drive.DriveApi.DriveFileScope];
//
// class GoogleDrive {
//   final storage = CredentialsStore();
//
//   Future<Client> _authenticatedHttpClient() async {
//     var credentials = await storage.read();
//     if (credentials == null) {
//       // Not authenticated
//       var client = await clientViaUserConsent(
//         ClientId(_clientId, _clientSecret),
//         _scopes,
//         (url) {
//           launch(url);
//         },
//       );
//       await storage.write(Credentials(
//         client.credentials.accessToken,
//         client.credentials.refreshToken,
//       ));
//       return client;
//     } else {
//       // Authenticated
//       return authenticatedClient(
//         Client(),
//         AccessCredentials(
//           credentials.token,
//           credentials.refreshToken,
//           _scopes,
//         ),
//       );
//     }
//   }
//
//   Future<drive.DriveApi> _driveApi() async {
//     var client = await _authenticatedHttpClient();
//     return drive.DriveApi(client);
//   }
//
//   // List files
//   Future list(File file) async {
//     var api = await _driveApi();
//     var response = await api.files.list(corpora: 'user');
//   }
//
//   //Upload File
//   Future upload(File file) async {
//     var api = await _driveApi();
//     var response = await api.files.create(
//       drive.File()..name = p.basename(file.absolute.path),
//       uploadMedia: drive.Media(file.openRead(), file.lengthSync()),
//     );
//   }
// }
