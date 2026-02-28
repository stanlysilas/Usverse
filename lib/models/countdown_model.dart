class CountdownModel {
  final int days;
  final int hours;
  final int minutes;
  final int seconds;

  CountdownModel({
    required this.days,
    required this.hours,
    required this.minutes,
    required this.seconds,
  });
}

CountdownModel splitDuration(Duration duration) {
  return CountdownModel(
    days: duration.inDays,
    hours: duration.inHours.remainder(24),
    minutes: duration.inMinutes.remainder(60),
    seconds: duration.inSeconds.remainder(60),
  );
}
