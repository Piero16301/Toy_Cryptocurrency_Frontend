import 'dart:convert';

import 'package:toy_cryptocurrency_frontend/preferences/aes_encrypt.dart';

UserResponse userResponseFromJson(String str) =>
    UserResponse.fromJson(json.decode(str));
String userResponseToJson(UserResponse data) => json.encode(data.toJson());

class UserResponse {
  int status;
  String message;
  List<UserModel> data;

  UserResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) => UserResponse(
        status: json['status'],
        message: json['message'],
        data: List<UserModel>.from(
            json['data'].map((x) => UserModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));
String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String? id;
  String? firstName;
  String? lastName;
  String? country;
  String? email;
  String? password;
  String? publicKey;
  String? privateKey;

  UserModel({
    this.id,
    this.firstName,
    this.lastName,
    this.country,
    this.email,
    this.password,
    this.publicKey,
    this.privateKey,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'],
        firstName: AESEncrypt.decryptString(json['firstName']),
        lastName: AESEncrypt.decryptString(json['lastName']),
        country: AESEncrypt.decryptString(json['country']),
        email: json['email'],
        password: AESEncrypt.decryptString(json['password']),
        publicKey: AESEncrypt.decryptString(json['publicKey']),
        privateKey: AESEncrypt.decryptString(json['privateKey']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstName':
            (firstName == null) ? '' : AESEncrypt.encryptString(firstName!),
        'lastName':
            (lastName == null) ? '' : AESEncrypt.encryptString(lastName!),
        'country': (country == null) ? '' : AESEncrypt.encryptString(country!),
        'email': email,
        'password': AESEncrypt.encryptString(password!),
        'publicKey':
            (publicKey == null) ? '' : AESEncrypt.encryptString(publicKey!),
        'privateKey':
            (privateKey == null) ? '' : AESEncrypt.encryptString(privateKey!),
      };

  UserModel copy() => UserModel(
        id: id,
        firstName: firstName,
        lastName: lastName,
        country: country,
        email: email,
        password: password,
        publicKey: publicKey,
        privateKey: privateKey,
      );
}
