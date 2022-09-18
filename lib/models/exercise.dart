class ExerciseModel {
  int id;
  int duration;
  int isCompleted;

  ExerciseModel({
    required this.id,
    required this.duration,
    required this.isCompleted,
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
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
