class Ids {
  static int getRecordId() {
    DateTime date = DateTime.now();
    int day = date.day;
    int month = date.month;
    int year = date.year;
    String d = '$year$month$day';

    return int.parse(d);
  }
}
