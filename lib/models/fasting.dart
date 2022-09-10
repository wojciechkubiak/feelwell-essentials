class FastingModel {
  DateTime start;
  DateTime end;
  String formattedStart;
  String formattedEnd;
  int startMilliseconds;
  int endMilliseconds;
  String fastingMode;

  FastingModel({
    required this.start,
    required this.end,
    required this.formattedStart,
    required this.formattedEnd,
    required this.startMilliseconds,
    required this.endMilliseconds,
    required this.fastingMode,
  });

  factory FastingModel.fromIntegers({
    required int startHour,
    required int startMinutes,
    required int duration,
  }) {
    DateTime now = DateTime.now();
    String day = now.day > 9 ? now.day.toString() : '0${now.day}';
    String month = now.month > 9 ? now.month.toString() : '0${now.month}';
    int year = now.year;
    String formattedHour = startHour > 9 ? startHour.toString() : '0$startHour';
    String formattedMinutes =
        startMinutes > 9 ? startMinutes.toString() : '0$startMinutes';

    DateTime start =
        DateTime.parse('$year-$month-$day $formattedHour:$formattedMinutes:00');
    DateTime end = start.add(Duration(hours: duration));

    String formattedEndHour =
        end.hour > 9 ? end.hour.toString() : '0${end.hour}';
    String formattedEndMinutes =
        end.minute > 9 ? end.minute.toString() : '0${end.minute}';

    FastingModel settings = FastingModel(
      start: start,
      end: end,
      formattedStart: '$formattedHour:$formattedMinutes',
      formattedEnd: '$formattedEndHour:$formattedEndMinutes',
      startMilliseconds: start.millisecondsSinceEpoch,
      endMilliseconds: end.millisecondsSinceEpoch,
      fastingMode: '$duration/${24 - duration}',
    );
    return settings;
  }

  List<dynamic> get props => [
        start,
        end,
        startMilliseconds,
        endMilliseconds,
        fastingMode,
      ];
}
