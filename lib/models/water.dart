class WaterModel {
  int id;
  int drunk;
  int toDrink;

  WaterModel({
    required this.id,
    required this.drunk,
    required this.toDrink,
  });

  factory WaterModel.fromJson(Map<String, dynamic> json) {
    WaterModel settings = WaterModel(
      id: json['id'],
      drunk: json['drunk'],
      toDrink: json['toDrink'],
    );
    return settings;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['drunk'] = drunk;
    data['toDrink'] = toDrink;
    return data;
  }

  List<dynamic> get props => [
        id,
        drunk,
        toDrink,
      ];
}
