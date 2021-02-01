import 'package:flutter_countdown_timer/current_remaining_time.dart';

class Toolbox {
  static String convertDurationToDisplay(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  static Duration convertCurrentRemainingTimeToDuration(CurrentRemainingTime currentRemainingTime){
    return Duration(
      days: currentRemainingTime.days,
      hours: currentRemainingTime.hours,
      minutes: currentRemainingTime.min,
      seconds: currentRemainingTime.sec,
    );
  }
}