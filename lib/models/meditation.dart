class MeditationModel {
  int id;
  int duration;
  int isCompleted;

  MeditationModel({
    required this.id,
    required this.duration,
    required this.isCompleted,
  });

  factory MeditationModel.fromJson(Map<String, dynamic> json) {
    return MeditationModel(
      id: json['id'],
      duration: json['duration'],
      isCompleted: json['isCompleted'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['duration'] = duration;
    data['isCompleted'] = isCompleted;
    return data;
  }

  List<dynamic> get props => [id, duration, isCompleted];
}
