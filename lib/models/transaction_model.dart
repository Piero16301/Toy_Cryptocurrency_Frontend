import 'dart:convert';

TransactionModel transactionModelFromJson(String str) =>
    TransactionModel.fromJson(json.decode(str));
String transactionModelToJson(TransactionModel data) =>
    json.encode(data.toJson());

class TransactionModel {
  String from;
  String to;
  double amount;
  double fee;

  TransactionModel({
    required this.from,
    required this.to,
    required this.amount,
    required this.fee,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      TransactionModel(
        from: json['from'],
        to: json['to'],
        amount: json['amount'].toDouble(),
        fee: json['fee'].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'from': from,
        'to': to,
        'amount': amount,
        'fee': fee,
      };

  TransactionModel copy() => TransactionModel(
        from: from,
        to: to,
        amount: amount,
        fee: fee,
      );
}
