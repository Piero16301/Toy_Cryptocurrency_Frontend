import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService extends ChangeNotifier {
  // URL Backend
  final String _baseUrl = '40.124.84.39';

  // Uses AES encryption for Android and Windows
  // Uses WebCrypto for Web
  final storage = const FlutterSecureStorage();

  Future<String> readPrivateKey() async {
    return await storage.read(key: 'privateKey') ?? '';
  }
}