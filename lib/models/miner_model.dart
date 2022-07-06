class MinerModel {
  int index;
  String name;
  int blocksMined;
  double totalCoins;
  int work;
  double workPercent;

  MinerModel({
    required this.index,
    required this.name,
    required this.blocksMined,
    required this.totalCoins,
    required this.work,
    required this.workPercent,
  });

  factory MinerModel.fromJson(Map<String, dynamic> json) => MinerModel(
        index: json['index'],
        name: json['name'],
        blocksMined: json['blocksMined'],
        totalCoins: json['totalCoins'].toDouble(),
        work: json['work'],
        workPercent: json['workPercent'],
      );

  Map<String, dynamic> toJson() => {
        'index': index,
        'name': name,
        'blocksMined': blocksMined,
        'totalCoins': totalCoins,
        'work': work,
        'workPercent': workPercent,
      };
}
