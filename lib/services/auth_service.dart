import 'dart:convert';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:toy_cryptocurrency_frontend/models/models.dart';
import 'package:toy_cryptocurrency_frontend/preferences/preferences.dart';

class AuthService extends ChangeNotifier {
  // URL Backend
  final String _baseUrl = '40.124.84.39';

  // Uses AES encryption for Android and Windows
  // Uses WebCrypto for Web
  final storage = const FlutterSecureStorage();

  Future<String?> sendSecurityCodeRegister(UserModel userModel) async {
    final url = Uri.http(_baseUrl, '/sendSecurityCodeRegister');
    final response = await http.post(url, body: userModelToJson(userModel));
    final Map<String, dynamic>? decodedData = json.decode(response.body);

    if (decodedData == null) return 'Error de conexión con el servidor';

    if (decodedData['status'] == 200) {
      return null;
    } else {
      return decodedData['message'];
    }
  }

  Future<String?> verifySecurityCodeRegister(
      UserModel userModel, String securityCode) async {
    final url = Uri.http(_baseUrl, '/verifySecurityCodeRegister/$securityCode');
    final response = await http.post(url, body: userModelToJson(userModel));
    final Map<String, dynamic>? decodedData = json.decode(response.body);

    if (decodedData == null) return 'Error de conexión con el servidor';

    if (decodedData['status'] == 201) {
      // Guardar datos del usuario en las preferencias
      Preferences.userId = decodedData['data']['InsertedID'];
      Preferences.userFirstName = userModel.firstName!;
      Preferences.userLastName = userModel.lastName!;
      Preferences.userCountry = userModel.country!;
      Preferences.userEmail = userModel.email!;
      Preferences.userPublicKey = userModel.publicKey!;
      Preferences.userPrivateKey = userModel.privateKey!;
      // Guardar llave privada en el cliente
      await storage.write(key: 'privateKey', value: userModel.privateKey);
      return null;
    } else {
      return decodedData['message'];
    }
  }

  Future<String?> sendSecurityCodeLogin(UserModel userModel) async {
    final url = Uri.http(_baseUrl, '/sendSecurityCodeLogin');
    final response = await http.post(url, body: userModelToJson(userModel));
    final Map<String, dynamic>? decodedData = json.decode(response.body);

    if (decodedData == null) return 'Error de conexión con el servidor';

    if (decodedData['status'] == 200) {
      return null;
    } else {
      return decodedData['message'];
    }
  }

  Future<String?> verifySecurityCodeLogin(
      UserModel userModel, String securityCode) async {
    final url = Uri.http(_baseUrl, '/verifySecurityCodeLogin/$securityCode');
    final response = await http.post(url, body: userModelToJson(userModel));
    final Map<String, dynamic>? decodedData = json.decode(response.body);

    if (decodedData == null) return 'Error de conexión con el servidor';

    if (decodedData['status'] == 200) {
      // Guardar datos del usuario en las preferencias
      Preferences.userId = decodedData['data']['id'];
      Preferences.userFirstName = decodedData['data']['firstName'];
      Preferences.userLastName = decodedData['data']['lastName'];
      Preferences.userCountry = decodedData['data']['country'];
      Preferences.userEmail = decodedData['data']['email'];
      Preferences.userPublicKey = decodedData['data']['publicKey'];
      Preferences.userPrivateKey = decodedData['data']['privateKey'];
      // Guardar llave privada en el cliente
      await storage.write(
          key: 'privateKey', value: decodedData['data']['privateKey']);
      return null;
    } else {
      return decodedData['message'];
    }
  }

  Future<String> readPrivateKey() async {
    return await storage.read(key: 'privateKey') ?? '';
  }

  Future logout() async {
    Preferences.userId = '';
    Preferences.userFirstName = '';
    Preferences.userLastName = '';
    Preferences.userCountry = '';
    Preferences.userEmail = '';
    Preferences.userPublicKey = '';
    Preferences.userPrivateKey = '';
    await storage.delete(key: 'privateKey');
    return;
  }
}
