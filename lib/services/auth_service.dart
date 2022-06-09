import 'dart:convert';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:toy_cryptocurrency_frontend/models/models.dart';
import 'package:toy_cryptocurrency_frontend/preferences/preferences.dart';

class AuthService extends ChangeNotifier {
  // URL Backend
  // final String _baseUrl = '40.124.84.39';
  final String _baseUrl = '127.0.0.1:80';

  // Se usa encriptación AES para Windows, Linux y MacOS
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
      UserModel userModelResponse =
          userModelFromJson(json.encode(decodedData['data']));

      // Guardar datos del usuario en las preferencias
      Preferences.userId = userModelResponse.id!;
      Preferences.userFirstName = userModelResponse.firstName!;
      Preferences.userLastName = userModelResponse.lastName!;
      Preferences.userCountry = userModelResponse.country!;
      Preferences.userEmail = userModelResponse.email!;
      Preferences.userPublicKey = userModelResponse.publicKey!;
      Preferences.userPrivateKey = userModelResponse.privateKey!;
      // Guardar llave privada en el cliente
      await storage.write(
          key: 'privateKey', value: userModelResponse.privateKey);
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
      UserModel userModelResponse =
          userModelFromJson(json.encode(decodedData['data']));

      // Guardar datos del usuario en las preferencias
      Preferences.userId = userModelResponse.id!;
      Preferences.userFirstName = userModelResponse.firstName!;
      Preferences.userLastName = userModelResponse.lastName!;
      Preferences.userCountry = userModelResponse.country!;
      Preferences.userEmail = userModelResponse.email!;
      Preferences.userPublicKey = userModelResponse.publicKey!;
      Preferences.userPrivateKey = userModelResponse.privateKey!;
      // Guardar llave privada en el cliente
      await storage.write(
          key: 'privateKey', value: userModelResponse.privateKey);
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
