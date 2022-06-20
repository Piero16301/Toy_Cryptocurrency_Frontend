import 'dart:convert';

TransactionModel transactionModelFromJson(String str) =>
    TransactionModel.fromJson(json.decode(str));
String transactionModelToJson(TransactionModel data) =>
    json.encode(data.toJson());

class TransactionModel {
  String? from;
  String? to;
  double? amount;
  double? fee;

  TransactionModel({
    this.from,
    this.to,
    this.amount,
    this.fee,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      TransactionModel(
        from: json['from'],
        to: json['to'],
        amount: (json['amount'] == null) ? null : json['amount'].toDouble(),
        fee: (json['fee'] == null) ? null : json['fee'].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'from': from,
        'to': to,
        'amount': amount,
        'fee': fee,
      };
}
