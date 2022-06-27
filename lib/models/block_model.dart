import 'dart:convert';

import 'package:toy_cryptocurrency_frontend/models/models.dart';

BlockModel blockModelFromJson(String str) =>
    BlockModel.fromJson(json.decode(str));
String blockModelToJson(BlockModel data) => json.encode(data.toJson());

class BlockModel {
  String id;
  int index;
  String previousHash;
  int proof;
  DateTime timestamp;
  String miner;
  String signature;
  TransactionModel transaction;

  BlockModel({
    required this.id,
    required this.index,
    required this.previousHash,
    required this.proof,
    required this.timestamp,
    required this.miner,
    required this.signature,
    required this.transaction,
  });

  factory BlockModel.fromJson(Map<String, dynamic> json) => BlockModel(
        id: json['id'],
        index: json['index'],
        previousHash: json['previousHash'],
        proof: (json['proof'] == null) ? 0 : json['proof'],
        timestamp: DateTime.parse(json['timestamp']),
        miner: json['miner'],
        signature: json['signature'],
        transaction: TransactionModel.fromJson(json['transaction']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'index': index,
        'previousHash': previousHash,
        'proof': proof,
        'timestamp': timestamp.toIso8601String(),
        'miner': miner,
        'signature': signature,
        'transaction': transaction.toJson(),
      };
}
