import 'dart:convert';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:http/http.dart' as http;

import 'package:toy_cryptocurrency_frontend/models/models.dart';
import 'package:toy_cryptocurrency_frontend/preferences/preferences.dart';

class BlockService extends ChangeNotifier {
  // URL Backend
  // final String _baseUrl = '40.124.84.39';
  final String _baseUrl = '127.0.0.1:80';

  List<UserModel> availableUsers = [];
  late UserModel selectedUser;

  bool isLoadingUsers = false;

  BlockService() {
    getAvailableUsers();
  }

  Future<List<UserModel>> getAvailableUsers() async {
    isLoadingUsers = true;
    notifyListeners();

    // Hacer request para obtener el saldo del usuario

    // Hacer request para obtener la lista de usuarios disponibles
    final url =
        Uri.http(_baseUrl, '/getAvailableUsers/${Preferences.userEmail}');
    final response = await http.get(url);
    final Map<String, dynamic>? decodedData = json.decode(response.body);

    if (decodedData == null) {
      isLoadingUsers = false;
      notifyListeners();
      return [];
    }

    if (decodedData['data'] == null) {
      isLoadingUsers = false;
      notifyListeners();
      return [];
    }

    UserResponse userResponse = userResponseFromJson(response.body);
    availableUsers = userResponse.data;

    isLoadingUsers = false;
    notifyListeners();

    return availableUsers;
  }
}
