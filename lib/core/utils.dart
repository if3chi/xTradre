class Utils {
  static String displayDate(dynamic dateTime) {
    if (dateTime is DateTime) {
      return getDate(dateTime);
    }

    if (dateTime is String) {
      return getDate(DateTime.parse(dateTime));
    }

    return "None";
  }

  static getDate(DateTime date) => date.toLocal().toString().split(' ')[0];
}
