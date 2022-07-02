import 'dart:convert';
import 'dart:math';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:http/http.dart' as http;

import 'package:toy_cryptocurrency_frontend/models/models.dart';
import 'package:toy_cryptocurrency_frontend/preferences/preferences.dart';

class BlockService extends ChangeNotifier {
  // URL Backend
  final List<String> _baseUrl = ['20.222.41.230', '40.124.84.39'];
  // final String _baseUrl = '127.0.0.1:80';

  List<UserModel> availableUsers = [];
  double balance = 0;
  late UserModel selectedUser;

  List<BlockModel> blocks = [];

  bool isLoadingUsersAndBalance = false;
  bool isLoadingBlockchain = false;

  BlockService() {
    getUsersAndBalance();
  }

  Future<List<UserModel>> getUsersAndBalance() async {
    isLoadingUsersAndBalance = true;
    notifyListeners();

    // Hacer request para obtener el saldo del usuario
    balance = await getUserBalance(true);

    // Hacer request para obtener la lista de usuarios disponibles
    final urlUsers =
        Uri.http(_baseUrl[0], '/getAvailableUsers/${Preferences.userEmail}');
    final responseUsers = await http.get(urlUsers);
    final Map<String, dynamic>? decodedUsers = json.decode(responseUsers.body);

    if (decodedUsers == null) {
      isLoadingUsersAndBalance = false;
      notifyListeners();
      return [];
    }

    if (decodedUsers['data'] == null) {
      isLoadingUsersAndBalance = false;
      notifyListeners();
      return [];
    }

    UserResponse userResponse = userResponseFromJson(responseUsers.body);
    availableUsers = userResponse.data;

    isLoadingUsersAndBalance = false;
    notifyListeners();

    return availableUsers;
  }

  Future<double> getUserBalance(bool initialLoad) async {
    if (!initialLoad) {
      isLoadingUsersAndBalance = true;
      notifyListeners();
    }

    final urlBalance =
        Uri.http(_baseUrl[0], '/getBalance/${Preferences.userEmail}');
    final responseBalance = await http.get(urlBalance);
    final Map<String, dynamic>? decodedBalance =
        json.decode(responseBalance.body);

    if (decodedBalance == null) {
      balance = 0;
      if (!initialLoad) {
        isLoadingUsersAndBalance = false;
        notifyListeners();
      }
      return 0;
    } else {
      balance = decodedBalance['data']['balance'].toDouble();
      if (!initialLoad) {
        isLoadingUsersAndBalance = false;
        notifyListeners();
      }
      return decodedBalance['data']['balance'].toDouble();
    }
  }

  Future<String?> newTransaction(
      TransactionModel transaction, String signature) async {
    // Enviar request al servidor principal o réplica
    Random r = Random();
    bool isMain = r.nextBool();
    String selectedServer = (isMain) ? _baseUrl[0] : _baseUrl[1];

    // Hacer request para crear la transacción
    final url =
        Uri.http(selectedServer, '/newTransaction', {'signature': signature});
    final response =
        await http.post(url, body: transactionModelToJson(transaction));
    final Map<String, dynamic>? decodedData = json.decode(response.body);

    if (decodedData == null) {
      return 'Error de conexión con el servidor';
    }

    if (decodedData['status'] == 200) {
      return null;
    } else {
      return decodedData['message'];
    }
  }

  Future<List<BlockModel>> getBlockchain() async {
    isLoadingBlockchain = true;
    notifyListeners();

    // Hacer request para obtener la lista de bloques
    final url = Uri.http(_baseUrl[0], '/getBlockchain');
    final response = await http.get(url);
    final Map<String, dynamic>? decodedData = json.decode(response.body);

    if (decodedData == null) {
      isLoadingBlockchain = false;
      notifyListeners();
      return [];
    }

    if (decodedData['data'] == null) {
      isLoadingBlockchain = false;
      notifyListeners();
      return [];
    }

    blocks = List<BlockModel>.from(
        decodedData['data'].map((block) => BlockModel.fromJson(block)));

    isLoadingBlockchain = false;
    notifyListeners();

    return blocks;
  }
}
