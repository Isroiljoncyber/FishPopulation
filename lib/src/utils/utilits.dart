import 'dart:math';

import 'package:untitled1/src/utils/fish_type.dart';

mixin Utils {
  final String _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();

  void onWillingPrintMessage(FishType type, bool isAccepted) {
    if (isAccepted) {
      if (type == FishType.fishA) {
        return print("WILLING: FishB => FishA is Accepted");
      }
      return print("WILLING: FishA => FishB is Accepted");
    }
    if (type == FishType.fishA) {
      return print("WILLING: FishB => FishA is Canceled");
    }
    return print("WILLING: FishA => FishB is Canceled");
  }

  void onLivePrintMessage(FishType type, String fishName) {
    return print("Born : $type, name : $fishName ");
  }

  void onDeadPrintMessage(FishType type, String fishName, String reasonDeath, int deathCount) {
    return print(
        "Dead => : $type, name: $fishName, reason : $reasonDeath, all count : $deathCount");
  }

  void onPrintHowManyFishOnTheAquarium(int countFishA, int countFishB) {
    return print("FishA : $countFishA, FishB : $countFishB");
  }

  void onPrintWhenNoFishLeft(FishType type) {
    return print("PROGRAM OVER: \n There is no more Fish => FishType : $type");
  }

  String getRandomString(int length) {
    return String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }

}
