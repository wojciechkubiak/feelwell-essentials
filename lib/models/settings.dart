class SettingsModel {
  int waterCapacity;
  int waterToDrink;
  int fastingLength;
  int fastingStartHour;
  int fastingStartMinutes;
  int exerciseLength;
  int meditationLength;
  bool isProper;

  SettingsModel({
    required this.waterCapacity,
    required this.waterToDrink,
    required this.fastingLength,
    required this.fastingStartHour,
    required this.fastingStartMinutes,
    required this.exerciseLength,
    required this.meditationLength,
    this.isProper = false,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    SettingsModel settings = SettingsModel(
      waterCapacity: json['waterCapacity'],
      waterToDrink: json['waterToDrink'],
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
    data['waterCapacity'] = waterCapacity;
    data['waterToDrink'] = waterToDrink;
    data['fastingLength'] = fastingLength;
    data['fastingStartHour'] = fastingStartHour;
    data['fastingStartMinutes'] = fastingStartMinutes;
    data['exerciseLength'] = exerciseLength;
    data['meditationLength'] = meditationLength;
    return data;
  }

  List<dynamic> get props => [
        waterCapacity,
        waterToDrink,
        fastingLength,
        fastingStartHour,
        fastingStartMinutes,
        exerciseLength,
        meditationLength,
      ];
}
