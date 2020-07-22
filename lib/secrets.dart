import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:yaml/yaml.dart';

class Secrets {
  final GoogleSecrets google;

  Secrets({
    @required this.google,
  });

  factory Secrets.fromYaml(Map<String, dynamic> map) {
    return Secrets(
      google: GoogleSecrets.fromYaml(map["google"]),
    );
  }
}

class GoogleSecrets {
  final String clientId;
  final String clientSecret;

  GoogleSecrets({
    @required this.clientId,
    @required this.clientSecret,
  });

  factory GoogleSecrets.fromYaml(Map<String, dynamic> map) {
    return GoogleSecrets(
      clientId: map["clientId"],
      clientSecret: map["clientSecret"],
    );
  }
}

class SecretsLoader {
  final String secretPath;

  SecretsLoader({this.secretPath});

  Future<Secrets> load() {
    return rootBundle.loadStructuredData<Secrets>(
      this.secretPath,
      (value) async => Secrets.fromYaml(loadYaml(value)),
    );
  }
}
