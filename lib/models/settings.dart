class SettingsModel {
  int id;
  int waterCapacity;
  int waterToDrink;
  int glassSize;
  int fastingLength;
  int fastingStartHour;
  int fastingStartMinutes;
  int exerciseLength;
  int meditationLength;

  SettingsModel({
    required this.id,
    required this.waterCapacity,
    required this.waterToDrink,
    required this.glassSize,
    required this.fastingLength,
    required this.fastingStartHour,
    required this.fastingStartMinutes,
    required this.exerciseLength,
    required this.meditationLength,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    SettingsModel settings = SettingsModel(
      id: json['id'],
      waterCapacity: json['waterCapacity'],
      waterToDrink: json['waterToDrink'],
      glassSize: json['glassSize'],
      fastingLength: json['fastingLength'],
      fastingStartHour: json['fastingStartHour'],
      fastingStartMinutes: json['fastingStartMinutes'],
      exerciseLength: json['exerciseLength'],
      meditationLength: json['meditationLength'],
    );
    return settings;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['waterCapacity'] = waterCapacity;
    data['waterToDrink'] = waterToDrink;
    data['glassSize'] = glassSize;
    data['fastingLength'] = fastingLength;
    data['fastingStartHour'] = fastingStartHour;
    data['fastingStartMinutes'] = fastingStartMinutes;
    data['exerciseLength'] = exerciseLength;
    data['meditationLength'] = meditationLength;
    return data;
  }

  List<dynamic> get props => [
        id,
        waterCapacity,
        waterToDrink,
        glassSize,
        fastingLength,
        fastingStartHour,
        fastingStartMinutes,
        exerciseLength,
        meditationLength,
      ];
}
