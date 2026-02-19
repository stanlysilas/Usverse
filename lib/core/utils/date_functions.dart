import 'package:intl/intl.dart';

class DateFunctions {
  Future<String> formatDateToString(DateTime dateTime) async {
    final String formattedString = DateFormat('dd-MM-yyyy').format(dateTime);

    return formattedString;
  }

  int calculateDaysTogether(DateTime anniversaryDate) {
    return DateTime.now().difference(anniversaryDate).inDays;
  }

  DateTime getNextAnniversary(DateTime anniversary) {
    final now = DateTime.now();

    DateTime next = DateTime(now.year, anniversary.month, anniversary.day);

    if (next.isBefore(now)) {
      next = DateTime(now.year + 1, anniversary.month, anniversary.day);
    }

    return next;
  }

  Duration timeUntil(DateTime target) {
    return target.difference(DateTime.now());
  }

  String yearsUntilNextAnniversary(DateTime anniversaryDate) {
    final now = DateTime.now();

    int yearsCompleted = now.year - anniversaryDate.year;

    final thisYearAnniversary = DateTime(
      now.year,
      anniversaryDate.month,
      anniversaryDate.day,
    );

    if (now.isBefore(thisYearAnniversary)) {
      yearsCompleted -= 1;
    }

    final upcomingYear = yearsCompleted + 1;

    return "Approaching your ${ordinal(upcomingYear)} year  together ❤️";
  }

  String ordinal(int number) {
    if (number % 100 >= 11 && number % 100 <= 13) {
      return "${number}th";
    }

    switch (number % 10) {
      case 1:
        return "${number}st";
      case 2:
        return "${number}nd";
      case 3:
        return "${number}rd";
      default:
        return "${number}th";
    }
  }

  bool isAnniversaryToday(DateTime anniversary) {
    final now = DateTime.now();
    return now.month == anniversary.month && now.day == anniversary.day;
  }
}
